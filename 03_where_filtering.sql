-- ============================================
-- Dataset: Kaggle "Orders" Dataset (Retail/E-commerce)
-- Tables: list_of_orders, order_details, sales_target
-- Source: Kaggle Orders dataset, loaded into PostgreSQL
-- Purpose:Practicing WHERE clause comparisons, logical 
-- operators, ranges, pattern matching
-- ============================================

--1 Show all orders with quantity of at least 5
SELECT *FROM order_details 
WHERE quantity>=5;

--2 Find orders where quantity is at most 2
SELECT *FROM order_details 
WHERE quantity<=2;

--3 List orders that are non-profitable (loss or break-even)
SELECT *FROM order_details 
WHERE profit=0;

--4 Get orders with strictly positive profit
SELECT *FROM order_details
WHERE profit>0;

--5 Find orders where quantity is non-zero
SELECT * FROM order_details
WHERE quantity>0;

--6 Show orders with amount over 3000
SELECT *FROM order_details
WHERE amount>3000;

--7 List orders under 100 in amount
SELECT *FROM order_details
WHERE amount<100;

--8 Find orders in the Furniture category with amount at least 1000
SELECT *FROM order_details
WHERE category='Furniture' AND amount>=1000;

--9 Show orders that are either Clothing or Electronics
SELECT *FROM order_details
WHERE category IN('Clothing','Electronics');

--10 List orders in Furniture or Electronics with negative profit
SELECT *FROM order_details
WHERE category IN('Clothing','Electronics') AND profit<0;

--11 Find orders that are NOT in the Clothing category
SELECT *FROM order_details
WHERE category NOT IN('Clothing');

--12 Show orders placed after June 1, 2018
SELECT *FROM  list_of_orders
WHERE order_date > '2018-06-01'

--13 List orders placed before March 2018 began
SELECT *FROM  list_of_orders
WHERE order_date < '2018-03-01';

--14 Find orders placed between April 1 and April 30, 2018 inclusive
SELECT *FROM  list_of_orders
WHERE order_date BETWEEN ('2018-04-01') AND ('2018-04-30');

--15  Get all orders placed during May 2018 (the whole month)
SELECT *FROM list_of_orders
WHERE order_date BETWEEN '2018-05-01' AND '2018-05-31';

--16 Show orders placed on exactly April 20, 2018
SELECT *FROM list_of_orders
WHERE order_date='2018-04-20';

--17 List orders from customers whose name starts with 'S'
SELECT *FROM list_of_orders
WHERE customer_name LIKE 'S%';

--18 Find orders from cities ending in 'pur
SELECT *FROM list_of_orders
WHERE city LIKE '%pur';

--19 Show orders from customers whose name contains 'ha', regardless
SELECT *FROM  list_of_orders
WHERE customer_name ILIKE '%ha%';

--20  List orders where the state name has 'M' as the second letter
SELECT *FROM list_of_orders
WHERE "state" LIKE '_M%';

--21 Find orders from cities starting with 'B', case doesn't matter
SELECT *FROM list_of_orders
WHERE city ILIKE 'B%';

--22  Show orders in categories Furniture, Clothing, or Electronics
SELECT *FROM order_details
WHERE category IN('Furniture','Clothing','Electronics');

--23 List orders NOT from Gujarat, Maharashtra, or Karnataka
SELECT *FROM list_of_orders
WHERE "state" NOT IN('Gujarat', 'Maharashtra','Karnataka');

--24 Find orders where quantity is at least 1 and at most 5
SELECT *FROM order_details
WHERE quantity>=1 AND quantity<=5;

--25 Show orders with profit exactly zero
SELECT *FROM order_details
WHERE profit=0;

--26 List orders that made no loss
SELECT *FROM order_details
WHERE profit >0;

--27 Find high-value Furniture orders (amount over 2000) that are also profitable
SELECT * FROM order_details
WHERE category='Furniture' AND amount>2000 AND profit >0;

--28  Show orders that are Electronics and were sold in quantity of more than 3
SELECT *FROM order_details
WHERE category='Electronics' AND  quantity>3;

--29  List orders where quantity is under 3 or amount is over 5000
SELECT * FROM order_details
WHERE quantity<3 OR amount>5000;

--30  Find Clothing orders with quantity of at least 10, or any Furniture
SELECT *FROM order_details
WHERE category=('Clothing'  AND quantity>=10) OR category='Furniture';

--31 Show orders placed in the first quarter of 2018 (Jan-Mar)
SELECT * FROM list_of_orders
WHERE order_date BETWEEN '2018-01-01' AND '2018-03-31';

--32 List orders placed on or after April 5 but before April 15, 2018
SELECT * FROM list_of_orders
WHERE order_date >'2018-04-05' AND order_date <'2018-04-15' 

--33 Find customers whose name ends with 'a
SELECT * FROM list_of_orders
WHERE customer_name LIKE '%a';

--34 Show cities whose name contains 'na' (exact case)
SELECT * FROM list_of_orders
WHERE city LIKE '%na%';

--35 List sub-categories starting with 'T', regardless of case
SELECT * FROM order_details
WHERE sub_category ILIKE 'T%';

--36 Find orders where the sub-category is Chairs, Tables, Bookcases, or Furnishings.
SELECT * FROM order_details
WHERE sub_category IN('Chairs', 'Tables', 'Bookcas','Furnishings');

--37 Show orders NOT in sub-categories Chairs or Tables
SELECT * FROM order_details
WHERE sub_category NOT IN('Chairs','Tables')

--38  List orders where amount is between 500 and 1000, excluding Clothing category
SELECT * FROM order_details
WHERE category NOT IN ( 'Clothing')and amount BETWEEN 500 AND 1000;

--39  Find orders with negative profit in Electronics or Clothing category
SELECT * FROM order_details
WHERE category IN('Electronics','Clothing') AND profit<0;

--40  Show sales targets for Furniture category with a target of at least 10000
SELECT * FROM sales_target
WHERE category ='Furniture' AND target>=10000;

--41 List sales targets recorded before June 2018
SELECT * FROM sales_target
WHERE order_month <'2018-06-01';

--42 Find sales targets from April 2018 through June 2018 inclusive
SELECT * FROM sales_target
WHERE order_month  BETWEEN '2018-04-01' AND '2018-06-01';

--43 Show sales targets that are not for the Clothing category
SELECT * FROM sales_target
WHERE category NOT IN('Clothing');

--44 List orders with quantity of exactly 7 and amount greater than 1000
SELECT * FROM order_details
WHERE quantity=7 AND amount>1000;

--45 Find orders that have zero profit or zero quantity
SELECT * FROM order_details
WHERE quantity =0 OR profit=0;

--46 Show orders from customers named exactly 'Amit' (not a partial match)
SELECT * FROM list_of_orders
WHERE customer_name='Amit';

--47 List orders placed during April 2018, using the safe half-open method
SELECT * FROM list_of_orders
WHERE order_date>='2018-04-01' AND order_date<='2018-04-30';

--48 Find non-Electronics orders with heavy losses (profit less than -500
SELECT * FROM order_details
WHERE category NOT IN('Electronics') AND profit<-500;

--49 Show orders where the customer name has 'r' as the third letter
SELECT * FROM list_of_orders
WHERE  customer_name LIKE '__r%';

--50 Find all profitable Furniture or Electronics orders placed after May 2018,
excluding quantity below 2.
SELECT * FROM list_of_orders L
INNER JOIN order_details O ON l.order_id=o.order_id
WHERE O.category IN('Furniture','Electronic') AND L.order_date>'2018-05-1'
AND o.quantity<2;
