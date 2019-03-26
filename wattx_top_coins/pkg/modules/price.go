package modules

type Price struct {
	Rank   int64   `json:"rank"`
	Symbol string  `json:"symbol"`
	Price  float64 `json:"price"`
}
