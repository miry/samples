package btree_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/btree"
)

func TestTree(t *testing.T) {
	tree := btree.Tree{}
	assert.Nil(t, tree.Right)
	assert.Nil(t, tree.Left)
	assert.Equal(t, 0, tree.Value)
}

func TestTreeValuesWide(t *testing.T) {
	wide := sample1()
	assert.Equal(t, []int{1, 1, 2, 3, 5, 8, 13}, wide.Values())
}

func TestTreeValuesDepth(t *testing.T) {
	depth := sample2()
	assert.Equal(t, []int{1, 1, 2, 3, 5, 8, 13}, depth.Values())
}

func TestTreeValuesStreamWide(t *testing.T) {
	wide := sample1()
	out := make(chan int)
	go wide.ValuesStream(out)
	actual := []int{}
	for i := range out {
		actual = append(actual, i)
	}
	assert.Equal(t, []int{1, 1, 2, 3, 5, 8, 13}, actual)
}

func TestSameTreesEqual(t *testing.T) {
	wide := sample1()
	same := sample1()
	assert.True(t, wide.Equal(same))
}

func TestTreesEqual(t *testing.T) {
	wide := sample1()
	depth := sample2()
	assert.True(t, wide.Equal(depth))
}

func sample1() *btree.Tree {
	head := &btree.Tree{
		Left: &btree.Tree{
			Left: &btree.Tree{
				Value: 1,
			},
			Right: &btree.Tree{
				Value: 2,
			},
			Value: 1,
		},
		Right: &btree.Tree{
			Left: &btree.Tree{
				Value: 5,
			},
			Right: &btree.Tree{
				Value: 13,
			},
			Value: 8,
		},
		Value: 3,
	}
	return head
}

func sample2() *btree.Tree {
	head := &btree.Tree{
		Left: &btree.Tree{
			Left: &btree.Tree{
				Left: &btree.Tree{
					Value: 1,
				},
				Right: &btree.Tree{
					Value: 2,
				},
				Value: 1,
			},
			Right: &btree.Tree{
				Value: 5,
			},
			Value: 3,
		},
		Right: &btree.Tree{
			Value: 13,
		},
		Value: 8,
	}
	return head
}
