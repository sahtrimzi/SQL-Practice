-- ============================================
-- Dataset: Kaggle "Orders" Dataset (Retail/E-commerce)
-- Tables: list_of_orders, order_details, sales_target
-- Source: Kaggle Orders dataset, loaded into PostgreSQL
-- Purpose: Practicing Date/Time Functions, combined with 
--          WHERE, JOIN, Set Operators, String/Numeric 
--          Functions, and CASE for revision
-- ============================================

-- ===== SECTION 1: Basic Date/Time Functions =====

--Q1: Show order_date along with just the YEAR extracted from it (use EXTRACT)
SELECT order_date,
EXTRACT(YEAR FROM order_date)AS order_year
FROM list_of_orders;

--Q2: Show order_date along with just the MONTH extracted from it
SELECT order_date,
EXTRACT(MONTH FROM order_date) AS order_month
FROM list_of_orders;

--Q3: Show order_date along with just the DAY (day of month) extracted from it
SELECT order_date,
EXTRACT(DAY FROM order_date) AS order_day
FROM list_of_orders;

--Q4: Show order_date and the day of the week it fell on (use EXTRACT(DOW FROM ...) 
--    — 0=Sunday, 6=Saturday)
SELECT  order_date, 
EXTRACT(DOW FROM order_date) AS day_of_week
FROM list_of_orders;

--Q5: Show order_date formatted as "DD-Mon-YYYY" (e.g., "20-Apr-2018") using TO_CHAR
SELECT order_date, TO_CHAR(order_date, 'DD-Mon-YYYY') 
AS formatted_date
FROM list_of_orders;

-- ===== SECTION 2: Date/Time Functions + WHERE (revision) =====

--Q6: Find all orders placed in the year 2018 (use EXTRACT(YEAR FROM order_date))
SELECT  order_date
FROM list_of_orders 
WHERE EXTRACT(YEAR FROM order_date)=2018;

--Q7: Find all orders placed in the month of April (any year) — use EXTRACT(MONTH FROM ...)
SELECT order_date
FROM list_of_orders
WHERE EXTRACT(MONTH FROM order_date)=4;

--Q8: Find orders placed on a Sunday (day of week = 0)
SELECT order_date 
FROM list_of_orders
WHERE EXTRACT(DOW FROM order_date)=0;

--Q9: Show order_date and amount for orders placed in the last quarter of 
--    the year (October, November, December)
SELECT order_date, amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE EXTRACT(MONTH FROM order_date) IN (10, 11, 12);

--Q10: Find orders where order_date is exactly 30 days after '2018-04-01' 
--     (use date arithmetic: '2018-04-01' + INTERVAL '30 days')
SELECT order_date
FROM list_of_orders
WHERE order_date = DATE '2018-04-01' + INTERVAL '30 days';

-- ===== SECTION 3: Date/Time Functions + JOIN (revision) =====

--Q11: Show customer_name, order_date, and the MONTH extracted from 
--     order_date, for every order
SELECT customer_name,order_date,EXTRACT(MONTH FROM order_date) 
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q12: Show customer_name and amount, only for orders placed on a weekend 
--     (Saturday or Sunday) — use EXTRACT(DOW FROM order_date)
SELECT  customer_name,amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id 
WHERE EXTRACT(DOW FROM order_date) IN(0,6);

--Q13: Show customer_name and order_date formatted as "Month YYYY" (e.g., 
--     "April 2018") using TO_CHAR
SELECT customer_name,TO_CHAR(order_date,'Month YYYY')
FROM  list_of_orders ;

--Q14: Show category and order_date, only for orders placed in the first 
--     week of any month (day of month <= 7)
SELECT category,order_date
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id 
WHERE EXTRACT(DAY FROM order_date)<=7;

--Q15: Show customer_name and the number of days between order_date and 
--     '2018-12-31' (use date subtraction)
SELECT customer_name, DATE '2018-12-31' - order_date AS days_difference
FROM list_of_orders L;

-- ===== SECTION 4: Date/Time Functions + Set Operators (revision) =====

--Q16: Show customer_name for orders placed in January UNION customer_name 
--     for orders placed in February (use EXTRACT(MONTH FROM ...))
SELECT 
customer_name
FROM list_of_orders
WHERE EXTRACT(MONTH FROM order_date)=1
UNION 
SELECT 
customer_name
FROM list_of_orders
WHERE EXTRACT(MONTH FROM order_date)=2;

--Q17: Find customer_names who placed orders in Q1 2018 INTERSECT 
--     customer_names who placed orders in Q2 2018 (selecting only 
--     customer_name to avoid the extra-column trap)
SELECT customer_name
FROM list_of_orders
WHERE EXTRACT(YEAR FROM order_date) = 2018
AND EXTRACT(QUARTER FROM order_date) = 1
INTERSECT
SELECT customer_name
FROM list_of_orders
WHERE EXTRACT(YEAR FROM order_date) = 2018
AND EXTRACT(QUARTER FROM order_date) = 2;

--Q18: Show customer_names who ordered on a weekday EXCEPT customer_names 
--     who ever ordered on a weekend
SELECT 
customer_name FROM
list_of_orders 
WHERE EXTRACT(ISODOW FROM order_date) IN(1,2,3,4,5)
EXCEPT 
SELECT 
customer_name FROM
list_of_orders 
WHERE EXTRACT(ISODOW FROM order_date) IN (6,7);

