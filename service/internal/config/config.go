package config

import (
	"os"

	"github.com/ilyakaznacheev/cleanenv"
)

type Config struct {
	Gateway      Gateway      `yaml:"gateway" env-required:"true"`
	Database     Database     `yaml:"database" env-required:"true"`
	Redis        Redis        `yaml:"redis" env-required:"true"`
	Keycloak     Keycloak     `yaml:"keycloak" env-required:"true"`
	Notification Notification `yaml:"notification" env-required:"true"`
	Logger       Logger       `yaml:"logger" env-required:"true"`
	Yandex       Yandex       `yaml:"yandex" env-required:"true"`
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
	SSLMode  string `yaml:"sslMode" env:"DB_SSL_MODE" env-default:"disable"`
}

type Redis struct {
	Host string `yaml:"host" env:"REDIS_HOST" env-default:"localhost"`
	Port int    `yaml:"port" env:"REDIS_PORT" env-default:"6379"`
}

type Keycloak struct {
	Host         string `yaml:"host" env:"KEYCLOAK_HOST" env-default:"localhost"`
	Port         int    `yaml:"port" env:"KEYCLOAK_PORT" env-default:"8180"`
	Realm        string `yaml:"realm" env:"KEYCLOAK_REALM" env-default:""`
	ClientID     string `yaml:"clientId" env:"KEYCLOAK_CLIENT_ID" env-default:""`
	ClientSecret string `yaml:"clientSecret" env:"KEYCLOAK_CLIENT_SECRET" env-default:""`
}

type Notification struct {
	Email  Email  `yaml:"email" env-required:"true"`
	Static Static `yaml:"static" env-required:"true"`
}

type Email struct {
	SenderEmail    string `yaml:"senderEmail" env:"EMAIL_SENDER_EMAIL" env-default:"noreply@wasubi.com"`
	SenderNickname string `yaml:"senderNickname" env:"EMAIL_SENDER_NICKNAME" env-default:"Wasubi"`
	SmtpServerHost string `yaml:"smtpServerHost" env:"EMAIL_SMTP_SERVER_HOST" env-default:"smtp.gmail.com"`
	SmtpServerPort int    `yaml:"smtpServerPort" env:"EMAIL_SMTP_SERVER_PORT" env-default:"587"`
	SmtpUsername   string `yaml:"smtpUsername" env:"EMAIL_SMTP_USERNAME" env-default:""`
	SmtpPassword   string `yaml:"smtpPassword" env:"EMAIL_SMTP_PASSWORD" env-default:""`
	TemplatesPath  string `yaml:"templatesPath" env:"EMAIL_TEMPLATES_PATH" env-default:"./templates/emails"`
}

type Static struct {
	TemplatesPath string `yaml:"templatesPath" env:"STATIC_TEMPLATES_PATH" env-default:"./templates/static"`
}

type Yandex struct {
	ClientID     string `yaml:"clientId" env:"YANDEX_CLIENT_ID" env-default:""`
	ClientSecret string `yaml:"clientSecret" env:"YANDEX_CLIENT_SECRET" env-default:""`
}

type Logger struct {
	Env    EnvType `yaml:"env" env:"ENV" env-default:"development"`
	LogDir string  `yaml:"logDir" env:"LOG_DIR" env-default:"./logs"`
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
		path = "/opt/wasubi/configs/service/config.yaml"
	}

	return path
}
