package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/miry/samples/godnsproxy/pkg/version"
)

var (
	server       = flag.String("server", "1.1.1.1", "DNS upstream server")
	printVersion = flag.Bool("version", false, "Print version")
)

func main() {
	flag.Parse()

	if *printVersion {
		fmt.Println("DNS server:", *server)
		fmt.Printf("%#v\n", version.Get())
		os.Exit(0)
	}
}
