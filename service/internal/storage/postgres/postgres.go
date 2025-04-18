package pgstorage

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"time"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/domain"
	"github.com/AlexOreL-272/Subscription-Tracker/internal/storage"
	ctxerror "github.com/AlexOreL-272/Subscription-Tracker/pkg/context_error"
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
		return nil, ctxerror.New(op, err)
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

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	// Build request
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
	).Suffix("ON CONFLICT (id) DO NOTHING")

	// Insert user into database
	sqlSaveUserRequest, args, err := saveUserRequest.ToSql()
	if err != nil {
		return "", ctxerror.New(op, err)
	}

	if _, err := p.db.Exec(sqlSaveUserRequest, args...); err != nil {
		return "", ctxerror.New(op, err)
	}

	return id, nil
}

func (p *PostgresStorage) DeleteUser(
	id string,
) error {
	const op = "pgstorage.PostgresStorage.DeleteUser"

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	// Build delete requests
	deleteUserSubscriptionRequest := psql.Delete(userSubTableName).Where(squirrel.Eq{"user_id": id})
	deleteSubscriptionRequest := psql.Delete(subTableName).Where(squirrel.Eq{"id": id})
	deleteUserRequest := psql.Delete(userTableName).Where(squirrel.Eq{"id": id})

	ctx := context.Background()

	// Begin transaction
	tx, err := p.db.BeginTx(ctx, nil)
	if err != nil {
		return ctxerror.New(op, err)
	}

	// Defer rollback in case anything fails
	defer tx.Rollback()

	// Delete user subscription
	sqlDeleteUserSubscriptionRequest, args, err := deleteUserSubscriptionRequest.ToSql()
	if err != nil {
		return ctxerror.New(op, err)
	}

	if _, err := tx.Exec(sqlDeleteUserSubscriptionRequest, args...); err != nil {
		return ctxerror.New(op, err)
	}

	// Delete subscription
	sqlDeleteSubscriptionRequest, args, err := deleteSubscriptionRequest.ToSql()
	if err != nil {
		return ctxerror.New(op, err)
	}

	if _, err := tx.Exec(sqlDeleteSubscriptionRequest, args...); err != nil {
		return ctxerror.New(op, err)
	}

	// Delete user
	sqlDeleteUserRequest, args, err := deleteUserRequest.ToSql()
	if err != nil {
		return ctxerror.New(op, err)
	}

	if _, err := tx.Exec(sqlDeleteUserRequest, args...); err != nil {
		return ctxerror.New(op, err)
	}

	// Commit transaction
	if err := tx.Commit(); err != nil {
		return ctxerror.New(op, err)
	}

	return nil
}

func (p *PostgresStorage) SaveSubscription(
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
) (string, error) {
	const op = "pgstorage.PostgresStorage.SaveSubscription"

	var subID string

	if id != nil {
		subID = *id
	} else {
		// Generate subscription ID
		subID = uuid.New().String()
	}

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	// Build request
	saveSubscriptionRequest := psql.Insert(subTableName).Columns(
		"id",

		"caption", // caption
		"comment", // comment

		"cost",      // cost
		"currency",  // currency
		"first_pay", // first pay date
		"interval",  // interval
		"end_date",  // end date

		"category", // category
		"color",    // color

		"is_active", // is active

		"trial_active",   // trial active
		"trial_interval", // trial interval
		"trial_cost",     // trial cost
		"trial_end_date", // trial end date

		"support_link", // support link
	).Values(
		subID,

		caption,
		comment,

		cost,
		currency,
		firstPay,
		interval,
		endDate,

		category,
		color,

		isActive,

		trialActive,
		trialInterval,
		trialCost,
		trialEndDate,

		supportLink,
	)

	// Insert subscription into database
	sqlSaveSubscriptionRequest, args, err := saveSubscriptionRequest.ToSql()
	if err != nil {
		return "", ctxerror.New(op, err)
	}

	if _, err := p.db.Exec(sqlSaveSubscriptionRequest, args...); err != nil {
		return "", ctxerror.New(op, err)
	}

	return subID, nil
}

