package mid

import (
	"html"
	"net/http"

	"github.com/miry/samples/gohttproxy/cmd/recipes/app"
)

type middlewareFunc func(w http.ResponseWriter, r *http.Request)

func LoggingMiddleware(app *app.App, f middlewareFunc) middlewareFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		app.Logger.Info().Msgf("%s %s", r.Method, html.EscapeString(r.URL.Path))
		f(w, r)
	}
}

func JsonHeaderMiddleware(f middlewareFunc) middlewareFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header()["Content-Type"] = []string{"application/json"}
		f(w, r)
	}
}

func PanicMiddleware(app *app.App, f middlewareFunc) middlewareFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			if err := recover(); err != nil {
				error := err.(string)
				http.Error(w, error, 500)
				app.Logger.Error().Str("err", error).Msg("Request could not be processed")
			}
		}()

		f(w, r)
	}
}
