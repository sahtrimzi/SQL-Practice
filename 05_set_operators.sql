-- ============================================
-- Dataset: Kaggle "Orders" Dataset (Retail/E-commerce)
-- Tables: list_of_orders, order_details, sales_target
-- Source: Kaggle Orders dataset, loaded into PostgreSQL
-- Purpose: Practicing Set Operators (UNION, UNION ALL, 
--          INTERSECT, EXCEPT) combined with WHERE and JOIN 
--          for revision
-- ============================================

-- ===== SECTION 1: UNION — combining two filtered lists =====

--Q1: Show customer_name of customers from 'Maharashtra' combined with 
--    customer_name of customers from 'Gujarat' (no duplicates)
SELECT  customer_name,"state" FROM list_of_orders
WHERE "state"='Maharashtra'
UNION 
SELECT customer_name,"state" FROM list_of_orders
WHERE "state"='Gujarat';

--Q2: List order_id from orders placed before '2018-03-01' combined with 
--    order_id from orders placed after '2018-06-01' 
--NOTE:this question we also solve through the Between but WE use set operator to understand the syntax
SELECT order_id,order_date FROM list_of_orders
WHERE order_date<'2018-03-01'
UNION
SELECT order_id,order_date FROM list_of_orders
WHERE order_date>'2018-06-01';

--Q3: Show customer_name for customers from 'Delhi' UNION customer_name 
--    for customers whose name starts with 'A'
--NOTE:this question we also solve through the OR operatore but WE use set operatore to understand the syntax 
SELECT  customer_name FROM list_of_orders
WHERE city='Delhi' 
UNION 
SELECT customer_name FROM list_of_orders
WHERE customer_name LIKE 'A%';

--Q4: Combine city names from orders where amount > 2000 with city names 
--    from orders where profit < 0 (no duplicate cities) 
--NOTE:this question we also solve through the OR operatore but WE use set operatore to understand the syntax 
SELECT city FROM list_of_orders L 
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE amount >2000
UNION 
SELECT city FROM list_of_orders L 
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE profit<0;

--Q5: List sub_category from 'Electronics' category UNION sub_category 
--    from 'Furniture' category (all unique sub-categories across both) 
--NOTE:this question we also solve Nthrough the AND  operatore but WE use set operatore to understand the syntax
SELECT sub_category  FROM order_details
WHERE category='Electronics'
UNION
SELECT sub_category FROM order_details
WHERE category='Furniture';

-- ===== SECTION 2: UNION ALL — same as above but keeping duplicates =====

--Q6: Show customer_name from orders in 'Punjab' UNION ALL customer_name 
--    from orders in 'Haryana' (duplicates allowed, since a customer 
--    could appear multiple times in each)
SELECT customer_name FROM list_of_orders
WHERE "state"='Punjab'
UNION ALL
SELECT customer_name FROM list_of_orders
WHERE "state"='Haryana';

