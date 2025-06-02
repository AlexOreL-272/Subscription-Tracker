package notifications

import "errors"

type NotificationMethod string

const (
	Email NotificationMethod = "email"
)

var (
	ErrUnknownMethod = errors.New("unknown notification method")
)

type Parameter string

const (
	Subject     Parameter = "subject"
	ContentType Parameter = "contentType"
)

type ParameterTable map[Parameter]any
