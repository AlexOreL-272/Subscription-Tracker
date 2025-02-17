package pgstorage

import (
	"fmt"
	"time"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/domain"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/storage"
	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

const (
	userTableName    = "subscription_tracker.users"
	subTableName     = "subscription_tracker.subscriptions"
	userSubTableName = "subscription_tracker.user_subscription"

	saveUserRequest = `
		INSERT INTO %s (id, full_name, surname, email)
		VALUES ($1, $2, $3, $4)
		RETURNING id;
	`

	getFullSubscriptionsByUserIDRequest = `
		SELECT subs.id, subs.caption, subs.link, subs.tag, subs.category, subs.cost, subs.currency, subs.first_pay, subs.interval, subs.comment, subs.color, subs.created_at
		FROM %s subs
		LEFT JOIN %s user_subs ON subs.id = user_subs.subs_id
		WHERE user_subs.user_id = $1
		ORDER BY subs.created_at DESC
		LIMIT $2
		OFFSET $3;
	`

	getShortSubscriptionsByUserIDRequest = `
		SELECT subs_id AS id
		FROM %s
		WHERE user_id = $1
		LIMIT $2
		OFFSET $3;
	`

	saveSubscriptionRequest = `
		INSERT INTO %s (id, caption, link, tag, category, cost, currency, first_pay, interval, comment, color)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
	`

	assignSubscriptionToUserRequest = `
		INSERT INTO %s (user_id, subs_id)
		VALUES ($1, $2);
	`
)

type PostgresStorage struct {
	db *sqlx.DB
}

func New(connString string) (*PostgresStorage, error) {
	const op = "pgstorage.New"

	db, err := sqlx.Connect("postgres", connString)
	if err != nil {
		return nil, fmt.Errorf("%s:%w", op, err)
	}

	return &PostgresStorage{
		db: db,
	}, nil
}

func (p *PostgresStorage) SaveUser(
	id string,
	fullName string,
	surname string,
	email string,
) (string, error) {
	const op = "pgstorage.PostgresStorage.SaveUser"

	var userID string
	request := fmt.Sprintf(saveUserRequest, userTableName)

	if err := p.db.QueryRow(
		request,
		id,
		fullName,
		surname,
		email,
	).Scan(&userID); err != nil {
		return "", fmt.Errorf("%s:%w", op, err)
	}

	return userID, nil
}

func (p *PostgresStorage) SaveSubscription(
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
) (string, error) {
	const op = "pgstorage.PostgresStorage.SaveSubscription"

	subID := uuid.New().String()
	request := fmt.Sprintf(saveSubscriptionRequest, subTableName)

	_, err := p.db.Exec(
		request,
		subID,
		caption,
		link,
		tag,
		category,
		cost,
		currency,
		firstPay,
		interval,
		comment,
		color,
	)
	if err != nil {
		return "", fmt.Errorf("%s:%w", op, err)
	}

	return subID, nil
}

func (p *PostgresStorage) AssignSubscriptionToUser(
	userID string,
	subID string,
) error {
	const op = "pgstorage.PostgresStorage.AssignSubscriptionToUser"

	request := fmt.Sprintf(assignSubscriptionToUserRequest, userSubTableName)

	if _, err := p.db.Exec(
		request,
		userID,
		subID,
	); err != nil {
		return fmt.Errorf("%s:%w", op, err)
	}

	return nil
}

func (p *PostgresStorage) GetSubscriptions(
	id string,
	resultType storage.GetSubscriptionResultType,
	category string,
	offset uint32,
	limit uint32,
) ([]domain.Subscription, error) {
	const op = "pgstorage.PostgresStorage.GetSubscriptions"

	var request string

	switch resultType {
	case storage.FullType:
		request = fmt.Sprintf(getFullSubscriptionsByUserIDRequest, subTableName, userSubTableName)
	case storage.ShortType:
		request = fmt.Sprintf(getShortSubscriptionsByUserIDRequest, userSubTableName)
	default:
		return nil, fmt.Errorf("%s:%w", op, storage.ErrInvalidResultType)
	}

	var subscriptions []domain.Subscription

	if err := p.db.Select(&subscriptions, request, id, limit, offset); err != nil {
		return nil, fmt.Errorf("%s:%w", op, err)
	}

	return subscriptions, nil
}

func (p *PostgresStorage) GetSubscriptionById(
	id string,
) (domain.Subscription, error) {
	return domain.Subscription{}, nil
}
