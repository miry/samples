package problems_test

import (
	"testing"
	"fmt"


	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/algorithms/problems"
)

func TestShuffleArray(t *testing.T) {
	tests := []struct {
		name     string
		subject  []int
	}{
		{"empty array", []int{}},
		{"sinlge element", []int{1}},
		{"two elements", []int{1, 2}},
		{"three elements", []int{1, 2, 3}},
		{"four elements", []int{1, 2, 3, 4}},
	}

	experiments := 100
	epsilon := float64(experiments) * 0.05

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			actuals := map[string]int{}

			for i := 0 ; i < experiments ; i++ {
				shuffled := fmt.Sprint(problems.ShuffleArray(test.subject))
				if _, ok := actuals[shuffled]; !ok {
					actuals[shuffled] = 0
				}
				actuals[shuffled] += 1
			}

			actual := actuals[fmt.Sprint(test.subject)]
			avg := float64(experiments) / float64(len(actuals))

			assert.InEpsilon(t, avg, actual, epsilon)
		})
	}
}
