package application

import (
	gatewayapp "github.com/AlexOreL-272/Subscription-Tracker/internal/application/gateway"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/config"
	"go.uber.org/zap"
)

type Application struct {
	apiGateway *gatewayapp.Application
}

func New(
	cfg *config.Config,
	logger *zap.Logger,
) *Application {
	gatewayConfig := gatewayapp.GatewayConfig{
		Gateway:      cfg.Gateway,
		Keycloak:     cfg.Keycloak,
		Database:     cfg.Database,
		Yandex:       cfg.Yandex,
		Notification: cfg.Notification,
	}

	apiGateway := gatewayapp.New(gatewayConfig, logger)

	return &Application{
		apiGateway: apiGateway,
	}
}

func (a *Application) MustStart() {
	go a.apiGateway.MustStart()
}

func (a *Application) Shutdown() {
	a.apiGateway.Shutdown()
}
