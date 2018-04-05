package handlers

import (
	"encoding/json"
	"fmt"

	"github.com/miry/samples/rack/mid"
)

type response struct {
	Status   string `json:"status"`
	Endpoint string `json:"endpoint"`
	ReqIP    string `json:"req_ip"`
}

func Track(req *mid.Request) error {
	r := response{Status: "ok", Endpoint: req.Endpoint, ReqIP: req.ReqIP}
	result, err := json.Marshal(r)
	if err != nil {
		return err
	}

	fmt.Fprintf(req.Writer, "%s", result)
	return nil
}
