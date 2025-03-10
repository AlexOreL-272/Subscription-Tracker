package ctxerror

import "fmt"

type Error struct {
	source string
	err    error
}

func New(source string, err error) *Error {
	return &Error{
		source: source,
		err:    err,
	}
}

func (e *Error) Error() string {
	if e.err == nil {
		return e.source
	}

	return fmt.Sprintf("%s: %v", e.source, e.err)
}

func (e *Error) Unwrap() error {
	return e.err
}
