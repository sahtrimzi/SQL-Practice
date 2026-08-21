-- ============================================
-- Dataset: Kaggle "Orders" Dataset (Retail/E-commerce)
-- Tables: list_of_orders, order_details, sales_target
-- Source: Kaggle Orders dataset, loaded into PostgreSQL
-- Purpose: Practicing CASE statements (simple + searched), 
--          combined with WHERE, JOIN, Set Operators, String 
--          and Numeric Functions for revision
-- ============================================

-- ===== SECTION 1: Basic Searched CASE =====

--Q1: Show amount along with a new column "value_tier" — 'High' if amount 
--    > 2000, 'Medium' if amount > 500, else 'Low'
SELECT amount,
CASE 
WHEN amount>2000 THEN 'High'
WHEN amount>500 THEN 'Medium'
ELSE 'Low'
END AS "value_tier"
FROM order_details;

--Q2: Show profit along with a new column "result" — 'Profit' if profit > 0, 
--    'Loss' if profit < 0, else 'Break-even'
SELECT profit,
CASE
WHEN profit>0 THEN 'Profit'
WHEN profit<0 THEN 'Loss'
ELSE 'Break-even'
END AS "result"
FROM order_details;

--Q3: Show quantity along with a new column "order_size" — 'Bulk' if 
--    quantity >= 10, 'Normal' otherwise
SELECT quantity,
CASE 
WHEN quantity>=10 THEN 'Bulk'
ELSE 'Normal'
END AS "order_size"
FROM order_details;

--Q4: Show customer_name and a new column "name_length_category" — 'Long' 
--    if LENGTH(customer_name) > 10, else 'Short'
SELECT customer_name,
CASE 
WHEN LENGTH(customer_name)>10 THEN 'Long'
ELSE 'Short'
END AS "name_length_category"
FROM list_of_orders;

--Q5: Show category along with a new column "category_type" using simple 
--    CASE — 'Tech' for Electronics, 'Home' for Furniture, 'Apparel' for 
--    Clothing
SELECT category,
CASE 
WHEN category='Electronics' THEN 'Tech'
WHEN category='Furniture' THEN 'Home'
WHEN category='Clothing' THEN 'Apparel'
END AS "category_type"
FROM order_details;

-- ===== SECTION 2: CASE + WHERE (revision) =====

--Q6: Show amount and value_tier (High/Medium/Low, as in Q1) but only for 
--    orders in the 'Electronics' category
SELECT amount,
CASE 
WHEN amount>2000 THEN 'High'
WHEN amount>500 THEN 'Medium'
ELSE 'Low'
END AS "value_tier"
FROM order_details 
WHERE category='Electronics';

--Q7: Show profit and result (Profit/Loss/Break-even) but only for orders 
--    placed after '2018-04-01'
SELECT profit,
CASE 
WHEN profit>0 THEN 'Profit'
WHEN Profit<0 THEN 'Loss'
ELSE 'Break-even'
END AS "result"
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE order_date>'2018-04-01';

--Q8: Find all orders where the CASE-derived value_tier would be 'High' 
--    (amount > 2000) — hint: you can filter using the same condition in WHERE
SELECT amount,
CASE 
WHEN amount>2000 THEN 'High'
END AS value_tier
FROM order_details 
WHERE amount>2000; 

--Q9: Show quantity and order_size (Bulk/Normal) only for the 'Furniture' 
--    category
SELECT quantity,
CASE 
WHEN quantity>=10 THEN 'Bulk'
ELSE 'Normal'
END AS "order_size"
FROM order_details 
WHERE category ='Furniture';

--Q10: Show customer_name and name_length_category, only for customers 
--     from 'Maharashtra'
SELECT customer_name,
CASE 
WHEN LENGTH(customer_name)>10 THEN 'Long'
ELSE 'Short'
END AS "name_length_category"
FROM list_of_orders
WHERE state ='Maharashtra';

-- ===== SECTION 3: CASE + JOIN (revision) =====

