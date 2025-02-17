package pgstorage

import (
	"fmt"
	"time"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/domain"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

const (
	userTableName = "subscription_tracker.users"
	subTableName  = "subscription_tracker.subscriptions"

	saveUserRequest = `
		INSERT INTO %s (id, full_name, surname, email)
		VALUES ($1, $2, $3, $4)
		RETURNING id;
	`
)

type PostgresStorage struct {
	db *sqlx.DB
}

func New(connString string) (*PostgresStorage, error) {
	db, err := sqlx.Connect("postgres", connString)
	if err != nil {
		return nil, err
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
	return "", nil
}

func (p *PostgresStorage) GetSubscriptions(
	id string,
	resultType string,
	category string,
	offset uint32,
	limit uint32,
) ([]domain.Subscription, error) {
	return nil, nil
}

func (p *PostgresStorage) GetSubscriptionById(
	id string,
) (domain.Subscription, error) {
	return domain.Subscription{}, nil
}
