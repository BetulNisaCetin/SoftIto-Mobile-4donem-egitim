CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fullname TEXT NOT NULL,
    email TEXT NOT NULL
);

INSERT INTO users (fullname, email)
VALUES ('Betül Nisa Çetin', 'betul@example.com');

INSERT INTO users (fullname, email)
VALUES ('Beyza Çetin', 'beyza@example.com');

INSERT INTO users (fullname, email)
VALUES ('Furkan Çetin', 'furkan@example.com');

SELECT * FROM users;

UPDATE users
SET email = 'betul.nisa@example.com'
WHERE id = 1;

SELECT * FROM users;

DELETE FROM users
WHERE id = 3;

SELECT * FROM users;
-- INNER JOIN için orders tablosu

CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    order_number TEXT NOT NULL
);

INSERT INTO orders (user_id, order_number)
VALUES (1, 'ORD-001');

INSERT INTO orders (user_id, order_number)
VALUES (2, 'ORD-002');

INSERT INTO orders (user_id, order_number)
VALUES (3, 'ORD-003');

-- INNER JOIN
SELECT
    users.fullname,
    users.email,
    orders.order_number
FROM users
INNER JOIN orders
    ON users.id = orders.user_id;