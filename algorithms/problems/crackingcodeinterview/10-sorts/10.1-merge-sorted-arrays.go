package sorts

import (
	"fmt"
)

// Merge 2 arrays
func Merge(a, b []int, nA, nB int) ([]int, error) {
	n := len(a)
	if nA < 0 || nB < 0 || nA+nB > n {
		return nil, fmt.Errorf("Not valid arguments")
	}

	i := nA - 1
	j := nB - 1
	k := nA + nB - 1

	for j >= 0 {
		if i >= 0 && a[i] > b[j] {
			a[k] = a[i]
			i--
		} else {
			a[k] = b[j]
			j--
		}
		k--
	}

	return a, nil
}
