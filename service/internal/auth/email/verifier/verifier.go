package emailverifier

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"github.com/AlexOreL-272/Subscription-Tracker/internal/auth"
	"github.com/Masterminds/squirrel"
	"github.com/jmoiron/sqlx"
	"github.com/thanhpk/randstr"
)

type Verifier interface {
	CreateVerificationTicket(email string) (string, error)
	Verify(token string) error
}

type EmailVerifier struct {
	db *sqlx.DB

	verifier auth.EmailVerifier
}

const (
	verificationTicketTableName string = "subscription_tracker.email_verifications"

	tokenSize int = 16
)

var (
	ErrNotFound = fmt.Errorf("email verification ticket not found")
)

func New(
	connString string,
	verifier auth.EmailVerifier,
) (*EmailVerifier, error) {
	const op = "emailverifier.New"

	db, err := sqlx.Connect("postgres", connString)
	if err != nil {
		return nil, fmt.Errorf("%s: %w", op, err)
	}

	return &EmailVerifier{
		db:       db,
		verifier: verifier,
	}, nil
}

func (v *EmailVerifier) CreateVerificationTicket(
	email string,
) (string, error) {
	const op = "emailverifier.EmailVerifier.CreateVerificationTicket"

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	// Generate token
	token := generateToken()

	// Build request
	createVerificationTicketRequest := psql.Insert(verificationTicketTableName).Columns(
		"email",
		"token",
	).Values(
		email,
		token,
	)

	sqlCreateTicketRequest, args, err := createVerificationTicketRequest.ToSql()
	if err != nil {
		return "", fmt.Errorf("%s: %w", op, err)
	}

	if _, err := v.db.Exec(sqlCreateTicketRequest, args...); err != nil {
		return "", fmt.Errorf("%s: %w", op, err)
	}

	return token, nil
}

func generateToken() string {
	return randstr.String(tokenSize)
}

func (v *EmailVerifier) Verify(token string) error {
	const op = "emailverifier.EmailVerifier.Verify"

	psql := squirrel.StatementBuilder.PlaceholderFormat(squirrel.Dollar)

	// Build request
	verifyRequest := psql.Select("email").
		From("deleted").
		Prefix(fmt.Sprintf(`
			WITH deleted AS (
				DELETE FROM %s
				WHERE token = '%s'
				RETURNING email
			)
		`, verificationTicketTableName, token))

	// Update verification ticket
	sqlVerifyRequest, args, err := verifyRequest.ToSql()
	if err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	var verifiedEmail string

	if err := v.db.QueryRow(sqlVerifyRequest, args...).Scan(&verifiedEmail); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return ErrNotFound
		}

		return fmt.Errorf("%s: %w", op, err)
	}

	if err := v.verifier.SetVerifiedEmail(context.Background(), verifiedEmail); err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}
