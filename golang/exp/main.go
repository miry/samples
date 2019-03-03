package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
)

var file = flag.String("f", "", "file path for input data")
var corruptedPassword = flag.String("p", "", "possible corrupted password")

func main() {
	flag.Parse()

	var pattern map[int]rune
	var emptySlots []int
	var err error

	if corruptedPassword != nil {
		pattern, emptySlots, err = buildPattern(*corruptedPassword)
		if err != nil {
			log.Fatalf("could not create pattern '%s': %v", *corruptedPassword, err)
		}

		fmt.Printf("pattern: %+v\n", pattern)
	} else {
		log.Fatal("no password provided")
	}

	var passwords []string
	if file != nil {
		passwords, err = process(*file)
		if err != nil {
			log.Fatalf("could not process file '%s': %v", *file, err)
		}
	} else {
		log.Fatal("no input file")
	}

	possiblepasswords := findPasswords(len(*corruptedPassword), pattern, passwords)

	for _, possible := range possiblepasswords {
		fmt.Printf("%s\n", possible)
	}

	guessPosition, err := guess(emptySlots, possiblepasswords)

	if err != nil {
		log.Fatalf("could not guess : %v", err)
	}

	fmt.Printf("guessPosition: %d\n", guessPosition)
	return
}

func process(filename string) ([]string, error) {
	fmt.Printf("file: %s\n", filename)

	if filename == "" {
		return nil, fmt.Errorf("no input file")
	}

	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	result := []string{}
	for scanner.Scan() {
		result = append(result, scanner.Text())
	}

	return result, nil
}

func buildPattern(password string) (map[int]rune, []int, error) {
	result := map[int]rune{}
	emptys := []int{}

	if password == "" {
		return result, emptys, fmt.Errorf("empty password")
	}

	for i, char := range password {
		if char == '-' {
			emptys = append(emptys, i)
		} else {
			result[i] = char
		}
	}

	return result, emptys, nil
}

func findPasswords(passwordLen int, pattern map[int]rune, possiblePasswords []string) []string {
	result := []string{}

	for _, password := range possiblePasswords {
		if len(password) == passwordLen && matchPattern(pattern, password) {
			result = append(result, password)
		}
	}

	return result
}

func matchPattern(pattern map[int]rune, word string) bool {
	for pos, char := range pattern {
		if rune(word[pos]) != char {
			return false
		}
	}
	return true
}

func guess(emptySlots []int, passwords []string) (int, error) {
	if len(passwords) == 0 {
		return 0, fmt.Errorf("no valid password income")
	}

	if len(emptySlots) == 0 {
		return 0, fmt.Errorf("no emptyslots")
	}

	minimumDuplicationPosition := 0
	minimumDuplicationCounter := len(passwords) + 1

	for _, position := range emptySlots {

		characters := map[byte]int{}

		for _, password := range passwords {
			char := password[position]
			if _, ok := characters[char]; !ok {
				characters[char] = 0
			}
			characters[char]++
		}

		maxRepeatCounter := maxDuplication(characters)

		if maxRepeatCounter < minimumDuplicationCounter {
			minimumDuplicationPosition = position
		}

	}

	return minimumDuplicationPosition, nil
}

func maxDuplication(characters map[byte]int) int {
	result := 1

	for _, counter := range characters {
		if counter > result {
			result = counter
		}
	}

	return result
}
