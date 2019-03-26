package main

import (
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"github.com/miry/wattx_top_coins/pkg/app"
	"github.com/miry/wattx_top_coins/pkg/handler"
	mid "github.com/miry/wattx_top_coins/pkg/middleware"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	// Initialize
	app, err := app.NewApp()

	if err != nil {
		log.Fatal(err)
	}
	// app.Logger = app.Logger.Output(zerolog.ConsoleWriter{Out: os.Stdout})
	defer func() {
		if err := recover(); err != nil {
			app.Logger.
				Fatal().
				Msgf("Exception: %s", err)
		}
	}()

	Routes(app, app.Handler)

	// Process
	stop := make(chan os.Signal, 1)
	signal.Notify(stop, syscall.SIGINT, syscall.SIGTERM, syscall.SIGKILL)

	go app.Serve()

	// Stop
	<-stop
	app.Shutdown()
}

// Routes map enpoints to handlers
func Routes(app *app.App, server *http.ServeMux) {
	// GET /
	coinsHandler := handler.NewCoinsHandler(app)
	server.HandleFunc("/", mid.RootMiddleware(mid.LoggingMiddleware(app, mid.PanicMiddleware(app, mid.JSONHeaderMiddleware(coinsHandler.List)))))

	// GET /version
	versionHandler := handler.NewVersionHandler(app)
	server.HandleFunc("/version", mid.LoggingMiddleware(app, mid.PanicMiddleware(app, mid.JSONHeaderMiddleware(versionHandler.Show))))

	// GET /metrics
	server.Handle("/metrics", promhttp.Handler())
}
