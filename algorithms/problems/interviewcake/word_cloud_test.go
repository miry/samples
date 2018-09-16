package interviewcake_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	problems "github.com/miry/samples/algorithms/problems/interviewcake"
)

func TestCloudify(t *testing.T) {
	ins := []string{
		"After beating the eggs 2, Dana read the next step: Add milk and eggs, then add flour and sugar.",
		"We came, we saw, we conquered...then we ate Bill's (Mille-Feuille) cake.The bill came to five dollars.",
	}

	outs := []problems.WordStats{
		map[string]int{
			"AFTER":   1,
			"BEATING": 1,
			"ADD":     2,
			"AND":     2,
		},
		map[string]int{
			"WE":  4,
			"THE": 1,
		},
	}

	for i, test := range ins {
		actual := problems.Cloudify(test)
		for w, count := range outs[i] {
			assert.Equal(t, count, actual[w])
		}
	}
}
