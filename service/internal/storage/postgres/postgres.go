package pgstorage

import (
	"fmt"
	"time"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/domain"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/storage"
	"github.com/Masterminds/squirrel"
	"github.com/google/uuid"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

const (
	userTableName    = "subscription_tracker.users"
	subTableName     = "subscription_tracker.subscriptions"
	userSubTableName = "subscription_tracker.user_subscription"
)

type PostgresStorage struct {
	db *sqlx.DB
}

func New(connString string) (*PostgresStorage, error) {
	const op = "pgstorage.New"

	db, err := sqlx.Connect("postgres", connString)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
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

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	saveUserRequest := psql.Insert(userTableName).Columns(
		"id",
		"full_name",
		"surname",
		"email",
	).Values(
		id,
		fullName,
		surname,
		email,
	)

	sqlSaveUserRequest, args, err := saveUserRequest.ToSql()
	if err != nil {
		return "", fmt.Errorf("%s: %w", op, err)
	}

	if _, err := p.db.Exec(sqlSaveUserRequest, args...); err != nil {
		return "", fmt.Errorf("%s: %w", op, err)
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
	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	saveSubscriptionRequest := psql.Insert(subTableName).Columns(
		"id",
		"caption",
		"link",
		"tag",
		"category",
		"cost",
		"currency",
		"first_pay",
		"interval",
		"comment",
		"color",
	).Values(
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

	sqlSaveSubscriptionRequest, args, err := saveSubscriptionRequest.ToSql()
	if err != nil {
		return "", fmt.Errorf("%s: %w", op, err)
	}

	if _, err := p.db.Exec(sqlSaveSubscriptionRequest, args...); err != nil {
		return "", fmt.Errorf("%s: %w", op, err)
	}

	return subID, nil
}

func (p *PostgresStorage) AssignSubscriptionToUser(
	userID string,
	subID string,
) error {
	const op = "pgstorage.PostgresStorage.AssignSubscriptionToUser"

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	assignSubscriptionToUserRequest := psql.Insert(userSubTableName).Columns(
		"user_id",
		"subs_id",
	).Values(
		userID,
		subID,
	)

	sqlAssignSubscriptionToUserRequest, args, err := assignSubscriptionToUserRequest.ToSql()
	if err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	if _, err := p.db.Exec(sqlAssignSubscriptionToUserRequest, args...); err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}

func (p *PostgresStorage) GetSubscriptions(
	id string,
	resultType storage.GetSubscriptionResultType,
	offset uint32,
	limit uint32,
) ([]domain.Subscription, error) {
	const op = "pgstorage.PostgresStorage.GetSubscriptions"

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	var getSubscriptionsRequest squirrel.SelectBuilder

	switch resultType {
	case storage.FullType:
		getSubscriptionsRequest = psql.Select(
			"subs.id",
			"subs.caption",
			"subs.link",
			"subs.tag",
			"subs.category",
			"subs.cost",
			"subs.currency",
			"subs.first_pay",
			"subs.interval",
			"subs.comment",
			"subs.color",
			"subs.created_at",
		).
			From(fmt.Sprintf("%s subs", subTableName)).
			LeftJoin(fmt.Sprintf("%s user_subs ON %s", userSubTableName, "subs.id = user_subs.subs_id")).
			Where(squirrel.Eq{"user_subs.user_id": id}).
			OrderBy("subs.created_at DESC")

	case storage.ShortType:
		// request = fmt.Sprintf(getShortSubscriptionsByUserIDRequest, userSubTableName)
		getSubscriptionsRequest = psql.Select(
			"subs_id AS id",
		).
			From(userSubTableName).
			Where(squirrel.Eq{"user_id": id})

	default:
		return nil, storage.ErrInvalidResultType
	}

	if limit != 0 {
		getSubscriptionsRequest = getSubscriptionsRequest.Limit(uint64(limit))
	}

	if offset != 0 {
		getSubscriptionsRequest = getSubscriptionsRequest.Offset(uint64(offset))
	}

	sqlGetSubscriptionsRequest, args, err := getSubscriptionsRequest.ToSql()
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}

	var subscriptions []domain.Subscription

	if err := p.db.Select(&subscriptions, sqlGetSubscriptionsRequest, args...); err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}

	return subscriptions, nil
}

func (p *PostgresStorage) GetSubscriptionById(
	id string,
) (domain.Subscription, error) {
	const op = "pgstorage.PostgresStorage.GetSubscriptionById"

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	getSubscriptionByIDRequest := psql.Select(
		"id",
		"caption",
		"link",
		"tag",
		"category",
		"cost",
		"currency",
		"first_pay",
		"interval",
		"comment",
		"color",
		"created_at",
	).
		From(subTableName).
		Where(squirrel.Eq{"id": id})

	sqlGetSubscriptionByIDRequest, args, err := getSubscriptionByIDRequest.ToSql()
	if err != nil {
		return domain.Subscription{}, fmt.Errorf("%s: %w", op, err)
	}

	var subscription []domain.Subscription

	if err := p.db.Select(&subscription, sqlGetSubscriptionByIDRequest, args...); err != nil {
		return domain.Subscription{}, fmt.Errorf("%s: %w", op, err)
	}

	if len(subscription) == 0 {
		return domain.Subscription{}, storage.ErrNotFound
	}

	return subscription[0], nil
}

func (p *PostgresStorage) EditSubscription(
	id string,
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
) error {
	const op = "pgstorage.PostgresStorage.EditSubscription"

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	updateSubscriptionRequest := psql.Update(subTableName).Where(squirrel.Eq{"id": id})

	if caption != "" {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("caption", caption)
	}

	if link != "" {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("link", link)
	}

	if tag != "" {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("tag", tag)
	}

	if category != "" {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("category", category)
	}

	if cost != 0 {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("cost", cost)
	}

	if currency != "" {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("currency", currency)
	}

	if !firstPay.IsZero() {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("first_pay", firstPay)
	}

	if interval != 0 {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("interval", interval)
	}

	if comment != "" {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("comment", comment)
	}

	if color != 0 {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("color", color)
	}

	// TODO: make trigger on update
	updateSubscriptionRequest = updateSubscriptionRequest.Set("updated_at", time.Now())

	sqlUpdateSubscriptionRequest, args, err := updateSubscriptionRequest.ToSql()
	if err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	if _, err := p.db.Exec(sqlUpdateSubscriptionRequest, args...); err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}
