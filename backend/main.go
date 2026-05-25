package main

import (
	"log"
	"backend/config"
	"backend/routes"
	"github.com/gofiber/fiber/v2"
	"github.com/joho/godotenv"
)

func main() {

	err := godotenv.Load()

	if err != nil {
		log.Fatal("Error loading .env file")
	}

	config.ConnectDB()

	app := fiber.New()

	// Root Route
	app.Get("/", func(c *fiber.Ctx) error {

		return c.JSON(fiber.Map{
			"success": true,
			"message": "Sports IPTV API Running",
		})
	})

	routes.SetupRoutes(app)

	log.Fatal(app.Listen("0.0.0.0:3000"))
}