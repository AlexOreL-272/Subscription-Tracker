package application

import (
	gatewayapp "github.com/AlexOreL-272/Subscription-Tracker/internal/application/gateway"
	"go.uber.org/zap"
)

type Application struct {
	apiGateway *gatewayapp.Application
}

type Config struct {
	GatewayHost string
	GatewayPort int
}

func New(
	cfg Config,
	logger *zap.Logger,
) *Application {
	apiGateway := gatewayapp.New(cfg.GatewayHost, cfg.GatewayPort, logger)

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
