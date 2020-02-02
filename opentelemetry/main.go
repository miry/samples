package main

import (
	"context"
	"fmt"
	"log"

	lt "github.com/lightstep/lightstep-tracer-go"
	"github.com/lightstep/opentelemetry-exporter-go/lightstep"
	core "go.opentelemetry.io/otel/api/core"
	"go.opentelemetry.io/otel/api/global"
	apitrace "go.opentelemetry.io/otel/api/trace"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
)

func initTracer() (*lightstep.Exporter, error) {
	// exp, err := stdout.NewExporter(stdout.Options{PrettyPrint: true})
	log.Printf("> initTracer\n")

	// Logging
	logAndMetricsHandler := func(event lt.Event) {
		switch event := event.(type) {
		case lt.EventStatusReport:
			log.Printf("Dropped spans %+v\n", event.DroppedSpans())
		case lt.ErrorEvent:
			log.Printf("LS Tracer error: %s\n", event)
		default:
			log.Printf("LS Tracer info: %s\n", event)
		}
	}
	lt.SetGlobalEventHandler(logAndMetricsHandler)

	exp, err := lightstep.NewExporter(
		lightstep.WithServiceName("go-guide-server"),
		lightstep.WithAccessToken("HL0mLWpQFHXUVg/y8vZe8Aoyzbv5s3JMMbqy6+WU00AXjA+qWykt8Rx5/2XMJvmE7jUyvkwm4v1HHKF9CMLeclgHWfL7llj9d7r4utp+"),
		lightstep.WithHost("ingest.lightstep.com"),
		lightstep.WithPort(443),
	)
	if err != nil {
		return nil, fmt.Errorf("could not initialize tracer stdout exporter: %w", err)
	}

	// exp, err := jaeger.NewExporter(jaeger.WithCollectorEndpoint("http://localhost:14268/api/traces"))

	tp, err := sdktrace.NewProvider(sdktrace.WithSyncer(exp),
		sdktrace.WithConfig(sdktrace.Config{DefaultSampler: sdktrace.AlwaysSample()}))
	if err != nil {
		return nil, fmt.Errorf("failed to initialize tracer provider: %w", err)
	}
	global.SetTraceProvider(tp)
	return exp, nil
}

func main() {
	err := run()
	if err != nil {
		log.Fatal(err)
	}
}

func run() error {
	exp, err := initTracer()
	if err != nil {
		return err
	}

	tracer := global.TraceProvider().Tracer("ex.com/basic")
	ctx := context.Background()

	err = tracer.WithSpan(ctx, "foo", func(ctx context.Context) error {
		return tracer.WithSpan(ctx, "bar", func(ctx context.Context) error {
			return tracer.WithSpan(ctx, "baz", func(ctx context.Context) error {
				return nil
			})
		})
	})
	if err != nil {
		return err
	}

	// Create span with attributes
	ctx, span := tracer.Start(context.Background(), "foo")
	span.SetAttributes(core.KeyValue{Key: "platform", Value: core.String("osx")})
	span.SetAttributes(core.KeyValue{Key: "version", Value: core.String("1.2.3")})
	span.AddEvent(ctx, "event in foo", core.KeyValue{Key: "name", Value: core.String("foo1")})

	// Create a child span
	attributes := []core.KeyValue{
		core.KeyValue{Key: "platform", Value: core.String("osx")},
		core.KeyValue{Key: "version", Value: core.String("1.2.3")},
	}

	ctx, child := tracer.Start(ctx, "baz", apitrace.ChildOf(span.SpanContext()), apitrace.WithAttributes(attributes...))
	// Some job

	// Close first child span
	child.End()

	// Then close parent span
	span.End()

	exp.Flush()

	return nil
}
