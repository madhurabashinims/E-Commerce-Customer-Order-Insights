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

--PHASE 5-Temporal & Behavioral Analytics
--1.Customer Lifetime Value (CLV: = Average Purchase Value × Average Purchase Frequency × Average Customer Lifespan)
WITH avg_purchase_value AS(
SELECT c.customer_id,
	   ROUND(AVG(op.payment_value),2) AS avg_purchase_val
FROM customers c INNER JOIN orders o ON c.customer_id=o.customer_id
INNER JOIN order_payments op ON op.order_id=o.order_id
GROUP BY c.customer_id
),
purchase_freq AS(
SELECT c.customer_id,
	   COUNT(o.order_id) AS purchase_freq
FROM customers c INNER JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id
),
avg_purchase_freq AS(
SELECT customer_id,
	   ROUND(AVG(purchase_freq),0) AS avg_purchase_freq
FROM purchase_freq
GROUP BY customer_id
),
CLV AS(
SELECT apv.customer_id,
	   apv.avg_purchase_val*apf.avg_purchase_freq AS CLV
FROM avg_purchase_value apv INNER JOIN avg_purchase_freq apf ON apv.customer_id=apf.customer_id
),
segmentation AS(
SELECT customer_id,
	   CASE WHEN CLV>100 THEN 1
	   ELSE 0
	   END AS customer_segmentation
FROM CLV)
SELECT 
    s.customer_segmentation,
    ROUND(AVG(r.review_score),2) AS avg_review_score
FROM segmentation s
INNER JOIN orders o ON s.customer_id=o.customer_id
INNER JOIN order_reviews r ON o.order_id=r.order_id
GROUP BY customer_segmentation;

SELECT CORR(s.customer_segmentation,r.review_score)
FROM segmentation s INNER JOIN orders o ON s.customer_id=o.customer_id
INNER JOIN order_reviews r ON o.order_id=r.order_id;

/*We tested whether customer lifetime value (CLV)-based segmentation (High vs Low) has any 
significant relationship with customer review scores. Both statistical correlation (≈ –0.002)
and group averages (High CLV ≈ 4.1, Low CLV ≈ 4.0) indicate there is no meaningful 
relationship. This suggests that a customer’s value to the business does not strongly 
influence the ratings they provide, at least in this dataset.*/

--2.Customer Churn & Retention
WITH last_order AS
(SELECT c.customer_id,
	   MAX(o.order_purchase_timestamp) AS last_order
FROM customers c INNER JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id),
inactive_days AS(
SELECT customer_id,
	   ROUND(EXTRACT(EPOCH FROM( CURRENT_DATE-last_order))/86400,1) AS inactive_days
FROM last_order)
SELECT customer_id,
		CASE WHEN inactive_days>3000 THEN 'Inactive'
		ELSE 'Active customer'
		END AS Active_or_Inactive_customer
FROM inactive_days

/*We have a list of active and inactive customers so that we can either offer attractive rewards
to active users or dig into and find the reason for inactivity in certain customers.*/

--3.Seasonality Trends
SELECT COUNT(order_id),
		EXTRACT(month FROM order_purchase_timestamp) AS month_order_placed
FROM orders
GROUP BY month_order_placed
ORDER BY COUNT(order_id) DESC

/*Orders pile up high in August maybe due to festivals in Brazil like Festa do Peão de Barretos
and in May since its nice summer vacation time.*/

/*In this phase, we explored deeper business intelligence questions. First, we classified 
customers into active/inactive segments, revealing retention challenges. Although cohort 
analysis wasn’t feasible due to single-order customers, profitability by category and
seasonality trends gave important insights into peak shopping months (e.g., August, May). 

Overall, Phase 5 highlighted not just descriptive patterns but also actionable insights 
that can drive marketing and sales strategies, making the project more professional and 
business-oriented.*/