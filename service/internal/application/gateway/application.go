package gatewayapp

import (
	"context"
	"errors"
	"fmt"
	"net/http"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/auth/keycloak"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/config"
	handler "github.com/AlexOreL-272/Subscription-Tracker/internal/http"
	pgstorage "github.com/AlexOreL-272/Subscription-Tracker/internal/storage/postgres"
	"github.com/go-chi/chi"
	"go.uber.org/zap"
)

type Application struct {
	gatewayServer *http.Server
	logger        *zap.Logger
}

type GatewayConfig struct {
	Gateway  config.Gateway
	Keycloak config.Keycloak
	Database config.Database
}

func New(
	cfg GatewayConfig,
	logger *zap.Logger,
) *Application {
	const op = "gatewayapp.New"

	keycloakClient := keycloak.New(
		fmt.Sprintf("%s:%d", cfg.Keycloak.Host, cfg.Keycloak.Port),
		cfg.Keycloak.Realm,
		cfg.Keycloak.RealmAdmin,
		cfg.Keycloak.ClientID,
		cfg.Keycloak.ClientSecret,
		cfg.Keycloak.AdminUser,
		cfg.Keycloak.AdminPass,
	)

	postgresDB, err := pgstorage.New(fmt.Sprintf(
		"host=%s port=%d user=%s password=%s dbname=%s sslmode=%s",
		cfg.Database.Host,
		cfg.Database.Port,
		cfg.Database.User,
		cfg.Database.Password,
		cfg.Database.DBName,
		cfg.Database.SSLMode,
	))
	if err != nil {
		logger.
			With(zap.String("operation", op)).
			Error("failed to connect to database", zap.Error(err))
	}

	handler := handler.New(
		keycloakClient,
		postgresDB,
		postgresDB,
		postgresDB,
		logger,
	)

	router := chi.NewRouter()
	setupRouter(router, handler)

	srv := &http.Server{
		Addr:    fmt.Sprintf("%s:%d", cfg.Gateway.Host, cfg.Gateway.Port),
		Handler: router,
	}

	return &Application{
		gatewayServer: srv,
		logger:        logger,
	}
}

func (a *Application) MustStart() {
	if err := a.start(); err != nil {
		panic(err)
	}
}

func (a *Application) start() error {
	const op = "gatewayapp.Application.start"

	a.logger.
		With(zap.String("operation", op)).
		Info("starting API Gateway application")

	if err := a.gatewayServer.ListenAndServe(); err != nil {
		if errors.Is(err, http.ErrServerClosed) {
			return nil
		}

		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}

func (a *Application) Shutdown() {
	const op = "gatewayapp.Application.Shutdown"

	a.logger.
		With(zap.String("operation", op)).
		Info("shutting down")

	ctx := context.Background()
	if err := a.gatewayServer.Shutdown(ctx); err != nil {
		a.logger.
			With(zap.String("operation", op)).
			Error("failed to shutdown", zap.Error(err))
	}
}

func setupRouter(
	router *chi.Mux,
	handler *handler.Handler,
) {
	// use URL paths and middlewares
	router.Get("/", handler.Echo)

	router.Post("/register", handler.Register)
	router.Post("/login", handler.Login)
}
