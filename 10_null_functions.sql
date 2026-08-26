-- ============================================
-- Dataset: Kaggle "Orders" Dataset (Retail/E-commerce)
-- Tables: list_of_orders, order_details, sales_target
-- Source: Kaggle Orders dataset, loaded into PostgreSQL
-- Purpose: Practicing NULL Functions (COALESCE, NULLIF), 
--          combined with WHERE, JOIN, CASE for revision
-- ============================================

-- ===== SECTION 1: Basic NULL Functions =====

--Q1: Show profit, and a new column that replaces NULL profit with 0 
--    (use COALESCE)
SELECT 
profit, 
COALESCE(profit, 0) AS profit_replaced
FROM order_details;

--Q2: Show category, and a new column that replaces NULL category with 
--    'Unknown' (use COALESCE)
SELECT 
category, 
COALESCE(category, 'Unknown') AS category_replaced
FROM order_details;

--Q3: Show quantity, and use NULLIF to turn any quantity of 0 into NULL 
--    (useful before dividing by quantity later)
SELECT 
quantity, 
NULLIF(quantity, 0) AS safe_quantity
FROM order_details;

--Q4: Count how many rows in order_details have a NULL category
SELECT COUNT(*) AS null_category_count
FROM order_details
WHERE category IS NULL;

--Q5: Show amount, profit, and COALESCE(profit, 0) as "safe_profit" side 
--    by side, to see where the replacement actually took effect
SELECT 
amount, 
profit, 
COALESCE(profit, 0) AS safe_profit
FROM order_details;

-- ===== SECTION 2: NULL Functions + JOIN/WHERE (revision, using LEFT JOIN) =====

--Q6: Show all orders (LEFT JOIN with order_details) and use COALESCE to 
--    show 'No Category Assigned' wherever category is NULL
SELECT 
L.order_id,
O.category,
COALESCE(category, 'No Category Assigned') AS category_replaced
FROM  list_of_orders L
LEFT JOIN order_Details O
ON O.order_id=L.order_id;

--Q7: Find orders (via LEFT JOIN) where COALESCE(amount, 0) equals 0 
--    (i.e., the order has no matching order_details, or a genuine 0 amount)
SELECT 
L.order_id,
O.amount,
COALESCE(O.amount, 0) AS amount_replaced
FROM list_of_orders L
LEFT JOIN order_details O
ON L.order_id = O.order_id
WHERE COALESCE(O.amount, 0) = 0;

--Q8: Show customer_name and COALESCE(profit, 0) for all orders, only 
--    where COALESCE(profit, 0) is greater than 500
SELECT 
customer_name,
COALESCE(profit, 0) AS safe_profit 
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE COALESCE(profit, 0) >500;

--Q9: Show category and use NULLIF(category, 'Clothing') — this should 
--    turn 'Clothing' rows into NULL while leaving others unchanged; 
--    then count how many rows became NULL
SELECT 
COUNT(*) AS converted_null_count
FROM order_details
WHERE NULLIF(category, 'Clothing') IS NULL;

--Q10: Safely calculate profit margin as ROUND((profit / NULLIF(amount, 0)) 
--     * 100, 2) — this avoids the division-by-zero error we discussed 
--     earlier, show customer_name and the margin
SELECT 
L.customer_name,
ROUND((O.profit / NULLIF(O.amount, 0)) * 100, 2) AS profit_margin
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id = O.order_id;

-- ===== SECTION 3: Real-world business scenarios =====

--Q11: Show category with COALESCE(category, 'Uncategorized'), combined 
--     with CASE to also label it 'High Value' or 'Low Value' based on 
--     amount (COALESCE + CASE together)
SELECT 
COALESCE(category, 'Uncategorized') AS category_name,
amount,
CASE 
WHEN amount > 2000 THEN 'High Value'
ELSE 'Low Value'
END AS value_label
FROM order_details;

--Q12: Find the average amount using AVG(COALESCE(amount, 0)) versus a 
--     regular AVG(amount) — write both queries and note in a comment 
--     why they might give different results if NULLs exist
SELECT 
AVG(amount) AS regular_avg,
AVG(COALESCE(amount, 0)) AS coalesce_avg
FROM order_details;

--Q13: Show customer_name and city, using COALESCE(city, state, 'Location 
--     Unknown') — a fallback chain (show city if available, else state, 
--     else a default message)
SELECT 
customer_name,
COALESCE(city, state, 'Location Unknown') AS location
FROM list_of_orders;

--Q14: Find sub_categories where NULLIF(sub_category, 'Chairs') is NOT 
--     NULL (i.e., every sub_category except 'Chairs')
SELECT  sub_category
FROM order_details
WHERE NULLIF(sub_category, 'Chairs') IS NOT NULL;

--Q15: Show ROUND(COALESCE(amount, 0)) along with a CASE-based value_tier, 
--     combining NULL handling with your earlier CASE logic
SELECT 
ROUND(COALESCE(amount, 0)) AS rounded_amount,
CASE 
WHEN COALESCE(amount, 0) > 2000 THEN 'High Value'
ELSE 'Low Value'
END AS value_tier
FROM  order_details;