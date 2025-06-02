package redisstorage

import "time"

const (
	tokenTTL time.Duration = time.Hour * 3

	tokenLength int = 16
)
