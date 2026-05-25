package main

import (
	"log"
	"os"

	"backend/config"
	"backend/routes"

	"github.com/gofiber/fiber/v2"
	"github.com/joho/godotenv"
)

func main() {

	err := godotenv.Load()

	if err != nil {
		log.Println(".env file not found, using Render environment variables")
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
	port := os.Getenv("PORT")

	if port == "" {
		port = "8000"
	}

	log.Fatal(app.Listen("0.0.0.0:" + port))
}