// DOOZER Application test
// Please adjust the code as required in the task description and share us the link to your solution.
package main

import "fmt"

type Queue []int

func (q *Queue) RemoveLast() {
	l := (*q)
	if len(l) == 0 {
		return
	}
	ll := l[:len(l)-1]
	*q = ll
}

// 2.
// Create an implementation of "Queue" so this function returns {0, 1, 2}.
func BuildQueue(data []int) Queue {
	queue := Queue(data)
	qp := &queue
	qp.RemoveLast()
	return *qp
}

func main() {
	testCases := []struct {
		input  []int
		golden []int
	}{
		{
			[]int{0, 1, 2},
			[]int{0, 1},
		},
		{
			[]int{},
			[]int{},
		},
	}

	for _, tc := range testCases {
		q := BuildQueue(tc.input)
		if len(q) != len(tc.golden) {
			fmt.Printf("wrong queue length: got %v; want %v\n", len(q), len(tc.golden))
		}
		for i, v := range q {
			if v != tc.golden[i] {
				fmt.Printf("got %v; want %v\n", v, tc.golden[i])
			}
		}
	}
}
