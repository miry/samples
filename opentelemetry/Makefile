.PHONY: otel
otel:
	docker run -it --rm --net=host -v $(PWD)/conf:/conf otel/opentelemetry-collector /otel --config=/conf/otel-collector-config.yaml --metrics-level=none
