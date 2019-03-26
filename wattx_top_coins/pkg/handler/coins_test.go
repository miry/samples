package handler_test

import (
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/miry/wattx_top_coins/pkg/app"
	"github.com/miry/wattx_top_coins/pkg/handler"
	"github.com/stretchr/testify/assert"
)

func TestCoinsListHandler(t *testing.T) {
	a := assert.New(t)

	app, err := app.NewApp()
	a.Nil(err)
	subject := handler.NewCoinsHandler(app)

	req, err := http.NewRequest("GET", "localhost:8080/", nil)
	a.Nil(err)
	rec := httptest.NewRecorder()

	subject.List(rec, req)

	res := rec.Result()
	defer res.Body.Close()
	a.Equal(http.StatusOK, res.StatusCode)

	result, err := ioutil.ReadAll(res.Body)
	a.Nil(err)

	a.Contains(string(result), "\"data\":")
	a.Contains(string(result), "\"symbol\":\"BTC\"")
}
