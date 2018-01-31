package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/miry/gosample/rack/app"
	"github.com/miry/gosample/rack/handlers"
	"github.com/miry/gosample/rack/mid"
)

func main() {
	defer func() {
		if err := recover(); err != nil {
			fmt.Println(err)
		}
	}()

	a := &app.App{
		Version: "0.0.1",
	}

	http.HandleFunc("/version", func(w http.ResponseWriter, r *http.Request) { fmt.Fprintf(w, "%s", a.Version) })
	http.HandleFunc("/track", mid.Chain(a, handlers.Track, "track"))

	log.Fatal(http.ListenAndServe(":8080", nil))
}
