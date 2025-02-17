package config

import (
	"os"

	"github.com/ilyakaznacheev/cleanenv"
)

type Config struct {
	Gateway  Gateway  `yaml:"gateway" env-required:"true"`
	Database Database `yaml:"database" env-required:"true"`
	Keycloak Keycloak `yaml:"keycloak" env-required:"true"`
	Logger   Logger   `yaml:"logger" env-required:"true"`
}

type EnvType string

const (
	LocalEnv EnvType = "local"
	DevEnv   EnvType = "development"
	ProdEnv  EnvType = "production"
)

type Gateway struct {
	Host string `yaml:"host" env:"GATEWAY_HOST" env-default:"localhost"`
	Port int    `yaml:"port" env:"GATEWAY_PORT" env-default:"8080"`
}

type Database struct {
	Driver   string `yaml:"driver" env:"DB_DRIVER" env-default:"postgres"`
	Host     string `yaml:"host" env:"DB_HOST" env-default:"localhost"`
	Port     int    `yaml:"port" env:"DB_PORT" env-default:"5432"`
	User     string `yaml:"user" env:"DB_USER" env-default:"postgres"`
	Password string `yaml:"password" env:"DB_PASSWORD" env-default:"postgres"`
	DBName   string `yaml:"dbname" env:"DB_NAME" env-default:"database"`
	SSLMode  string `yaml:"ssl_mode" env:"DB_SSL_MODE" env-default:"disable"`
}

type Keycloak struct {
	Host         string `yaml:"host" env:"KEYCLOAK_HOST" env-default:"localhost"`
	Port         int    `yaml:"port" env:"KEYCLOAK_PORT" env-default:"8180"`
	Realm        string `yaml:"realm" env:"KEYCLOAK_REALM" env-default:""`
	RealmAdmin   string `yaml:"realmAdmin" env:"KEYCLOAK_REALM_ADMIN" env-default:""`
	ClientID     string `yaml:"clientId" env:"KEYCLOAK_CLIENT_ID" env-default:""`
	ClientSecret string `yaml:"clientSecret" env:"KEYCLOAK_CLIENT_SECRET" env-default:""`
	AdminUser    string `yaml:"adminUser" env:"KEYCLOAK_ADMIN_USER" env-default:""`
	AdminPass    string `yaml:"adminPass" env:"KEYCLOAK_ADMIN_PASS" env-default:""`
}

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
