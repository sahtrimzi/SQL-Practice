-- ============================================
-- Dataset: Kaggle "Orders" Dataset (Retail/E-commerce)
-- Tables: list_of_orders, order_details, sales_target
-- Source: Kaggle Orders dataset, loaded into PostgreSQL
-- Purpose: Practicing Window Ranking Functions — RANK, 
--          DENSE_RANK, NTILE, combined with PARTITION BY, 
--          JOIN, and prior functions for revision
-- ============================================

-- ===== SECTION 1: Basic Ranking (RANK vs DENSE_RANK vs ROW_NUMBER) =====

--Q1: Show order_id, amount, and RANK() OVER (ORDER BY amount DESC) — 
--    rank all orders by amount, highest first
SELECT order_id,amount,RANK() OVER(ORDER BY amount DESC) AS rank_amount
FROM order_details;

--Q2: Show order_id, amount, and DENSE_RANK() OVER (ORDER BY amount DESC)
SELECT order_id,amount, DENSE_RANK() OVER(ORDER BY amount DESC)
FROM order_details;

--Q3: Show order_id, amount, ROW_NUMBER(), RANK(), and DENSE_RANK() all 
--    side by side (same ORDER BY amount DESC) — find a row where amount 
--    ties with another row, and observe how the three functions differ
SELECT order_id,amount,ROW_NUMBER() OVER(ORDER BY amount DESC) AS ROW_NUMBERS,
RANK() OVER(ORDER BY amount DESC) AS RANK_AMOUNT,
DENSE_RANK() OVER(ORDER BY amount DESC) AS DENSE_RANKS
FROM order_details;
--I OBSERVED IN THIS QUERY THEY ARE TOTALY DIFFERNET ROW NUM ASSIGN THE NUMBER TO EACH ROW 
-- AND RANK GIVES NUMBER TO EACH ROW ACCORDING AMOUNT SAME AMOUNT THEY GIVE SAME RANK
-- AND  DENSE RANK ALSO GIVES THE NUMBER TO EACH SAME AS IT RANK FUNNTION BUT
--RANK FUNCTION SKIP THE NUMBER OS SAME FOR EXAMP 3 AND 3 NEXT ROW THEY GIVE 5 SKIP 4 
--DENSE FUNCTION CANNOT SKIP NUMBER THEY GIVE 4

--Q4: Show category, amount, and RANK() OVER (PARTITION BY category 
--    ORDER BY amount DESC) — rank orders within each category
SELECT category,amount,RANK() OVER(PARTITION BY category ORDER BY amount  DESC)
FROM order_details;

--Q5: Show category, amount, and DENSE_RANK() OVER (PARTITION BY category 
--    ORDER BY amount DESC)
SELECT category,amount, DENSE_RANK() OVER(PARTITION BY category ORDER BY amount DESC)
FROM order_details;


-- ===== SECTION 2: NTILE — dividing data into buckets =====

--Q6: Show order_id, amount, and NTILE(4) OVER (ORDER BY amount DESC) — 
--    divide all orders into 4 groups (quartiles) by amount
SELECT order_id,amount, NTILE(4) OVER(ORDER BY amount DESC) AS amount_in_group
FROM order_details;

--Q7: Show category, amount, and NTILE(3) OVER (PARTITION BY category 
--    ORDER BY amount DESC) — divide each category's orders into 3 tiers
SELECT category,amount, NTILE(3) OVER(PARTITION BY category ORDER BY AMOUNT DESC)
FROM order_details

--Q8: Show customer_name, amount, and NTILE(4) OVER (ORDER BY amount 
--    DESC) as "spending_quartile" — needs JOIN
SELECT customer_name,amount, NTILE(4) OVER(ORDER BY amount DESC) AS spending_quartile
FROM order_Details O
INNER JOIN list_of_orders L
ON O.order_id=L.order_id;

--Q9: Find all orders where NTILE(4) OVER (ORDER BY amount DESC) equals 
--    1 (the top quartile / top 25% by amount) — hint: use a subquery, 
--    since window functions can't go in WHERE directly
SELECT *
FROM (SELECT *,NTILE(4) OVER (ORDER BY amount DESC) AS quartile
FROM order_details
) AS ranked_orders
WHERE quartile = 1;
--Q10: Show sub_category, amount, and NTILE(2) OVER (PARTITION BY 
--     sub_category ORDER BY amount DESC) — split each sub_category into 
--     "top half" and "bottom half"
SELECT sub_category,amount, NTILE(2) OVER(PARTITION BY sub_category ORDER BY amount DESC)
FROM order_details;

