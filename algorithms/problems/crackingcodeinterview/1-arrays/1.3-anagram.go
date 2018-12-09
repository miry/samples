package main

import "fmt"

func isAnagramMap(a, b string) bool {
	if len(a) != len(b) {
		return false
	}

	result := map[byte]int{}

	var aChar, bChar byte
	for i := 0; i < len(a); i++ {
		aChar, bChar = a[i], b[i]
		result[aChar] += 1
		result[bChar] -= 1
	}

	for _, counter := range result {
		if counter != 0 {
			return false
		}
	}
	return true
}

// Expect ASCII chars only
func isAnagramArray(a, b string) bool {
	if len(a) != len(b) {
		return false
	}

	result := [256]int{}
	for _, c := range a {
		result[c]++
	}

	for _, c := range b {
		result[c]--
		if result[c] < 0 {
			return false
		}
	}

	for _, counter := range result {
		if counter != 0 {
			return false
		}
	}

	return true
}

func main() {
	anagramTests := map[[2]string]bool{
		{"heart", "earth"}:   true,
		{"checklen", "oops"}: false,
		{"heart", "bartch"}:  false,
		{"", ""}:             true,
	}

	for in, expected := range anagramTests {
		if actual := isAnagramMap(in[0], in[1]); actual != expected {
			fmt.Printf("isAnagramMap: %v expected to return %v, but returns %v\n", in, expected, actual)
		}
	}

	for in, expected := range anagramTests {
		if actual := isAnagramArray(in[0], in[1]); actual != expected {
			fmt.Printf("isAnagramArray: %v expected to return %v, but returns %v\n", in, expected, actual)
		}
	}
}