func (p *PostgresStorage) AssignSubscriptionToUser(
	userID string,
	subID string,
) error {
	const op = "pgstorage.PostgresStorage.AssignSubscriptionToUser"

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	// Build request
	assignSubscriptionToUserRequest := psql.Insert(userSubTableName).Columns(
		"user_id",
		"subs_id",
	).Values(
		userID,
		subID,
	)

	// Assign subscription to user
	sqlAssignSubscriptionToUserRequest, args, err := assignSubscriptionToUserRequest.ToSql()
	if err != nil {
		return ctxerror.New(op, err)
	}

	if _, err := p.db.Exec(sqlAssignSubscriptionToUserRequest, args...); err != nil {
		return ctxerror.New(op, err)
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

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	// Build request baseline
	var getSubscriptionsRequest squirrel.SelectBuilder

	switch resultType {
	case storage.FullType:
		// Build request in case of full result type
		getSubscriptionsRequest = psql.Select(
			"subs.id",

			"subs.caption", // caption
			"subs.comment", // comment

			"subs.cost",      // cost
			"subs.currency",  // currency
			"subs.first_pay", // first pay date
			"subs.interval",  // interval
			"subs.end_date",  // end date

			"subs.category", // category
			"subs.color",    // color

			"subs.is_active", // is active

			"subs.trial_active",   // trial active
			"subs.trial_interval", // trial interval
			"subs.trial_cost",     // trial cost
			"subs.trial_end_date", // trial end date

			"subs.support_link", // support link
		).
			From(fmt.Sprintf("%s subs", subTableName)).
			LeftJoin(fmt.Sprintf("%s user_subs ON %s", userSubTableName, "subs.id = user_subs.subs_id")).
			Where(squirrel.Eq{"user_subs.user_id": id}).
			OrderBy("subs.created_at DESC")

		// Add category filter if present
		if category != "" {
			getSubscriptionsRequest = getSubscriptionsRequest.Where(squirrel.Eq{"subs.category": category})
		}

	case storage.ShortType:
		// Build request in case of short result type
		getSubscriptionsRequest = psql.Select(
			"subs_id AS id",
		).
			From(userSubTableName).
			Where(squirrel.Eq{"user_id": id})

		// Add category filter if present
		if category != "" {
			getSubscriptionsRequest = getSubscriptionsRequest.Where(squirrel.Eq{"category": category})
		}

	default:
		return nil, storage.ErrInvalidResultType
	}

	// Add limit if present
	if limit != 0 {
		getSubscriptionsRequest = getSubscriptionsRequest.Limit(uint64(limit))
	}

	// Add offset if present
	if offset != 0 {
		getSubscriptionsRequest = getSubscriptionsRequest.Offset(uint64(offset))
	}

	// Select subscriptions
	sqlGetSubscriptionsRequest, args, err := getSubscriptionsRequest.ToSql()
	if err != nil {
		return nil, ctxerror.New(op, err)
	}

	var subscriptions []domain.Subscription

	if err := p.db.Select(&subscriptions, sqlGetSubscriptionsRequest, args...); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ctxerror.New(op, storage.ErrNotFound)
		}

		return nil, ctxerror.New(op, err)
	}

	if len(subscriptions) == 0 {
		return nil, ctxerror.New(op, storage.ErrNotFound)
	}

	return subscriptions, nil
}

