package service

import (
	"github.com/miry/samples/hellofresh/pkg/client"
	"github.com/miry/samples/hellofresh/pkg/mod"
)

type RecipeService struct {
	Client *client.RecipeClient
}

func NewRecipeService() *RecipeService {
	return &RecipeService{
		Client: client.NewRecipeClient(),
	}
}

func (r *RecipeService) Find(ids []int) ([]*mod.Recipe, error) {
	idsSize := len(ids)
	results := make([]*mod.Recipe, 0, idsSize)

	for _, id := range ids {
		recipe, err := r.Client.Get(id)
		if err != nil {
			return results, err
		}
		results = append(results, recipe)
	}

	return results, nil
}
