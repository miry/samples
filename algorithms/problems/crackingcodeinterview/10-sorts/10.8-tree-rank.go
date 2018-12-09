package main

import "fmt"

type Node struct {
	Left  *Node
	Right *Node
	Value int
	Count int
}

var root *Node

func track(x int) {
	if root == nil {
		root = &Node{
			Value: x,
		}
		return
	}

	node := root
	increment := []*Node{}
	for node != nil {
		increment = append(increment, node)
		if node.Value >= x {
			if node.Left == nil {
				node.Left = &Node{
					Value: x,
					Count: 1,
				}
				break
			}
			node = node.Left
		} else {
			if node.Right == nil {
				node.Right = &Node{
					Value: x,
					Count: 1,
				}
				break
			}
			node = node.Right
		}

	}
	for _, node := range increment {
		node.Count++
	}
}

func getRankOfNumber(x int) int {
	return getRankOfNumberR(root, x)
}

func getRankOfNumberR(node *Node, x int) int {
	result := 0
	if node == nil {
		return result
	}

	if node.Value > x {
		return getRankOfNumberR(node.Left, x)
	}

	if node.Left != nil {
		result += node.Left.Count
	}

	if node.Value == x {
		return result
	}

	return result + getRankOfNumberR(node.Right, x) + 1
}

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
}
