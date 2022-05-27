require "http/server"
require "opentelemetry-api"

class RootHandler
  include HTTP::Handler

  def call(context) : Nil
    request = context.request
    tracer = OpenTelemetry.trace
    span_context = OpenTelemetry::Propagation::TraceContext.new.extract(request.headers)
    if span_context
      tracer.trace_id = span_context.trace_id
      tracer.span_context = span_context
    end

    # OpenTelemetry::Context.with(context: span_context) do
    tracer.in_span("request") do |root_span|
      root_span.server!

      root_span.set_attribute("verb", "GET")
      root_span.set_attribute("url", "http://example.com/foo")
      root_span.add_event("dispatching to handler")
      tracer.in_span("handler") do |child_span|
        context.response.content_type = "text/plain"
        context.response.print "Hello world!"

        child_span.add_event("handling request")

        tracer.in_span("db") do |child_span|
          child_span.add_event("querying database")
        end
      end
    end
    # end
  end
end

def main
  # NOTE: Variant 1: Dynamicaly configure opentelemetry
  ENV["OTEL_TRACES_EXPORTER"] ||= "stdout"
  ENV["OTEL_SERVICE_NAME"] ||= "default_tracer_service_name"
  ENV["OTEL_SERVICE_VERSION"] ||= "0.1.0"
  ENV["OTEL_TRACES_SAMPLER"] ||= "alwayson"
  ENV["OTEL_EXPORTER_OTLP_ENDPOINT"] ||= "http://localhost:4318/v1/traces"

  run
rescue ex : Exception
  puts "Everything is bad!"
  puts ex
  puts ex.backtrace
end

def setup
  # NOTE: Variant 2: Configure opentelemetry via code
  OpenTelemetry.configure do |config|
    config.service_name = "server"
    config.service_version = "0.1.0"
    config.sampler = OpenTelemetry::Sampler::AlwaysOn.new
  end
end

def run
  setup

  server = HTTP::Server.new([
    HTTP::LogHandler.new,
    RootHandler.new,
  ])
  address = server.bind_tcp 8080
  puts "Listening on #{address}"
  puts "HINT: Try with to test with curl 127.0.0.1:8080"
  server.listen
end

main
