// DOOZER Application test
// Please adjust the code as required in the task description and share us the link to your solution.
package main

import (
	"fmt"
	"net/http"
	"net/http/httptest"
)

func IntegerHandler(i int) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "%d", i)
	}
}

// 7.
// Write the most basic implementation of an http.HandlerFunc named "IntegerHandler" that writes an integer (int) value to
// the http.ResponseWriter which was declared during the initiation of the handler.

func main() {
	handler := IntegerHandler(15)

	request := httptest.NewRequest(http.MethodGet, "http://localhost/test", nil)
	response := httptest.NewRecorder()

	hf := http.HandlerFunc(handler)
	hf.ServeHTTP(response, request)

	body := response.Body.String()
	if body != "15" {
		fmt.Printf("expected body: %q but got %q", "15", body)
	}
}
