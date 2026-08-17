-- Personal Subscription Tracker
-- Group 5 - Studio 1
-- Database schema based on the project proposal

CREATE DATABASE personal_subscription_tracker;
USE personal_subscription_tracker;

DROP TABLE IF EXISTS Recommendation;
DROP TABLE IF EXISTS Usage_Log;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Subscription;
DROP TABLE IF EXISTS User_Account;

CREATE TABLE User_Account (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    notification_preferences BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE Subscription (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subscription_name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    provider VARCHAR(150) NOT NULL,
    cost DECIMAL(10,2) NOT NULL,
    billing_cycle ENUM('weekly', 'monthly', 'yearly') NOT NULL,
    next_renewal_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User_Account(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (subscription_id) REFERENCES Subscription(subscription_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Usage_Log (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NOT NULL,
    usage_timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (subscription_id) REFERENCES Subscription(subscription_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Recommendation (
    recommendation_id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NOT NULL,
    recommendation_type ENUM('keep', 'cancel', 'downgrade', 'pause') NOT NULL,
    recommendation_date DATE NOT NULL,
    status ENUM('pending', 'accepted', 'dismissed') NOT NULL DEFAULT 'pending',
    FOREIGN KEY (subscription_id) REFERENCES Subscription(subscription_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Sample data
INSERT INTO User_Account (name, email, notification_preferences)
VALUES
('Priyom Roy', 'priyom@example.com', TRUE);

INSERT INTO Subscription
(user_id, subscription_name, category, provider, cost, billing_cycle, next_renewal_date)
VALUES
(1, 'Netflix', 'Streaming', 'Netflix', 22.99, 'monthly', '2026-09-10'),
(1, 'Spotify', 'Streaming', 'Spotify', 17.99, 'monthly', '2026-09-15'),
(1, 'Cloud Storage', 'Cloud Storage', 'Google', 3.49, 'monthly', '2026-09-20');

INSERT INTO Payment (subscription_id, amount_paid, payment_date)
VALUES
(1, 22.99, '2026-08-10'),
(2, 17.99, '2026-08-15'),
(3, 3.49, '2026-08-20');

INSERT INTO Usage_Log (subscription_id, usage_timestamp)
VALUES
(1, '2026-08-12 20:30:00'),
(1, '2026-08-14 21:00:00'),
(2, '2026-08-13 18:30:00'),
(2, '2026-08-16 19:00:00'),
(3, '2026-08-10 10:00:00');

INSERT INTO Recommendation
(subscription_id, recommendation_type, recommendation_date, status)
VALUES
(1, 'keep', '2026-08-17', 'pending'),
(2, 'keep', '2026-08-17', 'pending'),
(3, 'downgrade', '2026-08-17', 'pending');

-- Useful project queries

-- View all subscriptions for a user
SELECT *
FROM Subscription
WHERE user_id = 1;

-- Calculate total monthly subscription cost
SELECT SUM(cost) AS total_monthly_cost
FROM Subscription
WHERE billing_cycle = 'monthly';

-- Count usage for each subscription
SELECT
    s.subscription_name,
    COUNT(u.usage_id) AS usage_count
FROM Subscription s
LEFT JOIN Usage_Log u
    ON s.subscription_id = u.subscription_id
GROUP BY s.subscription_id, s.subscription_name;

-- View payments and subscriptions
SELECT
    s.subscription_name,
    p.amount_paid,
    p.payment_date
FROM Subscription s
JOIN Payment p
    ON s.subscription_id = p.subscription_id
ORDER BY p.payment_date DESC;

-- View recommendations
SELECT
    s.subscription_name,
    r.recommendation_type,
    r.status,
    r.recommendation_date
FROM Subscription s
JOIN Recommendation r
    ON s.subscription_id = r.subscription_id;
