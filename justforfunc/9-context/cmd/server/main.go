package main

import (
	"context"
	"fmt"
	"net/http"
	"time"

	log "github.com/miry/samples/justforfunc/9-context/log"
)

func main() {
	http.HandleFunc("/", log.Middleware(handler))
	panic(http.ListenAndServe(":8080", nil))
}

func handler(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	ctx = context.WithValue(ctx, int(42), int64(100))
	log.Println(ctx, "Started")
	defer log.Println(ctx, "Ended")

	select {
	case <-time.After(5 * time.Second):
		fmt.Fprintln(w, "Hello")
	case <-ctx.Done():
		err := ctx.Err()
		log.Println(ctx, err.Error())
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}
