package main

import (
	"context"
	"log"
	"net/http"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/exporters/stdout"
	"go.opentelemetry.io/otel/global"
	"go.opentelemetry.io/otel/propagators"
	"go.opentelemetry.io/otel/sdk/resource"
	"go.opentelemetry.io/otel/semconv"
)

var tracer otel.Tracer

func main() {
	err := run()
	if err != nil {
		log.Fatal(err)
	}
}

func run() error {

	shutdown := initProvider()
	defer shutdown()

	ctx := context.Background()
	tracer = global.Tracer("example")
	_, span := tracer.Start(ctx, "main")
	defer span.End()

	err := request(ctx)
	if err != nil {
		return err
	}

	return nil
}

func request(ctx context.Context) error {
	_, span := tracer.Start(
		ctx,
		"get_example",
		otel.WithSpanKind(otel.SpanKindClient),
	)
	defer span.End()

	resp, err := http.Get("http://example.com/")
	log.Println("GET http://example.com/ -> ", resp.StatusCode)
	return err
}

func initProvider() func() {
	exp, err := stdout.NewExporter()
	handleErr(err, "failed to create exporter")

	bsp := sdktrace.NewBatchSpanProcessor(exp)
	tracerProvider := sdktrace.NewTracerProvider(
		sdktrace.WithConfig(sdktrace.Config{DefaultSampler: sdktrace.AlwaysSample()}),
		sdktrace.WithResource(resource.New(
			// the service name used to display traces in backends
			semconv.ServiceNameKey.String("test-service"),
		)),
		sdktrace.WithSpanProcessor(bsp),
	)

	// set global propagator to tracecontext (the default is no-op).
	global.SetTextMapPropagator(propagators.TraceContext{})
	global.SetTracerProvider(tracerProvider)

	return func() {
		ctx := context.Background()
		handleErr(tracerProvider.Shutdown(ctx), "failed to shutdown provider")
		handleErr(exp.Shutdown(ctx), "failed to stop exporter")
	}
}

func handleErr(err error, message string) {
	if err != nil {
		log.Fatalf("%s: %v", message, err)
	}
}
