-- ============================================
-- Dataset: Kaggle "Orders" Dataset (Retail/E-commerce)
-- Tables: list_of_orders, order_details, sales_target
-- Source: Kaggle Orders dataset, loaded into PostgreSQL
-- Purpose: Practicing Window Aggregate Functions with frame 
--          clauses (ROWS BETWEEN) — moving totals, moving 
--          averages — combined with JOIN and prior functions
-- ============================================

-- ===== SECTION 1: True Running Total (ROWS frame, revisiting our RANGE vs ROWS discovery) =====

--Q1: Show order_id, amount, and a TRUE row-by-row running total (use 
--    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) — ordered by order_id
SELECT 
order_id, amount, SUM(amount) OVER (ORDER BY order_id 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM order_details
ORDER BY order_id;

--Q2: Show category, amount, and a TRUE running total within each 
--    category (PARTITION BY category, ROWS BETWEEN UNBOUNDED PRECEDING 
--    AND CURRENT ROW) — ordered by amount
SELECT category,amount,SUM(amount) OVER(PARTITION BY category ORDER BY amount
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS running_total
FROM order_details;

--Q3: Compare the default (RANGE) running total vs the explicit ROWS 
--    running total for the SAME query — write both, ordered by amount, 
--    and note in a comment where they differ
-- DIFFERENCE NOTE: 
-- RANGE (the default) groups identical values in the ORDER BY column (amount) 
-- together, adding them all at once to the running total. 
-- ROWS strictly evaluates row-by-row, even if the amount values are duplicates.
-- Therefore, the results will only differ when there are duplicate 'amount' values.

SELECT 
order_id,amount,
-- Default behavior (RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
SUM(amount) OVER (
ORDER BY amount) AS default_range_total,
-- Explicit row-by-row behavior
SUM(amount) OVER (ORDER BY amount 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS explicit_rows_total
FROM order_details
ORDER BY amount;

-- ===== SECTION 2: Moving Window (N PRECEDING) =====

--Q4: Show order_id, amount, and a moving sum of the CURRENT row + 
--    previous 2 rows (ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 
--    ordered by order_id
SELECT order_id,amount,SUM(amount) 
OVER(ORDER BY order_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS total_amount
FROM order_details;

--Q5: Show order_id, amount, and a moving AVERAGE of the current row + 
--    previous 2 rows (a simple 3-row moving average) — ordered by order_id
SELECT order_id,amount, AVG(amount) OVER(ORDER BY order_id
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)AS total_avg
FROM order_details;

--Q6: Show category, amount, and a moving sum within each category (2 
--    PRECEDING AND CURRENT ROW), ordered by amount
SELECT category,amount,SUM(amount) OVER(PARTITION BY category
ORDER BY amount ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS total_sum
FROM order_details;

--Q7: Show order_date, amount, and a moving average of the last 3 orders 
--    (by date) — ordered by order_date
SELECT order_date,amount,AVG(amount) OVER(ORDER BY order_date
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS total_avs
FROM list_of_orders L
INNER JOIN order_Details O
ON L.order_id=O.order_id;

--Q8: Show category, order_id, amount, and a moving MAX of current + 
--    previous 1 row, ordered by order_id, PARTITION BY category
SELECT category,order_id,amount, MAX(amount) over( PARTITION BY category ORDER BY order_id
ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS runig_max
FROM order_details;

-- ===== SECTION 3: Forward-looking windows (FOLLOWING) =====

--Q9: Show order_id, amount, and the sum of current row + NEXT 2 rows 
--    (ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING), ordered by order_id
SELECT order_id,amount,SUM(amount) OVER(ORDER BY order_id
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING ) AS runn_SUM
FROM order_details;

--Q10: Show order_id, amount, and the "remaining total" — sum from 
--     current row to the end (ROWS BETWEEN CURRENT ROW AND UNBOUNDED 
--     FOLLOWING), ordered by amount
SELECT order_id,amount,SUM(amount) OVER(ORDER BY amount 
ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
FROM order_details;

--Q11: Show category, amount, and a centered window — 1 PRECEDING AND 
--     1 FOLLOWING (this averages the current row with its immediate 
--     neighbors on both sides)
SELECT category, amount,
AVG(amount) OVER (ORDER BY amount ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS centered_avg
FROM order_details;

-- ===== SECTION 4: Window Aggregate + WHERE/JOIN (revision) =====

--Q12: Show customer_name, amount, and a true running total (ROWS 
--     BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) ordered by amount, 
--     only for orders in the 'Electronics' category
SELECT customer_name,amount,SUM(amount) OVER(ORDER BY amount 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Electronics';

--Q13: Show category, amount, and a moving sum (2 PRECEDING AND CURRENT 
--     ROW), only for profitable orders (profit > 0)
SELECT category,amount,SUM(amount) OVER( ORDER BY order_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MOVING_SUM
FROM order_details
WHERE profit>0;

--Q14: Show state, amount, and AVG(amount) OVER (PARTITION BY state 
--     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ORDER BY 
--     order_date) — a true running average per state over time (needs JOIN)
SELECT state,amount,AVG(amount) OVER(PARTITION BY state ORDER BY order_date 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS RUNNING_AVG
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q15: Show category, sub_category, amount, and COUNT(*) OVER (PARTITION 
--     BY category, sub_category) — count within each category+sub_category 
--     combination, only for amount > 200
SELECT category,sub_category,amount,
COUNT(*) OVER(PARTITION BY category,sub_category) AS count_cat_sub_cate
FROM order_details
WHERE amount>200;

-- ===== SECTION 5: Window Aggregate + String/Numeric/CASE (revision) =====

--Q16: Show UPPER(category), amount, and a ROUND-ed moving average (2 
--     PRECEDING AND CURRENT ROW)
SELECT UPPER(category), amount, ROUND(AVG(amount) OVER(ORDER BY order_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS running_avg_roun
FROM order_details;

--Q17: Show category, amount, and a CASE column "trend" — 'Rising' if 
--     the moving sum (1 PRECEDING AND CURRENT ROW) is greater than 
--     amount alone, else 'Flat' (hint: this will almost always be 
--     'Rising' unless amount is 0 — think about why, and note it as a comment)
SELECT category,amount,
CASE
WHEN SUM(amount) OVER(ORDER BY order_id ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) >amount THEN 'rising'
ELSE 'Flat'
END AS trend
FROM order_details;

--Q18: Show customer_name (INITCAP), amount, and a true running total 
--     of their own spending over time (PARTITION BY customer_name, 
--     ORDER BY order_date, ROWS BETWEEN UNBOUNDED PRECEDING AND 
--     CURRENT ROW) — needs JOIN
SELECT INITCAP(customer_name),amount,SUM(amount) OVER(PARTITION BY customer_name 
ORDER BY  order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS runn_total_sum
FROM list_of_orders L
INNER JOIN order_details O
ON O.order_id=L.order_id;

--Q19: Show category, ROUND(amount), and the difference between amount 
--     and a 3-row moving average (2 PRECEDING AND CURRENT ROW) — shows 
--     how far each order deviates from the recent trend
SELECT category, ROUND(amount, 0) AS rounded_amount,
amount - AVG(amount) OVER (ORDER BY order_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS deviation_from_trend
FROM order_details;

--Q20: Show state, amount, and COALESCE applied to a moving average (2 
--     PRECEDING AND CURRENT ROW), defaulting to 0 if NULL
SELECT state, amount,
COALESCE(AVG(amount) OVER (ORDER BY order_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS smoothed_moving_avg
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

