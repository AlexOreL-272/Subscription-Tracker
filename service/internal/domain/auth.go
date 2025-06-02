package domain

type YandexUser struct {
	PsuId     string `json:"psuid"`
	FullName  string `json:"real_name"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
	Email     string `json:"default_email"`
}

type UserInfo struct {
	Id         string `json:"sub"`         // Unique identifier
	Name       string `json:"name"`        // Full name
	GivenName  string `json:"given_name"`  // First name
	FamilyName string `json:"family_name"` // Last name
	Email      string `json:"email"`       // Email address
}
