package main

// https://golang.org/cmd/objdump/
// go build -o stacktrace stacktrace.go
// go tool objdump -S -s "main.example" ./stacktrace
func main() {
	example(make([]string, 2, 4), "hello", 10)
}

func example(slice []string, str string, i int) {
	panic("Want stack trace")
}
