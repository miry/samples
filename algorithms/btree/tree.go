package btree

import (
	"reflect"
)

type Tree struct {
	Right *Tree
	Left  *Tree
	Value int
}

func (t *Tree) Equal(s *Tree) bool {
	return reflect.DeepEqual(t.Values(), s.Values())
}

func (t *Tree) Values() []int {
	result := make([]int, 0, 10)

	if t.Left != nil {
		result = t.Left.Values()
	}

	result = append(result, t.Value)

	if t.Right != nil {
		result = append(result, t.Right.Values()...)
	}

	return result
}

func (t *Tree) ValuesStream(out chan int) {
	leftCh := make(chan int)
	rightCh := make(chan int)

	if t.Left != nil {
		go t.Left.ValuesStream(leftCh)
	}

	if t.Right != nil {
		go t.Right.ValuesStream(rightCh)
	}

	if t.Left != nil {
		for i := range leftCh {
			out <- i
		}
	}

	out <- t.Value

	if t.Right != nil {
		for i := range rightCh {
			out <- i
		}
	}

	close(out)
}
