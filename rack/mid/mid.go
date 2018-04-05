package mid

import (
	"net"
	"net/http"
	"net/url"

	"github.com/miry/samples/rack/app"
)

type ReqFunc func(*Request) error

type Request struct {
	App        *app.App
	Req        *http.Request
	ReqProto   string
	ReqHeaders http.Header
	ReqQuery   url.Values
	ReqIP      string
	Endpoint   string
	Writer     http.ResponseWriter
}

func Chain(a *app.App, handler ReqFunc, handlerName string) func(http.ResponseWriter, *http.Request) {
	handler = requestIP(handler)
	handler = traceRequest(handler, handlerName)

	handlerFn := func(w http.ResponseWriter, r *http.Request) {
		handler(&Request{
			App:        a,
			Req:        r,
			Writer:     w,
			ReqHeaders: r.Header,
			ReqQuery:   r.URL.Query(),
		})
	}

	return handlerFn
}

func requestIP(handler ReqFunc) ReqFunc {
	return func(req *Request) error {
		if ip, _, err := net.SplitHostPort(req.Req.RemoteAddr); err == nil {
			req.ReqIP = ip
		} else {
			return err
		}
		return handler(req)
	}
}
func traceRequest(handler ReqFunc, handlerName string) ReqFunc {
	return func(req *Request) error {
		req.Endpoint = handlerName
		return handler(req)
	}
}
