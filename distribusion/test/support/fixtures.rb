# frozen_string_literal: true

def sniffers_node_times_csv
  <<~CONTENT
    "node_time_id", "start_node", "end_node", "duration_in_milliseconds"
    "1", "lambda", "tau", "1000"
    "2", "tau", "psi", "1000"
    "3", "psi", "omega", "1000"
    "4", "lambda", "psi", "1000"
  CONTENT
end

def sniffers_routes_csv
  <<~CONTENT
    "route_id", "time", "time_zone"
    "1", "2030-12-31T13:00:06", "UTC±00:00"
    "2", "2030-12-31T13:00:07", "UTC±00:00"
    "3", "2030-12-31T13:00:00", "UTC±00:00"
  CONTENT
end

def sniffers_sequences_csv
  <<~CONTENT
    "route_id", "node_time_id"
    "1", "1"
    "1", "2"
    "1", "3"
    "2", "4"
    "2", "3"
    "3", "9"
  CONTENT
end

def loopholes_node_pairs_json
  <<~CONTENT
    {
      "node_pairs": [
        {
          "id": "1",
          "start_node": "gamma",
          "end_node": "theta"
        },
        {
          "id": "2",
          "start_node": "beta",
          "end_node": "theta"
        },
        {
          "id": "3",
          "start_node": "theta",
          "end_node": "lambda"
        }
      ]
    }
  CONTENT
end

def loopholes_routes_json
  <<~CONTENT
    {
      "routes": [
        {
          "route_id": "1",
          "node_pair_id": "1",
          "start_time": "2030-12-31T13:00:04Z",
          "end_time": "2030-12-31T13:00:05Z"
        },
        {
          "route_id": "1",
          "node_pair_id": "3",
          "start_time": "2030-12-31T13:00:05Z",
          "end_time": "2030-12-31T13:00:06Z"
        },
        {
          "route_id": "2",
          "node_pair_id": "2",
          "start_time": "2030-12-31T13:00:05Z",
          "end_time": "2030-12-31T13:00:06Z"
        },
        {
          "route_id": "2",
          "node_pair_id": "3",
          "start_time": "2030-12-31T13:00:06Z",
          "end_time": "2030-12-31T13:00:07Z"
        },
        {
          "route_id": "3",
          "node_pair_id": "9",
          "start_time": "2030-12-31T13:00:00Z",
          "end_time": "2030-12-31T13:00:00Z"
        }
      ]
    }
  CONTENT
end