--Q11: Show customer_name, amount, and value_tier for every order line 
--     item (use JOIN)
SELECT customer_name, amount,
CASE 
WHEN amount>2000 THEN 'High'
WHEN amount>500 THEN 'Medium'
ELSE 'Low'
END AS "value_tier"
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q12: Show customer_name, profit, and result (Profit/Loss/Break-even) 
--     for all orders
SELECT customer_name,profit,
CASE 
WHEN profit>0 THEN 'Profit'
WHEN Profit<0 THEN ' Loss'
ELSE 'Break-even'
END AS "result"
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q13: Show customer_name, city, and a new column "region_type" — 
--     'Metro' if city is 'Mumbai', 'Delhi', 'Bangalore', or 'Kolkata', 
--     else 'Non-Metro'
SELECT customer_name,city,
CASE 
WHEN city= 'Mumbai' OR city='Delhi'OR city='Bangalore'OR city='Kolkata' THEN 'Metro'
ELSE 'Non-Metro'
END AS"region_type"
FROM  list_of_orders;

--Q14: Show category, sub_category, and a new column "priority" — 'Urgent' 
--     if quantity > 8, 'Standard' otherwise
SELECT category,sub_category,
CASE WHEN quantity>8 THEN 'Urgent'
ELSE 'Standard'
END AS "priority"
FROM order_details;

--Q15: Show customer_name and a new column "spender_type" — 'Big Spender' 
--     if amount > 3000, 'Regular' if amount > 1000, else 'Small'
SELECT customer_name,
CASE
WHEN amount>3000 THEN 'Big Spender'
WHEN amount>1000 THEN 'Regular' 
ELSE 'Small'
END AS spender_type
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

-- ===== SECTION 4: CASE + Set Operators (revision) =====

--Q16: Show customer_name and value_tier for 'Electronics' orders UNION 
--     customer_name and value_tier for 'Furniture' orders
SELECT customer_name, amount,
CASE 
WHEN amount>2000 THEN 'High'
WHEN amount>500 THEN 'Medium'
ELSE 'Low'
END AS value_of_tier
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Electronics'
UNION
SELECT customer_name, amount,
CASE 
WHEN amount>2000 THEN 'High'
WHEN amount>500 THEN 'Medium'
ELSE 'Low'
END 
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Furniture';

--Q17: Find customer_names with result = 'Loss' in 'Clothing' category 
--     INTERSECT customer_names with result = 'Loss' in 'Electronics' 
--     category (hint: select only customer_name to avoid the INTERSECT 
--     extra-column trap)
SELECT customer_name,
CASE
WHEN profit<0 THEN 'Loss'
END AS result
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE  category='Clothing' AND profit<0
INTERSECT
SELECT customer_name,
CASE
WHEN profit<0 THEN 'Loss'
END AS result
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE  category='Electronics' AND profit<0;

--18: Show customer_name for orders where order_size = 'Bulk' in 
--     'Furniture' EXCEPT customer_name for orders where profit < 0
SELECT customer_name,
CASE 
WHEN quantity>=10 THEN 'Bulk'
ELSE 'Normal'
END AS order_size
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Furniture' AND quantity>=10
EXCEPT 
SELECT customer_name,
CASE 
WHEN quantity>=10 THEN 'Bulk'
ELSE 'Normal'
END AS order_size
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE profit<0;

--Q19: Combine (UNION) customer_names with spender_type = 'Big Spender' 
--     from 'Electronics' with customer_names with spender_type = 
--     'Big Spender' from 'Furniture'
SELECT customer_name
FROM list_of_orders L
INNER JOIN order_details O ON L.order_id=O.order_id
WHERE category='Electronics' AND amount>3000
UNION
SELECT customer_name
FROM list_of_orders L
INNER JOIN order_details O ON L.order_id=O.order_id
WHERE category='Furniture' AND amount>3000;

--Q20: Find sub_categories that appear in both 'High' value_tier orders 
--     AND profitable orders (profit > 0) — use INTERSECT, selecting 
--     only sub_category
SELECT sub_category
FROM order_details 
WHERE amount > 2000
INTERSECT
SELECT sub_category
FROM order_details 
WHERE profit > 0;

-- ===== SECTION 5: CASE + String/Numeric Functions (revision) =====

--Q21: Show UPPER(customer_name) along with value_tier, for orders where 
--     amount > 1000
SELECT  UPPER(customer_name)AS customer_name,
CASE 
WHEN amount>2000 THEN 'High'
ELSE 'LOW'
END AS value_tier
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE amount>1000;

