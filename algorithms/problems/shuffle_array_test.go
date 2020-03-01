package problems_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/algorithms/problems"
)

func TestShuffleArray(t *testing.T) {
	tests := []struct {
		name     string
		subject  []int
		expected []int
	}{
		{"empty array", []int{}, []int{}},
		{"sinlge element", []int{1}, []int{1}},
	}

	for _, test := range tests {
		actual := problems.ShuffleArray(test.subject)
		assert.Equal(t, test.expected, actual)
	}

	tests = []struct {
		name     string
		subject  []int
		expected []int
	}{
		{"two elements", []int{1, 2}, []int{1, 2}},
		{"three elements", []int{1, 2, 3}, []int{1, 2, 3}},
		{"four elements", []int{1, 2, 3, 4}, []int{1, 2, 3, 4}},
	}

	for _, test := range tests {
		actual := problems.ShuffleArray(test.subject)
		assert.NotEqual(t, test.expected, actual)
	}

}
