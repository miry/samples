package interviewcake

func SortScores(arr []int, n int) []int { // O(n+k)
	bucket := make([]int, n)
	for _, val := range arr { // O(n)
		bucket[val]++
	}

	var j int
	i := 0
	for val, count := range bucket { // O(k)
		for j = 0; j < count; j++ {
			arr[i] = val
			i++
		}

	}
	return arr
}
