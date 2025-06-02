package domain

import "time"

type UserCredentials struct {
	FullName string `json:"full_name"`
	Surname  string `json:"surname"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

type User struct {
	Id string `json:"id" db:"id"`

	FullName string `json:"full_name" db:"full_name"`
	Surname  string `json:"surname" db:"surname"`
	Email    string `json:"email" db:"email"`
}

type EditableSubscription struct {
	Caption *string `json:"caption,omitempty"`
	Comment *string `json:"comment,omitempty"`

	Cost     *float64   `json:"cost,omitempty"`
	Currency *string    `json:"currency,omitempty"`
	FirstPay *time.Time `json:"first_pay,omitempty"`
	Interval *uint32    `json:"interval,omitempty"`
	EndDate  *time.Time `json:"end_date,omitempty"`

	Category *string `json:"category,omitempty"`
	Color    *uint32 `json:"color,omitempty"`

	IsActive *bool `json:"is_active,omitempty"`

	TrialActive   *bool      `json:"trial_active,omitempty"`
	TrialInterval *uint32    `json:"trial_interval,omitempty"`
	TrialCost     *float64   `json:"trial_cost,omitempty"`
	TrialEndDate  *time.Time `json:"trial_end_date,omitempty"`

	SupportLink *string `json:"support_link,omitempty"`
}

type Subscription struct {
	Id *string `json:"id,omitempty" db:"id"`

	Caption string  `json:"caption,omitempty" db:"caption"`
	Comment *string `json:"comment,omitempty" db:"comment"`

	Cost     float64    `json:"cost,omitempty" db:"cost"`
	Currency string     `json:"currency,omitempty" db:"currency"`
	FirstPay time.Time  `json:"first_pay,omitempty" db:"first_pay"`
	Interval uint32     `json:"interval,omitempty" db:"interval"`
	EndDate  *time.Time `json:"end_date,omitempty" db:"end_date"`

	Category *string `json:"category,omitempty" db:"category"`
	Color    uint32  `json:"color,omitempty" db:"color"`

	IsActive bool `json:"is_active,omitempty" db:"is_active"`

	TrialActive   bool       `json:"trial_active,omitempty" db:"trial_active"`
	TrialInterval *uint32    `json:"trial_interval,omitempty" db:"trial_interval"`
	TrialCost     *float64   `json:"trial_cost,omitempty" db:"trial_cost"`
	TrialEndDate  *time.Time `json:"trial_end_date,omitempty" db:"trial_end_date"`

	SupportLink *string `json:"support_link,omitempty" db:"support_link"`
}
