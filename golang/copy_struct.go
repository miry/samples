package main

import (
	"fmt"
)

type A struct {
	Name   string
	Value  int
	Parent B
}

type B struct {
	Name  string
	Value int
}

type Cursor struct {
	AA A
	BB B
}

func (c *Cursor) Copy() *Cursor {
	result := &Cursor{}
	*result = *c
	return result
}

func (c *Cursor) Print() {
	fmt.Printf("cursort: %&\n", c)
	fmt.Printf("   addr: %p\n", c)
}

func main() {
	cursor := &Cursor{
		AA: A{
			Name:  "first A",
			Value: 1,
			Parent: B{
				Name:  "parent A",
				Value: 11,
			},
		},
		BB: B{
			Name:  "first B",
			Value: 1,
		},
	}

	fmt.Printf("== Start ==\n")
	cursor.Print()

	fmt.Printf("== Copy ==\n")
	dup := cursor.Copy()
	dup.Print()

	fmt.Printf("== Modify ==\n")
	dup.AA = A{Name: "second A", Value: 2}
	dup.Print()

	fmt.Printf("== Original ==\n")
	cursor.Print()
}
