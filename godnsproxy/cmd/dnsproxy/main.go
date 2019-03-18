package main

import (
	"encoding/binary"
	"encoding/hex"
	"flag"
	"fmt"
	"log"
	"net"
	"os"
	"time"

	n "github.com/miry/samples/godnsproxy/pkg/net"
	"github.com/miry/samples/godnsproxy/pkg/version"
)

const netBufferSize = 1452

var (
	address      = flag.String("address", "udp://127.0.0.1:8053", "Listen address for incoming connections e.g 127.0.0.1:3000")
	upstream     = flag.String("upstream", "", "Upstream address e.g tls://1.1.1.1:853")
	printVersion = flag.Bool("version", false, "Print version")
)

func main() {

	flag.Parse()

	if *printVersion {
		fmt.Printf("%#v\n", version.Get())
		os.Exit(0)
	}

	upstreamAddr, err := n.ParseAddress(*upstream)
	if err != nil {
		log.Fatalf("Invalid upstream address `%s' : %v", *upstream, err)
	}

	listenAddr, err := n.ParseAddress(*address)
	if err != nil {
		log.Fatalf("Invalid server address `%s' : %v", *address, err)
	}

	if len(listenAddr.Network) > 2 {
		switch listenAddr.Network[:3] {
		case "udp":
			log.Fatal(listenUDP(listenAddr, upstreamAddr))
		case "tcp":
			log.Fatal(listenTCP(listenAddr, upstreamAddr))
		default:
			log.Fatalf("Network %s is not supported for server", listenAddr.Network)
		}
	} else {
		log.Fatalf("Network %s is not supported for server", listenAddr.Network)
	}
}

func listenUDP(addr *n.Addr, upstream *n.Addr) error {
	log.Printf("Listening %s/%s\n", addr.Host, addr.Network)
	pc, err := net.ListenPacket(addr.Network, addr.Host)
	if err != nil {
		return err
	}
	defer pc.Close()

	// TODO: Support concurent processing per addr
	handleConnectionUDP(pc, upstream)
	return nil
}

func handleConnectionUDP(pc net.PacketConn, upstream *n.Addr) {

	for {
		buf := make([]byte, netBufferSize)
		n, addr, err := pc.ReadFrom(buf)
		if err != nil {
			fmt.Printf("failed readfrom : %v", err)
			continue
		}
		fmt.Printf("Read %d bytes from client %v\n", n, addr)
		fmt.Printf("%s", hex.Dump(buf[:n]))

		// TODO: Implement reconnect
		upstreamConn, err := upstream.Connect()
		if err != nil {
			fmt.Printf("ERROR: could not connect to upstream : %v", err)
			break
		}

		remoteAddr := upstreamConn.String()
		fmt.Printf("Connected to %s\n", remoteAddr)

		// Enrich UDP to TCP add size of message infront
		b := make([]byte, 2)
		binary.BigEndian.PutUint16(b[0:], uint16(n))

		err = upstreamConn.Write(append(b, buf[:n]...))
		if err != nil {
			continue
		}

		buf, err = upstreamConn.Read()
		if err != nil {
			continue
		}

		tcpMsgSize := int(binary.BigEndian.Uint16(buf[:2])) + 2
		if tcpMsgSize >= len(buf) {
			tcpMsgSize = len(buf) - 1
		}
		fmt.Printf("size: %v\n", tcpMsgSize)
		// Cut message size field: first 2 bytes for TCP -> UDP
		n, err = pc.WriteTo(buf[2:tcpMsgSize], addr)
		if err != nil {
			fmt.Printf("failed to write to client %v : %v\n", addr, err)
			continue
		}
		fmt.Printf("Write %d bytes to client %v\n", n, addr)
		upstreamConn.Close()
	}
}

func listenTCP(addr *n.Addr, upstream *n.Addr) error {
	log.Printf("Listening %s on %s\n", addr.Network, addr.Host)
	listen, err := net.Listen(addr.Network, addr.Host)
	if err != nil {
		log.Fatalf("Could not listen %s : %v", addr, err)
	}
	defer listen.Close()

	for {
		client := &n.Client{}
		client.Conn, err = listen.Accept()
		if err != nil {
			return fmt.Errorf("Could not accept connection : %v", err)
		}
		go handleConnectionTCP(client, upstream)
	}
}

func handleConnectionTCP(client *n.Client, upstream *n.Addr) {
	defer func() {
		if x := recover(); x != nil {
			log.Printf("[%s] ERROR: Panic %v", client, x)
		}
	}()

	defer client.Close()
	log.Printf("[%s] INFO: Serving", client)

	upstreamConn, err := upstream.Connect() //upstreams.Get().(net.Conn)
	if err != nil {
		return
	}
	defer upstreamConn.Close()

	cR, cW := net.Pipe()
	defer cR.Close()
	defer cW.Close()

	uR, uW := net.Pipe()
	defer uR.Close()
	defer uW.Close()

	exit := make(chan int, 0)
	go func(client *n.Client, cW net.Conn, exit chan int) {
		defer func() {
			if x := recover(); x != nil {
				log.Printf("ERROR: %v", x)
				exit <- 1
			}
		}()

		for {
			buf, err := client.Read()
			if err != nil {
				exit <- 1
				return
			}
			cW.Write(buf)
		}
	}(client, cW, exit)

	go func(upstreamConn *n.Client, cR net.Conn, exit chan int) {
		defer func() {
			if x := recover(); x != nil {
				log.Printf("ERROR: %v", x)
				exit <- 1
			}
		}()

		for {
			buf := make([]byte, netBufferSize)
			n, err := cR.Read(buf)
			if err != nil {
				exit <- 1
				return
			}

			err = upstreamConn.Write(buf[:n])
			if err != nil {
				exit <- 1
				return
			}
		}
	}(upstreamConn, cR, exit)

	go func(upstreamConn *n.Client, uW net.Conn, exit chan int) {
		defer func() {
			if x := recover(); x != nil {
				log.Printf("ERROR: %v", x)
				exit <- 1
			}
		}()

		for {
			buf, err := upstreamConn.Read()
			if err != nil {
				exit <- 1
				return
			}

			_, err = uW.Write(buf)
			if err != nil {
				log.Printf("ERROR: could not write to upstream pipe %v\n", err)
				exit <- 1
				return
			}
		}
	}(upstreamConn, uW, exit)

	go func(client *n.Client, uR net.Conn, exit chan int) {
		defer func() {
			if x := recover(); x != nil {
				log.Printf("ERROR: %v", x)
				exit <- 1
			}
		}()

		for {
			buf := make([]byte, 1452)
			n, err := uR.Read(buf)
			if err != nil {
				exit <- 1
				return
			}

			err = client.Write(buf[:n])
			if err != nil {
				exit <- 1
				return
			}
		}
	}(client, uR, exit)

	<-exit
	log.Printf("[%s] Finish transfer\n", client)
	time.Sleep(10 * time.Second)
}

func init() {
	os.Setenv("GODEBUG", os.Getenv("GODEBUG")+",tls13=1")
}