--Q19: Combine (UNION) customer_names from orders placed in the first 
--     half of 2018 (Jan-Jun) with customer_names from orders placed in 
--     the second half (Jul-Dec)
SELECT 
customer_name 
FROM list_of_orders 
WHERE 
EXTRACT(YEAR FROM order_date) = 2018
AND
EXTRACT(MONTH FROM order_date) BETWEEN 1 AND 6
UNION
SELECT 
customer_name 
FROM list_of_orders 
WHERE 
EXTRACT(YEAR FROM order_date) = 2018
AND
EXTRACT(MONTH FROM order_date) BETWEEN 7 AND 12;

--Q20: Find sub_categories ordered in April INTERSECT sub_categories 
--     ordered in May (selecting only sub_category)
SELECT 
sub_category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE EXTRACT(MONTH FROM order_date)=4
INTERSECT
SELECT O.sub_category
FROM list_of_orders L
INNER JOIN order_details O ON L.order_id = O.order_id
WHERE EXTRACT(MONTH FROM L.order_date) = 5;

-- ===== SECTION 5: Date/Time + String/Numeric/CASE Functions (revision) =====

--Q21: Show UPPER(customer_name) along with the MONTH NAME of order_date 
--     (use TO_CHAR with 'Month' format)
SELECT UPPER(customer_name),TO_CHAR(order_date,'Month')
FROM list_of_orders;

--Q22: Show customer_name combined with formatted order_date as one 
--     string, e.g., "Ali - 20/04/2018" (use CONCAT with TO_CHAR)
SELECT CONCAT(customer_name,' - ',TO_CHAR(order_date,'DD/MM/YYYY'))
FROM list_of_orders ;

--Q23: Show order_date and a new column "day_type using CASE — 'Weekend' 
--     if Saturday/Sunday, else 'Weekday' (combine EXTRACT(DOW) with CASE)
SELECT 
order_date,
CASE 
WHEN EXTRACT(ISODOW FROM order_date) IN(0,6) THEN 'Weekend'
ELSE 'Weekday'
END AS day_type
FROM list_of_orders;

--Q24: Show order_date and a new column "quarter" using CASE — 'Q1' for 
--     Jan-Mar, 'Q2' for Apr-Jun, 'Q3' for Jul-Sep, 'Q4' for Oct-Dec 
--     (combine EXTRACT(MONTH) with CASE)
SELECT
order_date,
CASE 
WHEN EXTRACT(MONTH FROM order_date) BETWEEN 1 AND 3 THEN 'Q1'
WHEN EXTRACT(MONTH FROM order_date) BETWEEN 4 AND 6 THEN 'Q2'
WHEN EXTRACT(MONTH FROM order_date) BETWEEN 7 AND 9 THEN 'Q3'
WHEN EXTRACT(MONTH FROM order_date) BETWEEN 10 AND 12 THEN 'Q4'
END quarter
FROM list_of_orders;
--Q25: Show ROUND(amount) along with the YEAR of order_date, for orders 
--     placed in 'Electronics' category
SELECT ROUND(amount),EXTRACT(YEAR FROM order_date)
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Electronics';

-- ===== SECTION 6: Real-world business scenarios =====

--Q26: Find the earliest (MIN) and latest (MAX) order_date in the entire 
--     dataset — this tells you the date range the data covers
SELECT 
MIN(order_date) AS earliest_order,
MAX(order_date) AS latest_order
FROM list_of_orders;

--Q27: Show customer_name and order_date, for orders placed exactly on 
--     the last day of any month (hint: compare order_date to 
--     DATE_TRUNC('month', order_date) + INTERVAL '1 month' - INTERVAL '1 day')
SELECT 
customer_name, 
order_date
FROM list_of_orders 
WHERE order_date = DATE_TRUNC('month', order_date) + INTERVAL '1 month' - INTERVAL '1 day';

--Q28: Find all orders placed within 7 days of the sales_target's 
--     order_month for their category (JOIN order_details + sales_target, 
--     then compare dates using date arithmetic)
SELECT DISTINCT
    L.order_id,
    L.order_date,
    O.category,
    st.order_month
FROM list_of_orders L
JOIN order_details O ON L.order_id = O.order_id
JOIN sales_target st ON st.category = O.category
WHERE order_date BETWEEN order_month - INTERVAL '7 days' 
AND order_month + INTERVAL '7 days';

--Q29: Show customer_name and a new column "days_since_order" — the 
--     number of days between order_date and CURRENT_DATE (use CURRENT_DATE)
SELECT 
    customer_name,
    order_date,
    CURRENT_DATE - order_date AS days_since_order
FROM list_of_orders ;

--Q30: Show category, order_date truncated to the month (use 
--     DATE_TRUNC('month', order_date)), and the total SUM of amount for 
--     that category-month combination (preview of GROUP BY with dates, 
--     which becomes powerful once you reach Aggregate Functions)
SELECT 
category,
DATE_TRUNC('month', order_date) AS order_month,
SUM(amount) AS total_amount
FROM list_of_orders L
JOIN order_details O 
ON L.order_id = O.order_id
GROUP BY category, DATE_TRUNC('month', order_date)
ORDER BY order_month, category;