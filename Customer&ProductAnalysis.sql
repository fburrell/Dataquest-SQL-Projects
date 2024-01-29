--Dataquest Guided Project: Customers and Products Analysis Using SQL

--Question 1: Which Products Should We Order More of or Less of?

WITH
lowstock AS (SELECT productcode, productname, 
       round((SELECT sum(quantityordered)*1.0 FROM orderdetails o WHERE  p.productcode = o.productcode)/quantityinstock,2)  AS stock
  FROM products p
  GROUP BY productcode

),
prodperf AS (SELECT productCode, 
       SUM(quantityOrdered * priceEach) AS prod_perf
  FROM orderdetails od
 GROUP BY productCode 

)
  SELECT ls.productcode, 
         ls.stock, pf.prod_perf
    FROM lowstock  AS ls
    JOIN prodperf AS pf
      ON ls.productCode = pf.productcode
      ORDER BY prod_perf DESC
   LIMIT 10;

--Question 2: How Should We Match Marketing and Communication Strategies to Customer Behavior?


--Find most profitable customers
WITH money AS (SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS profit FROM products p
JOIN orderdetails od 
ON p.productCode=od.productCode
JOIN orders o
ON od.orderNumber=o.orderNumber
GROUP customerNumber
ORDER BY profit DESC)

SELECT contactLastName, contactfirstname, city, country, profit FROM customers c
JOIN money
ON c.customerNumber=money.customerNumber
ORDER BY profit DESC
LIMIT 5

--Question 3: How Much Can We Spend on Acquiring New Customers?

WITH money AS (SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS profit FROM products p
JOIN orderdetails od 
ON p.productCode=od.productCode
JOIN orders o
ON od.orderNumber=o.orderNumber
GROUP BY customerNumber
ORDER BY profit DESC)

SELECT avg(profit) AS ltv FROM money

-answer: 39039.59 is customer Lifetime Value (LTV)



