package codewars_test

import (
	"fmt"
	"math/rand"
	"testing"

	"github.com/miry/samples/algorithms/problems/codewars"
	"github.com/stretchr/testify/assert"
)

func TestArrayDiffMap(t *testing.T) {
	tests := []map[string][2][]int{
		{
			"in":  [2][]int{[]int{1, 2}, []int{1}},
			"out": [2][]int{[]int{2}},
		},
		{
			"in":  [2][]int{[]int{1, 2, 2}, []int{1}},
			"out": [2][]int{[]int{2, 2}},
		},
		{
			"in":  [2][]int{[]int{1, 2, 2}, []int{2}},
			"out": [2][]int{[]int{1}},
		},
		{
			"in":  [2][]int{[]int{1, 2, 2}, []int{}},
			"out": [2][]int{[]int{1, 2, 2}},
		},
		{
			"in":  [2][]int{[]int{}, []int{1, 2, 2}},
			"out": [2][]int{[]int{}},
		},
	}

	for _, test := range tests {
		actual := codewars.ArrayDiffMap(test["in"][0], test["in"][1])
		assert.Equal(t, test["out"][0], actual, "Expected %v for %v", test["out"][0], test["in"])
	}
}

func TestArrayDiffInclude(t *testing.T) {
	tests := []map[string][2][]int{
		{
			"in":  [2][]int{[]int{1, 2}, []int{1}},
			"out": [2][]int{[]int{2}},
		},
		{
			"in":  [2][]int{[]int{1, 2, 2}, []int{1}},
			"out": [2][]int{[]int{2, 2}},
		},
		{
			"in":  [2][]int{[]int{1, 2, 2}, []int{2}},
			"out": [2][]int{[]int{1}},
		},
		{
			"in":  [2][]int{[]int{1, 2, 2}, []int{}},
			"out": [2][]int{[]int{1, 2, 2}},
		},
		{
			"in":  [2][]int{[]int{}, []int{1, 2, 2}},
			"out": [2][]int{[]int{}},
		},
	}

	for _, test := range tests {
		actual := codewars.ArrayDiffInclude(test["in"][0], test["in"][1])
		assert.Equal(t, test["out"][0], actual, "Expected %v for %v", test["out"][0], test["in"])
	}
}

func BenchmarkArrayDiff(b *testing.B) {
	for i := 0; i <= 1000; i += 10 {
		benchmarkArrayDiff(b, i)
	}
}

func benchmarkArrayDiff(b *testing.B, size int) {
	rand.Seed(int64(size % 42))

	exclude := make([]int, size, size)
	for i := 0; i < size; i++ {
		exclude[i] = rand.Intn(size)
	}

	subject := make([]int, size*2, size*2)
	for i := 0; i < size*2; i++ {
		subject[i] = rand.Intn(size)
	}

	test := [2][]int{
		subject,
		exclude,
	}

	b.ResetTimer()

	b.Run(fmt.Sprintf("ArrayDiffMap_%d", size), func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			codewars.ArrayDiffMap(test[0], test[1])
		}
	})

	b.Run(fmt.Sprintf("ArrayDiffInclude_%d", size), func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			codewars.ArrayDiffInclude(test[0], test[1])
		}
	})
}
