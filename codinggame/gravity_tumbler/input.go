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

func (i *Input) Gravity() *Input {
	result := make([][]byte, i.Height)

	for j := 0; j < i.Height; j++ {
		result[j] = make([]byte, i.Width, i.Width)
	}

	for j := 0; j < i.Width; j++ {
		light := countsOf(i.Fields, j, '.')
		for k := 0; k < light; k++ {
			result[k][j] = '.'
		}
		for k := light; k < i.Height; k++ {
			result[k][j] = '#'
		}
	}

	input := Input{
		Width:  i.Width,
		Height: i.Height,
		Fields: result,
	}

	return &input
}

func (i *Input) Rotate() *Input {
	result := make([][]byte, i.Width)

	for j := 0; j < i.Width; j++ {
		result[j] = make([]byte, i.Height, i.Height)
	}

	for j := 0; j < i.Width; j++ {
		for k := 0; k < i.Height; k++ {
			result[j][k] = i.Fields[k][j]
		}
	}

	input := Input{
		Width:  i.Height,
		Height: i.Width,
		Fields: result,
	}
	return &input
}

func countsOf(field [][]byte, col int, c byte) int {
	result := 0
	for _, row := range field {
		if row[col] == c {
			result++
		}
	}
	return result
}
