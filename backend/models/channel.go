package models

type Channel struct {
	ID         int    `json:"id"`
	Name       string `json:"name"`
	Image      string `json:"image"`
	Link       string `json:"link"`
	CategoryID int    `json:"category_id"`
	Category   string `json:"category"`
}