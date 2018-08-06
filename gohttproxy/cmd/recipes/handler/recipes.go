package handler

import (
	"errors"
	"net/http"
	"strconv"
	"strings"

	"github.com/rs/zerolog"

	"github.com/miry/samples/gohttproxy/cmd/recipes/app"
	"github.com/miry/samples/gohttproxy/pkg/mod"
	"github.com/miry/samples/gohttproxy/pkg/service"
)

type RecipesHandler struct {
	app *app.App
}

func NewRecipesHandler(app *app.App) *RecipesHandler {
	return &RecipesHandler{app: app}
}

const (
	pageDefault    = 1
	perPageDefault = 30
	minId          = 1
)

type requestParams struct {
	page    int
	perPage int
	ids     []int
}

func (h *RecipesHandler) Get(w http.ResponseWriter, r *http.Request) {
	reqParams, err := parseParams(r, h.app.Logger)
	if err != nil {
		http.Error(w, err.Error(), 422)
		h.app.Logger.Warn().Err(err).Msg("Could not parse params")
		return
	}

	if reqParams.ids == nil {
		http.Error(w, "Something goes wrong", 500)
		h.app.Logger.Info().Err(err).Msg("Wrong")
		return
	}

	h.app.Logger.Info().Msgf("Processing ids: %v", reqParams.ids)

	// TODO: Use goroutines with pool of jobs to process queries.
	recipes, err := service.NewRecipeService().Find(reqParams.ids)
	if err != nil && err.Error() != "HTTP 404" {
		http.Error(w, err.Error(), 422)
		h.app.Logger.Info().Err(err).Msg("Could not get recipes")
		return
	}

	response, err := BuildRecipesJsonResponse(recipes)
	if err != nil {
		http.Error(w, err.Error(), 500)
		h.app.Logger.Info().Err(err).Msg("Could not build response")
		return
	}

	if err != nil {
		http.Error(w, err.Error(), 500)
		h.app.Logger.Error().Err(err).Msg("Could not render recipese")
		return
	}

	w.Write(response)
}

const AvgRecipeContentSize = 3000

func BuildRecipesJsonResponse(recipes []*mod.Recipe) ([]byte, error) {
	recipesSize := len(recipes)
	if recipesSize == 0 {
		return []byte("[]"), nil
	}

	// Capacity set for optimization. Check avg recipe size via `http https://s3-eu-west-1.amazonaws.com/test-golang-recipes/1`
	result := make([]byte, 0, recipesSize*AvgRecipeContentSize)

	result = append(result, '[')
	for _, recipe := range recipes {
		result = append(result, recipe.Content...)
		result = append(result, ',')
	}
	result[len(result)-1] = ']'
	return result, nil
}

func makeRange(min, max int) []int {
	l := max - min + 1
	result := make([]int, l, l)
	for i := range result {
		result[i] = min + i
	}
	return result
}

func parseParams(r *http.Request, log *zerolog.Logger) (requestParams, error) {
	var err error
	result := requestParams{
		page:    pageDefault,
		perPage: perPageDefault,
		ids:     nil,
	}

	idsParam := r.URL.Query().Get("ids")
	if len(idsParam) != 0 {
		log.Debug().Str("ids", idsParam).Msgf("Processing ids params \"%s\"", idsParam)
		idsStr := strings.Split(idsParam, ",")
		idsStrSize := len(idsStr)
		if idsStrSize == 0 {
			return result, errors.New(`Not valid query param ids it should be numbers with delimeter comma`)
		}
		ids := make([]int, idsStrSize, idsStrSize)
		for i, idStr := range idsStr {
			ids[i], err = strconv.Atoi(idStr)
			if err != nil {
				log.Debug().Str("id", idStr).Err(err).Msg("Could not parse id")
				return result, errors.New(`Not valid query param ids it should have numbers`)
			}
		}
		result.ids = ids
		return result, nil
	}

	pageStr := r.URL.Query().Get("page")

	if len(pageStr) != 0 {
		result.page, err = strconv.Atoi(pageStr)
		if err != nil {
			log.Debug().Str("page", pageStr).Err(err).Msg("Could not parse page. Expect positive number.")
			return result, errors.New(`Not valid query param page it should be number`)
		}
	}

	if result.page < 1 {
		log.Debug().Int("page", result.page).Msg("Not valid page is less than 1")
		return result, errors.New(`Not valid query param page it should be 1 or greater`)
	}

	perPageStr := r.URL.Query().Get("per_page")

	if len(perPageStr) != 0 {
		result.perPage, err = strconv.Atoi(perPageStr)
		if err != nil {
			log.Debug().Str("per_page", perPageStr).Err(err).Msg("Could not parse per_page. Expect positive number.")
			return result, errors.New(`Not valid query param per_page it should be number`)
		}
	}

	if result.perPage < 1 {
		log.Debug().Int("per_page", result.perPage).Msg("Not valid per_page is less than 1")
		return result, errors.New(`Not valid query param per_page it should be 1 or greater`)
	}

	maxId := result.page * result.perPage
	minId := (result.page-1)*result.perPage + 1

	result.ids = makeRange(minId, maxId)

	return result, nil
}
