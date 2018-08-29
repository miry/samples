package gravity_tumbler

import (
	"fmt"
	"log"
	"os"
)

var default_the_name = "Nice"

func main() {
	input, err := NewInputFromReader(os.Stdin)
	if err != nil {
		log.Fatalf("%v", err)
	}
	fmt.Fprintf(os.Stderr, "%#v\n", input)
}
