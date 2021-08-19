package main

import (
	"fmt"
	"image"
	"image/color"
	"math"
	"time"

	"gioui.org/app"
	"gioui.org/f32"
	"gioui.org/font/gofont"
	"gioui.org/io/system"
	"gioui.org/layout"
	"gioui.org/op"
	"gioui.org/op/clip"
	"gioui.org/op/paint"
	"gioui.org/text"
	"gioui.org/unit"
	"gioui.org/widget"
	"gioui.org/widget/material"
)

type C = layout.Context
type D = layout.Dimensions

var boiling bool
var boilDurationInput widget.Editor
var progress float64
var progressIncrementer chan float64

func main() {
	progressIncrementer = make(chan float64)
	go func() {
		for {
			time.Sleep(time.Second / 25)
			progressIncrementer <- 0.004
		}
	}()

	go func() {
		w := app.NewWindow(
			app.Title("Egg timer"),
			app.Size(unit.Dp(1400), unit.Dp(600)),
		)
		draw(w)
	}()
	app.Main()
}

func draw(w *app.Window) error {
	var ops op.Ops
	var startButton widget.Clickable
	th := material.NewTheme(gofont.Collection())

	for {
		select {
		case e := <-w.Events():
			switch e := e.(type) {
			case system.FrameEvent:
				gtx := layout.NewContext(&ops, e)
				if startButton.Clicked() {
					boiling = !boiling
				}

				layout.Flex{
					Axis:    layout.Vertical,
					Spacing: layout.SpaceStart,
				}.Layout(gtx,

					// EggWidget
					layout.Rigid(
						func(gtx C) D {
							// Draw a custom path, shaped like an egg
							var eggPath clip.Path
							op.Offset(f32.Pt(200, 150)).Add(gtx.Ops)
							eggPath.Begin(gtx.Ops)
							// Rotate from 0 to 360 degrees
							for deg := 0.0; deg <= 360; deg++ {

								// Egg math (really) at this brilliant site. Thanks!
								// https://observablehq.com/@toja/egg-curve
								// Convert degrees to radians
								rad := deg / 360 * 2 * math.Pi
								// Trig gives the distance in X and Y direction
								cosT := math.Cos(rad)
								sinT := math.Sin(rad)
								// Constants to define the eggshape
								a := 110.0
								b := 150.0
								d := 20.0
								// The x/y coordinates
								x := a * cosT
								y := -(math.Sqrt(b*b-d*d*cosT*cosT) + d*sinT) * sinT
								// Finally the point on the outline
								p := f32.Pt(float32(x), float32(y))
								// Draw the line to this point
								eggPath.LineTo(p)
							}
							// Close the path
							eggPath.Close()

							// Get hold of the actual clip
							eggArea := clip.Outline{Path: eggPath.End()}.Op()

							// Fill the shape
							// color := color.NRGBA{R: 255, G: 239, B: 174, A: 255}
							color := color.NRGBA{R: 255, G: uint8(239 * (1 - progress)), B: uint8(174 * (1 - progress)), A: 255}
							paint.FillShape(gtx.Ops, color, eggArea)

							d := image.Point{Y: 375}
							return layout.Dimensions{Size: d}
						},
					),

					// Boiltime
					layout.Rigid(
						func(gtx C) D {
							// Define characteristics of the input box ...
							boilDurationInput.SingleLine = true
							boilDurationInput.Alignment = text.Middle
							// ... and wrap it in material design
							ed := material.Editor(th, &boilDurationInput, "sec")

							boilDuration := 3.0
							if boiling && progress < 1 {
								boilRemain := (1.0 - progress) * boilDuration
								inputStr := fmt.Sprintf("%.1f", math.Round(float64(boilRemain)*10)/10)
								boilDurationInput.SetText(inputStr)
							}

							margin := layout.Inset{
								Top:    unit.Dp(25),
								Bottom: unit.Dp(25),
								Right:  unit.Dp(35),
								Left:   unit.Dp(35),
							}

							border := widget.Border{Color: color.NRGBA{A: 0xff}, CornerRadius: unit.Dp(8), Width: unit.Px(2)}

							return margin.Layout(gtx,
								func(gtx C) D {
									return border.Layout(gtx, ed.Layout)
								},
							)

						},
					),

					// ProgressBarWidget
					layout.Rigid(
						func(gtx C) D {
							bar := material.ProgressBar(th, float32(progress))
							return bar.Layout(gtx)
						},
					),

					// StartButtonWidget
					layout.Rigid(
						func(gtx C) D {
							margin := layout.Inset{
								Top:    unit.Dp(25),
								Bottom: unit.Dp(25),
								Right:  unit.Dp(35),
								Left:   unit.Dp(35),
							}

							return margin.Layout(gtx,
								func(gtx C) D {
									var text string
									if !boiling {
										text = "Start"
									}
									if boiling && progress < 1 {
										text = "Stop"
									}
									if boiling && progress >= 1 {
										text = "Finished"
									}
									btn := material.Button(th, &startButton, text)
									return btn.Layout(gtx)
								},
							)
						},
					),
				)
				e.Frame(gtx.Ops)
			case system.DestroyEvent:
				return e.Err
			}
		case p := <-progressIncrementer:

			if boiling && progress < 1 {
				progress += p
				w.Invalidate()
			}
		}
	}
}
