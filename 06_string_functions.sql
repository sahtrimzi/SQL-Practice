-- ============================================
-- Dataset: Kaggle "Orders" Dataset (Retail/E-commerce)
-- Tables: list_of_orders, order_details, sales_target
-- Source: Kaggle Orders dataset, loaded into PostgreSQL
-- Purpose: Practicing String Functions, combined with WHERE, 
--          JOIN, and Set Operators for revision
-- ============================================

-- ===== SECTION 1: Basic String Functions =====

--Q1: Show customer_name in all UPPERCASE letters
SELECT customer_name, UPPER(customer_name) AS upper_case 
FROM list_of_orders;

--Q2: Show city names in all lowercase letters
SELECT city,LOWER(city) AS lower_case FROM list_of_orders;

--Q3: Show customer_name and city combined into a single column, separated 
--    by a comma and space 
SELECT customer_name,city, CONCAT(customer_name, ', ',city) AS combine
FROM list_of_orders;

--Q4: Show customer_name with its LENGTH (number of characters) as a separate column
SELECT customer_name,LENGTH(customer_name) AS length_names
FROM list_of_orders;


--Q5: Show customer_name with each word's first letter capitalized (use INITCAP)
SELECT customer_name,INITCAP(customer_name) AS first_letter_capitalized
FROM list_of_orders;

-- ===== SECTION 2: String Functions + WHERE (revision) =====

--Q6: Find customers whose customer_name has a LENGTH greater than 10 characters
SELECT customer_name,LENGTH(customer_name) 	cus_len
FROM list_of_orders
WHERE LENGTH(customer_name)>10;

--Q7: Show customer_name in UPPERCASE, but only for customers from 'Maharashtra'
SELECT customer_name,UPPER(customer_name) AS upper_case
FROM list_of_orders
WHERE state ='Maharashtra';

--Q8: Find customers whose city, when converted to lowercase, equals 'mumbai' 
SELECT LOWER(customer_name)AS cus_name,
LOWER(city) AS city FROM list_of_orders
WHERE city='Mumbai';

--Q9: Show the first 3 letters of customer_name  for customers 
--    whose amount was greater than 1000
SELECT 
LEFT(customer_name ,3) AS customer_name 
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE amount>1000;

--Q10: Find sub_category values where REPLACE-ing 'Phone' with 'Mobile' 
--     would change the text (i.e., sub_category contains 'Phone')
--NOTE : In This query we use = because we know in our date base Phones find exact Instead of using like  
SELECT sub_category,
REPLACE(sub_category,'Phone','Mobile')
FROM order_details
WHERE sub_category ='Phones';

-- ===== SECTION 3: String Functions + JOIN (revision) =====

