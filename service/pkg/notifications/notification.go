package notifications

type NotificationSender interface {
	Send(
		method NotificationMethod,
		to []string,
		body []byte,
		opts ParameterTable,
	) error
}
