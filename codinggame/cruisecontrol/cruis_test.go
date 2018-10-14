package cruisecontrol_test

import (
	"testing"

	"github.com/miry/samples/codinggame/cruisecontrol"
	"github.com/stretchr/testify/assert"
)

func TestCruisVillageTrafficLight(t *testing.T) {
	speed := 50
	lights := []*cruisecontrol.Light{
		{Distance: 200, Duration: 15},
	}
	assert.Equal(t, 50, cruisecontrol.Cruis(speed, lights))
}

func TestCruisVillageTrafficLight2(t *testing.T) {
	speed := 50
	lights := []*cruisecontrol.Light{
		{Distance: 200, Duration: 10},
	}
	assert.Equal(t, 36, cruisecontrol.Cruis(speed, lights))
}

func TestCruisVillageTrafficLight3(t *testing.T) {
	speed := 50
	lights := []*cruisecontrol.Light{
		{Distance: 200, Duration: 5},
	}
	assert.Equal(t, 50, cruisecontrol.Cruis(speed, lights))
}

func TestCruisQuietCountryRoad(t *testing.T) {
	speed := 90
	lights := []*cruisecontrol.Light{
		{Distance: 300, Duration: 30},
		{Distance: 1500, Duration: 30},
		{Distance: 3000, Duration: 30},
	}
	assert.Equal(t, 90, cruisecontrol.Cruis(speed, lights))
}

func TestCruisLessQuietCountryRoad(t *testing.T) {
	speed := 90
	lights := []*cruisecontrol.Light{
		{Distance: 300, Duration: 10},
		{Distance: 1500, Duration: 10},
		{Distance: 3000, Duration: 10},
	}
	assert.Equal(t, 54, cruisecontrol.Cruis(speed, lights))
}

func TestCruisUnsettledCountryRoad(t *testing.T) {
	speed := 90
	lights := []*cruisecontrol.Light{
		{Distance: 300, Duration: 30},  // 90
		{Distance: 1500, Duration: 20}, // 67
		{Distance: 3000, Duration: 10}, // 90
	}
	assert.Equal(t, 67, cruisecontrol.Cruis(speed, lights))
}

func TestCruisFastLights(t *testing.T) {
	speed := 90
	lights := []*cruisecontrol.Light{
		{Distance: 1234, Duration: 5},
		{Distance: 2468, Duration: 5},
		{Distance: 3702, Duration: 5},
		{Distance: 6170, Duration: 5},
		{Distance: 8638, Duration: 5},
		{Distance: 13574, Duration: 5},
		{Distance: 16042, Duration: 5},
		{Distance: 20978, Duration: 5},
		{Distance: 23446, Duration: 5},
		{Distance: 28382, Duration: 5},
		{Distance: 35786, Duration: 5},
		{Distance: 38254, Duration: 5},
		{Distance: 45658, Duration: 5},
		{Distance: 50594, Duration: 5},
		{Distance: 53062, Duration: 5},
		{Distance: 57998, Duration: 5},
	}
	assert.Equal(t, 74, cruisecontrol.Cruis(speed, lights))
}
