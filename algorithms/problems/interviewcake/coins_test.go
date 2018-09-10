package interviewcake_test

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"

	problems "github.com/miry/samples/algorithms/problems/interviewcake"
)

func TestCoins(t *testing.T) {
	tests := []map[string][][]int{
		{
			"in":  {{0}, {1}},
			"out": {},
		},
		{
			"in":  {{0}, {}},
			"out": nil,
		},
		{
			"in":  {{1}, {}},
			"out": nil,
		},
		{
			"in":  {{1}, {2}},
			"out": nil,
		},
		{
			"in":  {{1}, {1, 2, 3}},
			"out": {{1}},
		},
		{
			"in":  {{2}, {1, 2, 3}},
			"out": {{1, 1}, {2}},
		},
		{
			"in":  {{3}, {1, 2, 3}},
			"out": {{1, 1, 1}, {2, 1}, {3}},
		},
		{
			"in":  {{4}, {1, 2, 3}},
			"out": {{1, 1, 1, 1}, {2, 1, 1}, {3, 1}, {2, 2}},
		},
		{
			"in":  {{4}, {4, 2, 3}},
			"out": {{4}, {2, 2}},
		},
	}

	for _, test := range tests {
		fmt.Println("Test Case: ", test["in"])
		actual := problems.Coins(test["in"][0][0], test["in"][1])
		assert.Equal(t, test["out"], actual, "Expected %v for %v by %v", test["out"], test["in"][0][0], test["in"][1])
	}
}
