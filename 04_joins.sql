-- ============================================
-- Dataset: Kaggle "Orders" Dataset (Retail/E-commerce)
-- Tables: list_of_orders, order_details, sales_target
-- Source: Kaggle Orders dataset, loaded into PostgreSQL
-- Purpose: Practicing JOINs combined with WHERE filtering 
--          INNER JOIN, LEFT JOIN, multi-table business scenarios
-- ============================================

-- ===== SECTION 1: Basic INNER JOIN =====

--Q1: Show each order's order_id, customer_name, and the amount from order_details
SELECT 
L.order_id,
L.customer_name,
O.amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q2: List customer_name along with the category of products they ordered
SELECT 
L.customer_name,
O.category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q3: Show order_id, customer_name, and profit for every order line item
SELECT 
L.order_id,
L.customer_name,
O.profit
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q4: Display customer_name, city, and sub_category for all orders
SELECT 
L.Customer_name,
L.city,
O.sub_category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

--Q5: Show order_date along with amount and quantity for each order line item
SELECT 
L.order_date,
O.amount,
O.quantity
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id;

-- ===== SECTION 2: INNER JOIN + WHERE (single condition) =====

--Q6: Find all order line items where the customer is from 'Maharashtra', showing customer_name and amount
SELECT 
L.customer_name,
O.amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE "L.state" = 'Maharashtra';

--Q7: Show customer_name and amount for all orders in the 'Electronics' category
SELECT 
L.customer_name,
O.amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE O.category='Electronics';

--Q8: List customer_name and city for orders where profit was negative (a loss)
SELECT 
L.customer_name,
O.amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE profit<0;

--Q9: Find orders from 'Mumbai' where the amount was greater than 1000
SELECT
L.customer_name,
L.city,
O.amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE "city"='Mumbai'AND amount>1000;

--Q10: Show customer_name and category for orders placed after '2018-06-01'
SELECT 
L.customer_name,
O.category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE order_date>'2018-06-01';

-- ===== SECTION 3: INNER JOIN + WHERE (multiple conditions) =====

--Q11: Find customers from 'Gujarat' who bought 'Furniture' with amount over 500
SELECT 
L.customer_name,
L.state,
O.amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE "L.state"='Gujarat' AND O.category='Furniture' AND O.amount>500;

--Q12: Show orders from 'Punjab' or 'Haryana' where the category is 'Clothing'
SELECT 
L.customer_name,
O.category,
L.state
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE ("L.state" IN('Punjab','Haryana')) AND O.category='Clothing' ;

--Q13: List customer_name, city, and amount for loss-making Electronics orders (profit < 0)
SELECT
L.customer_name,
L.city,
O.amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE O.category='Electronics' AND O.profit<0;

--Q14: Find high-value orders (amount > 2000) placed by customers whose name starts with 'S'
SELECT 
L.customer_name,
O.amount
FROM list_of_orders L
INNER JOIN order_details O 
ON L.order_id=O.order_id
WHERE O.amount>2000 AND L.customer_name LIKE 'S%';

---Q15: Show orders from 'Kolkata' placed in April 2018 with quantity of at least 3
SELECT 
L.customer_name,
L.order_date,
O.quantity,
L.city
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE L.city='Kolkata'  AND L.order_date between ('2018-04-01')
and('2018-04-30') AND O.quantity>=3;

-- ===== SECTION 4: Business Scenarios — Customer Analysis =====

--Q16: List all order line items for the customer named exactly 'Bharat'
SELECT * FROM list_of_orders
WHERE customer_name='Bharat';

--Q17: Find every order placed by customers whose name contains 'sh' (case-insensitive)
SELECT * FROM list_of_orders
WHERE customer_name ILIKE '%sh%';

--Q18: Show all Electronics purchases made by customers from 'Karnataka'
SELECT 
L.customer_name,
O.category,
L.state
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE O.category='Electronics' AND L.state='Karnataka';

--Q19: Find orders where the customer is from a state NOT in ('Gujarat', 'Maharashtra')
SELECT 
L.customer_name,
L.city,
L.state
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE L.state NOT IN('Gujarat', 'Maharashtra');

--Q20: List customer_name and order_date for customers whose city ends with 'pur'
SELECT 
customer_name,
order_date,
city
FROM list_of_orders 
WHERE city LIKE '%pur';

-- ===== SECTION 5: Business Scenarios — Product/Category Analysis =====

--Q21: Show all orders containing 'Chairs' as the sub_category, along with the customer's state
SELECT 
L.customer_name,
L.state,
O.sub_category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE  O.sub_category='Chairs';

