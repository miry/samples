package recursion

func stairs(n int, steps []int) int {
	if n < 0 {
		return 0
	}

	if n == 0 {
		return 1
	}

	if len(steps) == 0 {
		return 0
	}

	memo := make([]int, n+1, n+1)
	memo[0] = 1

	for i := 1; i <= n; i++ {
		memo[i] = 0

		for _, step := range steps {
			if i-step < 0 {
				continue
			}
			memo[i] += memo[i-step]
		}
	}

	return memo[n]
}
