package gravity_tumbler

import (
	"bufio"
	"fmt"
	"os"
)

type Input struct {
	Width  int
	Height int
	Count  int
	Fields [][]byte
}

func NewInputFromReader(r *os.File) (*Input, error) {
	scanner := bufio.NewScanner(r)
	scanner.Buffer(make([]byte, 1000000), 1000000)

	result := Input{}

	scanner.Scan()
	fmt.Sscan(scanner.Text(), &result.Width, &result.Height)

	scanner.Scan()
	fmt.Sscan(scanner.Text(), &result.Count)

	result.Fields = make([][]byte, result.Height, result.Height)
	for i := 0; i < result.Height; i++ {
		scanner.Scan()
		result.Fields[i] = scanner.Bytes()
	}

	return &result, nil
}
