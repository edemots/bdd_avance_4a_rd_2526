-- 1. Calculez le chiffre d’affaires mensuel des 24 derniers mois
SELECT SUM(amount)
FROM payments
WHERE payments.paid_at >= NOW() - interval '24 month';
