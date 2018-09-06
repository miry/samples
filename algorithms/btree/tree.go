package btree

import (
	"reflect"
)

type Tree struct {
	Right *Tree
	Left  *Tree
	Value int
	Count int
}

func (t *Tree) Put(val int) {
	if t == nil {
		return
	}

	cmp := Compare(t.Value, val)
	if cmp == 1 {
		if t.Right != nil {
			t.Right.Put(val)
		} else {
			t.Right = &Tree{Value: val}
		}
	} else if cmp <= 0 {
		if t.Left != nil {
			t.Left.Put(val)
		} else {
			t.Left = &Tree{Value: val}
		}
	}
	t.Count = 1 + t.Left.Size() + t.Right.Size()
}

func (t *Tree) Size() int {
	if t == nil {
		return 0
	}

	if t.Count == 0 {
		t.Count = len(t.Values())
	}
	return t.Count
}

func (t *Tree) Equal(s *Tree) bool {
	return reflect.DeepEqual(t.Values(), s.Values())
}

func (t *Tree) Values() []int {
	if t == nil {
		return []int{}
	}

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

func Compare(a, b int) int {
	if a == b {
		return 0
	}
	if a < b {
		return -1
	}
	return +1
}
