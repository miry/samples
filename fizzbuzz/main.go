package main

import "fmt"

func FizzBuzz() {
	start, end := 1, 100
	for i := start; i <= end; i += 1 {
		output := ""
		if i%3 == 0 {
			output = "Fizz"
		}

		if i%5 == 0 {
			output = output + "Buzz"
		}

		if len(output) == 0 {
			output = fmt.Sprintf("%d", i)
		}

		fmt.Println(output)
	}

}

func main() {
	FizzBuzz()
}
