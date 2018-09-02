package heap

// Heap is a specialized tree-based data structure that satisfies the heap property:
// if P is a parent node of C, then the key (the value) of P is either greater
// than or equal to (in a max heap) or less than or equal to (in a min heap) the key of C.
// The node at the "top" of the heap (with no parents) is called the root node.
// https://en.wikipedia.org/wiki/Heap_(data_structure)
type heap struct {
	values []int
}

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
	return nil
}