-- ===== SECTION 3: Ranking + WHERE/JOIN (revision) =====

--Q11: Show customer_name, amount, and RANK() OVER (ORDER BY amount DESC), 
--     only for orders in the 'Electronics' category
SELECT customer_name,amount, RANK() OVER(ORDER BY amount DESC) AS Rank_amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE category='Electronics';
--Q12: Show state, amount, and DENSE_RANK() OVER (PARTITION BY state 
--     ORDER BY amount DESC), only for profitable orders (profit > 0)
SELECT state,amount, DENSE_RANK() OVER(PARTITION BY state ORDER BY amount DESC) AS dense_rank_amount
FROM list_of_orders L
INNER JOIN order_Details O
ON L.order_id=O.order_id
WHERE profit>0;
--Q13: Show category, sub_category, amount, and RANK() OVER (PARTITION 
--     BY category ORDER BY amount DESC), only for orders placed in 2018
SELECT category,sub_category,amount, RANK() OVER(PARTITION BY category ORDER BY  amount DESC)
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE EXTRACT(YEAR FROM order_date) = 2018;

--Q14: Show customer_name, city, amount, and DENSE_RANK() OVER 
--     (PARTITION BY city ORDER BY amount DESC), only for customers 
--     whose name starts with 'S'
SELECT customer_name,city,amount, DENSE_RANK() OVER(PARTITION BY city ORDER BY amount DESC) AS dense_rank_amount
FROM order_details O
INNER JOIN list_of_orders L
ON L.order_id=O.order_id
WHERE customer_name LIKE 'S%';

--Q15: Show category, amount, and NTILE(4) OVER (PARTITION BY category 
--     ORDER BY amount DESC), only for 'Electronics' and 'Furniture'
SELECT category,amount,NTILE(4) OVER(PARTITION BY category ORDER BY amount DESC)
FROM order_details
WHERE category IN('Electronics','Furniture');

-- ===== SECTION 4: Ranking + String/Numeric/CASE (revision) =====

--Q16: Show UPPER(category), amount, and RANK() OVER (PARTITION BY 
--     category ORDER BY amount DESC)
SELECT UPPER(category),amount, RANK() OVER(PARTITION BY  category ORDER BY amount DESC)
FROM order_details;

--Q17: Show customer_name (INITCAP), amount, and a CASE column "tier" 
--     — 'Top Spender' if NTILE(4) OVER (ORDER BY amount DESC) = 1, 
--     else 'Regular' (combines NTILE with CASE)
SELECT INITCAP(customer_name) AS customer_name,amount,
CASE 
WHEN NTILE(4) OVER (ORDER BY amount DESC) = 1 THEN 'Top Spender'
ELSE 'Regular'
END AS tier
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q18: Show category, ROUND(amount), and RANK() OVER (PARTITION BY 
--     category ORDER BY amount DESC) as "amount_rank"
SELECT category,ROUND(amount)AS round_amount, RANK() OVER(PARTITION BY category ORDER BY amount DESC)AS amount_rank
FROM order_details;
--Q19: Show state, amount, and a CASE column based on DENSE_RANK() OVER 
--     (PARTITION BY state ORDER BY amount DESC) — 'Best Order' if rank 
--     = 1, 'Second Best' if rank = 2, else 'Other'
SELECT state,amount,
CASE
WHEN DENSE_RANK() OVER(PARTITION BY state ORDER BY amount DESC)=1 THEN 'Best Order'
WHEN DENSE_RANK() OVER(PARTITION BY state ORDER BY amount DESC)=2 THEN 'Second Best'
ELSE 'Other'
END AS DENSE_RANKS
FROM list_of_orders L
INNER JOIN order_Details O
ON L.order_id=O.order_id;

--Q20: Show category, COALESCE(sub_category, 'Unknown'), amount, and 
--     RANK() OVER (PARTITION BY category ORDER BY amount DESC)
SELECT 
category,COALESCE(sub_category, 'Unknown') AS sub_category,amount,RANK() OVER (PARTITION BY category ORDER BY amount DESC) AS rank_num
FROM order_details; 
