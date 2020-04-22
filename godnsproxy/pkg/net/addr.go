package net

import (
	"crypto/tls"
	"fmt"
	"net"
)

// Addr stores combination of network and host with port
type Addr struct {
	Network string
	Host    string
}

// String returns the full address format (e.g tcp://0.0.0.0:53)
func (a *Addr) String() string {
	return fmt.Sprintf("%s://%s", a.Network, a.Host)
}

// Connect to host in network
func (a *Addr) Connect() (*Client, error) {
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

// ListenTCP opens a new socket for incoming connections
func (a *Addr) ListenTCP() (net.Listener, error) {
	return net.Listen(a.Network, a.Host)
}

// ListenUDP open a new UDP socket for incomming connections
func (a *Addr) ListenUDP() (net.PacketConn, error) {
	return net.ListenPacket(a.Network, a.Host)
}
