package hackerrank

// ref: https://www.hackerrank.com/challenges/counting-valleys/problem
func CountingValleys(n int, s string) int {
	result := 0

	counter := 0
	var diff int

	for i := 0; i < n; i++ {
		diff = 1
		if s[i] == 'D' {
			diff = -1
		}

		counter += diff
		if diff == 1 && counter == 0 {
			result++
		}
	}
	return result
}
