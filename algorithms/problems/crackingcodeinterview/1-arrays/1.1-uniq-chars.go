package arrays

func UniqChars(s string) bool {
	alphabet := [256]bool{}
	if len(s) > 26 {
		return false
	}

	for _, c := range s {
		if alphabet[c] {
			return false
		}
		alphabet[c] = true
	}
	return true
}
