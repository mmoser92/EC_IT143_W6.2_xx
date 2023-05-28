/*****************************************************************************************************************
NAME:    EC_IT143_W6.2_MM
PURPOSE: Answer the questions that i created

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     05/23/2022   JJAUSSI       1. Built this script for EC IT440


RUNTIME: 
Xm Xs

NOTES: 
This is where I talk about what this script is, why I built it, and other stuff...
 
******************************************************************************************************************/

-- Q1:  How many items with ListPrice more than $1000 have been sold?
-- A1: 
*/
SELECT COUNT(salesorderid) Total
FROM SalesOrderDetail s JOIN Product p ON s.productid = p.productid
WHERE listprice > 1000;

-- Q2:  What is the number of left racing socks ('Racing Socks, L') ordered by Company Name 'Riding Cycles
-- A2: 
*/
SELECT SUM(orderqty) total
FROM Product p JOIN SalesOrderDetail sd ON p.productid = sd.productid
JOIN SalesOrderHeader sh ON sd.salesorderid = sh.salesorderid
JOIN Customer c ON sh.customerid = c.customerid
WHERE (Name = 'Racing Socks, L') AND (companyname = 'Riding Cycles');

-- Q3: What is the Sales Order ID and the Unit Price for every Single Item Order.
-- A3:
*/
WITH temp1 AS (
  SELECT salesorderid, SUM(orderqty) items
  FROM SalesOrderDetail
  GROUP BY salesorderid
  HAVING items = 1
)
SELECT salesorderid, unitprice
FROM SalesOrderDetail
WHERE salesorderid IN (SELECT salesorderid FROM temp1);

-- Q4: What is the product name and the Company Name for all Customers who ordered Product Model 'Racing Socks
-- A4:
*/
SELECT p.name, companyname
FROM Customer c JOIN SalesOrderHeader sh ON c.customerid = sh.customerid
JOIN SalesOrderDetail sd ON sh.salesorderid = sd.salesorderid
JOIN Product p ON sd.productid = p.productid
JOIN ProductModel pm ON p.productmodelid = pm.productmodelid
WHERE pm.name = 'Racing Socks';

-- Q5: What is the Sub Total value in Sale Order Header to list orders from the largest to the smallest, and for each order show the Company Name and the Sub Total and the total weight of the order. 
-- A5:
*/
SELECT companyname, subtotal, SUM(orderqty * weight) weight
FROM SalesOrderHeader sh JOIN SalesOrderDetail sd ON sh.salesorderid = sd.salesorderid
JOIN Product p ON sd.productid = p.productid
JOIN Customer c ON sh.customerid = c.customerid
GROUP BY sh.salesorderid, companyname, subtotal
ORDER BY subtotal DESC;

-- Q6: How many products in the Product Category 'Cranksets' have been sold to an address in 'London'?
-- A6: 
*/
SELECT SUM(orderqty) total
FROM Address a JOIN SalesOrderHeader sh ON a.addressid = sh.billtoaddressid
JOIN SalesOrderDetail sd ON sh.salesorderid = sd.salesorderid
JOIN Product p ON sd.productid = p.productid
JOIN ProductCategory pc ON p.productcategoryid = pc.productcategoryid
WHERE (city = 'London') AND (pc.name = 'Cranksets');

-- Q7: What is each order showing the Sales Order ID and Subtotal calculated three ways?
	A) From the SalesOrderHeader
	B) Sum of OrderQty*UnitPrice
	C) Sum of OrderQty*ListPrice
-- A7:
*/
WITH tempA AS (
  SELECT salesorderid, subtotal A_total
  FROM SalesOrderHeader
), tempB AS (
  SELECT salesorderid, SUM(orderqty * unitprice) B_total
  FROM SalesOrderDetail
  GROUP BY salesorderid
), tempC AS (
  SELECT salesorderid, SUM(orderqty * listprice) C_total
  FROM SalesOrderDetail sd JOIN Product p ON sd.productid = p.productid
  GROUP BY salesorderid
)
SELECT tempA.salesorderid, A_total, B_total, C_total
FROM tempA JOIN tempB ON tempA.salesorderid = tempB.salesorderid
JOIN tempC ON tempB.salesorderid = tempC.salesorderid;


-- Q8: Show the bestselling item by value.
-- A8:
*/
SELECT name, SUM(orderqty * unitprice) total_value
FROM SalesOrderDetail sd JOIN Product p ON sd.productid = p.productid
GROUP BY name
ORDER BY total_value DESC
LIMIT 1;


SELECT GETDATE() AS my_date;