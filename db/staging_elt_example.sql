-- ============================================================
-- Optional ELT-flavor example.
-- Load orders RAW (untransformed) into a staging table, then
-- transform using a SQL view instead of doing it in Python.
-- Use this to show you understand both ETL and ELT patterns.
-- ============================================================

DROP TABLE IF EXISTS stg_raw_orders CASCADE;

-- Raw load: columns kept as TEXT, no cleaning done at load time
CREATE TABLE stg_raw_orders (
    order_id                       TEXT,
    customer_id                    TEXT,
    order_status                   TEXT,
    order_purchase_timestamp       TEXT,
    order_approved_at              TEXT,
    order_delivered_carrier_date   TEXT,
    order_delivered_customer_date  TEXT,
    order_estimated_delivery_date  TEXT
);

-- Transform happens here, in SQL, at query time (the "T" after "L")
CREATE OR REPLACE VIEW vw_orders_clean AS
SELECT
    order_id,
    customer_id,
    LOWER(TRIM(order_status))                        AS order_status,
    order_purchase_timestamp::TIMESTAMP               AS order_purchase_timestamp,
    order_approved_at::TIMESTAMP                       AS order_approved_at,
    order_delivered_carrier_date::TIMESTAMP            AS order_delivered_carrier_date,
    order_delivered_customer_date::TIMESTAMP           AS order_delivered_customer_date,
    order_estimated_delivery_date::TIMESTAMP           AS order_estimated_delivery_date
FROM stg_raw_orders
WHERE order_id IS NOT NULL;

-- Talking point for interviews:
-- "dim_orders / fact_* tables show my ETL pipeline (transform in
--  Python before load). stg_raw_orders + vw_orders_clean shows
--  the ELT alternative (load raw, transform in SQL)."
