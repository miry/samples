package client

import (
	"errors"
	"fmt"
	"io/ioutil"
	"net/http"

	"github.com/miry/samples/gohttproxy/pkg/mod"
)

type RecipeClient struct {
	Client *http.Client
	Url    string
}

func NewRecipeClient() *RecipeClient {
	return &RecipeClient{
		Client: http.DefaultClient,
		Url:    "https://s3-eu-west-1.amazonaws.com/test-golang-recipes",
	}
}

func (c *RecipeClient) Get(id int) (*mod.Recipe, error) {
	url := fmt.Sprintf("%s/%d", c.Url, id)
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, err
	}

	res, err := c.Client.Do(req)
	if err != nil {
		return nil, err
	}
	defer res.Body.Close()

	if res.StatusCode >= 300 {
		return nil, errors.New(fmt.Sprintf("HTTP %v", res.StatusCode))
	}

	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		return nil, err
	}

	return &mod.Recipe{Content: body}, nil
}
