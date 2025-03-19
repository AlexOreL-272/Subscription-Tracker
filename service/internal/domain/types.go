package domain

import "time"

type UserCredentials struct {
	FullName string `json:"full_name"`
	Surname  string `json:"surname"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type EditableSubscription struct {
	Caption  string    `json:"caption,omitempty"`
	Link     string    `json:"link,omitempty"`
	Tag      string    `json:"tag,omitempty"`
	Category string    `json:"category,omitempty"`
	Cost     float64   `json:"cost,omitempty"`
	Currency string    `json:"currency,omitempty"`
	FirstPay time.Time `json:"first_pay,omitempty"`
	Interval time.Time `json:"interval,omitempty"`
	Comment  string    `json:"comment,omitempty"`
	Color    uint32    `json:"color,omitempty"`
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
	Interval  time.Time `json:"interval,omitempty" db:"interval"`
	Comment   string    `json:"comment,omitempty" db:"comment"`
	Color     uint32    `json:"color,omitempty" db:"color"`
	CreatedAt time.Time `json:"created_at,omitempty" db:"created_at"`
}
