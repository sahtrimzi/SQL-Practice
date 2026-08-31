-- ============================================
-- Dataset: Kaggle "Orders" Dataset (Retail/E-commerce)
-- Tables: list_of_orders, order_details, sales_target
-- Source: Kaggle Orders dataset, loaded into PostgreSQL
-- Purpose: Practicing Window Functions Basics — OVER, 
--          PARTITION BY, ORDER BY (within window), combined 
--          with JOIN and prior functions for revision
-- ============================================

-- ===== SECTION 1: Basic Window Functions (no PARTITION yet) =====

--Q1: Show amount, and a new column with the running TOTAL sum of amount 
--    (SUM() OVER (ORDER BY amount)) — this shows a cumulative total
SELECT amount, SUM(amount) OVER (ORDER BY amount)
AS total_sum
FROM order_details;

--Q2: Show order_id, amount, and the OVERALL total SUM of amount across 
--    the whole table (SUM(amount) OVER ()) — no PARTITION, no ORDER BY, 
--    same total on every row
SELECT order_id,amount, SUM(amount) OVER ()
AS total_amount
FROM order_details;

--Q3: Show amount and the OVERALL AVERAGE amount (AVG(amount) OVER ()) 
--    on every row
SELECT amount, AVG(amount) OVER ()
AS total_avg
FROM order_details;

--Q4: Show amount and the OVERALL MAX amount (MAX(amount) OVER ()) 
--    on every row
SELECT amount, MAX(amount) OVER () 
AS max_amount
FROM order_details;

--Q5: Show order_id, amount, and ROW_NUMBER() OVER (ORDER BY amount DESC) 
--    — this assigns a unique rank 1, 2, 3... based on amount, highest first
SELECT order_id, amount,ROW_NUMBER() OVER(ORDER BY amount DESC) AS TOTAL_ROW
FROM order_details;

-- ===== SECTION 2: PARTITION BY — window functions per group =====

--Q6: Show category, amount, and SUM(amount) OVER (PARTITION BY category) 
--    — the total amount for that row's category, on every row
SELECT category,amount, SUM(amount) OVER(PARTITION BY category) AS TOTAL_AMOUNT
FROM order_details;

--Q7: Show category, amount, and AVG(amount) OVER (PARTITION BY category) 
--    — the average amount for that row's category
SELECT category, amount ,AVG(amount) OVER(PARTITION BY category) AS tota_AVG
FROM order_details;

--Q8: Show category, amount, and COUNT(*) OVER (PARTITION BY category) 
--    — how many orders exist in that row's category
SELECT category,amount, COUNT(*) OVER(PARTITION BY category) AS tottal_categorys
FROM  order_details;

--Q9: Show sub_category, profit, and MAX(profit) OVER (PARTITION BY sub_category) 
--    — the highest profit within that sub_category
SELECT sub_category,profit,MAX(profit) OVER(PARTITION BY sub_category) AS MAX_profit
FROM order_details;

--Q10: Show state, amount, and MIN(amount) OVER (PARTITION BY state) — 
--     the lowest amount within that state 
SELECT state, amount ,MIN(amount)  OVER(PARTITION BY state) AS MIN_amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

-- ===== SECTION 3: PARTITION BY + ORDER BY (within window) =====

--Q11: Show category, amount, and ROW_NUMBER() OVER (PARTITION BY category 
--     ORDER BY amount DESC) — rank each order within its own category by amount
SELECT category,amount, ROW_NUMBER() OVER(PARTITION BY category ORDER BY amount DESC)
AS RANK_NUM
FROM order_details;

--Q12: Show category, amount, and a running total of amount within each 
--     category (SUM(amount) OVER (PARTITION BY category ORDER BY amount))
SELECT category,amount, SUM(amount) OVER(PARTITION BY category ORDER BY amount)
AS running_total_amount
FROM order_details;

--Q13: Show state, order_date, and ROW_NUMBER() OVER (PARTITION BY state 
--     ORDER BY order_date ASC) — number each order within a state by 
--     date, earliest first
SELECT state,order_date, ROW_NUMBER() OVER(PARTITION BY state ORDER BY order_date ASC)
FROM list_of_orders;

--Q14: Show customer_name, amount, and ROW_NUMBER() OVER (PARTITION BY 
--     customer_name ORDER BY amount DESC) — rank each customer's own 
--     orders by amount (needs JOIN)
SELECT customer_name,amount, ROW_NUMBER() OVER (PARTITION BY customer_name ORDER BY amount DESC)
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q15: Show category, profit, and a running total of profit within each 
--     category, ordered by order_date (needs JOIN with list_of_orders)
SELECT category,profit, SUM(profit) OVER(PARTITION BY category ORDER BY  order_date)  AS running_profit
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

-- ===== SECTION 4: Window Functions + WHERE/JOIN (revision) =====

