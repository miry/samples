// DOOZER Application test
// Please adjust the code as required in the task description and share us the link to your solution.
package main

import "fmt"

func myRunner() func(int) int {
	prev := 0
	return func(i int) int {
		i, prev = prev+i, i
		return i
	}
}

// 3.
// Build an implementation of "myRunner" so the function returns [0, 1, 3, 5, 8, 13, 21] (these are not intended to be the fibonacci numbers)
// the implementation of "myRunner" may only contain ONE variable and a function parameter.
func BuildRunner() []int {
	rn := myRunner()
	s := []int{0, 1, 2, 3, 5, 8, 13}
	d := []int{}

	for _, x := range s {
		d = append(d, rn(x))
	}

	return d
}

func main() {
	golden := []int{0, 1, 3, 5, 8, 13, 21}
	r := BuildRunner()
	if len(r) != len(golden) {
		fmt.Printf("wrong result length: got %v; want %v\n", len(r), len(golden))
	}
	for i, v := range r {
		if v != golden[i] {
			fmt.Printf("got %v; want %v\n", v, golden[i])
		}
	}
}
