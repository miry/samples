package union_find_test

import (
	"fmt"
	"math/rand"
	"testing"

	"github.com/miry/samples/algorithms/union_find"
	"github.com/stretchr/testify/assert"
)

func TestEmpty(t *testing.T) {
	subject := union_find.NewUF(9)
	assert.NotNil(t, subject)
}

func TestUnion(t *testing.T) {
	subject := union_find.NewUF(9)
	subject.Union(1, 8)
	assert.True(t, subject.Connected(1, 8))
}

func TestConnectedZeroLevel(t *testing.T) {
	subject := union_find.NewUF(9)
	assert.True(t, subject.Connected(1, 1))
	assert.False(t, subject.Connected(1, 2))
}

func TestConnectedFirstLevel(t *testing.T) {
	subject := union_find.NewUF(9)
	subject.Union(1, 2)
	assert.True(t, subject.Connected(1, 1))
	assert.True(t, subject.Connected(1, 2))
}

func TestConnectedSecondLevel(t *testing.T) {
	subject := union_find.NewUF(9)
	subject.Union(1, 2)
	subject.Union(2, 3)
	assert.True(t, subject.Connected(1, 3))
}

func TestMultiUnion(t *testing.T) {
	subject := union_find.NewUF(9)
	subject.Union(1, 2)
	subject.Union(1, 3)
	assert.True(t, subject.Connected(2, 3))
}

func TestCycleUnion(t *testing.T) {
	subject := union_find.NewUF(9)
	subject.Union(1, 2)
	subject.Union(2, 3)
	subject.Union(3, 1)
	assert.True(t, subject.Connected(2, 3))
	assert.True(t, subject.Connected(1, 3))
	assert.True(t, subject.Connected(1, 2))
}

func BenchmarkInit(b *testing.B) {
	for i := 1; i < 100; i += 5 {
		benchmarkInit(b, i)
	}
}

func benchmarkInit(b *testing.B, size int) {
	b.ResetTimer()

	b.Run(fmt.Sprintf("UF_%d", size), func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			union_find.NewUF(size)
		}
	})
}

func BenchmarkUnion(b *testing.B) {
	for i := 1; i < 100; i += 5 {
		benchmarkUnion(b, i)
	}
}

func benchmarkUnion(b *testing.B, size int) {
	uf := union_find.NewUF(size)
	indexes := make([]int, size, size)

	rand.Seed(int64(size % 42))
	for i := 0; i < size; i++ {
		indexes[i] = rand.Intn(size)
	}
	var x, y int

	b.ResetTimer()

	b.Run(fmt.Sprintf("UF_%d", size), func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			x = indexes[i%size]
			y = indexes[size-i%size-1]
			uf.Union(x, y)
		}
	})
}
