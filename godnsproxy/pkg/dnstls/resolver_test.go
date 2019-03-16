package dnstls_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/godnsproxy/pkg/dnstls"
)

func TestNewResolver(t *testing.T) {
	assert := assert.New(t)

	actual, err := dnstls.New("")
	assert.NotNil(actual)
	assert.EqualError(err, "server could not be empty")
}
