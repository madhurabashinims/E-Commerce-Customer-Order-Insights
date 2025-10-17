-- Database: Olist_ecommerce

-- DROP DATABASE IF EXISTS "Olist_ecommerce";

CREATE TABLE profiling_results (
    table_name text,
    column_name text,
    total_rows bigint,
    distinct_values bigint,
    null_count bigint,
    null_percent numeric,
    min_value text,
    max_value text
);


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

DO $$
DECLARE 
    rec record;
BEGIN
    FOR rec IN
        SELECT table_name, column_name
        FROM information_schema.columns
        WHERE table_schema = 'public'
    LOOP
        RAISE NOTICE '
            SELECT ''%'' AS table_name, ''%'' AS column_name,
                   COUNT(*) AS total_rows,
                   COUNT(DISTINCT %I) AS distinct_values,
                   SUM(CASE WHEN %I IS NULL THEN 1 ELSE 0 END) AS null_count,
                   ROUND(100.0 * SUM(CASE WHEN %I IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS null_percent,
                   MIN(%I) AS min_value,
                   MAX(%I) AS max_value
            FROM %I;', 
            rec.table_name, rec.column_name,
            rec.column_name, rec.column_name, rec.column_name, rec.column_name, rec.column_name, rec.table_name;
    END LOOP;
END $$;

SELECT 'orders' AS table_name, 'order_delivered_carrier_date' AS column_name,
                   COUNT(*) AS total_rows,
                   COUNT(DISTINCT order_delivered_carrier_date) AS distinct_values,
                   SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS null_count,
                   ROUND(100.0 * SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS null_percent,
                   MIN(order_delivered_carrier_date) AS min_value,
                   MAX(order_delivered_carrier_date) AS max_value
            FROM orders;