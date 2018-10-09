package main

import (
	"flag"
	"log"
	"net"
	"os"
)

const (
	SERVER_HOST     = "localhost:8001"
	LISTEN_HOST     = "localhost:8002"
	CONNECTION_TYPE = "tcp"
)

var listen = flag.String("listen", LISTEN_HOST, "Listen TCP Port, e.g localhost:8002")
var forward = flag.String("forward", SERVER_HOST, "Forward host, e.g localhost:8001")

func main() {
	flag.Parse()
	log.SetOutput(os.Stderr)

	// Metrics
	mesure := NewMesure()

	// Listen Server
	ln, err := net.Listen(CONNECTION_TYPE, *listen)
	if err != nil {
		log.Fatal(err)
	}
	defer ln.Close()
	log.Printf("Listening on %s\n", *listen)

	// Accept connections
	for {
		conn, err := ln.Accept()
		if err != nil {
			log.Fatal(err)
		}
		log.Println("Open connection with", conn.RemoteAddr())
		go createSession(mesure, conn)
	}
}

func createSession(mesure *Mesure, clientConn net.Conn) {
	defer clientConn.Close()
	defer func() {
		if r := recover(); r != nil {
			log.Println("Something went wrong", r)
		}
	}()

	// Connect to server
	serverConn, err := net.Dial(CONNECTION_TYPE, *forward)
	if err != nil {
		log.Println("Could not connect to the server", err.Error())
		return
	}
	defer serverConn.Close()

	session := NewSession(clientConn, serverConn)
	session.Start(mesure)
	log.Println("Cao!")
}
