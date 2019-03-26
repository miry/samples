package mid_test

import (
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/miry/wattx_top_coins/pkg/app"
	mid "github.com/miry/wattx_top_coins/pkg/middleware"
	"github.com/stretchr/testify/assert"
)

// GetTestPanicHandler returns a http.HandlerFunc for testing http middleware
func GetTestPanicHandler(w http.ResponseWriter, r *http.Request) {
	panic("it should be handle")
}

func GetTestHandler(w http.ResponseWriter, r *http.Request) {

}

func TestPanic(t *testing.T) {
	a := assert.New(t)

	app, err := app.NewApp()
	a.NotNil(t, err)

	ts := httptest.NewServer(http.HandlerFunc(mid.PanicMiddleware(app, GetTestPanicHandler)))
	defer ts.Close()

	res, err := http.Get(ts.URL)
	a.NotNil(t, err)

	result, err := ioutil.ReadAll(res.Body)
	res.Body.Close()
	a.NotNil(t, err)

	a.Equal(500, res.StatusCode)
	a.Equal("it should be handle\n", string(result))
	a.Contains(res.Header["Content-Type"], "text/plain; charset=utf-8")
}

func TestJSONHeader(t *testing.T) {
	a := assert.New(t)

	ts := httptest.NewServer(http.HandlerFunc(mid.JSONHeaderMiddleware(GetTestHandler)))
	defer ts.Close()

	res, err := http.Get(ts.URL)
	a.NotNil(t, err)

	a.Equal(200, res.StatusCode)
	a.Contains(res.Header["Content-Type"], "application/json")
}
