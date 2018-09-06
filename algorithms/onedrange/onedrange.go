package onedrange

import (
	"github.com/miry/samples/algorithms/btree"
)

type Tree struct {
	*btree.Tree
}

func (t *Tree) Rank(max int) int {
	return rank(t.Tree, max)
}

func (t *Tree) Size(lo, hi int) int {
	result := rank(t.Tree, hi) - rank(t.Tree, lo)
	if contains(t.Tree, hi) {
		result++
	}
	return result
}

func contains(t *btree.Tree, val int) bool {
	if t == nil {
		return false
	}

	cmp := btree.Compare(t.Value, val)
	if cmp == 1 {
		return contains(t.Left, val)
	} else if cmp == -1 {
		return contains(t.Right, val)
	}

	return true
}

func rank(t *btree.Tree, max int) int {
	if t == nil {
		return 0
	}

	cmp := btree.Compare(t.Value, max)
	if cmp == 1 {
		return rank(t.Left, max)
	} else if cmp == -1 {
		return 1 + t.Left.Size() + rank(t.Right, max)
	} else {
		return t.Left.Size()
	}
}
