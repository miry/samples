package main

import (
	"context"
	"log"
	"net/http"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/global"
)

var tracer otel.Tracer

func main() {
	err := run()
	if err != nil {
		log.Fatal(err)
	}
}

func run() error {
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
