-- =====================================================================
-- Personal Subscription Tracker — Database Schema
-- Group 5 | Bachelor of Information Technology — Studio 1
-- Based on the ERD in Section 8 of the project proposal
-- Entities: USER, SUBSCRIPTION, PAYMENT, USAGE_LOG, RECOMMENDATION
-- =====================================================================

-- Drop tables if re-running this script
DROP TABLE IF EXISTS recommendation;
DROP TABLE IF EXISTS usage_log;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS subscription;
DROP TABLE IF EXISTS "user";

-- =====================================================================
-- USER
-- One record per person using the app.
-- =====================================================================
CREATE TABLE "user" (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    name                VARCHAR(100)  NOT NULL,
    email               VARCHAR(150)  NOT NULL UNIQUE,
    notification_pref   VARCHAR(50)   DEFAULT 'email'
);

-- =====================================================================
-- SUBSCRIPTION
-- Each recurring subscription a user has registered.
-- =====================================================================
CREATE TABLE subscription (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         INTEGER       NOT NULL,
    name            VARCHAR(100)  NOT NULL,
    category        VARCHAR(50)   NOT NULL,   -- e.g. streaming, software, gym, subscription box
    provider        VARCHAR(100),             -- company/merchant billing the subscription
    cost            DECIMAL(10,2) NOT NULL,
    billing_cycle   VARCHAR(20)   NOT NULL CHECK (billing_cycle IN ('weekly', 'monthly', 'yearly')),
    renewal_date    DATE          NOT NULL,

    CONSTRAINT fk_subscription_user
        FOREIGN KEY (user_id) REFERENCES "user"(id)
        ON DELETE CASCADE
);

-- =====================================================================
-- PAYMENT
-- A record of each amount actually paid for a subscription.
-- =====================================================================
CREATE TABLE payment (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    subscription_id   INTEGER       NOT NULL,
    amount            DECIMAL(10,2) NOT NULL,
    paid_on           DATE          NOT NULL,

    CONSTRAINT fk_payment_subscription
        FOREIGN KEY (subscription_id) REFERENCES subscription(id)
        ON DELETE CASCADE
);

-- =====================================================================
-- USAGE_LOG
-- Timestamped record of each time a subscription is actually used,
-- feeding the usage-versus-cost engine.
-- =====================================================================
CREATE TABLE usage_log (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    subscription_id   INTEGER   NOT NULL,
    used_on           DATETIME  NOT NULL,

    CONSTRAINT fk_usagelog_subscription
        FOREIGN KEY (subscription_id) REFERENCES subscription(id)
        ON DELETE CASCADE
);

-- =====================================================================
-- RECOMMENDATION
-- A cancel / downgrade / pause suggestion generated for a subscription,
-- plus whether the user accepted or dismissed it.
-- =====================================================================
CREATE TABLE recommendation (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    subscription_id   INTEGER      NOT NULL,
    type              VARCHAR(20)  NOT NULL CHECK (type IN ('cancel', 'downgrade', 'pause')),
    status            VARCHAR(20)  NOT NULL DEFAULT 'pending'
                       CHECK (status IN ('pending', 'accepted', 'dismissed')),

    CONSTRAINT fk_recommendation_subscription
        FOREIGN KEY (subscription_id) REFERENCES subscription(id)
        ON DELETE CASCADE
);

-- =====================================================================
-- Helpful indexes for common lookups (dashboard queries, FK joins)
-- =====================================================================
CREATE INDEX idx_subscription_user_id       ON subscription(user_id);
CREATE INDEX idx_payment_subscription_id    ON payment(subscription_id);
CREATE INDEX idx_usagelog_subscription_id   ON usage_log(subscription_id);
CREATE INDEX idx_recommendation_sub_id      ON recommendation(subscription_id);

-- =====================================================================
-- Sample seed data (optional)
-- =====================================================================
INSERT INTO "user" (name, email, notification_pref) VALUES
    ('Priyom Roy Sammo', 'priyom@example.com', 'email'),
    ('Jaskaran Singh', 'jaskaran@example.com', 'push');

INSERT INTO subscription (user_id, name, category, provider, cost, billing_cycle, renewal_date) VALUES
    (1, 'Netflix', 'streaming', 'Netflix Inc.', 22.99, 'monthly', '2026-09-01'),
    (1, 'Anytime Fitness', 'gym', 'Anytime Fitness', 34.99, 'weekly', '2026-08-24'),
    (2, 'iCloud+', 'cloud storage', 'Apple', 4.49, 'monthly', '2026-09-05');

INSERT INTO payment (subscription_id, amount, paid_on) VALUES
    (1, 22.99, '2026-08-01'),
    (2, 34.99, '2026-08-17'),
    (3, 4.49, '2026-08-05');

INSERT INTO usage_log (subscription_id, used_on) VALUES
    (1, '2026-08-15 20:30:00'),
    (2, '2026-08-10 07:00:00');

INSERT INTO recommendation (subscription_id, type, status) VALUES
    (1, 'downgrade', 'pending');
