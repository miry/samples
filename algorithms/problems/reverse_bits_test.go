package problems_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/algorithms/problems"
)

func TestReverseBits(t *testing.T) {
	tests := []map[string]uint8{
		{
			"in":  0xAB,
			"out": 0xD5,
		},
		{
			"in":  0xFF,
			"out": 0xFF,
		},
		{
			"in":  0x00,
			"out": 0x00,
		},
	}

	for _, test := range tests {
		actual := problems.ReverseBits(test["in"])
		assert.Equal(t, test["out"], actual)
	}
}
