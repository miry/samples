package main

import (
	"flag"
	"fmt"
	"log"
	"os"

	"github.com/miry/samples/godnsproxy/pkg/dnstls"
	"github.com/miry/samples/godnsproxy/pkg/version"
)

var (
	server       = flag.String("server", "1.1.1.1:853", "DNS upstream server")
	printVersion = flag.Bool("version", false, "Print version")
)

func main() {
	flag.Parse()

	if *printVersion {
		fmt.Println("DNS server:", *server)
		fmt.Printf("%#v\n", version.Get())
		os.Exit(0)
	}

	names := flag.Args()

	if len(names) == 0 {
		log.Fatal("No names to resolve")
	}

	resolver, err := dnstls.New(*server)
	if err != nil {
		log.Fatalf("Could not connect to server %s : %v\n", *server, err)
	}

	for _, name := range names {
		fmt.Printf("%s : ", name)
		result, err := resolver.Lookup(name)

		if err == nil {
			fmt.Println(result)
		} else {
			fmt.Println(err.Error())
		}

	}
}

func init() {
	os.Setenv("GODEBUG", os.Getenv("GODEBUG")+",tls13=1")
}
