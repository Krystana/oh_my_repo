--- example SQL queries I wrote creating the northwind metabase dashboard 

-- all categories: 

SELECT category_name FROM categories;

-- all categories with description: 

SELECT category_name, description FROM categories;

--- countries of customers: 

SELECT country FROM customers; 

--- all companies with name and city from Germany: 

SELECT company_name, city, country FROM customers WHERE country LIKE 'Germany';


--- 10 order ID's with highest order quantities and their unit prices:


SELECT order_id, unit_price, quanitity
FROM order_details
ORDER BY quanitity DESC
LIMIT 10;

---  quantity max: 

SELECT MAX(quanitity)
FROM order_details;


---  10 order ID's with highest unit prices and their quantities: 

SELECT order_id, unit_price, quanitity
FROM order_details
ORDER BY unit_price DESC
LIMIT 10;

---  unit price max: 

SELECT MAX(unit_price)
FROM order_details;

--- display orders with discounts:

SELECT discount, order_id, unit_price
FROM order_details
WHERE discount != 0
ORDER BY discount DESC
LIMIT 10;


--- order id's with delay in shipment:

SELECT order_id, required_date, shipped_date
FROM orders 
WHERE shipped_date > required_date;

--- customers with delay in shipment:

SELECT customer_id, required_date, shipped_date
FROM orders 
WHERE shipped_date > required_date;


-- Get the names and the quantities in stock for each product:

SELECT product_name, quantity_per_unit 
FROM products;

--- Get a list of current products (Product ID and name):

SELECT product_id, product_name 
FROM products;

--- Get a list of the most and least expensive products (name and unit price):

SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 10;

--- Get products that cost less than $20:

SELECT product_name, unit_price
FROM products
WHERE unit_price < 20
ORDER BY unit_price ASC;

-- Get products that cost between $15 and $25:

SELECT product_name, unit_price
FROM products
WHERE unit_price BETWEEN 15 AND 25;

--- Get products above the average price:

SELECT product_name, unit_price
FROM products
WHERE unit_price > (SELECT AVG(unit_price) FROM products);
--
SELECT AVG(unit_price) FROM products;


--- Get a list of discontinued products (Product ID and name):

SELECT product_name, discontinued
FROM products
WHERE discontinued = 1;

--- Count current and discontinued products:

SELECT COUNT(product_name)
FROM products
GROUP BY discontinued;

--- Find products with less units in stock than the quantity on order.

SELECT product_id
FROM products
WHERE units_in_stock < units_on_order;

--- Find the customer who had the highest order amount:

SELECT orders.customer_id, COUNT(order_details.quanitity)
FROM orders
INNER JOIN order_details ON orders.order_id = order_details.order_id
GROUP BY orders.customer_id
ORDER BY COUNT(order_details.quanitity) DESC
LIMIT 1; 

----Get orders for a given employee and the according customer

SELECT orders.employee_id, orders.order_id, orders.customer_id
FROM orders
INNER JOIN employees ON orders.employee_id = employees.employee_id;

-- products ordered most often in germany 1997

SELECT  SUM(od.quanitity), p.product_name, cat.category_name

FROM order_details AS od
JOIN products AS p
ON od.product_id = p.product_id
JOIN orders AS o
ON od.order_id = o.order_id
JOIN customers AS c
ON o.customer_id = c.customer_id
JOIN categories as cat
ON p.category_id = cat.category_id

WHERE c.country = 'Germany' AND o.order_date BETWEEN '01/01/1997' AND  '12/31/1997'

GROUP BY product_name, category_name
ORDER BY SUM(quanitity) DESC
LIMIT 10;

---  orders of 'Rhönberg Klosterbräu' in germany in 1997:  --works 

SELECT  od.quanitity, p.product_name, o.order_date

FROM order_details AS od
JOIN products AS p
ON od.product_id = p.product_id
JOIN orders AS o
ON od.order_id = o.order_id
JOIN customers AS c
ON o.customer_id = c.customer_id

WHERE c.country = 'Germany' AND o.order_date BETWEEN '01/01/1997' AND  '12/31/1997'  AND p.product_name = 'Rhönbräu Klosterbier'

GROUP BY p.product_name, od.quanitity, o.order_date
ORDER BY quanitity ASC;


---  total revenue of 'Rhönberg Klosterbräu'  in germany in 1997: 

SELECT   p.product_name, od.order_id, o.order_date,
od.quanitity*od.unit_price AS total_revenue

FROM order_details AS od
JOIN products AS p
ON od.product_id = p.product_id
JOIN orders AS o
ON od.order_id = o.order_id
JOIN customers AS c
ON o.customer_id = c.customer_id

WHERE c.country = 'Germany' AND o.order_date BETWEEN '01/01/1997' AND  '12/31/1997'  AND p.product_name = 'Rhönbräu Klosterbier'

GROUP BY p.product_name, total_revenue, od.quanitity, od.unit_price, o.order_date,  od.order_id

ORDER BY quanitity ASC;


--- orders by employee to germany in 1997:

SELECT e.last_name, COUNT(o.order_id) 
FROM employees AS e
JOIN orders AS o
ON o.employee_id = e.employee_id
JOIN order_details AS od
ON od.order_id = o.order_id
JOIN customers AS c
ON c.customer_id = o.customer_id

WHERE c.country = 'Germany' AND o.order_date BETWEEN '01/01/1997' AND  '12/31/1997'
GROUP BY e.last_name
ORDER BY COUNT(o.order_id) DESC;

--- create view of most often joined tables orders, order_details, products, customers for Germany total revenue Rhönbräu Klosterbier 1997: 

CREATE VIEW germany_view_1997 AS
SELECT   p.product_name, od.order_id, o.order_date,
od.quanitity*od.unit_price AS total_revenue

FROM order_details AS od
JOIN products AS p
ON od.product_id = p.product_id
JOIN orders AS o
ON od.order_id = o.order_id
JOIN customers AS c
ON o.customer_id = c.customer_id

WHERE c.country = 'Germany' AND o.order_date BETWEEN '01/01/1997' AND  '12/31/1997'  AND p.product_name = 'Rhönbräu Klosterbier'

GROUP BY p.product_name, total_revenue, od.quanitity, od.unit_price, o.order_date,  od.order_id

ORDER BY quanitity ASC;

SELECT * FROM germany_view_1997;

--- create view of most often joined tables orders, order_details, products, customers for Germany total revenue 1997: 

CREATE VIEW germany_view_1997_1 AS
SELECT   p.product_name, od.order_id, o.order_date,
od.quanitity*od.unit_price AS total_revenue

FROM order_details AS od
JOIN products AS p
ON od.product_id = p.product_id
JOIN orders AS o
ON od.order_id = o.order_id
JOIN customers AS c
ON o.customer_id = c.customer_id

WHERE c.country = 'Germany' AND o.order_date BETWEEN '01/01/1997' AND  '12/31/1997'   

GROUP BY p.product_name, total_revenue, od.quanitity, od.unit_price, o.order_date,  od.order_id

ORDER BY quanitity ASC;

SELECT * FROM germany_view_1997_1;
