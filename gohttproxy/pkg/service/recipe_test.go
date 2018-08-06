package service_test

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/miry/samples/gohttproxy/pkg/client"
	"github.com/miry/samples/gohttproxy/pkg/service"
	"github.com/stretchr/testify/assert"
)

func TestFindRecipeSuccess(t *testing.T) {
	client, mockServer := mockRecipeClient(recipeResponse)
	defer mockServer.Close()

	subject := &service.RecipeService{
		Client: client,
	}

	ids := []int{1}
	actual, err := subject.Find(ids)

	assert.Nil(t, err)
	assert.Equal(t, 1, len(actual))
}

func mockRecipeClient(body string) (*client.RecipeClient, *httptest.Server) {
	mockServer := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(body))
	}))

	client := client.NewRecipeClient()
	client.Url = mockServer.URL

	return client, mockServer
}

const recipeResponse = `
{
	"description": "Parm’s the charm with this next-level pork recipe. The cheese is mixed with panko breadcrumbs to create a crust that coats the tenderloin like a glorious golden-brown crown. That way, you get meltiness, juiciness, and crunch in every bite. But this recipe isn’t just about the meat: there’s also roasted rosemary potatoes and a crisp apple walnut salad to round things out.",
	"difficulty": 1,
	"headline": "with Potato Wedges and Apple Walnut Salad",
	"id": "1",
	"imageLink": "https://d3hvwccx09j84u.cloudfront.net/0,0/image/parmesan-crusted-pork-tenderloin-66608000.jpg",
	"ingredients": [
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/image/55661a71f8b25e391e8b456a.png",
					"name": "Rosemary"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/image/554a3abff8b25e1d268b456d.png",
					"name": "Yukon Gold Potatoes"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/image/5550e133fd2cb9a7168b456b.png",
					"name": "Parmesan Cheese"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/image/55ef01fbf8b25eba7e8b4567.png",
					"name": "Garlic Powder"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/ingredients/554a39a04dab71626c8b456b-3f519176.png",
					"name": "Panko Breadcrumbs"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/image/5567235df8b25e472f8b4567.png",
					"name": "Pork Tenderloin"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/image/5550e1064dab71893e8b4569.png",
					"name": "Sour Cream"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/image/554a302ffd2cb9324b8b4569.png",
					"name": "Lemon"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/image/554a3a7cf8b25ed7288b456b.png",
					"name": "Apple"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/image/5566e35f4dab71ea078b4567.png",
					"name": "Spring Mix Lettuce"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/image/5626b14af8b25e0b1f8b4567.png",
					"name": "Dried Cranberries"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/image/5550df2afd2cb9dd178b4569.png",
					"name": "Walnuts"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/ingredients/5566d4f94dab715a078b4568-7c93a003.png",
					"name": "Vegetable Oil"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/image/5566cdf2f8b25e0d298b4568.png",
					"name": "Olive Oil"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/image/5566ceb7fd2cb95f7f8b4567.png",
					"name": "Salt"
			},
			{
					"imageLink": "https://d3hvwccx09j84u.cloudfront.net/200,200/image/5566dc00f8b25e5b298b4568.png",
					"name": "Pepper"
			}
	],
	"name": "Parmesan-Crusted Pork Tenderloin",
	"prepTime": "PT30M"
}`
