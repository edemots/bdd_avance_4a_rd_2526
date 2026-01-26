-- 1. Calculez le chiffre d’affaires mensuel des 24 derniers mois
SELECT SUM(amount)::money AS total_revenue, date_trunc('month', paid_at) as month
FROM payments
WHERE payments.paid_at >= NOW() - interval '24 month'
GROUP BY month
ORDER BY month;

-- 2. Calculez le nombre de clients actifs, inactifs et le ratio entre les 2
SELECT
    COUNT(DISTINCT u.id) FILTER (WHERE o.id IS NOT NULL) as active_users,
    COUNT(*) FILTER (WHERE o.id IS NULL) as inactive_users,
    ROUND(
        (COUNT(*) FILTER (WHERE o.id IS NULL))::decimal(5, 3) /
        (COUNT(DISTINCT u.id) FILTER (WHERE o.id IS NOT NULL))::decimal(8, 3)
        * 100
    , 3) as ratio
FROM users u
LEFT JOIN orders o ON o.user_id = u.id;

-- 3. Calculez les ventes totales par catégories de produit par mois depuis le début de l’année
SELECT p.category, date_trunc('month', o.created_at) as month, SUM(oi.quantity * oi.unit_price) as total_sold
-- Je pars de orders
FROM orders o
-- Pour chaque order, je récupère ses items (product_id)
INNER JOIN order_items oi ON oi.order_id = o.id
-- Pour chaque product_id dans order_items, je récupère le détail dans la table products
INNER JOIN products p ON p.id = oi.product_id
-- Je filtre les commandes passées depuis le 01/01/2026 00:00:00
WHERE o.created_at >= date_trunc('year', NOW())
-- Je regroupe par catégorie de produit
GROUP BY p.category, month
-- Je trie par mois, puis dans un même mois par nom de catégorie Z-A
ORDER BY month, p.category DESC;

-- 4. Calculez le nombre de commandes payées ainsi que non payées
SELECT
    COUNT(*) FILTER (WHERE status = 'PAID') AS paid_orders,
    COUNT(*) FILTER (WHERE status <> 'PAID') AS no_paid_orders
FROM orders o;

-- 5. Comptez le nombre de commande par statut
SELECT COUNT(*) AS total, status
FROM orders
GROUP BY status;

-- 6. Calculez le chiffre d’affaire moyen par client
SELECT AVG(oi.quantity * oi.unit_price)::money AS avg_amount
FROM order_items oi;

-- OU

SELECT o.user_id, AVG(p.amount)::money
FROM orders o
INNER JOIN payments p ON p.order_id = o.id
GROUP BY o.user_id;
