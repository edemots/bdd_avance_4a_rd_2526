DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS payments CASCADE;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT,
  created_at TIMESTAMP
);

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name TEXT,
  category TEXT,
  price NUMERIC(10,2)
);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  status TEXT,
  created_at TIMESTAMP
);

CREATE TABLE order_items (
  order_id INT REFERENCES orders(id),
  product_id INT REFERENCES products(id),
  quantity INT,
  unit_price NUMERIC(10,2)
);

CREATE TABLE payments (
  id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(id),
  amount NUMERIC(10,2),
  paid_at TIMESTAMP
);

\set usersCount 100000
\set productsCount 25000
\set ordersCount 1000000
\set orderItemsCount 3000000

INSERT INTO users (email, created_at)
SELECT
  'user' || g || '@test.com',
  NOW() - (random() * interval '365 days')
FROM generate_series(1, :usersCount) g;

INSERT INTO products (name, category, price)
SELECT
  'Product ' || g,
  (ARRAY['Books', 'Tech', 'Clothing', 'Home'])[floor(random()*4)+1],
  round((random()*100 + 5)::numeric, 2)
FROM generate_series(1, :productsCount) g;

INSERT INTO orders (user_id, status, created_at)
SELECT
  floor(random()*:usersCount)+1,
  (ARRAY['PAID', 'CANCELLED', 'PENDING'])[floor(random()*3)+1],
  NOW() - (random() * interval '780 days')
FROM generate_series(1, :ordersCount);

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT
  floor(random()*:ordersCount)+1,
  floor(random()*:productsCount)+1,
  floor(random()*3)+1,
  round((random()*100 + 5)::numeric, 2)
FROM generate_series(1, :orderItemsCount);

INSERT INTO payments (order_id, amount, paid_at)
SELECT
  o.id,
  SUM(oi.quantity * oi.unit_price),
  o.created_at
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
WHERE o.status = 'PAID'
GROUP BY o.id, o.created_at;
