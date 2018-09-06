package onedrange_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/algorithms/btree"
	"github.com/miry/samples/algorithms/onedrange"
)

func TestInit(t *testing.T) {
	subject := onedrange.Tree{}
	assert.NotNil(t, subject)
}

func TestRankSmall(t *testing.T) {
	subject := &onedrange.Tree{
		Tree: &btree.Tree{
			Value: 2,
			Count: 3,
			Left: &btree.Tree{
				Value: 1,
				Count: 1,
			},
			Right: &btree.Tree{
				Value: 3,
				Count: 1,
			},
		},
	}
	assert.NotNil(t, subject)
	assert.Equal(t, 3, subject.Tree.Size())
	assert.Equal(t, 0, subject.Rank(1))
	assert.Equal(t, 1, subject.Rank(2))
	assert.Equal(t, 3, subject.Rank(5))
}

func TestRank(t *testing.T) {
	subject := sample2()
	assert.NotNil(t, subject)

	assert.Equal(t, 0, subject.Rank(-1))
	assert.Equal(t, 1, subject.Rank(1))
	assert.Equal(t, 2, subject.Rank(2))
	assert.Equal(t, 3, subject.Rank(5))
	assert.Equal(t, 7, subject.Rank(15))
}

func TestSize(t *testing.T) {
	subject := sample2()
	assert.NotNil(t, subject)

	assert.Equal(t, 0, subject.Size(-20, -1))
	assert.Equal(t, 7, subject.Size(-1, 15))
	assert.Equal(t, 1, subject.Size(-1, 0))
	assert.Equal(t, 2, subject.Size(-1, 1))
}

func sample2() *onedrange.Tree {
	head := &btree.Tree{
		Left: &btree.Tree{
			Left: &btree.Tree{
				Left: &btree.Tree{
					Value: 0,
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
				Value: 3,
				Count: 1,
			},
			Value: 5,
			Count: 5,
		},
		Right: &btree.Tree{
			Value: 13,
			Count: 1,
		},
		Value: 8,
		Count: 7,
	}
	return &onedrange.Tree{Tree: head}
}
