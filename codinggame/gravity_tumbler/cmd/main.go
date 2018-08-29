package main

import (
	"fmt"
	"log"
	"os"

	"github.com/miry/samples/codinggame/gravity_tumbler"
)

var default_the_name = "Nice"

func main() {
	input, err := gravity_tumbler.NewInputFromReader(os.Stdin)
	if err != nil {
		log.Fatalf("%v", err)
	}
	fmt.Fprintf(os.Stderr, "%#v\n", input)
}
