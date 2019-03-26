package handler

import (
	"encoding/json"
	"net/http"

	"github.com/miry/wattx_top_coins/pkg/app"
	"github.com/miry/wattx_top_coins/pkg/services"
)

// CoinsHandler process top coins endpoint
type CoinsHandler struct {
	app *app.App
}

// NewCoinsHandler initialize VersionHandler object
func NewCoinsHandler(app *app.App) *CoinsHandler {
	return &CoinsHandler{app: app}
}

// Rank,	Symbol,	Price USD
type coinResp struct {
	Rank   int64   `json:"rank"`
	Symbol string  `json:"symbol"`
	Price  float64 `json:"price"`
}

type coinsResp struct {
	Data []coinResp `json:"data"`
}

// List build json result for top coins
func (h *CoinsHandler) List(w http.ResponseWriter, r *http.Request) {

	coins := services.GetCoins(h.app, 200)

	coinPreseneters := make([]coinResp, len(coins), len(coins))

	for i, coin := range coins {
		coinPreseneters[i] = coinResp{coin.Rank, coin.Symbol, coin.Price}
	}

	resp := coinsResp{
		Data: coinPreseneters,
	}

	if err := json.NewEncoder(w).Encode(resp); err != nil {
		http.Error(w, err.Error(), 500)
		h.app.Logger.Error().Err(err).Msg("Could not render version")
	}
}
