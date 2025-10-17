-- Database: Olist_ecommerce

-- DROP DATABASE IF EXISTS "Olist_ecommerce";

CREATE DATABASE "Olist_ecommerce"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_India.1252'
    LC_CTYPE = 'English_India.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

--PHASE 1
--Initial Exploration & Data Quality Checks

--1.Who are the repeat buyers and how often do they order?
SELECT c.customer_id, COUNT(o.order_id) AS number_of_orders
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY number_of_orders DESC
LIMIT 20;
/*We see almost all customers have exactly one order. 
This suggests low customer retention and limited repeat purchases, 
indicating the company may need to improve loyalty programs, 
customer experience, or follow-up marketing strategies.*/

--2.Difference between order placed and delivered date → maximum delivery time
SELECT TO_CHAR(ORDER_APPROVED_AT, 'YYYYMMDDHH24MISS') FROM ORDERS;

--3.Which product has received the most positive review score?
SELECT P.PRODUCT_CATEGORY_NAME,
	   COUNT(*) AS total_reviews,
       AVG(R.REVIEW_SCORE) AS avg_review_score,
       SUM(CASE WHEN R.REVIEW_SCORE = 5 THEN 1 ELSE 0 END) AS five_star_reviews 
FROM PRODUCTS P INNER JOIN ORDER_ITEMS O ON P.PRODUCT_ID=O.PRODUCT_ID
INNER JOIN ORDER_REVIEWS R ON O.ORDER_ID=R.ORDER_ID
GROUP BY P.PRODUCT_CATEGORY_NAME
ORDER BY avg_review_score DESC, five_star_reviews DESC
LIMIT 10;
/*Most reviews are 5 stars, but by aggregating, we find that some categories  
stand out with the highest proportion of positive reviews. This suggests that these categories  
consistently deliver customer satisfaction*/

--4.Which payment type is most popular?”
SELECT PAYMENT_TYPE,COUNT(*) AS NO_OF_TRANSACTIONS
FROM ORDER_PAYMENTS
GROUP BY PAYMENT_TYPE
ORDER BY NO_OF_TRANSACTIONS DESC
/*We can see that majority of people use credit cards for the payment.
This indicates a clear dominance of card-based payments, meaning loyalty programs, cashback offers, 
tied to credit cards could increase retention and transaction volume. */

--5.Customers with highest payment value (classify into gold/silver)
SELECT C.CUSTOMER_ID,SUM(PAYMENT_VALUE) AS TOTAL_SPENDING_OF_CUSTOMER,
	   CASE WHEN SUM(PAYMENT_VALUE)>9000 THEN 'GOLD'
	   		WHEN SUM(PAYMENT_VALUE)>4000 THEN 'SILVER'
	   ELSE 'BRONZE' END AS CUSTOMER_CLASS
FROM
CUSTOMERS C INNER JOIN ORDERS O ON C.CUSTOMER_ID=O.CUSTOMER_ID 
INNER JOIN ORDER_PAYMENTS P ON O.ORDER_ID=P.ORDER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY TOTAL_SPENDING_OF_CUSTOMER DESC

/*We classify customers into 3 different categories based on their 
spending habits.We can now focus on the premium group and offer them
attractive packages and deals to retain them.*/

