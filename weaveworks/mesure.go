package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	metrics "github.com/rcrowley/go-metrics"
)

type Stats struct {
	Total      int64   `json:"msg_total"`
	ReqCount   int64   `json:"msg_req"`
	AckCount   int64   `json:"msg_ack"`
	NakCount   int64   `json:"msg_nak"`
	ReqRate1s  float64 `json:"request_rate_1s"`
	ReqRate10s float64 `json:"request_rate_10s"`
	ResRate1s  float64 `json:"response_rate_1s"`
	ResRate10s float64 `json:"response_rate_10s"`
}

type Mesure struct {
	Total      metrics.Counter
	ReqCount   metrics.Counter
	AckCount   metrics.Counter
	NakCount   metrics.Counter
	ReqRate1s  metrics.Counter
	ReqRate10s metrics.Counter
	ResRate1s  metrics.Counter
	ResRate10s metrics.Counter
}

func (messure *Mesure) Process(msg string) {
	log.Print(msg)
	messure.Total.Inc(1)

	if len(msg) > 3 {
		switch command := msg[0:3]; command {
		case "REQ":
			messure.ReqCount.Inc(1)
			messure.ReqRate1s.Inc(1)
			messure.ReqRate10s.Inc(1)
		case "ACK":
			messure.AckCount.Inc(1)
			messure.ResRate1s.Inc(1)
			messure.ResRate10s.Inc(1)
		case "NAK":
			messure.NakCount.Inc(1)
			messure.ResRate1s.Inc(1)
			messure.ResRate10s.Inc(1)
		}
	}
}

func (mesure *Mesure) Json() ([]byte, error) {
	msg := Stats{
		Total:      mesure.Total.Count(),
		ReqCount:   mesure.ReqCount.Count(),
		AckCount:   mesure.AckCount.Count(),
		NakCount:   mesure.NakCount.Count(),
		ReqRate1s:  float64(mesure.ReqRate1s.Count()),
		ReqRate10s: float64(mesure.ReqRate10s.Count()) / float64(10.0),
		ResRate1s:  float64(mesure.ResRate1s.Count()),
		ResRate10s: float64(mesure.ResRate10s.Count()) / float64(10.0),
	}
	return json.Marshal(msg)
}

func (messure *Mesure) Tick() {
	rate1sTick := time.Tick(time.Second * 2)   // 1s + 1s for background jobs
	rate10sTick := time.Tick(time.Second * 11) // 10s + 1s for background jobs
	for {
		select {
		case <-rate1sTick:
			messure.ReqRate1s.Clear()
			messure.ResRate1s.Clear()
		case <-rate10sTick:
			messure.ReqRate10s.Clear()
			messure.ResRate10s.Clear()
		}
	}
}

func (mesure *Mesure) RegisterPrinter() {
	sigc := make(chan os.Signal, 1)
	signal.Notify(sigc, syscall.SIGUSR1)

	go mesure.OutputStatsOn(sigc)
}

func (mesure *Mesure) OutputStatsOn(sigc chan os.Signal) {
	defer signal.Stop(sigc)
	for {
		<-sigc
		response, err := mesure.Json()
		if err != nil {
			log.Println(err)
		}
		fmt.Println(string(response))
	}
}

func NewMesure() *Mesure {
	mesure := Mesure{
		Total:      metrics.NewCounter(),
		ReqCount:   metrics.NewCounter(),
		AckCount:   metrics.NewCounter(),
		NakCount:   metrics.NewCounter(),
		ReqRate1s:  metrics.NewCounter(),
		ReqRate10s: metrics.NewCounter(),
		ResRate1s:  metrics.NewCounter(),
		ResRate10s: metrics.NewCounter(),
	}

	go mesure.Tick()
	mesure.RegisterPrinter()

	return &mesure
}
