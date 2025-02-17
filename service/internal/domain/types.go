package domain

import "time"

type UserCredentials struct {
	FullName string `json:"full_name"`
	Surname  string `json:"surname"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type Subscription struct {
	Id        string    `json:"id"`
	Caption   string    `json:"caption"`
	Link      string    `json:"link"`
	Tag       string    `json:"tag"`
	Category  string    `json:"category"`
	Cost      float64   `json:"cost"`
	Currency  string    `json:"currency"`
	FirstPay  time.Time `json:"first_pay"`
	Interval  float64   `json:"interval"`
	Comment   string    `json:"comment"`
	Color     uint8     `json:"color"`
	CreatedAt time.Time `json:"created_at"`
}
