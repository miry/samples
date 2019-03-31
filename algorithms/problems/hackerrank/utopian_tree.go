package hackerrank

func UtopianTree(n int32) int32 {
	return utopianTreeBitWise(n)
	// return utopianTreeBruteForce(n)
}

func utopianTreeBruteForce(n int32) int32 {
	var result int32 = 1
	var i int32
	for i = 1; i <= n; i++ {
		if i%2 == 1 {
			result *= 2
		} else {
			result++
		}
	}
	return result
}

func utopianTreeBitWise(n int32) int32 {
	return (1<<(uint32(n>>1)+1) - 1) << (uint32(n & 1))
}
