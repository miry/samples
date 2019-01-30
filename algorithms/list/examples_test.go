package list_test

import (
	"fmt"

	"github.com/miry/samples/algorithms/list"
)

func ExampleNode_Values() {
	fmt.Println("## Example of the List implementation")
	first := &list.Node{Value: "First node"}
	first.Print()

	fmt.Println()
	fmt.Println("### Append element")
	second := &list.Node{Value: "Second node"}
	third := &list.Node{Value: "Third node"}
	first.Next = second
	first.Append(third)
	first.Print()

	fmt.Println()
	fmt.Println("### Get element")
	second, _ = first.Get(1)
	fmt.Println("Get second node:", second.Value)
	third, _ = first.Get(2)
	fmt.Println("Get third node: ", third.Value)
	_, err := first.Get(3)
	if err != nil {
		fmt.Println("ERROR: ", err)
	} else {
		panic("Should not come here")
	}

	fmt.Println()
	fmt.Println("### Insert element")
	newSecond := &list.Node{Value: "New Second"}
	first.Insert(1, newSecond)
	oops := &list.Node{Value: "Should not be in the list"}
	first, err = first.Insert(6, oops)
	if err != nil {
		fmt.Println("ERROR: ", err)
	} else {
		panic("Should not come here")
	}
	newFirst := &list.Node{Value: "New First"}
	first, _ = first.Insert(0, newFirst)
	first.Print()

	fmt.Println()
	fmt.Println("### Delete element")
	first, _ = first.Delete(0)
	first, _ = first.Delete(3)
	first.Print()
	// Output:
	// ## Example of the List implementation
	// First node
	//
	// ### Append element
	// First node
	// Second node
	// Third node
	//
	// ### Get element
	// Get second node: Second node
	// Get third node:  Third node
	// ERROR:  Out of index
	//
	// ### Insert element
	// ERROR:  Out of index
	// New First
	// First node
	// New Second
	// Second node
	// Third node
	//
	// ### Delete element
	// First node
	// New Second
	// Second node
}
