package mergesort_test

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/algorithms/mergesort"
)

func TestSortArray(t *testing.T) {
	tables := []map[string][]int{
		{
			"in":  {},
			"out": {},
		},
		{
			"in":  {1},
			"out": {1},
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
			"in":  {1, 3, 2},
			"out": {1, 2, 3},
		},
		{
			"in":  {5, 1, 3, 2},
			"out": {1, 2, 3, 5},
		},
		{
			"in":  {12, 5, 1, 3, 2},
			"out": {1, 2, 3, 5, 12},
		},
		{
			"in":  {12, 1, 1, 3, 2, 12, 3},
			"out": {1, 1, 2, 3, 3, 12, 12},
		},
	}

	for _, row := range tables {
		fmt.Println("Case: ", row["in"])
		actual := mergesort.Sort(row["in"])
		assert.Equal(t, row["out"], actual)
	}
}
