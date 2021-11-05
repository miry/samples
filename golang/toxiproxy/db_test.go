package main

import (
	"net"
	"testing"
	"time"

	toxiServer "github.com/Shopify/toxiproxy/v2"
	toxiproxy "github.com/Shopify/toxiproxy/v2/client"
	pg "github.com/go-pg/pg/v10"
)

var db *pg.DB
var proxies map[string]*toxiproxy.Proxy

func DB() *pg.DB {
	if db == nil {
		var err error
		db, err = setupDB(":35432", "sample_test")
		if err != nil {
			panic(err)
		}
	}
	return db
}

func init() {
	runToxiproxyServer()

	toxi := toxiproxy.NewClient("localhost:8474")
	var err error
	_, err = toxi.Populate([]toxiproxy.Proxy{{
		Name:     "postgresql",
		Listen:   "localhost:35432",
		Upstream: "localhost:5432",
		Enabled:  true,
	}})
	if err != nil {
		panic(err)
	}

	proxies, err = toxi.Proxies()
	if err != nil {
		panic(err)
	}
}

func runToxiproxyServer() {
	server := toxiServer.NewServer()
	go func() {
		server.Listen("localhost", "8474")
	}()

	var err error
	timeout := 5 * time.Second
	for i := 0; i < 10; i += 1 {
		conn, err := net.DialTimeout("tcp", "localhost:8474", timeout)
		if err == nil {
			conn.Close()
			return
		}
	}
	panic(err)
}

func TestSlowDBConnection(t *testing.T) {
	db := DB()

	// Add 1s latency to 100% of downstream connections
	proxies["postgresql"].AddToxic("latency_down", "latency", "downstream", 1.0, toxiproxy.Attributes{
		"latency": 10000,
	})
	defer proxies["postgresql"].RemoveToxic("latency_down")

	err := process(db)
	if err != nil {
		t.Fatalf("got error %v, wanted no errors", err)
	}
}

func TestOutageResetPeer(t *testing.T) {
	db := DB()

	// Add broken TCP connection
	proxies["postgresql"].AddToxic("reset_peer_down", "reset_peer", "downstream", 1.0, toxiproxy.Attributes{
		"timeout": 10,
	})
	defer proxies["postgresql"].RemoveToxic("reset_peer_down")

	err := process(db)
	if err == nil {
		t.Fatalf("expect error")
	}
}
