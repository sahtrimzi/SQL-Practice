-- ============================================
-- Dataset: Kaggle "Orders" Dataset (Retail/E-commerce)
-- Tables: list_of_orders, order_details, sales_target
-- Source: Kaggle Orders dataset, loaded into PostgreSQL
-- Purpose: Practicing ORDER BY, LIMIT, and OFFSET
-- ============================================

--Q1: Show all orders sorted by order_date, oldest first
SELECT * FROM List_of_orders ORDER BY order_date ASC;

--Q2: Show all orders sorted by order_date, most recent first
SELECT * FROM List_of_orders ORDER BY order_date DESC;

--Q3: Show order_details sorted by amount, highest first
SELECT * FROM order_details ORDER BY amount DESC;

--Q4: Show the top 5 highest amount transactions from order_details
SELECT * FROM order_details ORDER BY amount DESC LIMIT 5;

--Q5: Show the 5 most loss-making transactions (lowest/most negative profit) from order_details
SELECT amount FROM order_details ORDER BY profit ASC LIMIT 5;

--Q6: Show order_details sorted by category (A-Z), and within each category sorted by amount (highest first)
SELECT *FROM order_details ORDER BY category ASC, amount DESC ;

--Q7: Show the top 10 highest amount orders, but skip the first 2 (show ranks 3-12)  use LIMIT with OFFSET
SELECT * FROM order_details ORDER BY
amount DESC LIMIT 10 OFFSET 2;

--Q8: Show all customers sorted alphabetically by customer_name
SELECT * FROM list_of_orders ORDER BY customer_name ASC;

