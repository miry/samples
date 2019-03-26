package coinmarketcap

import (
	"net/http"
	"net/url"

	"github.com/miry/wattx_top_coins/pkg/modules"
)

type Client struct {
	BaseURL   *url.URL
	Token     string
	UserAgent string

	httpClient *http.Client
}

func (c *Client) Listings() ([]modules.Coin, error) {
	rel := &url.URL{Path: "/v1/cryptocurrency/listings/latest"}
	u := c.BaseURL.ResolveReference(rel)
	req, err := http.NewRequest("GET", u.String(), nil)
	if err != nil {
		return nil, err
	}
	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", c.UserAgent)

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var coins []modules.Coin
	return coins, nil
}
