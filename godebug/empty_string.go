// go tool compile -N -S -S empty_string.go

package main

func IsEmptyStringByLen(s string) bool {
	result := len(s) == 0
	return result
}

func IsEmptyStringByCompare(s string) bool {
	result := s == ""
	return result
}

func main() {
	IsEmptyStringByLen("")
	IsEmptyStringByCompare("")
	return
}
