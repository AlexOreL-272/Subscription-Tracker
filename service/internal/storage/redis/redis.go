package redisstorage

import (
	"context"
	"time"

	ctxerror "github.com/AlexOreL-272/Subscription-Tracker/pkg/context_error"
	tokengen "github.com/AlexOreL-272/Subscription-Tracker/pkg/token_generator"
	"github.com/go-redis/redis/v8"
)

type RedisStorage struct {
	client *redis.Client
}

func New(address string) (*RedisStorage, error) {
	const op = "redisstorage.New"

	client := redis.NewClient(&redis.Options{
		Addr: address,
	})

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	if err := client.Ping(ctx).Err(); err != nil {
		return nil, ctxerror.New(op, err)
	}

	return &RedisStorage{
		client: client,
	}, nil
}

func (r *RedisStorage) CreatePasswordResetTicket(
	ctx context.Context,
	email string,
) (string, error) {
	const op = "redisstorage.RedisStorage.CreatePasswordResetTicket"

	token, err := tokengen.GenerateURLSafeToken(tokenLength)
	if err != nil {
		return "", ctxerror.New(op, err)
	}

	if err := r.client.Set(ctx, token, email, tokenTTL).Err(); err != nil {
		return "", ctxerror.New(op, err)
	}

	return token, nil
}

func (r *RedisStorage) ValidatePasswordResetTicket(
	ctx context.Context,
	token string,
) (string, error) {
	const op = "redisstorage.RedisStorage.ValidatePasswordResetTicket"

	email, err := r.client.Get(ctx, token).Result()
	if err != nil {
		return "", ctxerror.New(op, err)
	}

	return email, nil
}

func (r *RedisStorage) ClosePasswordResetTicket(
	ctx context.Context,
	token string,
) error {
	const op = "redisstorage.RedisStorage.ClosePasswordResetTicket"

	if err := r.client.Del(ctx, token).Err(); err != nil {
		return ctxerror.New(op, err)
	}

	return nil
}
