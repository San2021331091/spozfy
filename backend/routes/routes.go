package routes

import (
	"backend/controllers"
	"github.com/gofiber/fiber/v2"
)

func SetupRoutes(app *fiber.App) {

	api := app.Group("/api")

	// Categories
	api.Get("/categories", controllers.GetCategories)

	// Channels
	api.Get("/channels", controllers.GetChannels)
	api.Get("/channels/:id", controllers.GetChannel)

	// Channels by category
	api.Get(
		"/categories/:id/channels",
		controllers.GetChannelsByCategory,
	)
}