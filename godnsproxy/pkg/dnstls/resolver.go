package dnstls

import (
	"crypto/tls"
	"errors"
	"fmt"
	"net"
)

// Resolver resolves domain names against nameserver with tls enabled
type Resolver struct {
	Server Addr
}

var errNoServer = errors.New("server could not be empty")

// New returns  Resolver
func New(server string) (*Resolver, error) {
	result := &Resolver{}

	if len(server) == 0 {
		return result, errNoServer
	}

	result.Server = net.ResolveIPAddr("tcp", server)

	return result, nil
}

// Lookup resolve name to ip address
func (r *Resolver) Lookup(name string) ([]string, error) {

	conn, err := tls.Dial("tcp", r.Server.String(), &tls.Config{})
	if err != nil {
		fmt.Errorf("failed to connect to %s : %v", r.Server, err)
	}
	defer conn.Close()

	return []string{"8.8.8.8"}, nil
}
