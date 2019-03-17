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

	"github.com/miry/samples/godnsproxy/pkg/version"
)

const netBufferSize = 1024

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
		listenTCP(listenAddr, connectionPool(upstreamAddr))
	} else {
		log.Fatalf("Network %s is not supported for server", listenAddr.Network)
	}

}

func connectionPool(addr *Addr) *sync.Pool {
	return &sync.Pool{
		New: func() interface{} {
			return connect(addr)
		},
	}
}

func listenTCP(addr *Addr, upstreams *sync.Pool) {
	log.Printf("Listening %s on %s\n", addr.Network, addr.Host)
	listen, err := net.Listen(addr.Network, addr.Host)
	if err != nil {
		log.Fatalf("Could not listen %s : %v", addr, err)
	}
	defer listen.Close()

	for {
		conn, err := listen.Accept()
		if err != nil {
			log.Printf("ERROR: Could not accept connection : %v\n", err)
			return
		}
		go handleConnection(conn, upstreams)
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

func handleConnection(conn net.Conn, upstreams *sync.Pool) {
	defer conn.Close()

	client := conn.RemoteAddr().String()
	log.Printf("[%s] INFO: Serving", client)

	var upstreamConn net.Conn
	var remoteAddr string

	upstreamConn = upstreams.Get().(net.Conn)
	defer upstreams.Put(upstreamConn)
	remoteAddr = upstreamConn.RemoteAddr().String()

	for {
		clientConnBuf := make([]byte, netBufferSize)
		n, err := conn.Read(clientConnBuf)
		if err != nil {
			if err == io.EOF {
				log.Printf("[%s] INFO: Connection closed", client)
				return
			}

			log.Printf("[%s] ERROR: %v", client, err)
			continue
		}
		log.Printf("[%s] DEBUG: Read %d bytes from client", client, n)
		log.Printf("\n%s", hex.Dump(clientConnBuf[:n]))

		n, err = upstreamConn.Write(clientConnBuf[:n])
		if err != nil {
			fmt.Errorf("failed to write to server %s : %v", remoteAddr, err)
			continue
		}
		fmt.Printf("Write %d bytets to server %v\n", n, remoteAddr)

		// TODO: Handle big responses without blocking clients
		// for {
		bufServer := make([]byte, 1024000)
		n, err = upstreamConn.Read(bufServer)
		if err != nil {
			fmt.Errorf("failed to read from server %s : %v", remoteAddr, err)
			continue
		}

		fmt.Printf("[%s] Read %d bytets from server %v\n", client, n, remoteAddr)
		fmt.Printf("%s", hex.Dump(bufServer[:n]))

		n, err = conn.Write(bufServer[:n])
		if err != nil {
			fmt.Errorf("failed to write to client %v : %v", client, err)
			continue
		}
		fmt.Printf("[%s] Write %d bytes to client %v\n", client, n, client)
		// }
		fmt.Printf("[%s] Finish transfer\n", client)
	}
}
