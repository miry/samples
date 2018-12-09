package sorts

import "fmt"

func main() {
	in := []int{5, 1, 4, 4, 5, 9, 7, 13, 3}
	for _, x := range in {
		track(x)
	}
	fmt.Printf("rank(1): 0 == %v\n", getRankOfNumber(1))
	fmt.Printf("rank(3): 1 == %v\n", getRankOfNumber(3))
	fmt.Printf("rank(4): 3 == %v\n", getRankOfNumber(4))
	fmt.Printf("rank(5): 5 == %v\n", getRankOfNumber(5))
	fmt.Printf("rank(13): 5 == %v\n", getRankOfNumber(13))

	res, _ := Merge([]int{1, 2, 3, 0, 0, 0}, []int{1, 5, 7}, 3, 3)
	fmt.Printf("{1,2,3} {1,5,7} = %v\n", res)
	res, _ = Merge([]int{1, 2, 3, 0, 0, 0}, []int{-1, 0, 7}, 3, 3)
	fmt.Printf("{1,2,3} {-1,0,7} = %v\n", res)
	res, _ = Merge([]int{10, 20, 30, 0, 0, 0}, []int{1, 5, 7}, 3, 3)
	fmt.Printf("{10,20,30} {1,5,7} = %v\n", res)
	res, _ = Merge([]int{10, 20, 30, 0, 0, 0, 0, 0, 0, 0, 0}, []int{1, 5, 7, 11, 13, 15, 17, 19}, 3, 8)
	fmt.Printf("{10,20,30} {1, 5, 7, 11, 13, 15, 17, 19} = %v\n", res)
	_, err := Merge([]int{10, 20, 30, 0, 0, 0}, []int{1, 5, 7}, 100, 3)
	fmt.Printf("{10,20,30} {1,5,7} = %v\n", err)
}
