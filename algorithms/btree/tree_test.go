package btree_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/algorithms/btree"
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
	assert.Equal(t, 7, wide.Size())
}

func TestTreeValuesDepth(t *testing.T) {
	depth := sample2()
	assert.Equal(t, []int{1, 1, 2, 3, 5, 8, 13}, depth.Values())
	assert.Equal(t, 7, depth.Size())
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

func TestPut(t *testing.T) {
	wide := sample1()
	assert.Equal(t, 7, wide.Size())
	wide.Put(4)
	assert.Equal(t, []int{4, 1, 1, 2, 3, 5, 8, 13}, wide.Values())
	assert.Equal(t, 8, wide.Size())

}

func sample1() *btree.Tree {
	head := &btree.Tree{
		Left: &btree.Tree{
			Count: 3,
			Left: &btree.Tree{
				Value: 1,
				Count: 1,
			},
			Right: &btree.Tree{
				Value: 2,
				Count: 1,
			},
			Value: 1,
		},
		Right: &btree.Tree{
			Count: 3,
			Left: &btree.Tree{
				Value: 5,
				Count: 1,
			},
			Right: &btree.Tree{
				Value: 13,
				Count: 1,
			},
			Value: 8,
		},
		Value: 3,
		Count: 7,
	}
	return head
}

func sample2() *btree.Tree {
	head := &btree.Tree{
		Left: &btree.Tree{
			Left: &btree.Tree{
				Left: &btree.Tree{
					Value: 1,
					Count: 1,
				},
				Right: &btree.Tree{
					Value: 2,
					Count: 1,
				},
				Value: 1,
				Count: 3,
			},
			Right: &btree.Tree{
				Value: 5,
				Count: 1,
			},
			Value: 3,
			Count: 2,
		},
		Right: &btree.Tree{
			Value: 13,
			Count: 1,
		},
		Value: 8,
		Count: 4,
	}
	return head
}
