package interviewcake

/*
Coins is an algorithm problem from https://www.interviewcake.com/question/ruby/coin

Your quirky boss collects rare, old coins...

They found out you're a programmer and asked you to solve something they've been wondering for a long time.

Write a method that, given:

an amount of money
an array of coin denominations
computes the number of ways to make the amount of money with coins of the available denominations.

Example: for amount=4 (4¢) and denominations=[1,2,3] (11¢, 22¢ and 33¢), your program would output 44—the number of ways to make 44¢ with those denominations:

1¢, 1¢, 1¢, 1¢
1¢, 1¢, 2¢
1¢, 3¢
2¢, 2¢
*/
func Coins(a int, denominations []int) [][]int {
	if len(denominations) == 0 || a < 0 {
		return nil
	}

	result := [][]int{}
	if a == 0 {
		return result
	}

	found := false
	var (
		variations [][]int
		diff       int
	)

	for i, n := range denominations {
		diff = a - n
		if diff < 0 {
			continue
		}
		found = true

		variations = Coins(diff, denominations[i:])
		if variations == nil {
			continue
		}

		if len(variations) == 0 {
			result = append(result, []int{n})
			continue
		}

		for _, variation := range variations {
			result = append(result, append(variation, n))
		}
	}

	if !found {
		return nil
	}
	return result
}
