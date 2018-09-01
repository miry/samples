package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

type coord struct {
	row   int
	col   int
	field [][]byte
	prev  *coord
}

func (c *coord) isElement(el byte) bool {
	return c.field[c.row][c.col] == el
}

func (c *coord) value() byte {
	return c.field[c.row][c.col]
}

// TODO: Check for visited cells and process them
func (c *coord) routeTo(el byte) []*coord {
	visited := map[string]bool{
		c.String(): true,
	}
	elements := c.getNeighbours()
	for {
		newCells := []*coord{}
		for _, cell := range elements {
			switch cell.value() {
			case '.':
				for _, cell := range cell.getNeighbours() {
					if _, ok := visited[cell.String()]; !ok {
						visited[cell.String()] = true
						newCells = append(newCells, cell)
					}
				}
			case el:
				return cell.route()
			}
		}
		elements = newCells
	}
}

func (c *coord) route() []*coord {
	result := []*coord{}
	for cell := c; cell != nil; cell = cell.prev {
		result = append(result, cell)
	}
	return result
}
func (c *coord) getNeighbours() []*coord {
	result := make([]*coord, 0, 4)

	rows := len(c.field)
	cols := len(c.field[0])

	if c.row > 0 {
		cell := coord{c.row - 1, c.col, c.field, c}
		result = append(result, &cell)
	}

	if c.row < rows-1 {
		cell := coord{c.row + 1, c.col, c.field, c}
		result = append(result, &cell)
	}

	if c.col > 0 {
		cell := coord{c.row, c.col - 1, c.field, c}
		result = append(result, &cell)
	}

	if c.col < cols-1 {
		cell := coord{c.row, c.col + 1, c.field, c}
		result = append(result, &cell)
	}

	return result
}

func (c *coord) isBlocked() bool {
	return c.isElement('#')
}

func (c *coord) isBike() bool {
	return c.isElement('B')
}

func (c *coord) isEmployee() bool {
	return c.isElement('E')
}

func (c *coord) String() string {
	return fmt.Sprintf("(%d,%d)", c.row, c.col)
}

func parseInput() ([][]byte, error) {
	scanner := bufio.NewScanner(os.Stdin)

	result := [][]byte{}
	for scanner.Scan() {
		result = append(result, scanner.Bytes())
	}
	return result, nil
}

func findElement(field [][]byte, el byte) *coord {
	for i, row := range field {
		for j, cell := range row {
			if cell == el {
				return &coord{i, j, field, nil}
			}
		}
	}
	return nil
}

func main() {
	field, err := parseInput()
	if err != nil {
		log.Fatalf("could not parse input %v", err)
	}

	for i, row := range field {
		for j, cell := range row {
			fmt.Printf("(%d,%d): %c  | ", i, j, cell)
		}
		fmt.Printf("\n")
	}

	bike := findElement(field, 'B')
	if bike == nil {
		log.Fatal("could not find Bike coordinates")
	}

	fmt.Printf("bike coord: %s\n", bike)
	neighbours := bike.getNeighbours()
	fmt.Printf("next coords: %v\n", neighbours)
	n := neighbours[0]
	fmt.Printf("route: %v\n", n.route())
	fmt.Printf("bike route: %v\n", bike.routeTo('E'))
	fmt.Println()
}
