package app

import (
	"context"
	"net/http"
	"os"
	"time"

	"github.com/rs/zerolog"
)

// ScoketTimeout set timeout for HTTP server
const ScoketTimeout = 30 * time.Second

// App is used for keep central location of configuration and resources
type App struct {
	Logger  *zerolog.Logger
	Handler *http.ServeMux
	server  *http.Server
}

// NewApp initialize App instance
func NewApp() (*App, error) {
	// Configuration
	addr := ":" + os.Getenv("PORT")
	if addr == ":" {
		addr = ":8080"
	}

	mux := http.NewServeMux()
	zerolog.TimeFieldFormat = ""
	zerolog.SetGlobalLevel(zerolog.DebugLevel)

	// To use JSON format output for logs:
	// logger := zerolog.New(os.Stdout).With().Timestamp().Logger()
	logger := zerolog.New(zerolog.ConsoleWriter{Out: os.Stdout}).With().Timestamp().Logger()

	app := &App{
		Logger:  &logger,
		Handler: mux,
		server:  newHTTPServer(mux, addr),
	}

	return app, nil
}

// Serve start listen on port for HTTP
func (app *App) Serve() {
	app.Logger.Info().Msgf("Listening on http://0.0.0.0%s", app.server.Addr)
	err := app.server.ListenAndServe()
	if err != nil {
		app.Logger.
			Fatal().
			Err(err).
			Msg("HTTPServer crashed")
	}
}

// Shutdown gracefully stop HTTP server
func (app *App) Shutdown() {
	app.Logger.Info().Msg("Shutting down the server...")
	ctx, cancel := context.WithTimeout(context.Background(), ScoketTimeout)
	defer cancel()
	app.server.Shutdown(ctx)
	app.Logger.Info().Msg("Server stopped")
}

func newHTTPServer(handler http.Handler, addr string) *http.Server {
	httpServer := &http.Server{
		Handler:      handler,
		Addr:         addr,
		ReadTimeout:  ScoketTimeout,
		WriteTimeout: ScoketTimeout,
	}

	return httpServer
}
