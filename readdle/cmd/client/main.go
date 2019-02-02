package main

import (
	"flag"
	"log"
	"strings"

	"bitbucket.org/miry/miry-readdle-test/pkg/client"
)

var (
	address = flag.String("address", "localhost:50051", "Server adddress to connect to.")
)

func main() {
	flag.Parse()

	if flag.NArg() == 0 {
		log.Fatalf("missing user name arguments")
	}
	username := strings.Join(flag.Args(), " ")
	chat := &client.ChatClient{
		Address:  *address,
		Username: username,
	}
	if err := chat.Run(); err != nil {
		log.Fatal(err)
	}
	log.Println("That's all folks!")
}
