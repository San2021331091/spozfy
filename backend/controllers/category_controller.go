package controllers

import (
	"backend/config"
	"backend/models"
	"backend/utils"

	"github.com/gofiber/fiber/v2"
)

func GetCategories(c *fiber.Ctx) error {

	rows, err := config.DB.Query(`
		SELECT id, name
		FROM sports_categories
		ORDER BY name
	`)

	if err != nil {
		return utils.Error(c, err.Error())
	}

	defer rows.Close()

	var categories []models.Category

	for rows.Next() {

		var category models.Category

		rows.Scan(
			&category.ID,
			&category.Name,
		)

		categories = append(categories, category)
	}

	return utils.Success(c, categories)
}