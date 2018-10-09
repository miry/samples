package main

import (
	"log"
	"os"
	"os/signal"
	"syscall"

	"github.com/miry/samples/hellofresh/cmd/recipes/app"
	"github.com/miry/samples/hellofresh/cmd/recipes/handler"
	"github.com/miry/samples/hellofresh/cmd/recipes/mid"
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
				Msgf("Excpetion: %s", err)
		}
	}()

	// Routes
	// GET /version
	versionHandler := handler.NewVersionHandler(app)
	app.Handler.HandleFunc("/version", mid.LoggingMiddleware(app, mid.PanicMiddleware(app, mid.JsonHeaderMiddleware(versionHandler.Show))))

	recipesHandler := handler.NewRecipesHandler(app)
	app.Handler.HandleFunc("/recipes", mid.LoggingMiddleware(app, mid.PanicMiddleware(app, mid.JsonHeaderMiddleware(recipesHandler.Get))))

	// GET /metrics
	app.Handler.Handle("/metrics", promhttp.Handler())

	// Process
	stop := make(chan os.Signal, 1)
	signal.Notify(stop, syscall.SIGINT, syscall.SIGTERM, syscall.SIGKILL)

	go app.Serve()

	// Stop
	<-stop
	app.Shutdown()
}
