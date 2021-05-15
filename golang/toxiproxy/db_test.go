package main

import (
	"testing"

	pg "github.com/go-pg/pg/v10"
)

var db *pg.DB

func DB() *pg.DB {
	if db == nil {
		var err error
		db, err = setupDB("sample_test")
		if err != nil {
			panic(err)
		}
	}
	return db
}

func TestPingWithConnection(t *testing.T) {
	db := DB()
	err := process(db)
	if err != nil {
		t.Fatalf("got error %v, wanted no errors", err)
	}
}
