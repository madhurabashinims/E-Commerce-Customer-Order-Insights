-- Database: postgres

-- DROP DATABASE IF EXISTS postgres;

CREATE DATABASE postgres
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_India.1252'
    LC_CTYPE = 'English_India.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE postgres
    IS 'default administrative connection database';

--Phase 3 – Product & Customer Segmentation

/*1.Which products have the highest average review scores, and how do they rank within 
their product category?*/
WITH product_avg_reviews AS (
    SELECT 
        p.product_id,
        p.product_category_name,
        ROUND(AVG(o.review_score), 2) AS avg_review_score
    FROM products p
    INNER JOIN order_items oi ON p.product_id = oi.product_id
    INNER JOIN order_reviews o ON oi.order_id = o.order_id
    WHERE o.review_score IS NOT NULL
    GROUP BY p.product_id, p.product_category_name
),
ranked_products AS (
    SELECT 
        product_id,
        product_category_name,
        avg_review_score,
        RANK() OVER (PARTITION BY product_category_name ORDER BY avg_review_score DESC) AS rank_within_category
    FROM product_avg_reviews
)
SELECT *
FROM ranked_products
WHERE rank_within_category = 1
ORDER BY avg_review_score DESC;
/*These products are likely customer favorites → increase marketing, highlight them on the platform, or use them as flagship items.
Products with high review scores boost customer trust → consider cross-selling them with lower-rated items.
If some categories have no standout product (average scores are low across the board), that’s a red flag → maybe supplier quality issues or logistics delays affecting reviews.*/

/*2.Which regions (customer states) prefer which product categories?*/
WITH no_of_orders AS(
	SELECT p.product_category_name,c.customer_state,COUNT(o.order_id) AS no_of_orders_placed
	FROM
	customers c INNER JOIN orders o ON c.customer_id=o.customer_id 
	INNER JOIN order_items oi ON o.order_id=oi.order_id
	INNER JOIN products p on p.product_id=oi.product_id 
	GROUP BY (p.product_category_name,c.customer_state))
SELECT *,
RANK() OVER(PARTITION BY customer_state ORDER BY no_of_orders_placed DESC) AS rank_of_product_within_city
FROM no_of_orders
/*Here we see the importances given to several products within many cities corresponding
to the number of orders placed.Thus this is a vital piece of information in deciding
the marketing strategy for the cities,which when centred around the highly ranked products
would yield more profits.
*/

/*3.Are the top-selling products also the ones with the best reviews?*/
WITH sales_counts AS (
    SELECT 
        p.product_id,
        p.product_category_name,
        COUNT(o.order_id) AS sales_count
    FROM products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    INNER JOIN orders o ON oi.order_id = o.order_id
    GROUP BY p.product_id, p.product_category_name
),
review_averages AS (
    SELECT 
        p.product_id,
        p.product_category_name,
        ROUND(AVG(r.review_score), 2) AS avg_review_score
    FROM products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    INNER JOIN order_reviews r ON oi.order_id = r.order_id
    GROUP BY p.product_id, p.product_category_name
),
combined AS (
    SELECT 
        s.product_id,
        s.product_category_name,
        s.sales_count,
        r.avg_review_score
    FROM sales_counts s
    INNER JOIN review_averages r 
        ON s.product_id = r.product_id
)
SELECT *,
       CASE 
           WHEN sales_count > (
               SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sales_count) 
               FROM combined
           )
           AND avg_review_score < 3 
           THEN '⚠️ High Sales + Low Reviews'
           ELSE 'OK'
       END AS product_flag
FROM combined
ORDER BY sales_count DESC, avg_review_score ASC;

/*We have managed to flag the products in each category which have low review scores
despite having a good customer base.Thus if we could focus on the cause of the 
*/

/*4.Which product categories contribute the most to revenue per region?*/
WITH product_city_revenue AS (
  SELECT 
    p.product_id,
    p.product_category_name,
    c.customer_city,
    SUM(oi.price + oi.freight_value) AS revenue
  FROM customers c
  INNER JOIN orders o ON c.customer_id = o.customer_id 
  INNER JOIN order_items oi ON o.order_id = oi.order_id
  INNER JOIN products p ON p.product_id = oi.product_id 
  GROUP BY p.product_id, p.product_category_name, c.customer_city
)
SELECT *,
       RANK() OVER (PARTITION BY customer_city ORDER BY revenue DESC) AS rank_within_category
FROM product_city_revenue
WHERE rank_within_category=1;
/*So from this list we are able to get the list of product categories popular in 
the respective regions thereby urging us to shift our focus to those particular 
sales*/

/*5.Which customers are trend-setters in buying new or niche categories?*/
WITH category_sales AS (
    SELECT 
        p.product_category_name,
        COUNT(*) AS total_sales
    FROM order_items oi
    INNER JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
),
category_share AS (
    SELECT 
        product_category_name,
        total_sales,
        1.0 * total_sales / SUM(total_sales) OVER() AS sales_share
    FROM category_sales
),
niche_categories AS (
    SELECT product_category_name
    FROM category_share
    WHERE sales_share < 0.05   -- niche = less than 5% of total sales
),
trend_setters AS (
    SELECT 
        c.customer_id,
        p.product_category_name,
        MIN(o.order_purchase_timestamp) AS quickest_purchase_time
    FROM customers c
    INNER JOIN orders o ON o.customer_id = c.customer_id
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    INNER JOIN products p ON oi.product_id = p.product_id
    WHERE p.product_category_name IN (SELECT product_category_name FROM niche_categories)
    GROUP BY c.customer_id, p.product_category_name
)
SELECT * 
FROM trend_setters
ORDER BY quickest_purchase_time ASC;

/*Thus by identifying customers who have displayed to be the fastest in buying products
we could spot potential trend setters in the making and thereby nit pick influencers
to market our products.*/