func (p *PostgresStorage) GetSubscriptionById(
	id string,
) (*domain.Subscription, error) {
	const op = "pgstorage.PostgresStorage.GetSubscriptionById"

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	// Build request
	getSubscriptionByIDRequest := psql.Select(
		"id",

		"caption", // caption
		"comment", // comment

		"cost",      // cost
		"currency",  // currency
		"first_pay", // first pay date
		"interval",  // interval
		"end_date",  // end date

		"category", // category
		"color",    // color

		"is_active", // is active

		"trial_active",   // trial active
		"trial_interval", // trial interval
		"trial_cost",     // trial cost
		"trial_end_date", // trial end date

		"support_link", // support link
	).
		From(subTableName).
		Where(squirrel.Eq{"id": id})

	// Select subscription by ID
	sqlGetSubscriptionByIDRequest, args, err := getSubscriptionByIDRequest.ToSql()
	if err != nil {
		return nil, ctxerror.New(op, err)
	}

	var subscription []domain.Subscription

	if err := p.db.Select(&subscription, sqlGetSubscriptionByIDRequest, args...); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ctxerror.New(op, storage.ErrNotFound)
		}

		return nil, ctxerror.New(op, err)
	}

	// If subscription is not found
	if len(subscription) == 0 {
		return nil, ctxerror.New(op, storage.ErrNotFound)
	}

	return &subscription[0], nil
}

func (p *PostgresStorage) EditSubscription(
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
) error {
	const op = "pgstorage.PostgresStorage.EditSubscription"

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	// Build update request
	updateSubscriptionRequest := psql.Update(subTableName).Where(squirrel.Eq{"id": id})

	// Add fields to update
	if caption != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("caption", caption)
	}

	if comment != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("comment", comment)
	}

	if cost != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("cost", *cost)
	}

	if currency != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("currency", *currency)
	}

	if firstPay != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("first_pay", *firstPay)
	}

	if interval != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("interval", *interval)
	}

	if endDate != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("end_date", *endDate)
	}

	if category != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("category", *category)
	}

	if color != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("color", *color)
	}

	if isActive != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("is_active", *isActive)
	}

	if trialActive != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("trial_active", *trialActive)
	}

	if trialInterval != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("trial_interval", *trialInterval)
	}

	if trialCost != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("trial_cost", *trialCost)
	}

	if trialEndDate != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("trial_end_date", *trialEndDate)
	}

	if supportLink != nil {
		updateSubscriptionRequest = updateSubscriptionRequest.Set("support_link", *supportLink)
	}

	// Update subscription
	sqlUpdateSubscriptionRequest, args, err := updateSubscriptionRequest.ToSql()
	if err != nil {
		return ctxerror.New(op, err)
	}

	if _, err := p.db.Exec(sqlUpdateSubscriptionRequest, args...); err != nil {
		return ctxerror.New(op, err)
	}

	return nil
}

func (p *PostgresStorage) DeleteSubscription(
	id string,
) error {
	op := "pgstorage.PostgresStorage.DeleteSubscription"

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	// Build delete requests
	deleteUserSubscriptionRequest := psql.Delete(userSubTableName).Where(squirrel.Eq{"subs_id": id})
	deleteSubscriptionRequest := psql.Delete(subTableName).Where(squirrel.Eq{"id": id})

	ctx := context.Background()

	// Begin transaction
	tx, err := p.db.BeginTx(ctx, nil)
	if err != nil {
		return ctxerror.New(op, err)
	}

	// Defer rollback in case anything fails
	defer tx.Rollback()

	// Delete user subscription
	sqlDeleteUserSubscriptionRequest, args, err := deleteUserSubscriptionRequest.ToSql()
	if err != nil {
		return ctxerror.New(op, err)
	}

	if _, err := tx.Exec(sqlDeleteUserSubscriptionRequest, args...); err != nil {
		return ctxerror.New(op, err)
	}

	// Delete subscription
	sqlDeleteSubscriptionRequest, args, err := deleteSubscriptionRequest.ToSql()
	if err != nil {
		return ctxerror.New(op, err)
	}

	if _, err := tx.Exec(sqlDeleteSubscriptionRequest, args...); err != nil {
		return ctxerror.New(op, err)
	}

	// Commit transaction
	if err := tx.Commit(); err != nil {
		return ctxerror.New(op, err)
	}

	return nil
}
