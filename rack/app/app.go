package app

import (
	"github.com/gocraft/health"
)

type App struct {
	Hostname    string
	Version     string
	TraceStream *health.Stream
}
