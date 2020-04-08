// +build go1.14

package main

import (
	"encoding/binary"
	"encoding/hex"
	"fmt"
	"log"
	"net"
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

	// TODO: Manage invalid params
	if len(listenAddr.Network) < 3 {
		return fmt.Errorf("Network `%s' is not supported for server", listenAddr.Network)
	}

	switch listenAddr.Network[:3] {
	case "udp":
		return listenUDP(listenAddr, upstreamAddr)
	case "tcp":
		return listenTCP(listenAddr, upstreamAddr)
	default:
		return fmt.Errorf("Network `%s' is not supported for server", listenAddr.Network)
	}
}

func listenUDP(addr *n.Addr, upstream *n.Addr) error {
	log.Printf("Listening %s\n", addr)
	pc, err := addr.ListenUDP()
	if err != nil {
		return err
	}
	defer pc.Close()

	exit := make(chan int, 1)

	for {
		select {
		case <-exit:
			log.Printf("Exiting...")
			close(exit)
			return nil
		default:
			buf := make([]byte, netBufferSize)
			msgSize, addr, err := pc.ReadFrom(buf)
			if err != nil {
				log.Printf("ERROR: failed read : %v", err)
				continue
			}
			go handleConnectionUDP(pc, buf, msgSize, addr, upstream, exit)
		}
	}
}

func listenTCP(addr *n.Addr, upstream *n.Addr) error {
	log.Printf("Listening tcp %s\n", addr)
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
		go handleConnectionTCP(client, upstream)
		log.Printf("[DEBUG] Number goroutines: %d", runtime.NumGoroutine())
	}
}

func handleConnectionTCP(downstreamClient *n.Client, upstream *n.Addr) {
	defer func() {
		if x := recover(); x != nil {
			log.Printf("[%s] PANIC: handleConnectionTCP %v", downstreamClient, x)
		}
	}()
	defer downstreamClient.Close()

	log.Printf("[%s] INFO: Serving", downstreamClient)

	// TODO: Implement Connection pool for TCP and TLS
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

func read(upstreamClient *n.Client, upstreamNetwork string, pc net.PacketConn, addr net.Addr) error {
	buf, err := upstreamClient.Read()
	if err != nil {
		return fmt.Errorf("could not read from upstream %w", err)
	}

	if upstreamNetwork[:3] != "udp" {
		// Cut message size field: first 2 bytes for TCP -> UDP
		tcpMsgSize := int(binary.BigEndian.Uint16(buf[:2])) + 2
		if tcpMsgSize >= len(buf) {
			tcpMsgSize = len(buf) - 1
		}
		log.Printf("DEBUG: size: %v\n", tcpMsgSize)
		log.Printf("DEBUG: Cut the first 2 bytes with msg size")
		buf = buf[2:tcpMsgSize]
	}

	msgSize, err := pc.WriteTo(buf, addr)
	if err != nil {
		return fmt.Errorf("failed to write to client: %w", err)
	}
	log.Printf("[%s] DEBUG: Write %d bytes", addr, msgSize)
	return nil
}

func handleConnectionUDP(pc net.PacketConn, buf []byte, msgSize int, addr net.Addr, upstream *n.Addr, exit chan int) {
	defer func() {
		if x := recover(); x != nil {
			log.Printf("PANIC: request > Recover %v", x)
		}
	}()

	downstreamClient := n.ClientUDP{
		Addr: addr,
	}
	defer downstreamClient.Close()

	log.Printf("[%s] DEBUG: Read %d bytes", downstreamClient, msgSize)
	fmt.Println(hex.Dump(buf[:msgSize]))

	// TODO: Implement reconnect and connection pool
	// TODO: Fix connect to UDP server
	upstreamClient, err := upstream.Connect()
	if err != nil {
		log.Printf("ERROR: could not connect to upstream : %v", err)
		exit <- 1
		return
	}
	defer upstreamClient.Close()

	log.Printf("[%s] Connected to %s\n", downstreamClient, upstreamClient)

	if upstream.Network[:3] != "udp" {
		// Enrich UDP to TCP add size of message infront
		log.Printf("DEBUG: Enrich packets with size for UDP to TCP conversion")

		b := make([]byte, 2)
		binary.BigEndian.PutUint16(b[0:], uint16(msgSize))
		buf = append(b, buf[:msgSize]...)
	}

	err = upstreamClient.Write(buf)
	if err != nil {
		log.Printf("[%s -> %s] ERROR: could not write: %v", downstreamClient, upstreamClient, err)
		return
	}

	err = read(upstreamClient, upstream.Network, pc, addr)
	if err != nil {
		log.Printf("[%s <- %s] ERROR: Could not read / write : %v", downstreamClient, upstreamClient, err)
	}
}

// Enable TLS 1.3 for go1.12
// func init() {
// 	os.Setenv("GODEBUG", os.Getenv("GODEBUG")+",tls13=1")
// }
