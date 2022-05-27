# stdout_exporter_sample.cr
#
# Example how to start with traces with minimal examples and print in STDOUT
#
# $ crystal run stdout_exporter_sample.cr
# {
#   "type": "trace",
#   "traceId": "34d661e8000eda38e4ccd7385a5793cd",
#   "resource": {
#     "service.name": "stdout_exporter_sample",
#     "service.version": "0.1.0",
#     "service.instance.id": "000eda38-e4cc-34d2-f300-9aba12abbaa9",
#     "telemetry.sdk.name": "opentelemetry",
#     "telemetry.sdk.language": "crystal",
#     "telemetry.sdk.version": "0.3.4"
#   },
#   "spans": [
#     {
#       "type": "span",
#       "traceId": "34d661e8000eda38e4ccd7385a5793cd",
#       "spanId": "0eda38e4cc000001",
#       "parentSpanId": null,
#       "kind": 5,
#       "name": "first_operation",
#       "status": "{\"code\":0,\"message\":\"\"}",
#       "startTime": 1655107020886482944,
#       "endTime": 1655107020886550016,
#       "attributes": {
#         "foo": "BAR",
#         "url": "http://example.com/foo"
#       },
#       "events": [
#         {
#           "type": "event",
#           "timestamp": 1655107020886516992,
#           "name": "dispatching logs"
#         }
#       ]
#     },
#     {
#       "type": "span",
#       "traceId": "34d661e8000eda38e4ccd7385a5793cd",
#       "spanId": "0eda38e4cc000004",
#       "parentSpanId": "0eda38e4cc000001",
#       "kind": 1,
#       "name": "process_second_stage",
#       "status": "{\"code\":0,\"message\":\"\"}",
#       "startTime": 1655107020886541056,
#       "endTime": 1655107020886548992,
#       "attributes": {},
#       "events": [
#         {
#           "type": "event",
#           "timestamp": 1655107020886544896,
#           "name": "checked permissions"
#         }
#       ]
#     },
#     {
#       "type": "span",
#       "traceId": "34d661e8000eda38e4ccd7385a5793cd",
#       "spanId": "0eda38e4cc000005",
#       "parentSpanId": "0eda38e4cc000004",
#       "kind": 4,
#       "name": "write_to_storage",
#       "status": "{\"code\":0,\"message\":\"\"}",
#       "startTime": 1655107020886544896,
#       "endTime": 1655107020886548992,
#       "attributes": {},
#       "events": [
#         {
#           "type": "event",
#           "timestamp": 1655107020886547968,
#           "name": "insert user"
#         }
#       ]
#     },
#     {
#       "type": "span",
#       "traceId": "34d661e8000eda38e4ccd7385a5793cd",
#       "spanId": "0eda38e4cc000002",
#       "parentSpanId": "0eda38e4cc000001",
#       "kind": 1,
#       "name": "inner_operation",
#       "status": "{\"code\":0,\"message\":\"\"}",
#       "startTime": 1655107020886518016,
#       "endTime": 1655107020886541056,
#       "attributes": {},
#       "events": [
#         {
#           "type": "event",
#           "timestamp": 1655107020886521088,
#           "name": "handling request"
#         }
#       ]
#     },
#     {
#       "type": "span",
#       "traceId": "34d661e8000eda38e4ccd7385a5793cd",
#       "spanId": "0eda38e4cc000003",
#       "parentSpanId": "0eda38e4cc000002",
#       "kind": 4,
#       "name": "get_user_from_db",
#       "status": "{\"code\":0,\"message\":\"\"}",
#       "startTime": 1655107020886522112,
#       "endTime": 1655107020886540032,
#       "attributes": {},
#       "events": [
#         {
#           "type": "event",
#           "timestamp": 1655107020886524928,
#           "name": "querying database"
#         }
#       ]
#     }
#   ]
# }

require "opentelemetry-api"

STDOUT.sync = true

OpenTelemetry.configure do |config|
  config.service_name = "stdout_exporter_sample"
  config.service_version = "0.1.0"
  config.sampler = OpenTelemetry::Sampler::AlwaysOn.new
  config.exporter = OpenTelemetry::Exporter.new(variant: :stdout)
end
tracer = OpenTelemetry.tracer_provider.tracer

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

# Make sure all exporter stdout finish in exporter fiber
sleep(1)