--Q16: Show customer_name, category, amount, and SUM(amount) OVER 
--     (PARTITION BY category) — only for orders where amount > 500 
--     (remember: WHERE filters BEFORE the window function runs)
SELECT customer_name,category,amount, SUM(amount) OVER(PARTITION BY category)
AS total_amount FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE amount>500;

--Q17: Show state, amount, and AVG(amount) OVER (PARTITION BY state), 
--     only for profitable orders (profit > 0)
SELECT state, amount, AVG(amount) OVER (PARTITION BY state) AS total_avg
FROM List_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE profit>0;

--Q18: Show category, sub_category, and COUNT(*) OVER (PARTITION BY 
--     category) — only for orders placed in 2018
SELECT category, sub_category, 
COUNT(*) OVER (PARTITION BY category) AS category_count
FROM list_of_orders L
INNER JOIN order_details O ON L.order_id = O.order_id
WHERE EXTRACT(YEAR FROM order_date) = 2018;
--Q19: Show customer_name, city, amount, and MAX(amount) OVER (PARTITION 
--     BY city) — only for customers whose name starts with 'S'
SELECT customer_name,city,amount, MAX(amount) OVER (PARTITION BY city)
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE customer_name LIKE 'S%';

--Q20: Show category, amount, and ROW_NUMBER() OVER (PARTITION BY 
--     category ORDER BY amount DESC), only for the 'Electronics' and 
--     'Furniture' categories
SELECT category,amount, ROW_NUMBER() OVER(PARTITION BY category ORDER BY amount DESC)
FROM order_details 
WHERE 	category IN('Electronics','Furniture');

-- ===== SECTION 5: Window Functions + String/Numeric/CASE (revision) =====

--Q21: Show UPPER(category), amount, and ROUND(AVG(amount) OVER 
--     (PARTITION BY category)) — combining String + Numeric + Window
SELECT UPPER(category),amount, 
ROUND(AVG(amount) OVER(PARTITION BY category)) AS round_of_avg 
FROM order_details;

--Q22: Show category, amount, and a CASE-based column "vs_category_avg" 
--     — 'Above Average' if amount > AVG(amount) OVER (PARTITION BY 
--     category), else 'Below Average' (this compares each row to its 
--     own group's average — something GROUP BY alone cannot do easily)
SELECT 
category, 
amount, 
CASE 
WHEN amount > AVG(amount) OVER(PARTITION BY category) THEN 'Above Average'
ELSE 'Below Average'
END AS vs_category_avg
FROM order_details;

--Q23: Show customer_name (INITCAP), amount, and SUM(amount) OVER 
--     (PARTITION BY customer_name) as "customer_total_spend"
SELECT INITCAP(customer_name),amount, SUM(amount) OVER(PARTITION BY customer_name)
AS total_sum
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q24: Show category, ROUND(amount), and COUNT(*) OVER (PARTITION BY 
--     category) as "category_order_count"
SELECT category, ROUND(amount),COUNT(*) OVER(PARTITION BY category) category_order_count
FROM order_details;

--Q25: Show state, amount, and a CASE column "region_flag" combined with 
--     AVG(amount) OVER (PARTITION BY state) to show whether each order 
--     is above or below its state's average
SELECT 
L.state, 
O.amount, 
CASE 
WHEN O.amount > AVG(O.amount) OVER(PARTITION BY L.state) THEN 'Above Average'
ELSE 'Below Average'
END AS region_flag
FROM list_of_orders L
INNER JOIN order_details O ON L.order_id = O.order_id;


-- ===== SECTION 6: Real-world business scenarios =====

--Q26: Show category, order_id, amount, and the DIFFERENCE between this 
--     order's amount and the category's average amount (amount - 
--     AVG(amount) OVER (PARTITION BY category)) — this shows how far 
--     above/below average each order is
SELECT 
category, order_id, 
amount,  amount - AVG(amount) OVER(PARTITION BY category) AS diff_from_avg
FROM order_details;

--Q27: Show customer_name, order_date, and ROW_NUMBER() OVER (PARTITION 
--     BY customer_name ORDER BY order_date ASC) as "order_sequence" — 
--     this numbers each customer's orders in chronological order 
--     (1st order, 2nd order, etc.)
SELECT 
customer_name, order_date, 
ROW_NUMBER() OVER(PARTITION BY customer_name ORDER BY order_date ASC) AS order_sequence
FROM list_of_orders;

--Q28: Show category, amount, and what PERCENTAGE this order's amount 
--     represents of its category's total — ROUND((amount / SUM(amount) 
--     OVER (PARTITION BY category)) * 100, 2)
SELECT 
category, amount, 
ROUND((amount / SUM(amount) OVER(PARTITION BY category)) * 100, 2) AS pct_of_category_total
FROM order_details;

--Q29: Show state, city, amount, and COUNT(*) OVER (PARTITION BY state, 
--     city) — partitioning by TWO columns together (state AND city 
--     combination)
SELECT  state, city, amount,
COUNT(*) OVER(PARTITION BY state, city) AS city_order_count
FROM list_of_orders L
INNER JOIN order_details O
ON O.order_id=L.order_id;