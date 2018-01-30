// DOOZER Application test
// Please adjust the code as required in the task description and share us the link to your solution.
package main

import "fmt"

type Result struct {
	Data *Data
}

type Data struct {
	ID int
}

func BuildResults() []Result {

	var list []Result

	for i := 0; i < 10; i++ {
		data := Data{}
		data.ID = i
		list = append(list, Result{
			Data: &data,
		})
	}

	return list
}

// 1.
// Write a function called BuildResultsFixed based on the BuildResults but resulting in the following output:
// - IDs within the Result.Data are: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
func BuildResultsFixed() []Result {
	return BuildResults()
}

func main() {
	results := BuildResultsFixed()

	if len(results) != 10 {
		fmt.Printf("10 Results expected, got %d", len(results))
		return
	}

	for i, r := range results {
		if r.Data == nil || r.Data.ID != i {
			fmt.Printf("invalid ID: %d expected: %d got: %d\n", r.Data.ID)
		}
	}

	item1 := results[1].Data
	results[1].Data.ID = 50

	if item1.ID != 50 {
		fmt.Printf("invalid ID after change: %d expected: %d\n", item1.ID, 50)
	}
}
