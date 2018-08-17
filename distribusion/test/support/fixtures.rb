# frozen_string_literal: true

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
