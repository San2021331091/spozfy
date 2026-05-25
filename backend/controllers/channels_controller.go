package controllers

import (
	"backend/config"
	"backend/models"
	"backend/utils"

	"github.com/gofiber/fiber/v2"
)

func GetChannels(c *fiber.Ctx) error {

	rows, err := config.DB.Query(`
		SELECT
			sc.id,
			sc.name,
			sc.image,
			sc.link,
			sc.category_id,
			sct.name
		FROM sports_channels sc
		JOIN sports_categories sct
		ON sc.category_id = sct.id
		ORDER BY sc.name
	`)

	if err != nil {
		return utils.Error(c, err.Error())
	}

	defer rows.Close()

	var channels []models.Channel

	for rows.Next() {

		var channel models.Channel

		rows.Scan(
			&channel.ID,
			&channel.Name,
			&channel.Image,
			&channel.Link,
			&channel.CategoryID,
			&channel.Category,
		)

		channels = append(channels, channel)
	}

	return utils.Success(c, channels)
}

func GetChannel(c *fiber.Ctx) error {

	id := c.Params("id")

	var channel models.Channel

	err := config.DB.QueryRow(`
		SELECT
			sc.id,
			sc.name,
			sc.image,
			sc.link,
			sc.category_id,
			sct.name
		FROM sports_channels sc
		JOIN sports_categories sct
		ON sc.category_id = sct.id
		WHERE sc.id = $1
	`, id).Scan(
		&channel.ID,
		&channel.Name,
		&channel.Image,
		&channel.Link,
		&channel.CategoryID,
		&channel.Category,
	)

	if err != nil {
		return utils.Error(c, "Channel not found")
	}

	return utils.Success(c, channel)
}

func GetChannelsByCategory(c *fiber.Ctx) error {

	categoryId := c.Params("id")

	rows, err := config.DB.Query(`
		SELECT
			sc.id,
			sc.name,
			sc.image,
			sc.link,
			sc.category_id,
			sct.name
		FROM sports_channels sc
		JOIN sports_categories sct
		ON sc.category_id = sct.id
		WHERE sc.category_id = $1
		ORDER BY sc.name
	`, categoryId)

	if err != nil {
		return utils.Error(c, err.Error())
	}

	defer rows.Close()

	var channels []models.Channel

	for rows.Next() {

		var channel models.Channel

		rows.Scan(
			&channel.ID,
			&channel.Name,
			&channel.Image,
			&channel.Link,
			&channel.CategoryID,
			&channel.Category,
		)

		channels = append(channels, channel)
	}

	return utils.Success(c, channels)
}