package interviewcake_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	problems "github.com/miry/samples/algorithms/problems/interviewcake"
)

func TestSortScores(t *testing.T) {
	tests := []map[string][]int{
		map[string][]int{
			"in":  []int{},
			"out": []int{},
		},
		map[string][]int{
			"in":  []int{1, 2},
			"out": []int{1, 2},
		},
		map[string][]int{
			"in":  []int{2, 1},
			"out": []int{1, 2},
		},
		map[string][]int{
			"in":  []int{10, 7, 5, 8, 11, 9},
			"out": []int{5, 7, 8, 9, 10, 11},
		},
		map[string][]int{
			"in":  []int{10, 7, 5, 8, 11, 1, 2},
			"out": []int{1, 2, 5, 7, 8, 10, 11},
		},
		map[string][]int{
			"in":  []int{10, 7, 45, 8, 11, 20, 30},
			"out": []int{7, 8, 10, 11, 20, 30, 45},
		},
	}

	for _, test := range tests {
		actual := problems.SortScores(test["in"], 100)
		assert.Equal(t, test["out"], actual, "Expected %v for %v", test["out"], test["in"])
	}
}
