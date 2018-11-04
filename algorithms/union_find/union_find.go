package union_find

type UF struct {
	Size  int
	store []int
}

func NewUF(size int) *UF {
	store := make([]int, size, size)

	for i := 0; i < size; i++ {
		store[i] = i
	}

	return &UF{
		Size:  size,
		store: store,
	}
}

func (uf *UF) Union(a, b int) {
	c := uf.head(a)
	uf.store[c] = b
}

func (uf *UF) Connected(a, b int) bool {
	if a == b || uf.store[a] == b || uf.store[b] == a {
		return true
	}

	if uf.store[a] != a {
		return uf.Connected(uf.store[a], b)
	}

	if uf.store[b] != b {
		return uf.Connected(a, uf.store[b])
	}

	return false
}

func (uf *UF) head(a int) int {
	if a == uf.store[a] {
		return a
	}
	return uf.head(uf.store[a])
}
