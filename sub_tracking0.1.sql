

-- ============================================
-- 1. USER TABLE
-- ============================================

CREATE TABLE User (
    user_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    notification_pref TEXT
);


-- ============================================
-- 2. SUBSCRIPTION TABLE
-- ============================================

CREATE TABLE Subscription (
    subscription_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    provider TEXT NOT NULL,
    cost REAL NOT NULL,
    billing_cycle TEXT NOT NULL,
    renewal_date TEXT NOT NULL,

    FOREIGN KEY (user_id)
        REFERENCES User(user_id)
);


-- ============================================
-- 3. PAYMENT TABLE
-- ============================================

CREATE TABLE Payment (
    payment_id INTEGER PRIMARY KEY,
    subscription_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    paid_on TEXT NOT NULL,

    FOREIGN KEY (subscription_id)
        REFERENCES Subscription(subscription_id)
);


-- ============================================
-- 4. USAGE_LOG TABLE
-- ============================================

CREATE TABLE Usage_Log (
    usage_id INTEGER PRIMARY KEY,
    subscription_id INTEGER NOT NULL,
    used_at TEXT NOT NULL,

    FOREIGN KEY (subscription_id)
        REFERENCES Subscription(subscription_id)
);


-- ============================================
-- 5. RECOMMENDATION TABLE
-- ============================================

CREATE TABLE Recommendation (
    recommendation_id INTEGER PRIMARY KEY,
    subscription_id INTEGER NOT NULL,
    type TEXT NOT NULL,
    status TEXT NOT NULL,

    FOREIGN KEY (subscription_id)
        REFERENCES Subscription(subscription_id)
);
-- USER DATA

INSERT INTO User
(user_id, name, email, notification_pref)
VALUES
(1, 'Jaskaran Singh', 'jaskaran@email.com', 'Email'),
(2, 'Abdul Majeed', 'abdul@email.com', 'Email'),
(3, 'Priyom Roy', 'priyom@email.com', 'SMS');


-- SUBSCRIPTION DATA

INSERT INTO Subscription
(subscription_id, user_id, name, category, provider, cost, billing_cycle, renewal_date)
VALUES
(1, 1, 'Netflix', 'Streaming', 'Netflix', 22.99, 'Monthly', '2026-09-15'),
(2, 1, 'Spotify', 'Streaming', 'Spotify', 14.99, 'Monthly', '2026-09-20'),
(3, 1, 'Gym Membership', 'Fitness', 'City Fitness', 45.00, 'Monthly', '2026-09-05'),
(4, 2, 'Microsoft 365', 'Software', 'Microsoft', 15.00, 'Monthly', '2026-09-10'),
(5, 3, 'Google Drive', 'Cloud Storage', 'Google', 3.00, 'Monthly', '2026-09-25');


-- PAYMENT DATA

INSERT INTO Payment
(payment_id, subscription_id, amount, paid_on)
VALUES
(1, 1, 22.99, '2026-08-15'),
(2, 2, 14.99, '2026-08-20'),
(3, 3, 45.00, '2026-08-05'),
(4, 4, 15.00, '2026-08-10'),
(5, 5, 3.00, '2026-08-25');


-- USAGE LOG DATA

INSERT INTO Usage_Log
(usage_id, subscription_id, used_at)
VALUES
(1, 1, '2026-08-01 20:30:00'),
(2, 1, '2026-08-05 21:00:00'),
(3, 1, '2026-08-10 19:45:00'),
(4, 2, '2026-08-02 10:00:00'),
(5, 2, '2026-08-08 15:30:00'),
(6, 3, '2026-08-03 17:00:00'),
(7, 3, '2026-08-06 17:30:00');


-- RECOMMENDATION DATA

INSERT INTO Recommendation
(recommendation_id, subscription_id, type, status)
VALUES
(1, 1, 'Keep', 'Accepted'),
(2, 2, 'Keep', 'Accepted'),
(3, 3, 'Keep', 'Accepted'),
(4, 4, 'Downgrade', 'Pending'),
(5, 5, 'Cancel', 'Dismissed');
PRAGMA table_info(User);

PRAGMA table_info(Subscription);

PRAGMA table_info(Payment);

PRAGMA table_info(Usage_Log);

PRAGMA table_info(Recommendation);
SELECT
    u.user_id,
    u.name,
    u.email,
    s.subscription_id,
    s.name AS subscription_name,
    s.category,
    s.provider,
    s.cost,
    s.billing_cycle,
    s.renewal_date,
    p.payment_id,
    p.amount,
    p.paid_on,
    ul.used_at,
    r.type AS recommendation,
    r.status AS recommendation_status
FROM User u
JOIN Subscription s
    ON u.user_id = s.user_id
LEFT JOIN Payment p
    ON s.subscription_id = p.subscription_id
LEFT JOIN Usage_Log ul
    ON s.subscription_id = ul.subscription_id
LEFT JOIN Recommendation r
    ON s.subscription_id = r.subscription_id;