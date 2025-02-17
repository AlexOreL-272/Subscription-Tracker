package http

import (
	"encoding/json"
	"net/http"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/auth"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/domain"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/storage"
	"go.uber.org/zap"
)

type Handler struct {
	logger      *zap.Logger
	authClient  auth.Auth
	userSaver   storage.UserSaver
	subSaver    storage.SubscriptionSaver
	subProvider storage.SubscriptionProvider
}

func New(
	authClient auth.Auth,
	userSaver storage.UserSaver,
	subSaver storage.SubscriptionSaver,
	subProvider storage.SubscriptionProvider,
	logger *zap.Logger,
) *Handler {
	return &Handler{
		logger:      logger,
		authClient:  authClient,
		userSaver:   userSaver,
		subSaver:    subSaver,
		subProvider: subProvider,
	}
}

func (h *Handler) Echo(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello, world!"))
}

// TODO: make auth and storage saving in transaction
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

	// save user to auth service
	registerResp, err := h.authClient.Register(
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

	// save user to database
	_, err = h.userSaver.SaveUser(
		registerResp.Id,
		userCredentials.FullName,
		userCredentials.Surname,
		userCredentials.Email,
	)
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to save user to database", zap.Error(err))
		http.Error(w, "failed to save user to database", http.StatusInternalServerError)

		return
	}

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

	loginResp, err := h.authClient.Login(
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

func (h *Handler) CreateSubscription(w http.ResponseWriter, r *http.Request) {
	const handler = "http.Handler.CreateSubscription"

	var createSubRequest domain.CreateSubscriptionRequest

	if err := json.NewDecoder(r.Body).Decode(&createSubRequest); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to decode subscription", zap.Error(err))
		http.Error(w, "failed to decode subscription", http.StatusBadRequest)

		return
	}

	defer func() {
		if err := r.Body.Close(); err != nil {
			h.logger.
				With(zap.String("operation", handler)).
				Error("failed to close request body", zap.Error(err))
		}
	}()

	subId, err := h.subSaver.SaveSubscription(
		createSubRequest.Subscription.Caption,
		createSubRequest.Subscription.Link,
		createSubRequest.Subscription.Tag,
		createSubRequest.Subscription.Category,
		createSubRequest.Subscription.Cost,
		createSubRequest.Subscription.Currency,
		createSubRequest.Subscription.FirstPay,
		createSubRequest.Subscription.Interval,
		createSubRequest.Subscription.Comment,
		createSubRequest.Subscription.Color,
	)
	if err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to save subscription to database", zap.Error(err))
		http.Error(w, "failed to save subscription to database", http.StatusInternalServerError)

		return
	}

	if err := h.subSaver.AssignSubscriptionToUser(
		createSubRequest.UserID,
		subId,
	); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to assign subscription to user", zap.Error(err))
		http.Error(w, "failed to assign subscription to user", http.StatusInternalServerError)

		return
	}

	response := domain.SaveSubscriptionResponse{
		ID: subId,
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	if err := json.NewEncoder(w).Encode(response); err != nil {
		h.logger.
			With(zap.String("operation", handler)).
			Error("failed to encode response", zap.Error(err))
		http.Error(w, "failed to encode response", http.StatusInternalServerError)

		return
	}
}
