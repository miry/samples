package onedrange

import (
	"fmt"

	"github.com/miry/samples/algorithms/btree"
)

type Tree struct {
	*btree.Tree
}

func (t *Tree) Rank(max int) int {
	return rank(t.Tree, max)
}

func rank(t *btree.Tree, max int) int {
	if t == nil {
		return 0
	}

	cmp := btree.Compare(t.Value, max)
	fmt.Printf("rank for: %v and max: %v cmp: %d\n", t.Value, max, cmp)
	if cmp == 1 {
		return rank(t.Left, max)
	} else if cmp == -1 {
		return 1 + t.Left.Size() + rank(t.Right, max)
	} else {
		return t.Left.Size()
	}
}
