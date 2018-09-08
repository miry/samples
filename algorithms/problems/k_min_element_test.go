package problems_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/algorithms/problems"
)

func TestKMinElement(t *testing.T) {
	tests := []map[string][]int{
		map[string][]int{
			"in":  []int{1, 2, 3, 4, 5, 6, 7},
			"out": []int{1, 2, 3},
		},
		map[string][]int{
			"in":  []int{4, 1, 5, 2, 3, 0, 10},
			"out": []int{0, 1, 2},
		},
	}

	for _, test := range tests {
		actual := problems.KMinElement(test["in"], 3)
		assert.Equal(t, test["out"], actual)
	}
}
