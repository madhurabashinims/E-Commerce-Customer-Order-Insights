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

--PHASE 4-Seller & Payment Analysis (profitability, fraud checks, repeat sellers, etc.).

--1.How reliable is a seller?
/*Measure: % on-time deliveries, avg delivery delay, review scores per seller.*/
SELECT 
    s.seller_id,
    COUNT(DISTINCT oi.order_id) AS no_of_orders,
    AVG(ors.review_score) AS avg_review_score,
    ROUND(AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400), 2) 
        AS avg_delivery_days
FROM sellers s
INNER JOIN order_items oi 
    ON s.seller_id = oi.seller_id
INNER JOIN orders o 
    ON o.order_id = oi.order_id
INNER JOIN order_reviews ors 
    ON ors.order_id = oi.order_id
GROUP BY s.seller_id
ORDER BY COUNT(DISTINCT oi.order_id) DESC, AVG(ors.review_score) DESC;

/*We can identify top sellers who handle a high volume of orders,
maintain strong average review scores, and deliver in fewer days.
Such sellers show higher reliability and have better potential 
to retain customers and grow their customer base.*/

--2.Delivery Cost Efficiency (freight vs revenue)
WITH delivery_cost_efficiency AS (
	SELECT seller_id,
    ROUND(SUM(oi.freight_value) / NULLIF(SUM(oi.price), 0), 2) AS freight_to_revenue_ratio
	FROM order_items oi
	GROUP BY seller_id
)
SELECT seller_id
FROM delivery_cost_efficiency
ORDER BY freight_to_revenue_ratio DESC
LIMIT 10
/*These are the top 10 sellers who have low delivery efficiency implying they are spending excess
money in logistics than what the business is yielding them as profits.*/

--3.Sales over time
WITH trends AS(
SELECT 
	DATE_TRUNC ('month',o.order_purchase_timestamp) AS sales_month,
	SUM(oi.price) AS total_revenue_per_month,
	COUNT(o.order_id) AS no_of_orders_month_wise,
	ROW_NUMBER() OVER (ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp) DESC) as rn
FROM 
	order_items oi INNER JOIN orders o on o.order_id=oi.order_id
GROUP BY sales_month
)
SELECT 
	sales_month,
	total_revenue_per_month,
	no_of_orders_month_wise
FROM trends
WHERE
    rn > 1
ORDER BY sales_month

/*The analysis shows an overall increasing trend in both revenue and order volumes month-over-month, 
although some fluctuations are present. This suggests healthy platform growth and indicates that the 
platform is performing well in attracting and retaining customers.*/

--4.Anomaly /Fraud Detection in Specific Regions
WITH city_delivery AS (
    SELECT 
        c.customer_city,
        AVG(o.order_delivered_customer_date - o.order_purchase_timestamp) AS avg_delivery_time
    FROM
        customers c
    JOIN
        orders o ON c.customer_id = o.customer_id
    WHERE
        o.order_delivered_customer_date IS NOT NULL
    GROUP BY
        c.customer_city
),
stats AS (
    SELECT
        AVG(avg_delivery_time) AS global_avg,
        STDDEV_POP(EXTRACT(EPOCH FROM avg_delivery_time)) AS global_stddev
    FROM
        city_delivery
),flagged as(
SELECT
    cd.customer_city,
    cd.avg_delivery_time,
    CASE
        WHEN cd.avg_delivery_time > s.global_avg + (2 * s.global_stddev) * interval '1 second' THEN 'Anomalously Late'
        WHEN cd.avg_delivery_time < s.global_avg - (2 * s.global_stddev) * interval '1 second' THEN 'Anomalously Early'
        ELSE 'Normal'
    END AS anomaly_flag
FROM
    city_delivery cd, stats s
ORDER BY
    cd.avg_delivery_time DESC)
SELECT customer_city
FROM flagged 
WHERE anomaly_flag='Anomalously Late'

/*This query gives the company a geographical risk map of delivery issues,like exactly what anomaly/fraud detection should surface.We 
classify the different cities as being anomalously late,or not based on whether the orders from their region have an average delivery
time greater than the overall average delivery time across all orders.*/


