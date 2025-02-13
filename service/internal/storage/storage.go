package storage

type UserSaver interface {
	Save(
		fullName string,
		surname string,
		email string,
	) (string, error)
}

type UserProvider interface {
	// GetUserByEmail(email string)
}