--Q22: Find all profitable (profit > 0) Furniture orders along with customer_name and city
SELECT 
L.customer_name,
L.city,
O.category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE O.profit>0 AND  O.category='Furniture';

--Q23: List orders where sub_category is 'Phones' or 'Printers', with customer_name and order_date
SELECT 
L.customer_name,
L.order_date,
O.sub_category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE O.sub_category IN('Phones','Printers');

--Q24: Show customer_name for all orders with quantity greater than 5 in the 'Clothing' category
SELECT 
L.customer_name,
O.quantity
FROM list_of_orders L
INNER JOIN order_details O 
ON L.order_id=O.order_id
WHERE O.category='Clothing' AND O.quantity>5;

--Q25: Find all orders where the sub_category is NOT 'Trousers', showing city and amount
SELECT 
L.customer_name,
L.city,
O.amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE O.sub_category NOT IN('Trousers');

-- ===== SECTION 6: LEFT JOIN — finding unmatched/missing data =====

--Q26: Show all orders from list_of_orders along with their order_details, including orders 
--     that might not have any matching detail rows (use LEFT JOIN)
SELECT 
L.order_id,
L.customer_name,
L.order_date,
L.city,
O.category,
O.quantity
FROM list_of_orders L
LEFT JOIN order_details O
ON L.order_id=O.order_id;

--Q27: Find any orders in list_of_orders that have NO matching rows in order_details 
--     (orders with missing/incomplete detail records)
SELECT
L.order_id,
L.customer_name,
L.order_date,
L.city,
O.amount,
O.profit,
O.quantity,
O.category,
O.sub_category
FROM list_of_orders L
LEFT JOIN order_details O
ON L.order_id=O.order_id
WHERE O.order_id IS NULL;

--Q28: List all orders (including ones without order_details) and show NULL where no 
--     amount exists
SELECT 
L.order_id,
L.customer_name,
O.amount
FROM list_of_orders L
LEFT JOIN order_details O
ON L.order_id=O.order_id;

--Q29: Show all customers and their orders, including any order that has no category 
-- assigned (NULL category)
SELECT 
L.order_id,
L.customer_name,
O.category
FROM list_of_orders L
LEFT JOIN order_details O
ON L.order_id=O.order_id;

--Q30: Find orders where order_details data is completely missing
SELECT 
L.order_id,
L.customer_name,
O.category
FROM list_of_orders L
LEFT JOIN order_details O
ON L.order_id=O.order_id
WHERE O.order_id IS NULL;

-- ===== SECTION 7: Date-based JOIN scenarios =====

--Q31: Show customer_name and amount for orders placed in the first quarter of 2018 
--     (Jan-Mar), category = 'Electronics'
SELECT 
L.order_id,
L.customer_name,
O.amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE L.order_date BETWEEN'2018-01-01' AND '2018-03-31'
AND O.category='Electronics';

--Q32: Find all Furniture orders placed between '2018-04-01' and '2018-04-30'
SELECT 
L.order_id,
L.customer_name,
O.amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE L.order_date BETWEEN'2018-04-01' AND '2018-04-30'
AND O.category='Furniture';

--Q33: List customer_name, order_date, and profit for orders placed in May 2018 with 
--     negative profit
SELECT 
L.customer_name,
L.order_date,
O.profit
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE L.order_date BETWEEN'2018-05-01' AND '2018-05-31'
AND O.profit<0;

--Q34: Show orders placed after June 2018 where the customer is from 'Rajasthan'
SELECT 
customer_name,
order_date
FROM list_of_orders
WHERE order_date>'2018-06-30' AND "state"='Rajasthan';

--Q35: Find orders placed on exactly '2018-04-20' along with their category and amount
SELECT 
L.customer_name,
O.category,
O.amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE L.order_date='2018-04-20';

-- ===== SECTION 8: Aggregea-adjacent (JOIN + WHERE, no GROUP BY yet) =====

--Q36: List every individual loss-making transaction (profit < 0) along with the state 
--     it was ordered from
SELECT 
L.order_id,
L.customer_name,
L.state,
O.profit
FROM list_of_orders L
INNER JOIN  order_details O
ON L.order_id=O.order_id
WHERE profit<0 ;

--Q37: Show all orders with amount between 500 and 1000, including customer_name and city
SELECT 
L.customer_name,
L.city,
O.amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE O.amount BETWEEN 500 AND 1000;

--Q38: Find orders where quantity is at least 5 and the category is 'Furniture', 
--     showing customer_name
SELECT 
L.customer_name,
O.quantity,
O.category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE O.quantity>=5  AND O.category='Furniture';

