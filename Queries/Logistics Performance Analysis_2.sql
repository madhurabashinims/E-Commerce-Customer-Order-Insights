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

--PHASE 2 
--Logistics & Delivery Performance Analysis

--1.What is the average time (in days) between purchase and delivery for all orders?
SELECT ORDER_ID,
	   ROUND(EXTRACT(DAY FROM ORDER_DELIVERED_CUSTOMER_DATE-ORDER_PURCHASE_TIMESTAMP),2) AS TIME_DIFFERENCE 
FROM ORDERS 
WHERE ORDER_DELIVERED_CUSTOMER_DATE IS NOT NULL
ORDER BY TIME_DIFFERENCE DESC

SELECT ROUND(AVG(EXTRACT(DAY FROM ORDER_DELIVERED_CUSTOMER_DATE-ORDER_PURCHASE_TIMESTAMP)), 2) 
       AS AVERAGE_DELIVERY_TIME
FROM ORDERS
WHERE ORDER_DELIVERED_CUSTOMER_DATE IS NOT NULL;

/*We analyzed delivery speed for all orders and found that the 
average delivery time is 12 days, while the maximum delay reached 
209 days. Such extreme delays could negatively affect customer 
satisfaction and retention. We recommend investigating the 
logistics pipeline and identifying specific sellers, carriers, 
or regions causing delays to minimize these outliers.
*/

--2.What percentage of orders were delivered after the estimated delivery date?
SELECT ROUND((SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END)::NUMERIC * 100) / COUNT(*), 2)
		AS PERCENT_OF_ORDERS_DELIVERED_POST_ESTIMATE_DATE
FROM orders
/*A mere 7 percent of orders were delivered after the estimated date.
This reflects strong accuracy in predicting the delivery estimates, which can boost customer trust. 
However, even small percentages of delay could impact customer satisfaction, so further analysis into the late 
deliveries  is recommended.*/

--3.Which sellers have the longest average delivery times to customers?
SELECT s.seller_id,
	   ROUND(EXTRACT(DAY FROM o.order_delivered_customer_date - o.order_purchase_timestamp),2) AS TIME_DIFFERENCE
FROM 
orders o INNER JOIN order_items i on o.order_id=i.order_id
INNER JOIN sellers s on i.seller_id=s.seller_id
WHERE o.order_delivered_customer_date IS NOT NULL
ORDER BY time_difference DESC
/*We now have a list of sellers corresponding to the highest
delays in delivery date to the lowest.Some sellers consistently show longer delivery periods compared to others. 
This could be due to logistics inefficiencies, regional constraints, 
or inventory issues. Focusing on these outlier sellers can help 
reduce overall delivery delays.*/

--4.Do longer delivery times correlate with lower review scores?
SELECT r.review_score,AVG(EXTRACT(DAY FROM o.order_delivered_customer_date - o.order_purchase_timestamp)) 
		AS delivery_Time_corresponding_to_review_Score
FROM 
orders o LEFT JOIN order_reviews r on o.order_id=r.order_id
WHERE  r.review_score IS NOT NULL
GROUP BY r.review_score
/*We observe a clear negative correlation between delivery time and review scores: longer delivery times generally lead
to lower review scores.This implies that delayed deliveries forces customers to leave a bad review.So we have to make
sure that the deliveries are timely to ensure a good review score. */

/*Lets do  a follow-up to look closely as to what specific product is particularly affected and its impact on review scores*/
SELECT 
    p.product_category_name,
    ROUND(AVG(EXTRACT(DAY FROM o.order_delivered_customer_date - o.order_purchase_timestamp)),2) 
        AS avg_delivery_time,
    ROUND(AVG(r.review_score),2) AS avg_review_score
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_delivered_customer_date IS NOT NULL
  AND r.review_score IS NOT NULL
GROUP BY p.product_category_name
ORDER BY avg_delivery_time DESC; 
/*Movies takes the longest to deliver (~30 days on avg) and has an avg review of 3.2, so logistics improvements here
would directly raise satisfaction.*/

--5.Which customer states have the highest average delivery delay?
SELECT c.customer_state,
       ROUND(AVG(EXTRACT(DAY FROM o.order_delivered_customer_date - o.order_purchase_timestamp)), 2) AS avg_delivery_days,
       COUNT(*) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC
LIMIT 10;

/*The top 10 states with the delayed deliveries are shown.
They range from 200 days to 180 days.The underlying logistical challenges, remote locations, or poor supply-chain infrastructure for these delays
should be determined to enable speedy
delivery in these regions and to increase the customer base here*/
