package http

import (
	"encoding/json"
	"net/http"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/auth/keycloak"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/domain"
	"go.uber.org/zap"
)

type Handler struct {
	logger         *zap.Logger
	keycloakClient *keycloak.KeycloakClient
}

func New(keycloakClient *keycloak.KeycloakClient, logger *zap.Logger) *Handler {
	return &Handler{
		logger:         logger,
		keycloakClient: keycloakClient,
	}
}

func (h *Handler) Echo(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello, world!"))
}

func (h *Handler) Register(w http.ResponseWriter, r *http.Request) {
	const handler = "http.Handler.Register"

	var userCredentials domain.UserCredentials

	if err := json.NewDecoder(r.Body).Decode(&userCredentials); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to decode user credentials", zap.Error(err))
		http.Error(w, "failed to decode user credentials", http.StatusBadRequest)

		return
	}

	defer func() {
		if err := r.Body.Close(); err != nil {
			h.logger.
				With(zap.String("operation", handler)).
				Error("failed to close request body", zap.Error(err))
		}
	}()

	// save user to keycloak
	registerResp, err := h.keycloakClient.Register(
		r.Context(),
		userCredentials,
	)
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to register user", zap.Error(err))
		http.Error(w, "failed to register user", http.StatusInternalServerError)

		return
	}

	// TODO: save user to database
	// implementation

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	if err := json.NewEncoder(w).Encode(registerResp); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to encode response", zap.Error(err))
		http.Error(w, "failed to encode response", http.StatusInternalServerError)

		return
	}
}

func (h *Handler) Login(w http.ResponseWriter, r *http.Request) {
	const handler = "http.Handler.Login"

	var loginCredentials domain.LoginRequest

	if err := json.NewDecoder(r.Body).Decode(&loginCredentials); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to decode login credentials", zap.Error(err))
		http.Error(w, "failed to decode login credentials", http.StatusBadRequest)

		return
	}

	defer func() {
		if err := r.Body.Close(); err != nil {
			h.logger.
				With(zap.String("operation", handler)).
				Error("failed to close request body", zap.Error(err))
		}
	}()

	loginResp, err := h.keycloakClient.Login(
		r.Context(),
		loginCredentials.Email,
		loginCredentials.Password,
	)
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to login user", zap.Error(err))
		http.Error(w, "failed to login user", http.StatusInternalServerError)

		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	if err := json.NewEncoder(w).Encode(loginResp); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to encode response", zap.Error(err))
		http.Error(w, "failed to encode response", http.StatusInternalServerError)

		return
	}
}
