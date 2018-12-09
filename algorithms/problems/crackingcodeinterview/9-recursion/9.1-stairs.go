package main

import (
	"fmt"
)

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

func main() {
	fmt.Printf("n=-1 steps={1} => 0 == %d\n", stairs(-1, []int{1}))
	fmt.Printf("n=0 steps={1} => 1 == %d\n", stairs(0, []int{1}))
	fmt.Printf("n=0 steps={} => 1 == %d\n", stairs(0, []int{}))
	fmt.Printf("n=1 steps={} => 0 == %d\n", stairs(1, []int{}))
	fmt.Printf("n=1 steps={1} => 1 == %d\n", stairs(1, []int{1}))
	fmt.Printf("n=2 steps={1} => 1 == %d\n", stairs(2, []int{1}))
	fmt.Printf("n=2 steps={1,2} => 2 == %d\n", stairs(2, []int{1, 2}))
	fmt.Printf("n=3 steps={1,2,3} => 4 == %d\n", stairs(3, []int{1, 2, 3}))
	fmt.Printf("n=4 steps={1,2,3} => 7 == %d\n", stairs(4, []int{1, 2, 3}))
	fmt.Printf("n=4 steps={1,3} => 3 == %d\n", stairs(4, []int{1, 3}))
	fmt.Printf("n=4 steps={1} => 1 == %d\n", stairs(4, []int{1}))
	fmt.Printf("n=4 steps={1,4} => 2 == %d\n", stairs(4, []int{1, 4}))
}
