package net

import (
	"fmt"
	"net"
	"net/url"
)

func ParseAddress(addr string) (*Addr, error) {
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
