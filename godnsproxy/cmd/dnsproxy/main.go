package main

import (
	"crypto/tls"
	"encoding/hex"
	"fmt"
	"log"
	"net"
	"os"
)

var udpTcpDiffReq = []byte{0x00, 0x2c}
var udpTcpDiffRes = []byte{0x00, 0x4c}

func main() {
	// listen to incoming udp packets
	pc, err := net.ListenPacket("udp", ":1053")
	if err != nil {
		log.Fatal(err)
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
		fmt.Printf("%s", hex.Dump(append(udpTcpDiffReq, buf[:n]...)))

		conn, err := tls.Dial("tcp", quadDNSTLS, &tls.Config{})
		// conn, err := net.Dial("udp", "1.1.1.1:53")
		if err != nil {
			log.Fatalf("failed to connect to server : %v", err)
		}

		remoteAddr := conn.RemoteAddr().String()
		fmt.Printf("Connected to %s\n", remoteAddr)

		n, err = conn.Write(append(udpTcpDiffReq, buf[:n]...))
		// n, err = conn.Write(buf[:n])
		if err != nil {
			fmt.Printf("failed to write to server %s : %v\n", remoteAddr, err)
			continue
		}
		fmt.Printf("Write %d bytets to server %v\n", n, remoteAddr)

		bufServer := make([]byte, 1024)
		n, err = conn.Read(bufServer)
		if err != nil {
			fmt.Printf("failed to read from server %s : %v\n", remoteAddr, err)
			continue
		}
		fmt.Printf("Read %d bytets from server %v\n", n, remoteAddr)
		fmt.Printf("%s", hex.Dump(bufServer[:n]))

		n, err = pc.WriteTo(bufServer[2:n], addr)
		if err != nil {
			fmt.Printf("failed to write to client %v : %v\n", addr, err)
			continue
		}
		fmt.Printf("Write %d bytets to client %v\n", n, addr)
		conn.Close()
	}
}

func init() {
	os.Setenv("GODEBUG", os.Getenv("GODEBUG")+",tls13=1")
}
