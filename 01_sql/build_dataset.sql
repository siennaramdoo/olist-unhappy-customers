-- Build the modelling dataset: one row per delivered order that has a review.
-- Every feature is something the business knows by the time the order is delivered,
-- i.e. before the customer writes their review (avoids data leakage).

WITH
-- Some orders have more than one review: keep only the most recent one
latest_review AS (
    SELECT
        order_id,
        review_score,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY review_answer_timestamp DESC
        ) AS rn
    FROM order_reviews
),

-- order_items has one row per item, so total it up to one row per order
items_per_order AS (
    SELECT
        order_id,
        COUNT(*)                  AS n_items,
        COUNT(DISTINCT seller_id) AS n_sellers,
        SUM(price)                AS total_price,
        SUM(freight_value)        AS total_freight
    FROM order_items
    GROUP BY order_id
)

SELECT
    o.order_id,
    c.customer_state,

    -- When the order was placed
    strftime('%Y-%m', o.order_purchase_timestamp)              AS purchase_month,
    CAST(strftime('%w', o.order_purchase_timestamp) AS INTEGER) AS purchase_weekday,  -- 0 = Sunday

    -- What was in the order
    i.n_items,
    i.n_sellers,
    ROUND(i.total_price, 2)   AS total_price,
    ROUND(i.total_freight, 2) AS total_freight,

    -- Delivery timing (julianday turns a date into a number of days, so we can subtract)
    ROUND(julianday(o.order_delivered_customer_date)
        - julianday(o.order_purchase_timestamp), 1)            AS delivery_days,
    ROUND(julianday(o.order_estimated_delivery_date)
        - julianday(o.order_purchase_timestamp), 1)            AS promised_days,
    CAST(julianday(date(o.order_delivered_customer_date))
       - julianday(date(o.order_estimated_delivery_date)) AS INTEGER) AS days_late,  -- negative = early
    CASE WHEN date(o.order_delivered_customer_date)
            > date(o.order_estimated_delivery_date) THEN 1 ELSE 0 END AS is_late,

    -- Outcome (review_score is kept for charts but must NOT be used as a model feature)
    r.review_score,
    CASE WHEN r.review_score <= 2 THEN 1 ELSE 0 END AS unhappy

FROM orders AS o
INNER JOIN latest_review   AS r ON r.order_id = o.order_id AND r.rn = 1
INNER JOIN customers       AS c ON c.customer_id = o.customer_id
LEFT JOIN  items_per_order AS i ON i.order_id = o.order_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL;