--5.Anamolous sellers
WITH overall_stats AS (
    SELECT AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400) AS avg_delivery_days
    FROM orders o
    WHERE o.order_delivered_customer_date IS NOT NULL
),
seller_delivery AS (
    SELECT
        s.seller_id,
        AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400) AS avg_delivery_time
    FROM sellers s
    JOIN order_items oi ON s.seller_id = oi.seller_id
    JOIN orders o ON o.order_id = oi.order_id
    WHERE o.order_delivered_customer_date IS NOT NULL
    GROUP BY s.seller_id
)
SELECT sd.seller_id,
	   ROUND(sd.avg_delivery_time, 2) AS avg_delivery_days,
	   CASE
	   		WHEN sd.avg_delivery_time > os.avg_delivery_days THEN 'Not a reputed seller'
			ELSE 'Good seller'
		END AS seller_score
FROM seller_delivery sd ,overall_stats os 

/*We are able to distinguish good and low-performing sellers by comparing their delivery days.
This would aid us in focussing on elevating the performance of that specific group of sellers.*/


--6.Segmentation using reviews
WITH reply_time AS(
SELECT review_id,
	   ROUND(AVG(EXTRACT(EPOCH FROM(review_answer_timestamp-review_creation_date))/86400),1) AS avg_reply_time
FROM order_reviews
GROUP BY review_id),

segment_of_reviews AS(
SELECT review_id,
	   avg_reply_time,
	   CASE WHEN avg_reply_time<2 THEN 'Fast Reply'
	   		WHEN avg_reply_time<8 THEN 'Medium speed Reply'
			WHEN avg_reply_time<15 THEN 'Slow Reply'
			ELSE 'Critically Late-Action to be taken'
END AS reply_time_segments
FROM reply_time)
SELECT reply_time_segments,COUNT(reply_time_segments)
FROM segment_of_reviews
GROUP BY reply_time_segments
/*It is very joyous to see that the reviews with the fast reply is ranked at the top with a heaping 54282
in number which informs us that we are doing a pretty good and speedy job in customer satisfaction.*/

--7.Interaction Score-Including pie chart also
WITH reply_time AS(
SELECT review_id,
	   ROUND(AVG(EXTRACT(EPOCH FROM(review_answer_timestamp-review_creation_date))/86400),1) AS avg_reply_time
FROM order_reviews
GROUP BY review_id),

avg_review_score AS(
SELECT review_id,
	   AVG(review_score) AS avg_score
FROM order_reviews
GROUP BY review_id),

interaction_score AS(
SELECT r.review_id,
	   0.6 * a.avg_score + 0.4 * (1 / r.avg_reply_time) AS interaction_Score
FROM avg_review_score a INNER JOIN reply_time r on a.review_id=r.review_id),

avg_interaction_score AS
(SELECT review_id,
       ROUND(AVG(interaction_Score),0) as avg_interaction_score
FROM interaction_score
GROUP BY review_id
ORDER BY avg_interaction_score DESC)

SELECT avg_interaction_score,
	   COUNT(avg_interaction_score)
FROM avg_interaction_score
GROUP BY avg_interaction_score

/*After obtaining this table of interaction scores for various reviews,we observe a huge amount of reviews
67618 to be precise has just the score of 3.So therefore we really need to work towards more quality
responses to the reviews.*/

--8.What is the correlation between reply_time and review_score?
WITH reply_time AS(
SELECT review_id,
	   ROUND(AVG(EXTRACT(EPOCH FROM(review_answer_timestamp-review_creation_date))/86400),1) AS avg_reply_time
FROM order_reviews
GROUP BY review_id)

SELECT CORR(avg_reply_time, review_score) AS correlation
FROM order_reviews o INNER JOIN reply_time r on o.review_id=r.review_id
WHERE review_answer_timestamp IS NOT NULL;
/*Since the correlation values is very low:0.006919875918525611,we can conclude that there isn't any
relation between reply time and review score.*/