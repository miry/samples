package main

import (
	"testing"

	toxiproxy "github.com/Shopify/toxiproxy/client"
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

func TestPingWithConnection(t *testing.T) {
	db := DB()
	err := process(db)
	if err != nil {
		t.Fatalf("got error %v, wanted no errors", err)
	}

	// Add 1s latency to 100% of downstream connections
	proxies["postgresql"].AddToxic("latency_down", "latency", "downstream", 1.0, toxiproxy.Attributes{
		"latency": 10000,
	})
	err = process(db)
	if err != nil {
		t.Fatalf("got error %v, wanted no errors", err)
	}
}
