package emailsender

type EmailMessage struct {
	From        string
	To          []string
	Subject     string
	ContentType string
	Body        []byte
}
