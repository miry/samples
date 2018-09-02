package heap

import "fmt"

type heap struct {
	values []int
}

// NewHeap returns data strucutures Heap. Heap is a specialized tree-based data structure that satisfies the heap property:
// if P is a parent node of C, then the key (the value) of P is either greater
// than or equal to (in a max heap) or less than or equal to (in a min heap) the key of C.
// The node at the "top" of the heap (with no parents) is called the root node.
// https://en.wikipedia.org/wiki/Heap_(data_structure)
func NewHeap() *heap {
	return &heap{
		values: make([]int, 1, 10),
	}
}

func (h *heap) Max() *int {
	if h.Size() > 0 {
		return &h.values[1]
	}
	return nil
}

func (h *heap) Size() int {
	return len(h.values) - 1
}

func (h *heap) Insert(v int) error {
	h.values = append(h.values, v)
	h.swim(h.Size())
	return nil
}

func (h *heap) Print() {
	fmt.Printf("%+v\n", h.values)
}

// 0  1  2  3  4  5  6  7
// 0 88
//      51 34
//            31 24 15 22
func (h *heap) swim(k int) {
	h.Print()
	for k > 1 && h.less(k/2, k) {
		h.exch(k, k/2)
		k = k / 2
		h.Print()
	}
}

func (h *heap) less(i, j int) bool {
	return h.values[i] < h.values[j]
}

func (h *heap) exch(i, j int) {
	s := h.values[i]
	h.values[i] = h.values[j]
	h.values[j] = s
}
