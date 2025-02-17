package storage

import (
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
}

type SubscriptionSaver interface {
	SaveSubscription(
		caption string,
		link string,
		tag string,
		category string,
		cost float64,
		currency string,
		firstPay time.Time,
		interval float64,
		comment string,
		color uint8,
	) (string, error)
}

type SubscriptionProvider interface {
	GetSubscriptions(
		id string,
		resultType string,
		category string,
		offset uint32,
		limit uint32,
	) ([]domain.Subscription, error)

	GetSubscriptionById(
		id string,
	) (domain.Subscription, error)
}
