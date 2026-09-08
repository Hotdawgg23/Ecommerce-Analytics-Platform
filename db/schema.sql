-- ============================================================
-- E-commerce Analytics Warehouse Schema (Olist dataset)
-- Star-schema style: 1 fact table + dimension tables
-- ============================================================

DROP TABLE IF EXISTS fact_order_items CASCADE;
DROP TABLE IF EXISTS dim_customers CASCADE;
DROP TABLE IF EXISTS dim_products CASCADE;
DROP TABLE IF EXISTS dim_sellers CASCADE;
DROP TABLE IF EXISTS dim_orders CASCADE;
DROP TABLE IF EXISTS fact_payments CASCADE;
DROP TABLE IF EXISTS fact_reviews CASCADE;

-- ---------- Dimensions ----------

CREATE TABLE dim_customers (
    customer_id          VARCHAR(64) PRIMARY KEY,
    customer_unique_id   VARCHAR(64) NOT NULL,
    customer_city        VARCHAR(128),
    customer_state       VARCHAR(8),
    customer_zip_prefix  VARCHAR(16)
);

CREATE TABLE dim_products (
    product_id           VARCHAR(64) PRIMARY KEY,
    product_category     VARCHAR(128),
    product_weight_g      NUMERIC,
    product_length_cm     NUMERIC,
    product_height_cm     NUMERIC,
    product_width_cm      NUMERIC
);

CREATE TABLE dim_sellers (
    seller_id             VARCHAR(64) PRIMARY KEY,
    seller_city           VARCHAR(128),
    seller_state          VARCHAR(8),
    seller_zip_prefix     VARCHAR(16)
);

CREATE TABLE dim_orders (
    order_id                       VARCHAR(64) PRIMARY KEY,
    customer_id                    VARCHAR(64) REFERENCES dim_customers(customer_id),
    order_status                   VARCHAR(32),
    order_purchase_timestamp       TIMESTAMP,
    order_approved_at              TIMESTAMP,
    order_delivered_carrier_date   TIMESTAMP,
    order_delivered_customer_date  TIMESTAMP,
    order_estimated_delivery_date  TIMESTAMP
);

-- ---------- Facts ----------

CREATE TABLE fact_order_items (
    order_id        VARCHAR(64) REFERENCES dim_orders(order_id),
    order_item_id   INT,
    product_id      VARCHAR(64) REFERENCES dim_products(product_id),
    seller_id       VARCHAR(64) REFERENCES dim_sellers(seller_id),
    price           NUMERIC(10,2),
    freight_value   NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE fact_payments (
    order_id              VARCHAR(64) REFERENCES dim_orders(order_id),
    payment_sequential    INT,
    payment_type          VARCHAR(32),
    payment_installments  INT,
    payment_value         NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE fact_reviews (
    review_id                VARCHAR(64) PRIMARY KEY,
    order_id                 VARCHAR(64) REFERENCES dim_orders(order_id),
    review_score              INT,
    review_creation_date      TIMESTAMP,
    review_answer_timestamp   TIMESTAMP
);

-- ---------- Helpful indexes ----------
CREATE INDEX idx_orders_customer   ON dim_orders(customer_id);
CREATE INDEX idx_orders_purchase   ON dim_orders(order_purchase_timestamp);
CREATE INDEX idx_items_product     ON fact_order_items(product_id);
CREATE INDEX idx_items_seller      ON fact_order_items(seller_id);
CREATE INDEX idx_reviews_order     ON fact_reviews(order_id);
