package hackerrank_test

import (
	"testing"

	"github.com/miry/samples/algorithms/problems/hackerrank"
	"github.com/stretchr/testify/assert"
)

func TestCountingValleys(t *testing.T) {
	tests := []struct {
		n        int
		path     string
		expected int
	}{
		{
			6,
			"UUUUUU",
			0,
		},
		{
			8,
			"UDDDUDUU",
			1,
		},
		{
			12,
			"DDUUDDUDUUUD",
			2,
		},
	}

	for _, test := range tests {
		actual := hackerrank.CountingValleys(test.n, test.path)
		assert.Equal(t, test.expected, actual)
	}
}
