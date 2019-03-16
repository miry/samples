package main

import (
	"encoding/hex"
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"net/url"
	"os"

	"github.com/miry/samples/godnsproxy/pkg/version"
)

const NetBufferSize = 1024

var (
	address      = flag.String("address", "tcp://127.0.0.1:8080", "Listen address for incoming connections e.g 127.0.0.1:3000")
	upstream     = flag.String("upstream", "", "Upstream address e.g udp://1.1.1.1:53")
	printVersion = flag.Bool("version", false, "Print version")
)

type Addr struct {
	Network string
	Host    string
}

func (a *Addr) String() string {
	return a.Host
}

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

	connect(upstreamAddr)
	listen(listenAddr)
}

func listen(addr *Addr) {
	log.Printf("Listening %s on %s\n", addr.Network, addr.Host)
	listen, err := net.Listen(addr.Network, addr.Host)
	if err != nil {
		log.Fatalf("Could not listen %s : %v", addr, err)
	}
	defer listen.Close()

	for {
		conn, err := listen.Accept()
		if err != nil {
			log.Printf("ERROR: %v\n", err)
			return
		}
		go handleConnection(conn)
	}
}

func connect(addr *Addr) {
	log.Printf("Connect upstream %s on %s\n", addr.Network, addr.Host)
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

func handleConnection(conn net.Conn) {
	defer conn.Close()

	client := conn.RemoteAddr().String()
	log.Printf("[%s] INFO: Serving", client)

	for {
		clientConnBuf := make([]byte, NetBufferSize)
		n, err := conn.Read(clientConnBuf)
		if err != nil {
			if err == io.EOF {
				log.Printf("[%s] INFO: Connection closed", client)
				return
			}

			log.Printf("[%s] ERROR: %v", client, err)
			continue
		}
		log.Printf("[%s] DEBUG: Read %d bytes", client, n)
		log.Printf("\n%s", hex.Dump(clientConnBuf[:n]))

	}
}
