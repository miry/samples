package main

import (
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/miry/wattx_top_coins/pkg/app"
	"github.com/stretchr/testify/assert"
)

func TestRoutes(t *testing.T) {
	a := assert.New(t)

	app, err := app.NewApp()
	a.Nil(err)

	Routes(app, app.Handler)

	ts := httptest.NewServer(app.Handler)
	defer ts.Close()

	tt := []struct {
		name   string
		uri    string
		status int
	}{
		{"coins", "/", 200},
		{"unknown", "/foo/bar", 404},
		{"metrics", "/metrics", 200},
		{"version", "/version", 200},
	}

	for _, tc := range tt {
		t.Run(tc.name, func(t *testing.T) {
			app.Logger.Info().Msg(ts.URL + tc.uri)
			res, err := http.Get(ts.URL + tc.uri)
			a.Nil(err)

			app.Logger.Info().Msg(fmt.Sprintf("%s: %d == %d", tc.name, tc.status, res.StatusCode))
			a.Equal(tc.status, res.StatusCode)
		})
	}
}
