package gatewayapp

import (
	"errors"
	"fmt"
	"net/http"

	"github.com/go-chi/chi"
	"go.uber.org/zap"
)

type Application struct {
	gatewayServer *http.Server
	logger        *zap.Logger
}

func New(
	host string,
	port int,
	logger *zap.Logger,
) *Application {
	router := chi.NewRouter()
	setupRouter(router)

	srv := &http.Server{
		Addr:    fmt.Sprintf("%s:%d", host, port),
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

	if err := a.gatewayServer.Shutdown(nil); err != nil {
		a.logger.
			With(zap.String("operation", op)).
			Error("failed to shutdown", zap.Error(err))
	}
}

func setupRouter(router *chi.Mux) {
	// use URL paths and middlewares
	router.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello, world!"))
	})
}
