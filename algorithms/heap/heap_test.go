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

	assert.NoError(t, heap.Insert(83))
	assert.NoError(t, heap.Insert(122))
	assert.NoError(t, heap.Insert(255))
	assert.Equal(t, 3, heap.Size())
	assert.Equal(t, 255, *heap.Max())
}
