package recursion

import "fmt"

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

	magicIndex([]int{-10, -5, 0, 3, 5, 10, 20, 30}, 3)
	magicIndex([]int{-1, -1, 0, 0, 1, 1, 1, 7}, 7)
	magicIndex([]int{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 1)
	magicIndex([]int{9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9}, 9)

	sample := []int{}
	fmt.Printf("%v = %v\n", subsets(sample), "[]")
	sample = []int{1}
	fmt.Printf("%v = %v\n", subsets(sample), "[[] [1]]")
	sample = []int{1, 2, 3}
	fmt.Printf("%v = %v\n", subsets(sample), "[[] [1] [1 2] [1 2 3] [2] [2 3] [3]]")
	sample = []int{1, 2, 3, 4}
	fmt.Printf("%v = %v\n", subsets(sample), "[[] [1] [1 2] [1 2 3] [1 2 3 4] [2] [2 3] [2 3 4] [3] [3 4] [4]]")

}
