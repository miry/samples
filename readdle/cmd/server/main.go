package main

import (
	"flag"
	"log"
	"net"

	grpc "google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	pb "bitbucket.org/miry/miry-readdle-test/pkg/chat"
	"bitbucket.org/miry/miry-readdle-test/pkg/server"
)

var (
	address = flag.String("address", "0.0.0.0:50051", "Listen port for new client connections")
)

func main() {
	flag.Parse()

	// Listen port
	lis, err := net.Listen("tcp", *address)
	if err != nil {
		log.Fatalf("failed to listen %s: %v", *address, err)
	}

	// Initialize GRPC server
	s := grpc.NewServer()
	pb.RegisterChatServer(s, &server.ChatServer{})
	reflection.Register(s)
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
	log.Println("That's all folks!")
}
