-- ============================================
-- Dataset: Kaggle "Orders" Dataset (Retail/E-commerce)
-- Tables: list_of_orders, order_details, sales_target
-- Source: Kaggle Orders dataset, loaded into PostgreSQL
-- Purpose: Practicing Aggregate Functions (COUNT, SUM, AVG, 
--          MAX, MIN) with GROUP BY, combined with WHERE, 
--          JOIN, and prior functions for revision. 
--          (HAVING intentionally excluded — covered separately later)
-- ============================================

-- ===== SECTION 1: Basic Aggregate Functions (no GROUP BY) =====

--Q1: Count the total number of orders in list_of_orders
SELECT COUNT(order_id) AS total_order
FROM list_of_orders;

--Q2: Find the total SUM of all amounts in order_details
SELECT SUM(amount) AS total_amount 
FROM order_details;

--Q3: Find the AVERAGE amount across all order_details
SELECT AVG(amount) AS tota_average
FROM order_details;

--Q4: Find the MAXIMUM and MINIMUM amount in order_details, side by side
SELECT MAX(amount) AS MAX_AMOUNT ,MIN(amount) AS MIN_AMOUNT
FROM order_details;

--Q5: Count how many order_details rows have a non-NULL profit value
SELECT COUNT(profit) AS non_null
FROM order_Details;

-- ===== SECTION 2: Aggregate Functions + WHERE (revision) =====

--Q6: Find the total SUM of amount, but only for the 'Electronics' category
SELECT SUM(amount) AS total_amount_elect FROM order_details
WHERE category='Electronics';

--Q7: Count how many orders were placed from 'Maharashtra'
SELECT COUNT(order_id) FROM 
list_of_orders 
WHERE state='Maharashtra';

--Q8: Find the AVERAGE profit for orders where profit is negative
SELECT AVG(profit) AS avg_neg_pro
FROM order_details
WHERE profit<0;

--Q9: Find the MAXIMUM amount among orders placed in April 2018 (use 
--    EXTRACT for the date filter — revision)
SELECT MAX(amount) AS Max_amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE EXTRACT(MONTH FROM order_date) = 4 
AND EXTRACT(YEAR FROM order_date) = 2018;

--Q10: Count how many order_details have quantity greater than 5
SELECT COUNT(quantity) AS quan_grethan_5
FROM order_details 
WHERE quantity>5;

-- ===== SECTION 3: GROUP BY — aggregating per category =====

--Q11: Show the total SUM of amount for each category (GROUP BY category)
SELECT category,SUM(amount) AS total_amount
FROM order_details 
GROUP BY category;

--Q12: Count how many orders exist per state (GROUP BY state)
SELECT state,COUNT(order_id) as total_order
FROM list_of_orders 
GROUP BY state;

--Q13: Find the AVERAGE amount per sub_category
SELECT sub_category, AVG(amount) AS total_avg
FROM order_Details 
GROUP BY sub_category;

--Q14: Show the MAXIMUM profit achieved in each category
SELECT category,MAX(profit) AS max_profit
FROM order_details 
GROUP BY category;

--Q15: Count how many orders were placed from each city
SELECT city, COUNT(order_id) AS total_order
FROM list_of_orders 
GROUP BY city;

-- ===== SECTION 4: GROUP BY + WHERE (filter before grouping) =====

--Q16: Show the total SUM of amount per category, but only including 
--     orders placed after '2018-04-01'
SELECT category, SUM(amount) AS total_amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE order_date >'2018-04-01'
GROUP BY category;

--Q17: Count how many orders per state, but only for profitable orders 
--     (profit > 0)
SELECT state,COUNT(L.order_id) AS total_order
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE profit>0
GROUP BY state;

--Q18: Find the AVERAGE quantity per sub_category, only for the 
--     'Furniture' category
SELECT sub_category,AVG(quantity) AS total_avg_quant
FROM order_details 
WHERE category='Furniture'
GROUP BY sub_category

