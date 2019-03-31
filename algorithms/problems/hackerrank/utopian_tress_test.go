package hackerrank_test

import (
	"testing"

	"github.com/miry/samples/algorithms/problems/hackerrank"
	"github.com/stretchr/testify/assert"
)

func TestUtopianTree(t *testing.T) {
	tests := []map[string]int32{
		{
			"in":  0,
			"out": 1,
		},
		{
			"in":  1,
			"out": 2,
		},
		{
			"in":  2,
			"out": 3,
		},
		{
			"in":  3,
			"out": 6,
		},
		{
			"in":  4,
			"out": 7,
		},
		{
			"in":  10,
			"out": 63,
		},
	}

	for _, test := range tests {
		actual := hackerrank.UtopianTree(test["in"])
		assert.Equal(t, test["out"], actual)
	}
}
