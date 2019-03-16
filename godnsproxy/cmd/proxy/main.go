package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"net/url"
	"os"

	"github.com/miry/samples/godnsproxy/pkg/version"
)

var (
	address      = flag.String("address", "tcp://127.0.0.1:8080", "Listen address for incoming connections e.g 127.0.0.1:3000")
	upstream     = flag.String("upstream", "", "Upstream address e.g udp://1.1.1.1:53")
	printVersion = flag.Bool("version", false, "Print version")
)

func main() {
	flag.Parse()

	if *printVersion {
		fmt.Printf("%#v\n", version.Get())
		os.Exit(0)
	}

	network, addr, err := parseAddress(*address)
	if err != nil {
		log.Fatalf("Invalid address `%s' : %v", *address, err)
	}

	log.Printf("Listening %s on %s\n", network, addr)
}

func parseAddress(addr string) (string, string, error) {
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
		return "", "", fmt.Errorf("could not parse address %s : %v", addr, err)
	}

	if len(network) == 0 {
		network = "tcp"
	}

	return network, host, nil
}
