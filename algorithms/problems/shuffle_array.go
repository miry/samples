package problems

import (
	"math/rand"
	"time"
)

func ShuffleArray(in []int) []int {
	r := rand.New(rand.NewSource(time.Now().UnixNano()))

	n := len(in)

	for i := 0; i < n - 1; i += 1 {
		d := r.Intn(n - i)
		swap(in, i, i+d)
	}

	return in
}

func swap(in []int, i, j int) {
	in[i], in[j] = in[j], in[i]
}
