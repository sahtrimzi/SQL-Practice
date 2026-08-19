-- ============================================
-- Dataset: Kaggle "Orders" Dataset (Retail/E-commerce)
-- Tables: list_of_orders, order_details, sales_target
-- Source: Kaggle Orders dataset, loaded into PostgreSQL
-- Purpose: Practicing Numeric Functions, combined with WHERE, 
--          JOIN, Set Operators, and String Functions for revision
-- ============================================

-- ===== SECTION 1: Basic Numeric Functions =====

--Q1: Show amount rounded to the nearest whole number (0 decimal places), 
--    alongside the original amount
SELECT amount,ROUND(amount,0) AS Round_amount
FROM order_details;

--Q2: Show profit as an ABSOLUTE value (no negative signs), alongside the 
--    original profit
SELECT  profit,ABS(profit) AS Positive
FROM order_details;

--Q3: Show amount rounded to 1 decimal place
SELECT amount,ROUND(amount,1) AS Round_amount
FROM order_details;

--Q4: Show the CEIL (round up) and FLOOR (round down) of amount, side by side
SELECT 
amount,CEIL(amount)  AS amount_ceil, 
FLOOR(amount) AS amount_floor FROM order_details;

--Q5: Show quantity multiplied by itself (use POWER, quantity to the power of 2)
SELECT quantity,POWER(quantity,2) AS multiply 
FROM order_details;

-- ===== SECTION 2: Numeric Functions + WHERE (revision) =====

--Q6: Find orders where the ABSOLUTE value of profit is greater than 500 
--    (large gains or large losses)
SELECT ABS(profit) AS profit FROM 
order_details 
WHERE ABS(profit)>500;

--Q7: Show amount rounded to 0 decimals, but only for orders where 
--    category is 'Electronics'
SELECT ROUND(amount,0)
FROM order_details
WHERE category='Electronics';

--Q8: Find orders where quantity, when divided by 2, has a remainder of 
--    1 (odd quantities) — use MOD
SELECT quantity FROM order_details
WHERE MOD(quantity, 2) = 1;

--Q9: Show orders where FLOOR(amount) is greater than 1000
SELECT FLOOR(amount) AS AMOUNT
FROM order_details
WHERE  FLOOR(amount)>1000;

--Q10: Find orders where SIGN(profit) equals -1 (confirms the order was 
--     a loss) — this should match the same rows as profit < 0
SELECT profit,SIGN(profit) = -1
FROM  order_details
WHERE profit=-1;

-- ===== SECTION 3: Numeric Functions + JOIN (revision) =====

--Q11: Show customer_name along with ROUND(amount) for every order line item
SELECT 
L.customer_name,
ROUND(amount) AS round_of_amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q12: Show customer_name and the ABSOLUTE value of profit, for all orders 
--     in the 'Furniture' category
SELECT 
L.customer_name,
ABS(profit) AS absolute_profit
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Furniture';

--Q13: Show category and the average-looking rounded amount (ROUND to 0 
--     decimals) for every order — use JOIN
SELECT 
O.category,
ROUND(amount,0) AS round_of_amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q14: Find orders where quantity is a perfect square (hint: compare 
--     quantity to POWER(ROUND(SQRT(quantity)), 2))
SELECT quantity
FROM order_details
WHERE quantity = POWER(ROUND(SQRT(quantity)), 2);

--Q15: Show customer_name, city, and CEIL(amount) for orders where profit 
--     is negative
SELECT 
L.customer_name,
L.city,
CEIL(amount) AS amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE profit<0;

-- ===== SECTION 4: Numeric Functions + Set Operators (revision) =====

--Q16: Show ROUND(amount) for orders in 'Electronics' UNION ROUND(amount) 
--     for orders in 'Furniture'
SELECT
ROUND(amount) AS amount
FROM order_details 
WHERE category='Electronics'
UNION
SELECT
ROUND(amount)
FROM order_details 
WHERE category='Furniture';

--Q17: Find customer_names where ABS(profit) > 300 in the 'Clothing' 
--     category INTERSECT customer_names where ABS(profit) > 300 in the 
--     'Electronics' category
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE ABS(profit)>300 AND category='Clothing'
INTERSECT
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE ABS(profit)>300 AND category='Electronics';

--Q18: Show FLOOR(amount) for orders from 'Punjab' EXCEPT FLOOR(amount) 
--     for orders from 'Haryana'
SELECT 
FLOOR(amount)AS amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE state='Punjab'
EXCEPT 
SELECT 
FLOOR(amount)AS amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE state='Haryana';

--Q19: Combine (UNION) customer_names with even quantity (MOD(quantity,2)=0) 
--     from 'Furniture' orders with customer_names with even quantity 
--     from 'Electronics' orders
SELECT customer_name
FROM list_of_orders L
INNER JOIN order_details O 
ON L.order_id=O.order_id
WHERE category='Furniture' AND MOD(quantity,2)=0
UNION
SELECT customer_name
FROM list_of_orders L
INNER JOIN order_details O 
ON L.order_id=O.order_id
WHERE category='Electronics' AND MOD(quantity,2)=0;

--Q20: Find sub_categories where ROUND(amount) > 1000 INTERSECT 
--     sub_categories where ROUND(profit) > 0
SELECT
sub_category
FROM order_details
WHERE ROUND(amount)>1000
INTERSECT
SELECT 
sub_category
FROM order_details
WHERE ROUND(profit)>0;

-- ===== SECTION 5: Numeric Functions + String Functions (revision) =====

--Q21: Show UPPER(customer_name) along with ROUND(amount) for orders 
--     where amount > 1500
SELECT 
UPPER(L.customer_name) AS customer_name,
ROUND(O.amount) AS amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE ROUND(O.amount)>1500;

--Q22: Show customer_name combined with its rounded amount as one string, 
--     e.g., "Ali - 1500" (use CONCAT with ROUND, cast the number to TEXT)
SELECT
CONCAT(customer_name,' - ',ROUND(amount))
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q23: Find customer_names (LENGTH > 8) where ABS(profit) is greater 
--     than 400
SELECT 
L.customer_name,
LENGTH(customer_name) AS name_length
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE ABS(profit)>400 AND LENGTH(customer_name)>8 ;

--Q24: Show sub_category (uppercase) along with FLOOR(amount), for all 
--     Furniture orders
SELECT 
UPPER(sub_category) AS sub_category,
FLOOR(amount) AS floor_amount
FROM order_details
WHERE category='Furniture';

--Q25: Show customer_name (INITCAP) along with the SIGN of profit 
--     (1, -1, or 0), for all orders
SELECT
INITCAP(L.customer_name),
SIGN(profit) AS profit_SIGN
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;



















 




