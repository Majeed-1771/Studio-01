-- Personal Subscription Tracker
-- Database Design based on Group 5 Project Proposal
-- MySQL / MariaDB compatible

CREATE DATABASE IF NOT EXISTS personal_subscription_tracker;
USE personal_subscription_tracker;

-- =========================================
-- 1. USER
-- =========================================
CREATE TABLE IF NOT EXISTS `user` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    notification_pref BOOLEAN NOT NULL DEFAULT TRUE
);

-- =========================================
-- 2. SUBSCRIPTION
-- =========================================
CREATE TABLE IF NOT EXISTS subscription (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    provider VARCHAR(150) NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    billing_cycle ENUM('weekly', 'monthly', 'yearly') NOT NULL,
    renewal_date DATE NOT NULL,

    CONSTRAINT fk_subscription_user
        FOREIGN KEY (user_id)
        REFERENCES `user`(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================================
-- 3. PAYMENT
-- =========================================
CREATE TABLE IF NOT EXISTS payment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    paid_on DATE NOT NULL,

    CONSTRAINT fk_payment_subscription
        FOREIGN KEY (subscription_id)
        REFERENCES subscription(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================================
-- 4. USAGE LOG
-- =========================================
CREATE TABLE IF NOT EXISTS usage_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NOT NULL,
    used_on DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_usage_log_subscription
        FOREIGN KEY (subscription_id)
        REFERENCES subscription(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================================
-- 5. RECOMMENDATION
-- =========================================
CREATE TABLE IF NOT EXISTS recommendation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NOT NULL,
    type ENUM('cancel', 'downgrade', 'pause') NOT NULL,
    status ENUM('pending', 'accepted', 'dismissed') NOT NULL DEFAULT 'pending',

    CONSTRAINT fk_recommendation_subscription
        FOREIGN KEY (subscription_id)
        REFERENCES subscription(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================================
-- OPTIONAL INDEXES
-- =========================================
CREATE INDEX idx_subscription_user
    ON subscription(user_id);

CREATE INDEX idx_subscription_renewal
    ON subscription(renewal_date);

CREATE INDEX idx_payment_subscription
    ON payment(subscription_id);

CREATE INDEX idx_usage_log_subscription
    ON usage_log(subscription_id);

CREATE INDEX idx_usage_log_date
    ON usage_log(used_on);

CREATE INDEX idx_recommendation_subscription
    ON recommendation(subscription_id);
