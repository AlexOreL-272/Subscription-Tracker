-- Database schema on Figma
-- https://www.figma.com/design/cHjTNiuvX6GYrGH1HJUlGe/Diploma?node-id=14-2

CREATE SCHEMA IF NOT EXISTS "subscription_tracker";

CREATE TABLE IF NOT EXISTS "subscription_tracker"."users" (
    id VARCHAR(36) NOT NULL,
    surname VARCHAR(50),
    full_name VARCHAR(100),     -- name and middle name separated by space
    email VARCHAR(64),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS "subscription_tracker"."subscriptions" (
    id VARCHAR(36) NOT NULL,
    caption VARCHAR(50) NOT NULL,
    link TEXT,
    tag VARCHAR(30),
    category VARCHAR(30),
    cost REAL NOT NULL,
    currency VARCHAR(3) NOT NULL,
    first_pay TIMESTAMP NOT NULL,
    interval REAL NOT NULL,     -- in days
    comment TEXT,
    color INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS "subscription_tracker"."user_subscription" (
    user_id VARCHAR(36) NOT NULL,
    subs_id VARCHAR(36) NOT NULL,

    FOREIGN KEY (user_id) REFERENCES "subscription_tracker"."users"(id),
    FOREIGN KEY (subs_id) REFERENCES "subscription_tracker"."subscriptions"(id)
);