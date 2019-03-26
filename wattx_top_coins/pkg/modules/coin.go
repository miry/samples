package modules

// Coin represents cryptocurrency in response
type Coin struct {
	Rank   int64   `json:"rank"`
	Symbol string  `json:"symbol"`
	Price  float64 `json:"price"`
}
