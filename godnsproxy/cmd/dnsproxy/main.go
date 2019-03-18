package main

import (
	"crypto/tls"
	"encoding/binary"
	"encoding/hex"
	"flag"
	"fmt"
	"log"
	"net"
	"os"

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

	if len(listenAddr.Network) > 2 && listenAddr.Network[:3] == "udp" {
		log.Fatal(listenUDP(listenAddr, upstreamAddr))
	} else {
		log.Fatalf("Network %s is not supported for server", listenAddr.Network)
	}
}

func listenUDP(addr *n.Addr, upstream *n.Addr) error {
	// listen to incoming udp packets
	pc, err := net.ListenPacket(addr.Network, addr.Host)
	if err != nil {
		return err
	}
	defer pc.Close()

	// cloudfareDNSTLS := "1.1.1.1:853"
	// cloudfareDNS := "1.1.1.1:53"
	quadDNSTLS := "9.9.9.9:853"
	// conn, err := tls.Dial("tcp", quadDNSTLS, &tls.Config{})
	// // conn, err := net.Dial("udp", "1.1.1.1:53")
	// if err != nil {
	// 	log.Fatalf("failed to connect to server : %v", err)
	// }
	// defer conn.Close()
	// remoteAddr := conn.RemoteAddr().String()
	// fmt.Printf("Connected to %s\n", remoteAddr)

	for {
		buf := make([]byte, 1024)
		n, addr, err := pc.ReadFrom(buf)
		if err != nil {
			fmt.Printf("failed readfrom : %v", err)
			continue
		}
		fmt.Printf("Read %d bytes from client %v\n", n, addr)
		fmt.Printf("%s", hex.Dump(buf[:n]))

		conn, err := tls.Dial("tcp", quadDNSTLS, &tls.Config{})
		// conn, err := net.Dial("udp", "1.1.1.1:53")
		if err != nil {
			log.Fatalf("failed to connect to server : %v", err)
		}

		remoteAddr := conn.RemoteAddr().String()
		fmt.Printf("Connected to %s\n", remoteAddr)

		// Enrich UDP to TCP add size of message infront
		b := make([]byte, 2)
		binary.BigEndian.PutUint16(b[0:], uint16(n))

		n, err = conn.Write(append(b, buf[:n]...))
		// n, err = conn.Write(buf[:n])
		if err != nil {
			fmt.Printf("failed to write to server %s : %v\n", remoteAddr, err)
			continue
		}
		fmt.Printf("Write %d bytes to server %v\n", n, remoteAddr)

		bufServer := make([]byte, 1024)
		n, err = conn.Read(bufServer)
		if err != nil {
			fmt.Printf("failed to read from server %s : %v\n", remoteAddr, err)
			continue
		}
		fmt.Printf("Read %d bytes from server %v\n", n, remoteAddr)
		fmt.Printf("%s", hex.Dump(bufServer[:n]))

		// Cut message size field: first 2 bytes for TCP -> UDP
		n, err = pc.WriteTo(bufServer[2:n], addr)
		if err != nil {
			fmt.Printf("failed to write to client %v : %v\n", addr, err)
			continue
		}
		fmt.Printf("Write %d bytes to client %v\n", n, addr)
		conn.Close()
	}
}

func init() {
	os.Setenv("GODEBUG", os.Getenv("GODEBUG")+",tls13=1")
}
