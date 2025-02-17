package domain

import "time"

type UserCredentials struct {
	FullName string `json:"full_name"`
	Surname  string `json:"surname"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type Subscription struct {
	Id        string    `json:"id,omitempty" db:"id"`
	Caption   string    `json:"caption,omitempty" db:"caption"`
	Link      string    `json:"link,omitempty" db:"link"`
	Tag       string    `json:"tag,omitempty" db:"tag"`
	Category  string    `json:"category,omitempty" db:"category"`
	Cost      float64   `json:"cost,omitempty" db:"cost"`
	Currency  string    `json:"currency,omitempty" db:"currency"`
	FirstPay  time.Time `json:"first_pay,omitempty" db:"first_pay"`
	Interval  float64   `json:"interval,omitempty" db:"interval"`
	Comment   string    `json:"comment,omitempty" db:"comment"`
	Color     uint8     `json:"color,omitempty" db:"color"`
	CreatedAt time.Time `json:"created_at,omitempty" db:"created_at"`
}
