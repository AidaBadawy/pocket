package main

import (
	"log"

	"github.com/labstack/echo"
	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/core"
)

func main() {
	app := pocketbase.New()

	// Add a custom route
	app.OnBeforeServe().Add(func(e *core.ServeEvent) error {
		e.Router.GET("/custom", func(c echo.Context) error {
			return c.String(200, "Hello from custom route in PocketBase v0.25.0!")
		})
		return nil
	})

	// Start the app
	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
