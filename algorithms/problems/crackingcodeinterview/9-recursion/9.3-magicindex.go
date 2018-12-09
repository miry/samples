package recursion

import (
	"fmt"
)

func magicIndex(arr []int, exp int) int {
	n := len(arr) - 1
	index, counter := magicIndexRec(arr, 0, n, 0)
	fmt.Printf("recursion: %v => %d == %d with %d iterations\n", arr, index, exp, counter)

	return index
}

func magicIndexRec(arr []int, s, e, counter int) (int, int) {
	if s == e {
		if arr[s] == s {
			return s, counter
		}

		return -1, counter
	}

	if e < s {
		return -1, counter
	}

	mid := (e-s)/2 + s
	if arr[mid] == mid {
		return mid, counter
	}

	if arr[mid] < s {
		return magicIndexRec(arr, mid+1, e, counter+1)
	}

	if arr[mid] > e {
		return magicIndexRec(arr, s, mid-1, counter+1)
	}

	var leftIndex, leftCounter int
	if arr[mid] > mid-1 {
		leftIndex, leftCounter = magicIndexRec(arr, s, mid-1, counter+1)
	} else {
		leftIndex, leftCounter = magicIndexRec(arr, s, arr[mid], counter+1)
	}
	if leftIndex != -1 {
		return leftIndex, leftCounter
	}

	if arr[mid] < mid+1 {
		return magicIndexRec(arr, mid+1, e, counter+leftCounter)
	}

	return magicIndexRec(arr, arr[mid], e, counter+leftCounter)
}

func magicIndexBottomUp(arr []int, s, e int) int {
	return -1
}
