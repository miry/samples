// dlv debug mem.go
// go tool compile -m  mem.go

package main

import "fmt"

const readme = 101010

func main() {
	fmt.Printf("Hello %d\n", readme)
}
