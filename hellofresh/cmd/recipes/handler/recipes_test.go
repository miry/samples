package handler_test

import (
	"testing"

	"github.com/miry/samples/hellofresh/cmd/recipes/handler"
	"github.com/miry/samples/hellofresh/pkg/mod"
	"github.com/stretchr/testify/assert"
)

func TestEmptyRecipeResponse(t *testing.T) {

	recipes := make([]*mod.Recipe, 0)
	actual, err := handler.BuildRecipesJsonResponse(recipes)

	assert.Nil(t, err)
	assert.NotNil(t, actual)
	assert.Equal(t, "[]", string(actual))
}

func TestRecipeResponseOneItem(t *testing.T) {

	recipes := []*mod.Recipe{
		&mod.Recipe{
			Content: []byte(`{"key": "value"}`),
		},
	}

	actual, err := handler.BuildRecipesJsonResponse(recipes)

	assert.Nil(t, err)
	assert.NotNil(t, actual)
	assert.Equal(t, `[{"key": "value"}]`, string(actual))
}
func TestRecipeResponseItems(t *testing.T) {

	recipes := []*mod.Recipe{
		&mod.Recipe{Content: []byte(`{"key1": "foo"}`)},
		&mod.Recipe{Content: []byte(`{"key2": "bar"}`)},
		&mod.Recipe{Content: []byte(`{"key3": "quux"}`)},
	}

	actual, err := handler.BuildRecipesJsonResponse(recipes)

	assert.Nil(t, err)
	assert.NotNil(t, actual)
	assert.Equal(t, `[{"key1": "foo"},{"key2": "bar"},{"key3": "quux"}]`, string(actual))
}
