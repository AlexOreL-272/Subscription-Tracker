-- Database schema on Figma
-- https://www.figma.com/design/cHjTNiuvX6GYrGH1HJUlGe/Diploma?node-id=14-2

CREATE SCHEMA IF NOT EXISTS "subscription_tracker";

CREATE TABLE IF NOT EXISTS "subscription_tracker"."users" (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    surname VARCHAR(50),
    full_name VARCHAR(100),     -- name and middle name separated by space
    email VARCHAR(64),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS "subscription_tracker"."subscriptions" (
    id UUID NOT NULL DEFAULT gen_random_uuid(),

    caption VARCHAR(50) NOT NULL,
    comment VARCHAR(100),

    cost REAL NOT NULL,
    currency VARCHAR(3) NOT NULL,
    first_pay TIMESTAMP NOT NULL,
    interval INT NOT NULL,     -- in days;
    end_date TIMESTAMP,

    category VARCHAR(15),    
    color INT NOT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    trial_active BOOLEAN NOT NULL DEFAULT FALSE,
    trial_interval INT,
    trial_cost REAL,
    trial_end_date TIMESTAMP,

    support_link TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id)
);

CREATE FUNCTION updated_at_trigger_function() RETURNS trigger AS $$
BEGIN
    UPDATE "subscription_tracker"."subscriptions"
    SET updated_at = CURRENT_TIMESTAMP
    WHERE id = NEW.id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_subscriptions
AFTER UPDATE ON "subscription_tracker"."subscriptions"
FOR EACH ROW
EXECUTE FUNCTION updated_at_trigger_function();

CREATE TABLE IF NOT EXISTS "subscription_tracker"."user_subscription" (
    user_id UUID NOT NULL DEFAULT gen_random_uuid(),
    subs_id UUID NOT NULL DEFAULT gen_random_uuid(),

    FOREIGN KEY (user_id) REFERENCES "subscription_tracker"."users"(id),
    FOREIGN KEY (subs_id) REFERENCES "subscription_tracker"."subscriptions"(id)
);

CREATE TABLE IF NOT EXISTS "subscription_tracker"."email_verifications" (
    email VARCHAR(64) NOT NULL,
    token VARCHAR(16) NOT NULL,

    PRIMARY KEY (email)
);