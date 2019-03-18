package net

// Addr stores combination of network and host with port
type Addr struct {
	Network string
	Host    string
}

func (a *Addr) String() string {
	return a.Host
}
