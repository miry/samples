package main

import (
	"crypto/tls"
	"encoding/hex"
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"net/url"
	"os"
	"sync"
	"time"

	"github.com/miry/samples/godnsproxy/pkg/version"
)

const netBufferSize = 1452

var (
	address      = flag.String("address", "tcp://127.0.0.1:8080", "Listen address for incoming connections e.g 127.0.0.1:3000")
	upstream     = flag.String("upstream", "", "Upstream address e.g udp://1.1.1.1:53")
	printVersion = flag.Bool("version", false, "Print version")
)

// Addr stores net netowrk and host
type Addr struct {
	Network string
	Host    string
}

func (a *Addr) String() string {
	return a.Host
}

// TODO: Implement context
// TODO: Worker pools for connecitons
func main() {
	flag.Parse()

	if *printVersion {
		fmt.Printf("%#v\n", version.Get())
		os.Exit(0)
	}

	upstreamAddr, err := parseAddress(*upstream)
	if err != nil {
		log.Fatalf("Invalid upstream address `%s' : %v", *upstream, err)
	}

	listenAddr, err := parseAddress(*address)
	if err != nil {
		log.Fatalf("Invalid server address `%s' : %v", *address, err)
	}

	// TODO: Handle listenUDP
	if len(listenAddr.Network) > 2 && listenAddr.Network[:3] == "tcp" {
		log.Fatal(listenTCP(listenAddr, upstreamAddr))
	} else {
		log.Fatalf("Network %s is not supported for server", listenAddr.Network)
	}

}

type Client struct {
	Conn net.Conn
}

func (c *Client) String() string {
	return c.Conn.RemoteAddr().String()
}

func (c *Client) Close() {
	c.Conn.Close()
}

func (c *Client) Read() ([]byte, error) {
	result := make([]byte, netBufferSize)
	n, err := c.Conn.Read(result)
	if err != nil {
		if err == io.EOF {
			log.Printf("[%s] INFO: Connection closed", c)
			return nil, err
		}

		log.Printf("[%s] ERROR: %v", c, err)
		return nil, err
	}
	log.Printf("[%s] DEBUG: Read %d bytes from client", c, n)
	log.Printf("\n%s", hex.Dump(result[:n]))
	return result[:n], nil
}

func (c *Client) Write(buf []byte) error {
	n, err := c.Conn.Write(buf)
	if err != nil {
		return fmt.Errorf("failed to write to client %v : %v", c, err)
	}
	log.Printf("[%s] Write %d bytes to client\n", c, n)
	return nil
}

func connectionPool(addr *Addr) *sync.Pool {
	return &sync.Pool{
		New: func() interface{} {
			return connect(addr)
		},
	}
}

func listenTCP(addr *Addr, upstream *Addr) error {
	log.Printf("Listening %s on %s\n", addr.Network, addr.Host)
	listen, err := net.Listen(addr.Network, addr.Host)
	if err != nil {
		log.Fatalf("Could not listen %s : %v", addr, err)
	}
	defer listen.Close()

	for {
		client := &Client{}
		client.Conn, err = listen.Accept()
		if err != nil {
			return fmt.Errorf("Could not accept connection : %v", err)
		}
		go handleConnection(client, upstream)
	}
}

func connect(addr *Addr) net.Conn {
	log.Printf("Connecting to upstream %s on %s\n", addr.Network, addr.Host)

	var conn net.Conn
	var err error

	if addr.Network == "tls" {
		conn, err = tls.Dial("tcp", addr.Host, &tls.Config{})
	} else {
		conn, err = net.Dial(addr.Network, addr.Host)
	}

	if err != nil {
		log.Fatalf("failed to connect to upstream (%s) %s : %v", addr.Network, addr.Host, err)
	}

	return conn
}

func parseAddress(addr string) (*Addr, error) {
	network := ""
	host := ""

	uri, err := url.Parse(addr)
	if err == nil {
		network = uri.Scheme
		host = uri.Host
	}

	if len(host) == 0 {
		host = addr
	}

	if _, _, err = net.SplitHostPort(host); err != nil {
		return nil, fmt.Errorf("could not parse address %s : %v", addr, err)
	}

	if len(network) == 0 {
		network = "tcp"
	}

	result := &Addr{
		Network: network,
		Host:    host,
	}

	return result, nil
}

func handleConnection(client *Client, upstream *Addr) {
	defer func() {
		if x := recover(); x != nil {
			log.Printf("[%s] ERROR: Panic %v", client, x)
		}
	}()

	defer client.Close()
	log.Printf("[%s] INFO: Serving", client)

	var upstreamConn net.Conn

	upstreamConn = connect(upstream) //upstreams.Get().(net.Conn)
	defer upstreamConn.Close()

	cR, cW := net.Pipe()
	defer cR.Close()
	defer cW.Close()

	uR, uW := net.Pipe()
	defer uR.Close()
	defer uW.Close()

	exit := make(chan int, 0)
	go func(client *Client, cW net.Conn, exit chan int) {
		defer func() {
			if x := recover(); x != nil {
				log.Printf("ERROR: %v", x)
				exit <- 1
			}
		}()

		for {
			buf, err := client.Read()
			if err != nil {
				exit <- 1
				return
			}
			cW.Write(buf)
		}
	}(client, cW, exit)

	go func(upstreamConn net.Conn, cR net.Conn, exit chan int) {
		defer func() {
			if x := recover(); x != nil {
				log.Printf("ERROR: %v", x)
				exit <- 1
			}
		}()

		remoteAddr := upstreamConn.RemoteAddr().String()

		for {
			buf := make([]byte, netBufferSize)
			n, err := cR.Read(buf)
			if err != nil {
				exit <- 1
				return
			}

			n, err = upstreamConn.Write(buf[:n])
			if err != nil {
				log.Printf("failed to write to server %s : %v", remoteAddr, err)
				exit <- 1
				return
			}
			log.Printf("Write %d bytes to server %v\n", n, remoteAddr)
		}
	}(upstreamConn, cR, exit)

	go func(upstreamConn net.Conn, uW net.Conn, exit chan int) {
		defer func() {
			if x := recover(); x != nil {
				log.Printf("ERROR: %v", x)
				exit <- 1
			}
		}()

		remoteAddr := upstreamConn.RemoteAddr().String()

		for {
			buf := make([]byte, netBufferSize)

			n, err := upstreamConn.Read(buf)
			if err != nil {
				log.Printf("failed to read from server %s : %v", remoteAddr, err)
				exit <- 1
			}

			log.Printf("DEBUG: Read %d bytes from server %v\n", n, remoteAddr)
			log.Printf("\n%s", hex.Dump(buf[:n]))

			_, err = uW.Write(buf[:n])
			if err != nil {
				log.Printf("ERROR: could not write to upstream pipe %v\n", err)
				exit <- 1
				return
			}
		}
	}(upstreamConn, uW, exit)

	go func(client *Client, uR net.Conn, exit chan int) {
		defer func() {
			if x := recover(); x != nil {
				log.Printf("ERROR: %v", x)
				exit <- 1
			}
		}()

		for {
			buf := make([]byte, 1452)
			n, err := uR.Read(buf)
			if err != nil {
				exit <- 1
				return
			}

			err = client.Write(buf[:n])
			if err != nil {
				exit <- 1
				return
			}
		}
	}(client, uR, exit)

	<-exit
	log.Printf("[%s] Finish transfer\n", client)
	time.Sleep(10 * time.Second)
}
