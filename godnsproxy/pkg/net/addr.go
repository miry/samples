package net

import (
	"crypto/tls"
	"fmt"
	"log"
	"net"
)

// Addr stores combination of network and host with port
type Addr struct {
	Network string
	Host    string
}

func (a *Addr) String() string {
	return a.Host
}

// Connect to host in network
func (a *Addr) Connect() (*Client, error) {
	log.Printf("Connecting to upstream %s/%s\n", a.Network, a.Host)

	var conn net.Conn
	var err error

	if a.Network == "tls" {
		conn, err = tls.Dial("tcp", a.Host, &tls.Config{})
	} else {
		conn, err = net.Dial(a.Network, a.Host)
	}

	if err != nil {
		return nil, fmt.Errorf("failed to connect to upstream %s/%s : %v", a.Host, a.Network, err)
	}

	return &Client{Conn: conn}, nil
}
