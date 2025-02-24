package idprovider

import "errors"

var (
	ErrStateInvalid = errors.New("state is invalid")
	ErrCodeInvalid  = errors.New("code is invalid")
)
