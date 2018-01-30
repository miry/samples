// DOOZER Application test
// Please adjust the code as required in the task description and share us the link to your solution.
package main

import "fmt"

type TheWriter interface {
	Write([]byte) (int, error)
}

// 6.
// Adjust the WriteLN function so the test in the main function can be executed successfully.
func WriteLN(w TheWriter) error {
	_, err := w.Write([]byte("\n"))
	return err
}

type MyWriter struct {
	s []byte
}

func (m *MyWriter) Write(b []byte) (int, error) {
	m.s = append(m.s, b...)
	return len(b), nil
}

type StringWriter struct {
	s string
}

func (o *StringWriter) Write(b []byte) (int, error) {
	o.s += string(b)
	return len(b), nil
}

func main() {
	w1 := &MyWriter{}
	if err := WriteLN(w1); err != nil {
		fmt.Printf("MyWriter, unexpected error: %s", err)
	}

	w2 := &StringWriter{}
	if err := WriteLN(w2); err != nil {
		fmt.Printf("StringWriter, unexpected error: %s", err)
	}
}
