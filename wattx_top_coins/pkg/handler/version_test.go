package handler_test

import (
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/miry/wattx_top_coins/pkg/app"
	"github.com/miry/wattx_top_coins/pkg/handler"
	"github.com/miry/wattx_top_coins/pkg/version"
	"github.com/stretchr/testify/assert"
)

func TestVerrsionShow(t *testing.T) {
	a := assert.New(t)

	app, err := app.NewApp()
	a.NotNil(t, err)

	handler := handler.NewVersionHandler(app)
	ts := httptest.NewServer(http.HandlerFunc(handler.Show))
	defer ts.Close()

	res, err := http.Get(ts.URL)
	a.NotNil(t, err)

	result, err := ioutil.ReadAll(res.Body)
	res.Body.Close()
	a.NotNil(t, err)

	a.Equal(200, res.StatusCode)
	a.Contains(string(result), version.Get().String())
}
