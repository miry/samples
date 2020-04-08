// +build go1.14

package main

import (
	"errors"
	"flag"
	"fmt"

	n "godnsproxy/pkg/net"
)

type args struct {
	address  string
	upstream string
	version  bool
}

func parseArgs() args {
	result := args{}
	flag.StringVar(&result.address, "address", "tcp://127.0.0.1:8080", "Listen address for incoming connections e.g 127.0.0.1:3000")
	flag.StringVar(&result.upstream, "upstream", "", "Upstream address e.g udp://1.1.1.1:53")
	flag.BoolVar(&result.version, "version", false, "Print version")
	flag.Parse()

	return result
}

func (a args) PrintDefaults() {
	fmt.Println("Usage: ")
	flag.PrintDefaults()
}

func (a args) Validate() error {
	if a.address == "" {
		return errors.New("Missing listen address (e.g -address tcp://127.0.0.1:8080)")
	}

	if a.upstream == "" {
		return errors.New("Missing upstream address (e.g -upstream udp://1.1.1.1:53)")
	}

	return nil
}

func (a args) Parse() (*n.Addr, *n.Addr, error) {
	err := a.Validate()
	if err != nil {
		return nil, nil, err
	}

	upstreamAddr, err := n.ParseAddress(a.upstream)
	if err != nil {
		return nil, nil, fmt.Errorf("Invalid upstream address `%s' : %v", a.upstream, err)
	}

	listenAddr, err := n.ParseAddress(a.address)
	if err != nil {
		return nil, nil, fmt.Errorf("Invalid address `%s' : %v", a.address, err)
	}

	return listenAddr, upstreamAddr, nil
}
