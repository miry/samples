package benchmarks

import (
	"math/rand"
	"testing"
)

func BenchmarkAccessStructure(b *testing.B) {
	const size int = int(100)

	var indexes = make([]int, size, size)
	var arr = make([]int, size, size)
	var hash = make(map[int]int)

	rand.Seed(42)
	for i := 0; i < size; i++ {
		indexes[i] = rand.Intn(size)
		arr[i] = i
		hash[i] = i
	}

	b.ResetTimer()

	b.Run("Array", func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			indx := indexes[i]
			_ = arr[indx]
		}
	})

	b.Run("Hash", func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			indx := indexes[i]
			_ = hash[indx]
		}
	})
}
