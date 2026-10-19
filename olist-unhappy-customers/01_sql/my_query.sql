
SELECT c.customer_state, COUNT(*) AS orders, ROUND(AVG(r.review_score), 2) AS avg_review
FROM orders AS o
JOIN order_reviews AS r ON r.order_id = o.order_id
JOIN customers AS c ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
HAVING COUNT(*)>= 1000
ORDER BY avg_review ASC
LIMIT 5;