package arrays

import "fmt"

func ExampleIsAnagramMap_output() {
	anagramTests := [][2]string{
		{"heart", "earth"},
		{"checklen", "oops"},
		{"heart", "bartch"},
		{"", ""},
	}

	var actual bool
	for _, in := range anagramTests {
		actual = IsAnagramMap(in[0], in[1])

		fmt.Printf("IsAnagramMap of '%s' and '%s' returns %v\n", in[0], in[1], actual)
	}

	// Output: IsAnagramMap of 'heart' and 'earth' returns true
	// IsAnagramMap of 'checklen' and 'oops' returns false
	// IsAnagramMap of 'heart' and 'bartch' returns false
	// IsAnagramMap of '' and '' returns true
}

func ExampleIsAnagramArray_output() {
	anagramTests := [][2]string{
		{"heart", "earth"},
		{"checklen", "oops"},
		{"heart", "bartch"},
		{"", ""},
	}

	var actual bool
	for _, in := range anagramTests {
		actual = IsAnagramArray(in[0], in[1])

		fmt.Printf("IsAnagramArray of '%s' and '%s' returns %v\n", in[0], in[1], actual)
	}

	// Output: IsAnagramArray of 'heart' and 'earth' returns true
	// IsAnagramArray of 'checklen' and 'oops' returns false
	// IsAnagramArray of 'heart' and 'bartch' returns false
	// IsAnagramArray of '' and '' returns true
}

func ExampleUniqChars_output() {
	tt := []string{
		"abcd",
		"dcba",
		"aabbcc",
		"ZAaz",
	}

	var actual bool
	for _, in := range tt {
		actual = UniqChars(in)
		fmt.Printf("%s: %v\n", in, actual)
	}
	// Output: abcd: true
	// dcba: true
	// aabbcc: false
	// ZAaz: true
}