--Q11: Show customer_name (uppercase) along with category, for every order 
--     — use INNER JOIN
SELECT 
UPPER(L.customer_name) AS upper_name,
UPPER(O.category) AS upper_category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q12: Show the last 4 characters of customer_name (use RIGHT) along with 
--     the amount, for all order line items
SELECT 
O.amount
RIGHT(customer_name,4)
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q13: Show a combined string "customer_name - category" (e.g., "Ali - 
--     Electronics") for every order — use JOIN and CONCAT/||
SELECT 
CONCAT(customer_name,' ',category)
FROM list_of_orders L 
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q14: Find the LENGTH of each sub_category name, along with customer_name, 
--     for orders in the 'Furniture' category
SELECT 
L.customer_name,
LENGTH(sub_category) AS len_sub_cat
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Furniture';

--Q15: Show customer_name with extra spaces trimmed (use TRIM), along with 
--     city, for orders where profit was negative
SELECT 
TRIM(L.customer_name) AS customer_name,
L.city
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id = O.order_id
WHERE O.profit < 0;

-- ===== SECTION 4: String Functions + Set Operators (revision) =====

--Q16: Show UPPERCASE customer_name from 'Punjab' UNION UPPERCASE 
--     customer_name from 'Haryana'
SELECT
UPPER(customer_name)
FROM list_of_orders
WHERE state='Punjab'
UNION 
SELECT
UPPER(customer_name)
FROM list_of_orders
WHERE state='Haryana';

--Q17: Find customer_names (with LENGTH > 8) who bought 'Electronics' 
--     INTERSECT customer_names (with LENGTH > 8) who bought 'Furniture'
SELECT 
L.customer_name,
LENGTH(customer_name) AS length_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Electronics' 
AND LENGTH(customer_name)>8
INTERSECT
SELECT 
L.customer_name,
LENGTH(customer_name)  AS length_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Furniture' 
AND LENGTH(customer_name)>8;

--Q18: Show customer_name in lowercase for customers who ordered 'Chairs' 
--     EXCEPT customer_name in lowercase for customers who had a 
--     loss-making order (profit < 0)
SELECT
LOWER(customer_name) AS customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE sub_category='Chairs'
EXCEPT
SELECT
LOWER(customer_name) AS customer_name
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE profit<0;

--Q19: Combine (UNION) the first letter of customer_name (use LEFT with 
--     n=1) for customers from 'Gujarat' with the first letter of 
--     customer_name for customers from 'Rajasthan'
SELECT 
LEFT(customer_name,1)
FROM  list_of_orders
WHERE state='Gujarat'
UNION
SELECT 
LEFT(customer_name,1)
FROM  list_of_orders
WHERE state='Rajasthan';

--Q20: Find sub_category names (uppercase) ordered by customers in 
--     'Delhi' UNION sub_category names (uppercase) ordered by customers 
--     in 'Mumbai'
SELECT 
UPPER(sub_category)
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE city='Delhi'
UNION
SELECT 
UPPER(sub_category)
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE city='Mumbai';

-- ===== SECTION 5: Real-world business scenarios (all combined) =====

--Q21: Show customer_name and city combined as "City: Mumbai | Customer: Ali" 
--     format, for orders where amount > 2000 
SELECT 
CONCAT('City',': ',city, ' | ','Customer' ,': ', customer_name) AS Combine
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE amount>2000;

--Q22: Find customer_names where the customer_name contains the letter 'a' 
--     at least twice 

SELECT 
customer_name,
LENGTH(customer_name) AS name_len
FROM list_of_orders
WHERE LOWER(customer_name) LIKE '%a%a%';

--Q23: Show category and sub_category combined into one column as 
--     "Electronics > Phones" format, for all Electronics orders (JOIN + CONCAT + WHERE)
SELECT 
CONCAT(category,' > ',sub_category)
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Electronics';

--Q24: Find customer_names whose name, when uppercased, starts with 'S' 
--     — combine UPPER() with LIKE
SELECT 
UPPER(customer_name) AS customer_name
FROM list_of_orders L
WHERE customer_name like 'S%';

--Q25: Show a cleaned-up customer_name (TRIM applied) along with order_id, 
--     for orders placed in 'Kolkata' (String function + WHERE)
SELECT 
order_id,
TRIM(customer_name) AS customer_name
FROM list_of_orders
WHERE city ='Kolkata';

--Q26: List all distinct first letters (LEFT with n=1) of city names, 
--     across all orders — use DISTINCT with LEFT
SELECT DISTINCT
LEFT(city,1) AS first_letter
FROM list_of_orders;

--Q27: Find customer_names who bought Electronics with name LENGTH < 6 
--     UNION customer_names who bought Furniture with name LENGTH < 6
SELECT 
customer_name,
LENGTH(customer_name) AS length_name 
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Electronics'
AND LENGTH(customer_name)<6
UNION
SELECT 
customer_name,
LENGTH(customer_name)
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Furniture'
AND LENGTH(customer_name)<6;

--Q28: Show sub_category with 'Table' replaced by 'Desk' (use REPLACE), 
--     along with customer_name, for all Furniture orders
SELECT 
customer_name,
REPLACE(sub_category,'Table','Desk') 
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Furniture';

--Q29: Find the POSITION of the letter 'a' (first occurrence) within 
--     customer_name, shown alongside customer_name, for customers 
--     from 'Punjab'
SELECT 
customer_name,
POSITION('a' IN customer_name) AS position_of_a
FROM list_of_orders
WHERE state = 'Punjab';

--Q30: Show customer_name (INITCAP applied) and city (UPPERCASE applied) 
--     together as one combined string, for all profitable orders 
--     (profit > 0) — combines String functions + JOIN + WHERE
SELECT 
CONCAT(INITCAP(customer_name),' ',UPPER(city)) AS combine
FROM list_of_orders L
INNER JOIN order_details  O
ON L.order_id=O.order_id
WHERE profit>0;












