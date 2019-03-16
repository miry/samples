package dnstls

import "net"

// DNSTLS resolves domain names against nameserver with tls enabled
type Resolver struct {
	Server net.Addr
}

func New(server string) (*Resolver, error) {
	result := &Resolver{}
	return result, nil
}

func (r *Resolver) Lookup(name string) string {
	return "127.0.0.1"
}