--Q22: Show customer_name combined with their spender_type as one string, 
--     e.g., "Ali - Big Spender" (use CONCAT with CASE)
SELECT CONCAT(customer_name,' - ',
CASE
WHEN amount>3000 THEN 'Big Spender'
WHEN amount>1000 THEN 'Regular' 
ELSE 'Small'
END) AS spender_type
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q23: Show ROUND(amount) along with a new column "rounded_tier" — 'High' 
--     if ROUND(amount) > 2000, else 'Low'
SELECT ROUND(amount),
CASE 
WHEN ROUND(amount)>2000 THEN 'High'
ELSE 'Low'
END AS rounded_tier
FROM order_details;

--Q24: Show category (uppercase) and a new column "margin_health" — 
--     'Healthy' if ABS(profit) < 100, 'Risky' otherwise
SELECT 
UPPER(category),
CASE 
WHEN ABS(profit)<100 THEN 'Healthy'
ELSE 'Risky'
END AS margin_health
FROM order_details;

--Q25: Show customer_name (INITCAP) and result (Profit/Loss/Break-even), 
--     for all orders with quantity > 5
SELECT INITCAP(customer_name),
CASE
WHEN profit>0 THEN 'Profit'
WHEN profit<0 THEN 'Loss'
ELSE 'Break-even'
END AS "result"
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE quantity >5;

-- ===== SECTION 6: Real-world business scenarios (nested/multi-condition CASE) =====

--Q26: Show customer_name, amount, profit, and a new column 
--     "order_health" combining both — 'Great' if amount > 1500 AND 
--     profit > 0, 'Risky' if amount > 1500 AND profit < 0, 'Standard' 
--     otherwise (nested conditions inside CASE)
SELECT customer_name,amount,profit,
CASE 
WHEN amount > 1500 AND profit > 0 THEN 'Great'
WHEN amount > 1500 AND profit < 0 THEN 'Risky'
ELSE 'Standard'
END order_health
FROM list_of_orders L
INNER JOIN order_details O
ON O.order_id=L.order_id;

--Q27: Show category and a new column "target_status" — 'Above Target' 
--     if the order's amount exceeds the category's sales_target for 
--     that month, 'Below Target' otherwise (JOIN with sales_target, 
--     then CASE)
SELECT 
 o.category,
CASE 
WHEN o.amount > st.target THEN 'Above Target'
ELSE 'Below Target'
END AS target_status
FROM order_details o
INNER JOIN sales_target st
ON o.category = st.category;

--Q28: Count how many orders fall into each value_tier (High/Medium/Low) 
--     — hint: this needs CASE inside a GROUP BY (a preview of combining 
--     CASE with Aggregate Functions, which comes next)
SELECT 
CASE 
WHEN amount > 2000 THEN 'High'
WHEN amount > 500 THEN 'Medium'
ELSE 'Low'
END AS value_tier,
COUNT(order_id) AS total_orders
FROM order_details
GROUP BY 
CASE 
WHEN amount > 2000 THEN 'High'
WHEN amount > 500 THEN 'Medium'
ELSE 'Low'
END;

--Q29: Show customer_name and a new column "loyalty_flag" — 'Frequent 
--     Buyer' if customer_name appears more than once in list_of_orders 
--     for city = 'Mumbai', else 'One-time' (hint: this is tricky without 
--     aggregation — think about whether a simple CASE can solve it, or 
--     if it needs COUNT first; note your reasoning as a comment)
-- Reasoning: Standard CASE expressions evaluate rows individually and cannot count occurrences 
-- across multiple rows on their own. To determine if a customer appears more than once in 'Mumbai', 
-- we must aggregate the order counts using COUNT() within a GROUP BY
SELECT 
customer_name,
CASE 
WHEN COUNT(order_id) > 1 THEN 'Frequent Buyer'
ELSE 'One-time'
END AS loyalty_flag
FROM list_of_orders
WHERE city = 'Mumbai'
GROUP BY customer_name;

--Q30: Show customer_name, state, and a new column "state_group" using 
--     simple CASE — group states into 'North' (Punjab, Haryana, Delhi, 
--     Rajasthan), 'South' (Karnataka, Tamil Nadu), 'West' (Maharashtra, 
--     Gujarat), else 'Other'
SELECT 
customer_name,"state",
 CASE 
 WHEN "state" IN('Punjab', 'Haryana', 'Delhi', 'Rajasthan') THEN 'North'
 WHEN "state" IN('Karnataka', 'Tamil Nadu') THEN 'South'
 WHEN "state" IN('Maharashtra', 'Gujarat') THEN 'West'
 ELSE 'Other'
 END AS state_group
 FROM list_of_orders 
