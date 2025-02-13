package config

import (
	"os"

	"github.com/ilyakaznacheev/cleanenv"
)

type Config struct {
	Logger Logger `yaml:"logger" env-required:"true"`
}

type EnvType string

const (
	LocalEnv EnvType = "local"
	DevEnv   EnvType = "development"
	ProdEnv  EnvType = "production"
)

type Logger struct {
	Env    EnvType `yaml:"env" env:"ENV" env-default:"development"`
	LogDir string  `yaml:"log_dir" env:"LOG_DIR" env-default:"./logs"`
}

func MustLoad() *Config {
	configPath := fetchConfigPath()

	if configPath == "" {
		panic("Config path not found")
	}

	if _, err := os.Stat(configPath); os.IsNotExist(err) {
		panic("Config file not found")
	}

	var cfg Config
	if err := cleanenv.ReadConfig(configPath, &cfg); err != nil {
		panic("Error loading config file " + err.Error())
	}

	return &cfg
}

func fetchConfigPath() string {
	path := os.Getenv("CONFIG_PATH")

	if path == "" {
		path = "./configs/config.yaml"
	}

	return path
}
