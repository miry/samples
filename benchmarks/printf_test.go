// go test -bench=BenchmarkPrintString ./benchmarks/...  | ~/go/bin/benchgraph

package benchmarks

import (
	"fmt"
	"math/rand"
	"os"
	"runtime"
	"runtime/debug"
	"testing"
)

func Printf(value []int) {
	fmt.Printf("%v\n", value)
}

func FPrintf(value []int) {
	fmt.Fprintf(os.Stdout, "%v\n", value)
}

func BenchmarkPrintString(b *testing.B) {
	os.Stdout, _ = os.Open(os.DevNull)
	debug.SetGCPercent(-1)
	for _, size := range []int{1, 10, 100, 1000, 10000, 100000, 1000000} {
		benchmarkPrintString(b, size)
		runtime.GC()
	}
}

func benchmarkPrintString(b *testing.B, size int) {
	var arr = make([]int, size, size)

	rand.Seed(int64(size % 42))
	for i := 0; i < size; i++ {
		arr[i] = i
	}

	b.ResetTimer()

	b.Run(fmt.Sprintf("Printf_%d", size), func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			Printf(arr)
		}
	})

	b.Run(fmt.Sprintf("Fprintf_%d", size), func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			FPrintf(arr)
		}
	})
}
