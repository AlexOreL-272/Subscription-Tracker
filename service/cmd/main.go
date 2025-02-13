package main

import (
	"time"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/config"
	logutils "github.com/AlexOreL-272/Subscription-Tracker/internal/logger"
	"github.com/joho/godotenv"
)

func init() {
	if err := godotenv.Load(); err != nil {
		panic(err)
	}
}

func main() {
	// read config
	cfg := config.MustLoad()

	// setup logger
	logger := logutils.SetupLogger(cfg.Logger)

	// update logger every 24 hours
	go func() {
		ticker := time.NewTicker(24 * time.Hour)
		defer ticker.Stop()

		for range ticker.C {
			logger = logutils.SetupLogger(cfg.Logger)
		}
	}()

	// setup application

	// run application
}
