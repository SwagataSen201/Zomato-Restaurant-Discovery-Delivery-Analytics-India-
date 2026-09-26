-- ============================================================
-- Zomato Restaurant Discovery & Delivery Analytics — India
-- Product Analysis: Q1–Q8
-- Database: zomato_product_analytics
-- Table: zomato_india
-- Tool: PostgreSQL
-- ============================================================


-- ============================================================
-- Q1 — Restaurant Supply by City
-- Find the top 10 Indian cities by number of restaurants.
-- ============================================================

SELECT
    city,
    COUNT(*) AS restaurant_count
FROM zomato_india
GROUP BY city
ORDER BY restaurant_count DESC
LIMIT 10;


-- ============================================================
-- Q2 — Cuisine Assortment
-- Find the 15 most common cuisine combinations among Indian restaurants.
-- ============================================================

SELECT
    cuisines,
    COUNT(*) AS restaurant_count
FROM zomato_india
WHERE cuisines IS NOT NULL
GROUP BY cuisines
ORDER BY restaurant_count DESC
LIMIT 15;


-- ============================================================
-- Q3 — Rating Coverage by City
-- For each Indian city, what percentage of its restaurants have received a rating?
-- Only cities with at least 50 restaurants are included.
-- ============================================================

SELECT
    city,
    COUNT(*) AS total_restaurants,
    COUNT(*) FILTER (
        WHERE aggregate_rating > 0
    ) AS rated_restaurants,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE aggregate_rating > 0
        ) / COUNT(*),
        1
    ) AS rating_coverage_pct
FROM zomato_india
GROUP BY city
HAVING COUNT(*) >= 50
ORDER BY rating_coverage_pct DESC
LIMIT 10;


-- ============================================================
-- Q4 — Price & Rating
-- How does the average restaurant rating vary across different price segments in India?
-- ============================================================

SELECT
    CASE
        WHEN average_cost_for_two <= 300 THEN 'Budget'
        WHEN average_cost_for_two <= 700 THEN 'Mid-range'
        WHEN average_cost_for_two <= 1500 THEN 'Premium'
        ELSE 'Fine Dining'
    END AS price_segment,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(aggregate_rating), 2) AS average_rating
FROM zomato_india
WHERE average_cost_for_two > 0
  AND aggregate_rating > 0
GROUP BY price_segment
ORDER BY average_rating DESC;


-- ============================================================
-- Q5 — Customer Engagement
-- Do higher-rated restaurants receive more customer engagement?
-- ============================================================

SELECT
    rating_text,
    COUNT(*) AS restaurant_count,
    ROUND(AVG(votes), 0) AS average_votes
FROM zomato_india
WHERE aggregate_rating > 0
GROUP BY rating_text
ORDER BY average_votes DESC;


-- ============================================================
-- Q6 — Value-for-Money Restaurants
-- Which restaurants offer a combination of good rating, reasonable price, and meaningful customer engagement?
--
-- Project criteria:
-- Cost <= ₹500
-- Rating >= 4.0
-- Votes >= 200
-- ============================================================

SELECT
    restaurant_name,
    city,
    cuisines,
    average_cost_for_two,
    aggregate_rating,
    votes
FROM zomato_india
WHERE average_cost_for_two > 0
  AND average_cost_for_two <= 500
  AND aggregate_rating >= 4.0
  AND votes >= 200
ORDER BY aggregate_rating DESC, votes DESC
LIMIT 20;


-- ============================================================
-- Q7 — Online Delivery Adoption
-- Which Indian cities have the highest online-delivery adoption among restaurants?
-- Only cities with at least 50 restaurants are included.
-- ============================================================

SELECT
    city,
    COUNT(*) AS total_restaurants,
    SUM(
        CASE
            WHEN has_online_delivery = 'Yes' THEN 1
            ELSE 0
        END
    ) AS delivery_restaurants,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN has_online_delivery = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS delivery_adoption_pct
FROM zomato_india
GROUP BY city
HAVING COUNT(*) >= 50
ORDER BY delivery_adoption_pct DESC
LIMIT 10;


-- ============================================================
-- Q8 — Product Opportunity
-- Which cities have a strong supply of restaurants but relatively low online-delivery adoption?
-- Only cities with at least 100 restaurants are included.
-- ============================================================

SELECT
    city,
    COUNT(*) AS total_restaurants,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN has_online_delivery = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS delivery_adoption_pct
FROM zomato_india
GROUP BY city
HAVING COUNT(*) >= 100
ORDER BY delivery_adoption_pct ASC,
         total_restaurants DESC
LIMIT 10;
