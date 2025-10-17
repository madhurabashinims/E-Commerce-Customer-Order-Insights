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
	
-- Customers table
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

-- Sellers table
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

-- Products table
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- Orders table
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) REFERENCES customers(customer_id),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

-- Order Items table
CREATE TABLE order_items (
    order_id VARCHAR(50) REFERENCES orders(order_id),
    order_item_id INT,
    product_id VARCHAR(50) REFERENCES products(product_id),
    seller_id VARCHAR(50) REFERENCES sellers(seller_id),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- Order Payments table
CREATE TABLE order_payments (
    order_id VARCHAR(50) REFERENCES orders(order_id),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

-- Order Reviews table
CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50) REFERENCES orders(order_id),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
	PRIMARY KEY (order_id,review_id)
);
-- Geolocation table
CREATE TABLE geolocation(
	geolocation_zip_code_prefix INT,
	geolocation_lat NUMERIC(15,10),
	geolocation_lng NUMERIC(15,10),
	geolocation_city VARCHAR(50),
	geolocation_state VARCHAR(20)
);


--Adding data into tables in the right order
COPY customers FROM 'C:\SQL DATASET\olist_customers_dataset.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY geolocation FROM 'C:\SQL DATASET\olist_geolocation_dataset.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY orders FROM 'C:\SQL DATASET\olist_orders_dataset.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY order_payments FROM 'C:\SQL DATASET\olist_order_payments_dataset.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY order_reviews FROM 'C:\SQL DATASET\olist_order_reviews_dataset.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY products FROM 'C:\SQL DATASET\olist_products_dataset.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY sellers FROM 'C:\SQL DATASET\olist_sellers_dataset.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');
COPY order_items FROM 'C:\SQL DATASET\olist_order_items_dataset.csv' WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

--Checking if all tables have data
SELECT * FROM ORDER_REVIEWS
SELECT * FROM CUSTOMERS
SELECT * FROM GEOLOCATION
SELECT * FROM ORDERS
SELECT * FROM ORDER_PAYMENTS
SELECT * FROM PRODUCTS
SELECT * FROM SELLERS
SELECT * FROM ORDER_ITEMS

--Checking if all records have been imported
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation;

--Checking foreign key consistency
SELECT * FROM orders WHERE customer_id NOT IN (SELECT customer_id FROM customers);
SELECT * FROM order_payments WHERE order_id NOT IN (SELECT order_id FROM orders);
SELECT * FROM order_reviews WHERE order_id NOT IN (SELECT order_id FROM orders);
SELECT *
FROM order_items
WHERE order_id NOT IN (SELECT order_id FROM orders)
   OR product_id NOT IN (SELECT product_id FROM products)
   OR seller_id NOT IN (SELECT seller_id FROM sellers);


--BASIC QUERIES
SELECT customer_state, COUNT(*) 
FROM customers 
GROUP BY customer_state 
ORDER BY COUNT(*) DESC 
LIMIT 5;

--NULL CHECK IN CRITICAL COLUMNS
SELECT 'customers.customer_id', COUNT(*) 
FROM customers WHERE customer_id IS NULL
UNION ALL
SELECT 'orders.order_id', COUNT(*) 
FROM orders WHERE order_id IS NULL
UNION ALL
SELECT 'products.product_id', COUNT(*) 
FROM products WHERE product_id IS NULL;

--DATA RANGE CHECK BETWEEN FIRST AND LAST ORDER
SELECT MIN(order_purchase_timestamp) AS first_order,
       MAX(order_purchase_timestamp) AS last_order
FROM orders;