--Q19: Show total SUM of profit per city, but only for orders with 
--     amount > 1000
SELECT city,SUM(profit) AS total_profit
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE amount>1000
GROUP BY city;

--Q20: Count orders per category, but only for orders placed in Q2 2018 
--     (April-June, use EXTRACT for the filter)
SELECT category,COUNT(L.order_id) AS total_orders
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE EXTRACT(MONTH FROM order_date) BETWEEN 4 AND 6
AND  EXTRACT(YEAR FROM order_date) = 2018
GROUP BY category;
-- ===== SECTION 5: GROUP BY + JOIN (revision) =====

--Q21: Show each customer_name with the COUNT of orders they placed and 
--     the total SUM of amount they spent (JOIN list_of_orders with 
--     order_details, GROUP BY customer_name)
SELECT customer_name, COUNT(L.order_id) AS order_order,
SUM(amount) AS total_amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
GROUP BY customer_name;

--Q22: Find the total SUM of amount per category, alongside the 
--     sales_target for that category (JOIN order_details with 
--     sales_target on category, GROUP BY category)
SELECT S.category, S.target, SUM(O.amount) AS total_amount
FROM order_details O
INNER JOIN sales_target S 
ON O.category = S.category
GROUP BY S.category, S.target;

--Q23: Show state and the total COUNT of profitable orders 
--     per state (JOIN + WHERE + GROUP BY)
SELECT state, COUNT(profit) AS profitable_order_count
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE profit>0
GROUP BY state;

-- ===== SECTION 6: GROUP BY + String/Numeric/CASE/NULL Functions (revision) =====

--Q24: Show category in UPPERCASE along with the ROUND-ed (0 decimals) 
--     total SUM of amount per category
SELECT UPPER(category) AS category, ROUND(SUM(amount)) AS total_amount
FROM order_details 
GROUP BY category;

--Q25: Find customer_names (using INITCAP) along with their total order 
--     COUNT, grouped by customer_name
SELECT INITCAP(customer_name), COUNT(order_id) AS total_order
FROM list_of_orders
GROUP BY  INITCAP(customer_name);

--Q26: Show a "value_tier" using CASE (High/Medium/Low based on total 
--     SUM of amount per category), combining CASE with GROUP BY 
--     (hint: apply CASE to the aggregated SUM, not the raw amount)
SELECT 
category,
SUM(amount) AS total_amount,
CASE 
WHEN SUM(amount) >= 100000 THEN 'High'
WHEN SUM(amount) >= 50000 THEN 'Medium'
ELSE 'Low'
END AS value_tier
FROM order_details
GROUP BY category;

--Q27: Show category and SUM(COALESCE(profit, 0)) per category — using 
--     NULL handling inside an aggregate
SELECT  category,SUM(COALESCE(profit, 0)) AS total_profit
FROM order_details 
GROUP BY category;

--Q28: Count how many DISTINCT customer_names placed orders in each 
--     state (use COUNT(DISTINCT customer_name), GROUP BY state)
SELECT state, COUNT(DISTINCT customer_name) AS distinct_customer_count
FROM list_of_orders
GROUP BY state;

-- ===== SECTION 7: Real-world business scenarios =====

--Q29: For each category, show total SUM of amount, total SUM of profit, 
--     and the COUNT of orders — all three aggregates together, GROUP BY category
SELECT category, SUM(amount) AS total_amount,
SUM(profit) AS total_profit, COUNT(order_id) AS total_order
FROM order_details
GROUP BY category;

--Q30: Show category, GROUP BY category, and calculate the "average 
--     order value" as SUM(amount) / COUNT(order_id) — compare this 
--     result to simply using AVG(amount) and note in a comment whether 
--     they give the same answe
SELECT 
category,
SUM(amount) / COUNT(order_id) AS manual_avg,
AVG(amount) AS builtin_avg
FROM order_details
GROUP BY category;
--both ans are same bcz in our data set no null value are their that 
--they give us same result in other case in our data set have null 
--then give us different result bcz 1 query count order that means 
-- they cannot skip thi null values but simple aggreagate avg 
--function skip null value 
