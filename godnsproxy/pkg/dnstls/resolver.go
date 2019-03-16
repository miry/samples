package dnstls

import (
	"errors"
)

// Resolver resolves domain names against nameserver with tls enabled
type Resolver struct {
	Server string
}

var errNoServer = errors.New("server could not be empty")

// New returns  Resolver
func New(server string) (*Resolver, error) {
	result := &Resolver{}

	if len(server) == 0 {
		return result, errNoServer
	}

	return result, nil
}

// Lookup resolve name to ip address
func (r *Resolver) Lookup(name string) (string, error) {
	return "8.8.8.8", nil
}
