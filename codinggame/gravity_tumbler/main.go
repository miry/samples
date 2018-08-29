package main

import (
	"bufio"
	"fmt"
	"os"
)

type Input struct {
	width  int
	height int
	count  int
	fields []string
}

func readInput() *Input {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Buffer(make([]byte, 1000000), 1000000)

	result := Input{}

	scanner.Scan()
	fmt.Sscan(scanner.Text(), &result.width, &result.height)

	scanner.Scan()
	fmt.Sscan(scanner.Text(), &result.count)

	result.fields = make([]string, result.height, result.height)
	for i := 0; i < result.height; i++ {
		scanner.Scan()
		result.fields[i] = scanner.Text()
	}

	return &result
}

func main() {
	input := readInput()
	fmt.Fprintf(os.Stderr, "%#v\n", input)
}
