package mid

import (
	"html"
	"net/http"

	"github.com/miry/wattx_top_coins/pkg/app"
)

// MiddlewareFunc shortcut for handler func
type MiddlewareFunc func(w http.ResponseWriter, r *http.Request)

// RootgMiddleware ignore sub pathes
func RootMiddleware(f MiddlewareFunc) MiddlewareFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/" {
			http.NotFound(w, r)
			return
		}
		f(w, r)
	}
}

// LoggingMiddleware add messages to output for each request
func LoggingMiddleware(app *app.App, f MiddlewareFunc) MiddlewareFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		app.Logger.Info().Msgf("%s %s", r.Method, html.EscapeString(r.URL.Path))
		f(w, r)
	}
}

// JSONHeaderMiddleware sets response as JSON
func JSONHeaderMiddleware(f MiddlewareFunc) MiddlewareFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header()["Content-Type"] = []string{"application/json"}
		f(w, r)
	}
}

// PanicMiddleware return 500 http status if some panic happen
func PanicMiddleware(app *app.App, f MiddlewareFunc) MiddlewareFunc {
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
