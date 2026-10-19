-- Q1: How does lateness affect reviews?
SELECT
    CASE
        WHEN days_late <= -7 THEN '1. 7+ days early'
        WHEN days_late <   0 THEN '2. 1-6 days early'
        WHEN days_late =   0 THEN '3. On the day'
        WHEN days_late <=  3 THEN '4. 1-3 days late'
        WHEN days_late <=  7 THEN '5. 4-7 days late'
        WHEN days_late <= 14 THEN '6. 8-14 days late'
        ELSE                      '7. 15+ days late'
    END                                 AS delivery,
    COUNT(*)                            AS orders,
    ROUND(AVG(review_score), 2)         AS avg_review,
    ROUND(100.0 * AVG(unhappy), 1)      AS pct_unhappy
FROM orders_reviews
GROUP BY delivery
ORDER BY delivery;

-- Q2: Which states have the worst late-delivery rate? (states with 500+ orders)
SELECT
    customer_state,
    COUNT(*)                            AS orders,
    ROUND(100.0 * AVG(is_late), 1)      AS pct_late,
    ROUND(100.0 * AVG(unhappy), 1)      AS pct_unhappy
FROM orders_reviews
GROUP BY customer_state
HAVING COUNT(*) >= 500
ORDER BY pct_late DESC
LIMIT 10;

-- Q3: How did late deliveries and unhappy customers change month by month?
SELECT
    purchase_month,
    COUNT(*)                            AS orders,
    ROUND(100.0 * AVG(is_late), 1)      AS pct_late,
    ROUND(100.0 * AVG(unhappy), 1)      AS pct_unhappy
FROM orders_reviews
GROUP BY purchase_month
HAVING COUNT(*) >= 100
ORDER BY purchase_month;
