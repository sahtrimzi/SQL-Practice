-- ============================================
-- Dataset: Kaggle "Orders" Dataset (Retail/E-commerce)
-- Tables: list_of_orders, order_details, sales_target
-- Source: Kaggle Orders dataset, loaded into PostgreSQL
-- Purpose: Purpose: Practicing basic SELECT columns, aliases, DISTINCT
-- ============================================

--Q1: Select all columns and all rows from list_of_orders
SELECT * FROM list_of_orders;
--Q2: Select only customer_name and city from list_of_orders
SELECT customer_name,city FROM list_of_orders;
--Q3: Select order_id and amount from order_details, but rename amount to "sale_amount"
SELECT order_id,amount AS sale_amount
FROM order_details;
--Q4: Select all  states from list_of_orders
SELECT "state" FROM list_of_orders;
--Q5: Select all sub_categories from order_details
SELECT sub_category FROM order_details;

