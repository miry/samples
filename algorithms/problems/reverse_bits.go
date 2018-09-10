package problems

import (
	"fmt"
)

// ReverseBits reverse bits in x.
// The time complexity is O(n) where n is the word size.
// The space complexity is O(1).
func ReverseBits(x uint8) uint8 {
	val := uint8(x)
	bitsize := uint8(8)
	var i, j, ibit, jbit uint8
	for i, j = 0, bitsize-1; i < j; i, j = i+1, j-1 {
		ibit, jbit = (val >> i & 1), (val >> j & 1)
		val = (val & ^(1 << i)) | (jbit << i) // clear bit i and set as value from j
		val = (val & ^(1 << j)) | (ibit << j) // clear bit j and set as value from i
		fmt.Printf("[%d, %d] => x[i] = %b, x[j] = %b val: %8b\n", i, j, ibit, jbit, val)
	}
	return val
}
