-- ============================================================
-- Business analysis queries. Right I do economy extra informs in money actually among this actually because like six health care and is embedded embedded on Zeni, it is down where there's nothing actually in those two years as long as you're staying in general LP one matter mentioned road is like developed people for Extoken MBTI test you don't know where MVD test is MBTI that do you know what do you know the sixteen personality they select based on a personality test a core company their test was a personality test by the fuck would they go
-- 1. Monthly revenue trend
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(oi.price + oi.freight_value)                AS total_revenue,
    COUNT(DISTINCT o.order_id)                       AS total_orders
FROM dim_orders o
JOIN fact_order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;


-- 2. Running total revenue (window function)
SELECT
    month,
    total_revenue,
    SUM(total_revenue) OVER (ORDER BY month) AS running_total
FROM (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(oi.price) AS total_revenue
    FROM dim_orders o
    JOIN fact_order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
) monthly;


-- 3. Top 10 product categories by revenue
SELECT
    p.product_category,
    SUM(oi.price)          AS revenue,
    COUNT(*)                AS items_sold
FROM fact_order_items oi
JOIN dim_products p ON oi.product_id = p.product_id
GROUP BY p.product_category
ORDER BY revenue DESC
LIMIT 10;


-- 4. Average delivery time vs review score
SELECT
    r.review_score,
    ROUND(AVG(EXTRACT(EPOCH FROM (
        o.order_delivered_customer_date - o.order_purchase_timestamp
    )) / 86400)::numeric, 1) AS avg_delivery_days
FROM dim_orders o
JOIN fact_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;


-- 5. State-wise late delivery rate
SELECT
    c.customer_state,
    COUNT(*) FILTER (
        WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
    )::float / COUNT(*) AS late_delivery_rate,
    COUNT(*) AS total_orders
FROM dim_orders o
JOIN dim_customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY late_delivery_rate DESC;


-- 6. RFM base table (feeds the K-Means clustering step in Python)
-- Recency = days since last order, relative to the most recent
-- date in the dataset (Olist data is historical, so "today"
-- doesn't work — anchor to MAX(order_purchase_timestamp)).
WITH last_date AS (
    SELECT MAX(order_purchase_timestamp) AS max_date FROM dim_orders
)
SELECT
    c.customer_unique_id,
    EXTRACT(DAY FROM (ld.max_date - MAX(o.order_purchase_timestamp))) AS recency_days,
    COUNT(DISTINCT o.order_id)                                        AS frequency,
    SUM(oi.price)                                                      AS monetary
FROM dim_orders o
JOIN dim_customers c ON o.customer_id = c.customer_id
JOIN fact_order_items oi ON o.order_id = oi.order_id
CROSS JOIN last_date ld
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id, ld.max_date;


-- 7. (add more as you build each dashboard page)
-- e.g. seller performance, repeat customer rate, payment type
-- distribution, AOV by state, category x state cross-tab...
