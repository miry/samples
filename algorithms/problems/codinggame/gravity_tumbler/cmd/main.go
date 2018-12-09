package main

import (
	"fmt"
	"log"
	"os"

	"github.com/miry/samples/algorithms/problems/codinggame/gravity_tumbler"
)

func main() {
	input, err := gravity_tumbler.NewInputFromReader(os.Stdin)
	if err != nil {
		log.Fatalf("%v", err)
	}
	fmt.Fprintf(os.Stderr, "%#v\n", input)

	result := input.Run()
	result.Print()
}
