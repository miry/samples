/**
Writing programming interview questions hasn't made me rich yet ... so I might give up and start trading Apple stocks all day instead.

First, I wanna know how much money I could have made yesterday if I'd been trading Apple stocks all day.

So I grabbed Apple's stock prices from yesterday and put them in an array called stock_prices, where:

The indices are the time (in minutes) past trade opening time, which was 9:30am local time.
The values are the price (in US dollars) of one share of Apple stock at that time.
So if the stock cost $500 at 10:30am, that means stock_prices[60] = 500.

Write an efficient method that takes stock_prices and returns the best profit I could have made from one purchase and one sale of one share of Apple stock yesterday.

For example:

  stock_prices = [10, 7, 5, 8, 11, 9]

get_max_profit(stock_prices)
# returns 6 (buying for $5 and selling for $11)

No "shorting"—you need to buy before you can sell. Also, you can't buy and sell in the same time step—at least 1 minute has to pass.
**/

package problems

func GetMaxProfitBruteForce(prices []int) int { // Time complexity: O(n^2)
	n := len(prices)
	if n < 2 {
		return 0
	}

	max := 0
	var sell, buy, profit int
	for i := 0; i < n-1; i++ { // Time complexity: O(n)
		buy = prices[i]
		for j := i + 1; j < n; j++ { // Time complexity: O(1/2 n) ~= O(n)
			sell = prices[j]
			profit = sell - buy
			if profit > max {
				max = profit
			}
		}
	}

	return max
}

func GetMaxProfitOptimal(prices []int) int { // Time complexity: O(n)
	n := len(prices)
	if n < 2 {
		return 0
	}

	var price, current_profit int
	min, profit := prices[0], 0

	for i := 0; i < n; i++ { // Time complexity: O(n)
		price = prices[i]
		current_profit = price - min
		if current_profit > profit {
			profit = current_profit
		}
		if price < min {
			min = price
		}
	}

	return profit
}

func GetMaxProfit(prices []int) int {
	// return GetMaxProfitBruteForce(prices) // Time complexity: O(n^2)
	return GetMaxProfitOptimal(prices) // Time complexity: O(n)
}
