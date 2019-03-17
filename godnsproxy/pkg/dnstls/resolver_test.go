package dnstls_test

import (
	"testing"

	"github.com/stretchr/testify/assert"

	"github.com/miry/samples/godnsproxy/pkg/dnstls"
)

func TestNewResolverWithError(t *testing.T) {
	assert := assert.New(t)

	tc := []struct {
		server string
		err    string
	}{
		{"", "server could not be empty"},
	}

	for _, tt := range tc {
		actual, err := dnstls.New(tt.server)
		assert.NotNil(actual)
		assert.EqualError(err, tt.err)
	}
}

func TestLookup(t *testing.T) {
	assert := assert.New(t)

	subject, err := dnstls.New("1.1.1.1:853")
	assert.Nil(err)

	tc := []struct {
		name     string
		expected []string
	}{
		{"google-public-dns-a.google.com", []string{"8.8.8.8"}},
		{"google-public-dns-b.google.com", []string{"8.8.4.4"}},
		{"one.one.one.one", []string{"1.1.1.1", "1.0.0.1"}},
	}

	for _, tt := range tc {
		actual, err := subject.Lookup(tt.name)
		assert.Nil(err)
		assert.Equal(tt.expected, actual)
	}
}
