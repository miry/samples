package main

// https://www.codingame.com/ide/puzzle/aneo

import (
	"fmt"
	"os"

	"github.com/miry/samples/codinggame/cruisecontrol"
)

func main() {
	var speed int
	fmt.Scan(&speed)
	fmt.Fprintf(os.Stderr, "Speed: %#v\n", speed)

	var lightCount int
	fmt.Scan(&lightCount)
	fmt.Fprintf(os.Stderr, "Count: %#v\n", lightCount)

	lights := make([]*cruisecontrol.Light, lightCount, lightCount)
	var distance, duration int
	for i := 0; i < lightCount; i++ {
		fmt.Scan(&distance, &duration)
		lights[i] = &cruisecontrol.Light{
			Distance: float64(distance),
			Duration: float64(duration),
		}
	}
	fmt.Fprintf(os.Stderr, "Lights: %#v\n", lights)
	result := cruisecontrol.Cruis(speed, lights)

	fmt.Println(result) // Write answer to stdout
}
