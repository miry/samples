# otlp_http_exporter_sample.cr
#
# Example how to start with traces with minimal examples and emit in OTLP-HTTP
#
# $ docker run -d --name jaeger \
#    -e COLLECTOR_OTLP_ENABLED=true \
#    -p 16686:16686 \
#    -p 4317:4317 \
#    -p 4318:4318 \
#    jaegertracing/all-in-one:1.35
# $ crystal run http_exporter_sample.cr
# $ open http://localhost:16686
#
# Sample trace: otlp_http_exporter_sample.png

require "opentelemetry-api"

# Another way to configure OTLP exporter
# ENV["OTEL_EXPORTER_OTLP_ENDPOINT"] ||= "http://localhost:4318/v1/traces"

OpenTelemetry.configure do |config|
  config.service_name = "otlp_http_sample"
  config.service_version = "0.1.1"
  config.sampler = OpenTelemetry::Sampler::AlwaysOn.new
  config.exporter = OpenTelemetry::Exporter.new(variant: "http") do |c|
    # NOTICE: It allows to flush spans faster and not wait when 100 spans or 5 seconds
    cc = c.as(OpenTelemetry::Exporter::Http)
    cc.batch_threshold = 5
    cc.batch_latency = 1
  end
end
tracer = OpenTelemetry.tracer_provider.tracer
puts "Check trace: http://localhost:16686/trace/#{tracer.trace_id.hexstring}"

tracer.in_span("first_operation") do |root_span|
  root_span.consumer!
  root_span.set_attribute("foo", "BAR")
  root_span.set_attribute("url", "http://example.com/foo")

  root_span.add_event("dispatching logs")

  tracer.in_span("inner_operation") do |child_span|
    child_span.add_event("handling request")
    tracer.in_span("get_user_from_db") do |child_span|
      child_span.producer!
      child_span.add_event("querying database")
    end
  end

  tracer.in_span("process_second_stage") do |child_span|
    child_span.add_event("checked permissions")
    tracer.in_span("write_to_storage") do |child_span|
      child_span.producer!
      child_span.add_event("insert user")
    end
  end
end

sleep(2)
