package storage

import (
	"context"
	"errors"
	"time"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/domain"
)

type UserSaver interface {
	SaveUser(
		id string,
		fullName string,
		surname string,
		email string,
	) (string, error)

	DeleteUser(
		id string,
	) error
}

type SubscriptionSaver interface {
	SaveSubscription(
		id *string,

		caption string,
		comment *string,

		cost float64,
		currency string,
		firstPay time.Time,
		interval uint32,
		endDate *time.Time,

		category *string,
		color uint32,

		isActive bool,

		trialActive bool,
		trialInterval *uint32,
		trialCost *float64,
		trialEndDate *time.Time,

		supportLink *string,
	) (string, error)

	AssignSubscriptionToUser(
		userID string,
		subID string,
	) error
}

type SubscriptionEditor interface {
	EditSubscription(
		id string,

		caption *string,
		comment *string,

		cost *float64,
		currency *string,
		firstPay *time.Time,
		interval *uint32,
		endDate *time.Time,

		category *string,
		color *uint32,

		isActive *bool,

		trialActive *bool,
		trialInterval *uint32,
		trialCost *float64,
		trialEndDate *time.Time,

		supportLink *string,
	) error
}

type SubscriptionDeleter interface {
	DeleteSubscription(
		id string,
	) error
}

type GetSubscriptionResultType string

const (
	FullType  GetSubscriptionResultType = "full"
	ShortType GetSubscriptionResultType = "short"
)

var (
	ErrInvalidResultType = errors.New("invalid result type")
	ErrNotFound          = errors.New("not found")
)

type SubscriptionProvider interface {
	GetSubscriptions(
		id string,
		resultType GetSubscriptionResultType,
		category string,
		offset uint32,
		limit uint32,
	) ([]domain.Subscription, error)

	GetSubscriptionById(
		id string,
	) (*domain.Subscription, error)
}

type PasswordResetter interface {
	CreatePasswordResetTicket(
		ctx context.Context,
		email string,
	) (string, error)

	ValidatePasswordResetTicket(
		ctx context.Context,
		token string,
	) (string, error)

	ClosePasswordResetTicket(
		ctx context.Context,
		token string,
	) error
}
