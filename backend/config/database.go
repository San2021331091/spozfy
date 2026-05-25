package config

import (
	"database/sql"
	"log"
	"os"
	_ "github.com/lib/pq"
)

var DB *sql.DB

func ConnectDB() {

	dbUrl := os.Getenv("DATABASE_URL")

	db, err := sql.Open("postgres", dbUrl)

	if err != nil {
		log.Fatal("Database connection failed")
	}

	err = db.Ping()

	if err != nil {
		log.Fatal("Database unreachable")
	}

	DB = db

	log.Println("Database connected")
}