package main

import (
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"
)

func main() {
	a := app.New()
	w := a.NewWindow("Refresh")

	hello := widget.NewLabel("Version v3")
	w.SetContent(container.NewVBox(
		hello,
		widget.NewButton("Hi! v3", func() {
			hello.SetText("v3: Welcome :)")
		}),
	))

	w.ShowAndRun()
}
