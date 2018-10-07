package main

import (
	"fmt"
)

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

func main() {
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
