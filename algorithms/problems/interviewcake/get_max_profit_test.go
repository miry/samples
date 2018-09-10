package interviewcake_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	problems "github.com/miry/samples/algorithms/problems/interviewcake"
)

func TestGetMaxProfit(t *testing.T) {
	tests := []map[string][]int{
		{
			"in":  {},
			"out": {0},
		},
		{
			"in":  {1, 2},
			"out": {1},
		},
		{
			"in":  {2, 1},
			"out": {0},
		},
		{
			"in":  {10, 7, 5, 8, 11, 9},
			"out": {6},
		},
		{
			"in":  {10, 7, 5, 8, 11, 1, 2},
			"out": {6},
		},
		{
			"in":  {10, 7, 45, 8, 11, 20, 30},
			"out": {38},
		},
	}

	for _, test := range tests {
		actual := problems.GetMaxProfit(test["in"])
		assert.Equal(t, test["out"][0], actual, "Expected %v for %v", test["out"][0], test["in"])
	}
}
