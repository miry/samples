package heap_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/algorithms/heap"
)

func TestHeap(t *testing.T) {
	heap := heap.NewHeap()
	assert.Nil(t, heap.Max())
}

func TestHeapSize(t *testing.T) {
	heap := heap.NewHeap()
	assert.Equal(t, 0, heap.Size())
}

func TestHeapInsert(t *testing.T) {
	heap := heap.NewHeap()
	assert.Equal(t, 0, heap.Size())

	assert.NoError(t, heap.Insert(1))
	assert.Equal(t, 1, heap.Size())
}
