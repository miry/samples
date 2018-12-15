package codewars

// https://www.codewars.com/kata/array-dot-diff/ruby

func ArrayDiffMap(a, b []int) []int {
	set := make(map[int]struct{}, len(b))
	for _, val := range b {
		set[val] = struct{}{}
	}
	result := make([]int, 0, len(a))
	for _, val := range a {
		if _, ok := set[val]; !ok {
			result = append(result, val)
		}
	}
	return result
}

func ArrayDiffInclude(a, b []int) []int {
	result := make([]int, 0, len(a))
	for _, val := range a {
		if !arrayInclude(b, val) {
			result = append(result, val)
		}
	}
	return result
}

func arrayInclude(arr []int, val int) bool {
	for _, item := range arr {
		if val == item {
			return true
		}
	}
	return false
}
