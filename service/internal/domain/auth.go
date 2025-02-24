package domain

type User struct {
	PsuId    string `json:"psuid"`
	FullName string `json:"full_name"`
	LstName  string `json:"last_name"`
	Email    string `json:"default_email"`
}
