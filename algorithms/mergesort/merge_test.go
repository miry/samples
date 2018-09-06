package mergesort_test

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/algorithms/mergesort"
)

func TestSortArray(t *testing.T) {
	tables := []map[string][]int{
		map[string][]int{
			"in":  []int{},
			"out": []int{},
		},
		map[string][]int{
			"in":  []int{1},
			"out": []int{1},
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
			"in":  []int{1, 3, 2},
			"out": []int{1, 2, 3},
		},
		map[string][]int{
			"in":  []int{5, 1, 3, 2},
			"out": []int{1, 2, 3, 5},
		},
		map[string][]int{
			"in":  []int{12, 5, 1, 3, 2},
			"out": []int{1, 2, 3, 5, 12},
		},
		map[string][]int{
			"in":  []int{12, 1, 1, 3, 2, 12, 3},
			"out": []int{1, 1, 2, 3, 3, 12, 12},
		},
	}

	for _, row := range tables {
		fmt.Println("Case: ", row["in"])
		actual := mergesort.Sort(row["in"])
		assert.Equal(t, row["out"], actual)
	}
}
