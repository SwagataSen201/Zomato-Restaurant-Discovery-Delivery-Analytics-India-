-- ============================================================
-- **Zomato Restaurant Discovery & Delivery Analytics — India**
-- **Setup & Data Validation**
-- ============================================================

-- ============================================================
-- 1. Database Setup
-- ============================================================

CREATE DATABASE zomato_product_analytics;

-- ============================================================
-- 2. Table Setup
-- ============================================================

CREATE TABLE zomato_india (
    restaurant_id INTEGER,
    restaurant_name VARCHAR(255),
    city VARCHAR(100),
    locality VARCHAR(255),
    cuisines VARCHAR(1000),
    average_cost_for_two NUMERIC,
    has_table_booking VARCHAR(10),
    has_online_delivery VARCHAR(10),
    is_delivering_now VARCHAR(10),
    price_range INTEGER,
    aggregate_rating NUMERIC,
    rating_text VARCHAR(50),
    votes INTEGER,
    latitude NUMERIC,
    longitude NUMERIC
);

-- ============================================================
-- 3. Verify Import
-- ============================================================

-- We will check the count (total rows) availabe in zomato india
SELECT COUNT(*) AS total_rows
FROM zomato_india;

--  We will see the data preview for just 10 rows
SELECT *
FROM zomato_india
LIMIT 10;


-- ============================================================
-- 4. Check Duplicate Restaurant IDs
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT restaurant_id) AS unique_restaurants,
    COUNT(*) - COUNT(DISTINCT restaurant_id) AS duplicate_ids
FROM zomato_india;


-- ============================================================
-- 5. Check Missing Values
-- ============================================================

SELECT
    COUNT(*) FILTER (WHERE city IS NULL) AS null_city,
    COUNT(*) FILTER (WHERE cuisines IS NULL) AS null_cuisines,
    COUNT(*) FILTER (WHERE aggregate_rating IS NULL) AS null_rating,
    COUNT(*) FILTER (WHERE average_cost_for_two IS NULL) AS null_cost
FROM zomato_india;


-- ============================================================
-- 6. Check Numeric Ranges
-- ============================================================

SELECT
    MIN(average_cost_for_two) AS min_cost,
    MAX(average_cost_for_two) AS max_cost,
    MIN(aggregate_rating) AS min_rating,
    MAX(aggregate_rating) AS max_rating,
    MIN(votes) AS min_votes,
    MAX(votes) AS max_votes
FROM zomato_india;


-- ============================================================
-- 7. Check Online Delivery
-- ============================================================

SELECT
    has_online_delivery,
    COUNT(*) AS restaurants
FROM zomato_india
GROUP BY has_online_delivery;


-- ============================================================
-- 8. Check Zero Values
-- ============================================================

SELECT
    COUNT(*) FILTER (
        WHERE average_cost_for_two = 0
    ) AS zero_cost,

    COUNT(*) FILTER (
        WHERE aggregate_rating = 0
    ) AS zero_rating,

    COUNT(*) FILTER (
        WHERE votes = 0
    ) AS zero_votes
FROM zomato_india;


-- ============================================================
-- 9. Rating Categories
-- ============================================================

SELECT
    rating_text,
    COUNT(*) AS restaurants
FROM zomato_india
GROUP BY rating_text
ORDER BY restaurants DESC;
