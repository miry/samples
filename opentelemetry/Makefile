.PHONY: otel
otel:
	docker run -it --rm --net=host \
		-v $(PWD)/conf:/conf otel/opentelemetry-collector \
		/otel --config=/conf/otel-collector-config.yaml --metrics-level=none

.PHONY: jaeger
jaeger:
	docker run --rm --name jaeger \
		-e COLLECTOR_OTLP_ENABLED=true \
		-p 16686:16686 \
		-p 4317:4317 \
		-p 4318:4318 \
		jaegertracing/all-in-one:1.35 --log-level=debug

.PHONY: go
go:
	cd go; go run main.go

.PHONY: crystal
crystal: fmt
	cd crystal; shards install; OTEL_TRACES_EXPORTER="http" crystal run server.cr

.PHONY: fmt
fmt:
	crystal tool format crystal
	cd go; go fmt

.PHONY: e2e
e2e:
	curl -v "http://localhost:8080/success?query=e2e"
	curl -v "http://localhost:8080/success?query=e2e" -H "Traceparent: 00-1000000000000000209b117028ae242e-209b117028ae242e-01" -H "baggage: key1=,key2=val2"