--Q7: List order_id + amount for orders over 3000 UNION ALL order_id + 
--    amount for orders with negative profit (a loss-making order over 
--    3000 would appear twice — that's expected)
SELECT order_id,amount FROM order_details
WHERE amount>3000
UNION ALL
SELECT order_id,amount FROM order_details
WHERE profit<0

--Q8: Combine category from all 'Electronics' orders UNION ALL category 
--    from all 'Clothing' orders — count how many total rows this produces
SELECT order_id,category FROM order_details
WHERE category='Electronics'
UNION ALL
SELECT order_id,category FROM order_details
WHERE category='Clothing';

--Q9: Show state from orders placed in April 2018 UNION ALL state from 
--    orders placed in May 2018
SELECT "state" FROM list_of_orders
WHERE order_date BETWEEN'2018-04-01'AND'2018-04-30'
UNION ALL
SELECT order_id,customer_name FROM list_of_orders
WHERE order_date BETWEEN'2018-05-01'AND'2018-05-31';

--Q10: Compare the row count difference between using UNION vs UNION ALL 
--     when combining customer_name from 'Mumbai' orders and customer_name 
--     from 'Kolkata' orders — write both queries and note why the counts diffe
SELECT customer_name FROM list_of_orders
WHERE "city"='Mumbai'
UNION
SELECT customer_name FROM list_of_orders
WHERE "city"='Kolkata';
SELECT customer_name FROM list_of_orders
WHERE "city"='Mumbai'
UNION ALL
SELECT customer_name FROM list_of_orders
WHERE "city"='Kolkata';
--Both rows are different because in union donot retrieve duplicate data but 
--union all retrieve the duplicate data also 

-- ===== SECTION 3: INTERSECT — finding common records =====

--Q11: Find customer_names that appear in BOTH the 'Electronics' category 
--     AND the 'Furniture' category (customers who bought both) — use a 
--     JOIN to get customer_name per order, then INTERSECT

SELECT DISTINCT
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE O.category='Furniture'
INTERSECT
SELECT DISTINCT
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE O.category ='Electronics';

--Q12: Find states that have BOTH profitable orders (profit > 0) AND 
--     loss-making orders (profit < 0)
SELECT 
L.state
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE profit>0 
INTERSECT
SELECT 
L.state
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE profit<0;

--Q13: Find customer_names who placed orders in BOTH 'Maharashtra' 
--     deliveries AND orders with amount > 2000
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE "state"='Maharashtra'
INTERSECT
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE amount>2000

--Q14: Find cities that appear in orders from BOTH the first quarter 
--     (Jan-Mar 2018) AND the second quarter (Apr-Jun 2018)
SELECT 
L.city
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE order_date BETWEEN '2018-01-01' AND '2018-03-31'
INTERSECT 
SELECT 
L.city
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE order_date BETWEEN '2018-04-01' AND '2018-06-30';

--Q15: Find sub_categories that exist in BOTH orders with quantity >= 5 
--     AND orders with quantity <= 2 (sub-categories ordered in both 
--     small and large quantities)
SELECT 
O.sub_category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE quantity >=5
INTERSECT
SELECT 
O.sub_category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE quantity <=2

-- ===== SECTION 4: EXCEPT — finding differences =====

--Q16: Find customer_names who bought 'Electronics' but have NEVER bought 
--     'Furniture' (use JOIN to get customer_name per category, then EXCEPT)
SELECT
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category ='Electronics'
EXCEPT
SELECT
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category ='Furniture';

--Q17: Find states that have profitable orders but have NEVER had a 
--     loss-making order 
SELECT 
L.state
FROM list_of_orders L
INNER JOIN order_details O 
ON L.order_id=O.order_id
WHERE profit>0
EXCEPT
SELECT 
L.state
FROM list_of_orders L
INNER JOIN order_details O 
ON L.order_id=O.order_id
WHERE profit<0;

--Q18: Find order_ids from list_of_orders that do NOT appear in the set 
--     of orders with category = 'Clothing' (i.e., orders that never 
--     contain a Clothing item)
SELECT 
L.order_id
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
EXCEPT 
SELECT 
L.order_id
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category ='Clothing';

--Q19: Find cities that placed orders in Q1 2018 (Jan-Mar) but did NOT 
--     place any orders in Q2 2018 (Apr-Jun)
SELECT city 
FROM list_of_orders 
WHERE order_date BETWEEN '2018-01-01' AND '2018-03-31'
EXCEPT
SELECT city 
FROM list_of_orders 
WHERE order_date BETWEEN '2018-04-01' AND '2018-06-30';

--Q20: Find customer_names who ordered from 'Mumbai' but have never 
--     placed an order with amount greater than 1000
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE city='Mumbai'
EXCEPT
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE amount>1000

-- ===== SECTION 5: Combined business scenarios (JOIN + WHERE + Set Operators) ====

--Q21: List customer_name and city for high-value orders (amount > 2000) 
--     in 'Maharashtra', UNION customer_name and city for high-value 
--     orders in 'Karnataka' — use INNER JOIN to pull customer_name and 
--     city, filter with WHERE, then combine with UNION
SELECT 
L.customer_name,
L.city
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE amount>2000 AND "state"='Maharashtra'
UNION 
SELECT 
L.customer_name,
L.city
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE amount>2000 AND "state"='Karnataka';

--Q22: Find customer_names who bought Furniture in April 2018 UNION 
--     customer_names who bought Electronics in May 2018 (JOIN + WHERE 
--     date filtering + UNION)
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Furniture' AND order_date BETWEEN '2018-04-01' AND '2018-04-30'
UNION
SELECT 
L.customer_name 
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Electronics' AND order_date BETWEEN '2018-05-01' AND '2018-05-31'

--Q23: Find customer_names who placed profitable orders (profit > 0) 
--     INTERSECT customer_names who placed orders with quantity >= 5 
--     (customers who did both)
SELECT
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE profit>0
INTERSECT
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE quantity>=5;

--Q24: Find states with Furniture sales targets (from sales_target) 
--     INTERSECT states that actually placed Furniture orders (join 
--     order_details to list_of_orders to get state, then intersect 
--     with a distinct category check) 
-- NOTE : WE donot use in intersect operation because state column are not in sales_target table 
SELECT DISTINCT 
    L.state
FROM list_of_orders L
INNER JOIN order_details O 
    ON L.order_id = O.order_id
INNER JOIN sales_target S 
    ON O.category = S.category
WHERE S.category = 'Furniture';

--Q25: List customer_names who ordered 'Chairs' or 'Tables' sub_category, 
--     EXCEPT customer_names who had any loss-making (profit < 0) order
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE sub_category IN('Chairs','Tables')
EXCEPT 
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE profit<0;

--Q26: Combine (UNION) the list of customer_names from loss-making 
--     Electronics orders with customer_names from loss-making Clothing 
--     orders, filtered to only orders placed after '2018-01-01'
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Electronics' AND profit<0
UNION 
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Clothing' AND profit<0 AND order_date>'2018-01-01';

--Q27: Find sub_categories ordered by customers in 'Gujarat' INTERSECT 
--     sub_categories ordered by customers in 'Rajasthan' (sub-categories 
--     popular in both states)
SELECT 
O.sub_category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE "state"='Gujarat'
INTERSECT
SELECT 
O.sub_category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE "state"='Rajasthan'

--Q28: Find customer_names from orders with quantity between 3 and 8 in 
--     the 'Electronics' category, EXCEPT customer_names who ever placed 
--     an order in the 'Clothing' category
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE quantity BETWEEN 3 AND 8 AND category='Electronics'
EXCEPT 
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Clothing';

--Q29: List distinct city names from all profitable Furniture orders 
--     UNION distinct city names from all profitable Electronics orders, 
--     ordered alphabetically (combine Set Operator with ORDER BY)
SELECT DISTINCT
L.city
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Furniture' AND profit>0
UNION
SELECT DISTINCT
L.city
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Electronics' AND profit>0
ORDER BY city ASC;

--Q30: Find customer_names who bought from 'Electronics' AND 'Furniture' 
--     AND 'Clothing' — all three categories (hint: chain two INTERSECTs 
--     together, using JOIN + WHERE to build each category's customer list)
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Electronics'
INTERSECT
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Furniture'
INTERSECT
SELECT 
L.customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Clothing';














