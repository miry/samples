# Codewars problems

## Array Diff

```shell
go test -bench=. ./...  | benchgraph # Modified version of `CodingBerg/benchgraph` https://github.com/codingberg/benchgraph/pull/4
```

Bencmark result: http://benchgraph.codingberg.com/5n

Base on benchmarking Include solution is growing faster than using Map.
If arrays have small size, than it is ok to use Include approach.

10 items:

```
BenchmarkArrayDiff/ArrayDiffMap_10-4             1000000              1004 ns/op
BenchmarkArrayDiff/ArrayDiffInclude_10-4         5000000               303 ns/op
```

On 100 items it was changed:

```
BenchmarkArrayDiff/ArrayDiffMap_90-4              100000             11825 ns/op
BenchmarkArrayDiff/ArrayDiffInclude_90-4          100000             12056 ns/op
```

On 1000 items:

```
BenchmarkArrayDiff/ArrayDiffMap_990-4            10000            124874 ns/op
BenchmarkArrayDiff/ArrayDiffInclude_990-4         2000            953394 ns/op
```

![](https://duaw26jehqd4r.cloudfront.net/items/250U1Y3n1n1K0d420D33/%5B7e068f1794e0c02adc4029b07e06862a%5D_Find+array+difference+benchmarking.png?v=f1955335)
