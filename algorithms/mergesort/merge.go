package mergesort

func Sort(arr []int) []int {
	n := len(arr)
	if n <= 1 {
		return arr
	}
	mid := n / 2
	Sort(arr[:mid])
	Sort(arr[mid:])
	if arr[mid-1] < arr[mid] {
		return arr
	}
	return merge(arr, mid)
}

func merge(arr []int, mid int) []int {
	n := len(arr)
	aux := make([]int, n)
	copy(aux, arr[:])

	j := mid
	k := 0
	for lo := 0; k < mid; lo++ {
		if j >= n {
			arr[lo] = aux[k]
			k++
		} else if aux[k] <= aux[j] {
			arr[lo] = aux[k]
			k++
		} else {
			arr[lo] = aux[j]
			j++
		}
	}
	return arr
}
