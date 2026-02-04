-- 1. Afficher les commandes dont le montant total est supérieur au total moyen des commandes payées.
-- SELECT o.id, o.user_id, o.status, o.created_at, SUM(oi.quantity * oi.unit_price) AS order_total
-- FROM orders o
-- INNER JOIN order_items oi ON oi.order_id = o.id
-- GROUP BY o.id, o.user_id, o.status, o.created_at
-- HAVING SUM(oi.quantity * oi.unit_price) > (
--     SELECT AVG(amount)
--     FROM payments
-- );

-- 2. Afficher les utilisateurs ayant au moins une commande supérieure à 500€.
SELECT users.*
FROM users
WHERE EXISTS (
    SELECT 1
    FROM orders
    INNER JOIN payments on payments.order_id = orders.id
    WHERE orders.user_id = users.id AND payments.amount > 500
);

-- 3. Afficher les utilisateurs et leur chiffre d’affaires total, trié par CA décroissant.
SELECT users.id, users.email, SUM(p.amount) as total_payments
FROM users
INNER JOIN orders o ON o.user_id = users.id
INNER JOIN payments p ON p.order_id = o.id
GROUP BY users.id, users.email
ORDER BY total_payments DESC;
--
SELECT users.*, order_totals.total_order as total_payments
FROM users
INNER JOIN (
    SELECT o.user_id, SUM(p.amount) AS total_order
    FROM orders o
    INNER JOIN payments p ON p.order_id = o.id
    GROUP BY o.user_id
) AS order_totals ON order_totals.user_id = users.id
ORDER BY order_totals.total_order DESC;
