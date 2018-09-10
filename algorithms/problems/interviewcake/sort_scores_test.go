package interviewcake_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	problems "github.com/miry/samples/algorithms/problems/interviewcake"
)

func TestSortScores(t *testing.T) {
	tests := []map[string][]int{
		{
			"in":  {},
			"out": {},
		},
		{
			"in":  {1, 2},
			"out": {1, 2},
		},
		{
			"in":  {2, 1},
			"out": {1, 2},
		},
		{
			"in":  {10, 7, 5, 8, 11, 9},
			"out": {5, 7, 8, 9, 10, 11},
		},
		{
			"in":  {10, 7, 5, 8, 11, 1, 2},
			"out": {1, 2, 5, 7, 8, 10, 11},
		},
		{
			"in":  {10, 7, 45, 8, 11, 20, 30},
			"out": {7, 8, 10, 11, 20, 30, 45},
		},
	}

	for _, test := range tests {
		actual := problems.SortScores(test["in"], 100)
		assert.Equal(t, test["out"], actual, "Expected %v for %v", test["out"], test["in"])
	}
}
