package logutils

import (
	"fmt"
	"os"
	"path/filepath"
	"time"

	"go.uber.org/zap"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/config"
)

var (
	currentLogFile     *os.File
	currentLogFileName string
)

const (
	timeLayout = "2006-01-02"
)

func SetupLogger(cfg config.Logger) *zap.Logger {
	var logger *zap.Logger
	var err error

	if err := updateLogFile(cfg.LogDir); err != nil {
		panic(err)
	}

	switch cfg.Env {
	case config.LocalEnv:
		logger = zap.NewExample()
	case config.DevEnv:
		logPath := filepath.Join(cfg.LogDir, fmt.Sprintf("%s.log", currentLogFileName))

		loggerCfg := zap.NewDevelopmentConfig()
		loggerCfg.OutputPaths = []string{
			logPath,
			"stdout",
		}
		logger, err = loggerCfg.Build()
	case config.ProdEnv:
		logPath := filepath.Join(cfg.LogDir, fmt.Sprintf("%s.log", currentLogFileName))

		loggerCfg := zap.NewProductionConfig()
		loggerCfg.OutputPaths = []string{
			logPath,
		}
		logger, err = loggerCfg.Build()
	}

	if err != nil {
		logger = zap.NewExample()
	}

	return logger
}

func updateLogFile(logDir string) error {
	currentDate := time.Now().Format(timeLayout)

	// if currentLogFileName is the same as currentDate - do nothing
	if currentLogFileName == currentDate {
		return nil
	}

	// if currentLogFile is open - close it
	if currentLogFile != nil {
		if err := currentLogFile.Close(); err != nil {
			return err
		}
	}

	// update log file and log file name
	if err := os.MkdirAll(logDir, os.ModePerm); err != nil {
		return fmt.Errorf("cannot make logs directory: %w", err)
	}

	logFilePath := filepath.Join(logDir, fmt.Sprintf("%s.log", currentDate))

	logFile, err := os.OpenFile(logFilePath, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		return fmt.Errorf("cannot open log file: %w", err)
	}

	currentLogFile = logFile
	currentLogFileName = currentDate

	return nil
}
