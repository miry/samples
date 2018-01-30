// DOOZER Application test
// Please adjust the code as required in the task description and share us the link to your solution.
package main

import (
	"errors"
	"fmt"
	"regexp"
	"strings"
)

// 4.
// Create a function "ParseID" which receives one string argument and splits it into
// two parts using "-" as separator. Each part of the string may:
// - contain only numbers
// - contain at least 3 numbers
// - contain 5 numbers maximum
// It should return an error "invalid format" if the argument doesn't fit the description and otherwise return the
// two string parts as a slice of strings.
func ParseID(s string) ([]string, error) {
	result := strings.Split(s, "-")

	if len(result) != 2 {
		return nil, errors.New("invalid format")
	}

	re := regexp.MustCompile("^[0-9]{3,5}$")

	if !re.MatchString(result[0]) {
		return nil, errors.New("invalid format")
	}

	if !re.MatchString(result[1]) {
		return nil, errors.New("invalid format")
	}

	return result, nil
}

func main() {
	testCases := []struct {
		s   string
		err string
	}{
		{"100-100", ""},
		{"1001-100", ""},
		{"10011-100", ""},
		{"10011-100", ""},
		{"100-1001", ""},
		{"100-10011", ""},
		{"1001-10011", ""},
		{"10011-10011", ""},
		{"1001A-1001", "invalid format"},
		{"1001-1001A", "invalid format"},
		{"10-100", "invalid format"},
		{"100-100000", "invalid format"},
		{"100-100-100", "invalid format"},
	}
	for _, tc := range testCases {
		r, err := ParseID(tc.s)

		if tc.err == "" {
			if err != nil || len(r) != 2 {
				fmt.Printf("case: %s wrong result length: got %v; want 2\n", tc.s, len(r))
			}
		} else if err == nil || err.Error() != tc.err {
			fmt.Printf("case: %s error: got %v; want %v\n", tc.s, err, tc.err)
		}
	}
}
