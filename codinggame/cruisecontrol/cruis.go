package cruisecontrol

import (
	"math"
)

type Light struct {
	Distance float64
	Duration float64
}

func Cruis(maxspeed int, lights []*Light) int {
	speed := float64(maxspeed) * 10 / 36
	prev := speed + 1
	result := speed
	for prev != result {
		prev = result
		for _, light := range lights {
			result = getMaxSpeed(result, light)
		}
		corrector := result * 3.6
		if corrector-math.Floor(corrector) > 0.001 {
			result -= 0.0001
		}
	}

	return int(result * 3.6)
}

func getMaxSpeed(s float64, l *Light) float64 {
	cycle := l.Distance / l.Duration / s
	if cycle < 1 {
		return s
	}
	if int(cycle)%2 != 0 {
		cycle = math.Floor(cycle + 1)
	}

	return l.Distance / (l.Duration * cycle)
}
