package services

import (
	"github.com/miry/wattx_top_coins/pkg/app"
	"github.com/miry/wattx_top_coins/pkg/modules"
)

// GetCoins get recent coins information
func GetCoins(app *app.App, limit int) []modules.Coin {
	return []modules.Coin{
		{Rank: 1, Symbol: "BTC", Price: 6634.41},
		{Rank: 2, Symbol: "ETH", Price: 370.237},
		{Rank: 3, Symbol: "XRP", Price: 0.471636},
	}
}
