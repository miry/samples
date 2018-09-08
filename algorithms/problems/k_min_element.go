package problems

import (
	"container/heap"
	"math"
)

// IntMaxHeap implements Max Heap
type IntMaxHeap []int

func (h IntMaxHeap) Len() int           { return len(h) }
func (h IntMaxHeap) Less(i, j int) bool { return h[i] > h[j] }
func (h IntMaxHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

// Push use pointer receivers because they modify the slice's length,
// not just its contents.
func (h *IntMaxHeap) Push(x interface{}) {
	*h = append(*h, x.(int))
}

// Pop use pointer receivers because they modify the slice's length,
// not just its contents.
func (h *IntMaxHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[0 : n-1]
	return x
}

// Max returns head
func (h *IntMaxHeap) Max() int {
	arr := *h
	if len(arr) > 0 {
		return arr[0]
	}
	return math.MaxInt32
}

// KMinElement finds K smallest items from array
func KMinElement(arr []int, k int) []int {
	h := &IntMaxHeap{}
	heap.Init(h)
	for i, item := range arr {
		if i < k { // Time complexity: O(k)
			// Fill heap with first element
			heap.Push(h, item)
		} else { // Time complexity: O(n-k)
			if h.Max() > item {
				heap.Pop(h)        // Time complexity: O(1)
				heap.Push(h, item) // Time complexity: O(log k)
			}
		}
	}

	// Reverse returns max elements. Heap sort
	result := make([]int, k, k)
	for j := k - 1; j >= 0; j-- { // Time complexity: O(k)
		result[j] = heap.Pop(h).(int)
	}
	return result
}

// Time complexity: O(k + (n - k) * log k)