--Q39: List all orders from 'Chandigarh' with their category and sub_category
SELECT 
L.order_id,
L.customer_name,
O.category,
O.sub_category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE L.city='Chandigarh';

--Q40: Show customer_name for orders where profit is exactly 0 (break-even orders)
SELECT 
L.customer_name,
O.profit
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE O.profit=0;

-- ===== SECTION 9: Three-table scenarios (list_of_orders + order_details + sales_target) =====

--Q41: Show the sales_target for 'Furniture' category for the month of '2018-04-01', 
--     alongside actual Furniture order amounts from that same month (no aggregation, 
--     just list both side by side using a JOIN on category)
SELECT 
  S.target,
  O.amount,
  O.category,
  L.order_date
FROM sales_target S 
INNER JOIN order_details O
ON S.category=O.category
INNER JOIN list_of_orders L
ON L.order_id=O.order_id
WHERE S.order_month ='2018-04-01'
AND O.category = 'Furniture'
AND L.order_date BETWEEN '2018-04-01' AND '2018-04-30';

--Q42: Find all Electronics order_details along with the Electronics sales_target 
--     for '2018-05-01'
SELECT
L.order_id,
L.customer_name,
L.order_date,
S.target
FROM sales_target S
INNER JOIN order_details O
ON O.category=S.category
INNER JOIN list_of_orders L
ON L.order_id=O.order_id
WHERE O.category='Electronics' AND S.order_month='2018-05-01'; 

--Q43: List Clothing orders placed in June 2018 alongside the Clothing sales_target 
--     for June 2018
SELECT
L.order_id,
L.customer_name,
L.order_date,
O.category,
S.target
FROM list_of_orders L 
INNER JOIN order_details O
ON O.order_id=L.order_id
INNER JOIN sales_target S
ON S.category=O.category
WHERE L.order_date BETWEEN'2018-06-01' AND '2018-06-30'
AND S.order_month='2018-06-01'
AND O.category='Clothing';

--Q44: Show all order_details for 'Furniture' category where the corresponding 
--     sales_target (any month) was at least 10000
SELECT DISTINCT
L.order_id,
L.customer_name,
O.category,
L.order_date,
S.target
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
INNER JOIN sales_target S
ON O.category=S.category
WHERE O.category='Furniture' AND S.target>=10000;

--Q45: Find Electronics orders and their matching monthly sales_target, but only 
--     where order amount exceeds 1000
SELECT DISTINCT
L.customer_name,
L.order_date,
O.category,
S.target
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
INNER JOIN sales_target S
ON O.category=S.category
WHERE O.category='Electronics' AND amount>1000;

-- ===== SECTION 10: Complex multi-condition business logic =====

--Q46: Find all high-value (amount > 1500) profitable  orders from 
--     customers in 'Maharashtra' or 'Karnataka', showing customer_name, city, and category
SELECT 
L.order_id,
L.customer_name,
L.city,
O.category,
O.amount,
O.profit
FROM list_of_orders L
INNER JOIN order_details O
On L.order_id=O.order_id
WHERE O.amount>1500 AND O.profit>0 AND
L.state IN('Maharashtra','Karnataka');

--Q47: List loss-making Electronics or Furniture orders placed by 
--     customers whose city is NOT 'Mumbai'
SELECT 
L.order_id,
L.customer_name,
L.city,
O.profit,
O.category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE O.category IN('Electronics' , 'Furniture')
AND profit<0 AND city<>'Mumbai';

--Q48: Show customer_name, order_date, and amount for orders in 'Clothing' category 
--     with quantity between 2 and 8, placed in 2018 (April-June)
SELECT DISTINCT
L.order_id,
L.customer_name,
L.order_date,
O.amount
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE O.category='Clothing' AND 
O.quantity BETWEEN 2 AND 8
AND L.order_date BETWEEN'2018-04-01' AND '2018-06-30';

--Q49: Find all orders where the customer name ends with 'a', the category is 
--     'Electronics', and profit is positive
SELECT 
L.order_id,
L.customer_name,
O.profit
FROM list_of_orders L 
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE customer_name LIKE '%a' AND O.category='Electronics'
AND profit>0;

--Q50: List every order detail for customers from states starting with 'M' 
--     (e.g., Maharashtra, Madhya Pradesh), where amount is greater than 800 
--     and category is not 'Clothing'
SELECT 
L.order_id,
L.customer_name,
L.state,
O.amount,
O.category
FROM list_of_orders L
INNER JOIN order_details O
ON L.order_id=O.order_id
WHERE "state" ILIKE 'M%'
AND O.amount>800 AND O.category NOT IN ('Clothing');

