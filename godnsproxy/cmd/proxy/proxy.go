// +build go1.14

// There is a sample TCP proxy application.

package main

import (
	"fmt"
	"log"
	"os"
	"runtime"
	"time"

	n "godnsproxy/pkg/net"
	"godnsproxy/pkg/version"
)

const netBufferSize = 1452

func main() {
	err := run()
	if err != nil {
		log.Printf("ERROR: %v", err)
		os.Exit(1)
	}
}

func run() error {
	a := parseArgs()

	if a.version == true {
		fmt.Printf("%#v\n", version.Get())
		return nil
	}

	listenAddr, upstreamAddr, err := a.Parse()
	if err != nil {
		a.PrintDefaults()
		return err
	}

	if len(listenAddr.Network) > 2 && listenAddr.Network[:3] == "tcp" {
		return listenTCP(listenAddr, upstreamAddr)
	}

	// TODO: Handle listenUDP
	return fmt.Errorf("Network %s is not supported for server", listenAddr.Network)
}

func listenTCP(addr *n.Addr, upstream *n.Addr) error {
	log.Printf("Listening %s\n", addr)
	listen, err := addr.ListenTCP()
	if err != nil {
		return err
	}
	defer listen.Close()

	for {
		client := &n.Client{}
		// Waiting for a new connection
		client.Conn, err = listen.Accept()
		if err != nil {
			return fmt.Errorf("Could not accept connection : %w", err)
		}
		go handleConnection(client, upstream)
		log.Printf("[DEBUG] Number goroutines: %d", runtime.NumGoroutine())
	}
}

func handleConnection(downstreamClient *n.Client, upstream *n.Addr) {
	defer func() {
		if x := recover(); x != nil {
			log.Printf("[%s] ERROR: Panic recovered %v", downstreamClient, x)
		}
	}()
	defer downstreamClient.Close()

	log.Printf("[%s] DEBUG: Serving", downstreamClient)
	log.Printf("[%s] DEBUG: Connecting to upstream %s\n", downstreamClient, upstream.String())
	upstreamClient, err := upstream.Connect()
	if err != nil {
		log.Printf("[%s] ERROR: Could not setup connection to upstream %v", downstreamClient, upstreamClient)
		return
	}
	defer upstreamClient.Close()

	exit := make(chan int, 1)
	go n.Pipe(downstreamClient, upstreamClient, exit)
	go n.Pipe(upstreamClient, downstreamClient, exit)

	<-exit
	log.Printf("[%s] Finish transfer\n", downstreamClient)
	time.Sleep(200 * time.Millisecond)
	close(exit)
}
