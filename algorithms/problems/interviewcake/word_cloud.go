package interviewcake

/*
 You want to build a word cloud, an infographic where the size of a word corresponds to how often it appears in the body of text.

To do this, you'll need data. Write code that takes a long string and builds its word cloud data in a hash ↴ , where the keys are words and the values are the number of times the words occurred.

Think about capitalized words. For example, look at these sentences:

"After beating the eggs, Dana read the next step:"
"Add milk and eggs, then add flour and sugar."

What do we want to do with "After", "Dana", and "add"? In this example, your final hash should include one "Add" or "add" with a value of 222. Make reasonable (not necessarily perfect) decisions about cases like "After" and "Dana".

Assume the input will only contain words and standard punctuation.
*/

type WordStats map[string]int

func Cloudify(text string) WordStats {
	words := parse(text)
	result := WordStats{}
	for _, word := range words {
		result[word]++
	}
	return result
}

func parse(text string) []string {
	result := []string{}
	word := make([]rune, 0, 12)
	for _, r := range text {
		if !isalphanumeric(r) {
			if len(word) > 0 {
				result = append(result, string(word))
				word = make([]rune, 0, 12)
			}
		} else {
			word = append(word, upcase(r))
		}
	}
	if len(word) > 0 {
		result = append(result, string(word))
	}
	return result
}

func isalphanumeric(r rune) bool {
	return (r >= 'a' && r <= 'z') || (r >= 'A' && r <= 'Z')
}

var caseDiff = 'a' - 'A'

func upcase(r rune) rune {
	if r >= 'a' && r <= 'z' {
		return r - caseDiff
	}
	return r
}
