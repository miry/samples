package interviewcake_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	problems "github.com/miry/samples/algorithms/problems/interviewcake"
)

func TestGetMaxProfit(t *testing.T) {
	tests := []map[string][]int{
		map[string][]int{
			"in":  []int{},
			"out": []int{0},
		},
		map[string][]int{
			"in":  []int{1, 2},
			"out": []int{1},
		},
		map[string][]int{
			"in":  []int{2, 1},
			"out": []int{0},
		},
		map[string][]int{
			"in":  []int{10, 7, 5, 8, 11, 9},
			"out": []int{6},
		},
		map[string][]int{
			"in":  []int{10, 7, 5, 8, 11, 1, 2},
			"out": []int{6},
		},
		map[string][]int{
			"in":  []int{10, 7, 45, 8, 11, 20, 30},
			"out": []int{38},
		},
	}

	for _, test := range tests {
		actual := problems.GetMaxProfit(test["in"])
		assert.Equal(t, test["out"][0], actual, "Expected %v for %v", test["out"][0], test["in"])
	}
}
