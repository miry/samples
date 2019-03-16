package dnstls

import (
	"errors"
	"net"
)

// DNSTLS resolves domain names against nameserver with tls enabled
type Resolver struct {
	Server net.Addr
}

var NoServer = errors.New("server could not be empty")

func New(server string) (*Resolver, error) {
	result := &Resolver{}

	if len(server) == 0 {
		return result, NoServer
	}

	return result, nil
}

func (r *Resolver) Lookup(name string) string {
	return "127.0.0.1"
}
