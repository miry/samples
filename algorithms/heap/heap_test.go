package heap_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/algorithms/heap"
)

func TestHeapMaxNil(t *testing.T) {
	heap := heap.NewHeap()
	assert.Nil(t, heap.Max())
}

func TestHeapSizeEmpty(t *testing.T) {
	heap := heap.NewHeap()
	assert.Equal(t, 0, heap.Size())
}

func TestHeapInsertOneElement(t *testing.T) {
	heap := heap.NewHeap()
	assert.Equal(t, 0, heap.Size())

	assert.NoError(t, heap.Insert(83))
	assert.Equal(t, 1, heap.Size())
	assert.Equal(t, 83, *heap.Max())
}

func TestHeapInsertTwoElements(t *testing.T) {
	heap := heap.NewHeap()
	assert.Equal(t, 0, heap.Size())

	assert.NoError(t, heap.Insert(83))
	assert.NoError(t, heap.Insert(122))
	assert.Equal(t, 2, heap.Size())
	assert.Equal(t, 122, *heap.Max())
}

func TestHeapInsertThreeElements(t *testing.T) {
	heap := heap.NewHeap()
	assert.Equal(t, 0, heap.Size())

	for _, i := range []int{83, 122, 255} {
		assert.NoError(t, heap.Insert(i))
	}

	assert.Equal(t, 3, heap.Size())
	assert.Equal(t, 255, *heap.Max())
}

func TestHeapDeleteMax(t *testing.T) {
	heap := heap.NewHeap()
	for _, i := range []int{83, 122, 255} {
		assert.NoError(t, heap.Insert(i))
	}
	assert.Equal(t, 255, *heap.DeleteMax())
	assert.Equal(t, 2, heap.Size())
}

func TestHeapSort(t *testing.T) {
	heap := heap.NewHeap()
	subject := []int{83, 122, 255, 38, 1, 32}
	for _, i := range subject {
		assert.NoError(t, heap.Insert(i))
	}
	actual := make([]int, len(subject), len(subject))
	for i := 0; i < len(subject); i++ {
		actual[i] = *heap.DeleteMax()
	}
	assert.Equal(t, []int{255, 122, 83, 38, 32, 1}, actual)
}
