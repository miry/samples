package list

import (
	"errors"
	"fmt"
)

type Node struct {
	Next  *Node
	Value string
}

// Values returns a list of node's values
func (n *Node) Values() (result []string) {
	for node := n; node != nil; node = node.Next {
		result = append(result, node.Value)
	}
	return
}

func (n *Node) Append(next *Node) {
	last := n
	for node := n; node != nil; node = node.Next {
		last = node
	}
	last.Next = next
}

func (n *Node) Delete(pos int) (*Node, error) {
	if pos == 0 {
		result := n.Next
		n.Next = nil
		return result, nil
	}

	node, err := n.Get(pos - 1)

	if err != nil {
		return n, err
	}

	subject := node.Next
	next := subject.Next
	node.Next = next
	subject.Next = nil

	return n, err
}

func (n *Node) Get(pos int) (*Node, error) {
	if pos < 0 {
		return nil, errors.New("Out of index")
	}

	node := n
	for i := 0; i < pos; i++ {
		if node.Next == nil {
			return nil, errors.New("Out of index")
		}
		node = node.Next
	}
	return node, nil
}

func (n *Node) Insert(pos int, next *Node) (*Node, error) {
	if pos == 0 {
		next.Next = n
		return next, nil
	}

	node, err := n.Get(pos - 1)

	if err != nil {
		return n, err
	}

	old := node.Next
	next.Next = old
	node.Next = next

	return n, err
}

func (n *Node) Print() {
	for node := n; node != nil; node = node.Next {
		fmt.Println(node.Value)
	}
}
