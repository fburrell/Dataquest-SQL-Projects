--Dataquest Guided Project: Customers and Products Analysis Using SQL

--Question 1: Which Products Should We Order More of or Less of?

WITH
lowstock AS (SELECT productcode, productname, 
       round((select sum(quantityordered)*1.0 from orderdetails o where  p.productcode = o.productcode)/quantityinstock,2)  as stock
  FROM products p
  group by productcode

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
      order by prod_perf desc
   LIMIT 10;

--Question 2: How Should We Match Marketing and Communication Strategies to Customer Behavior?


--Find most profitable customers
with money as (select o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) as profit from products p
join orderdetails od 
on p.productCode=od.productCode
join orders o
on od.orderNumber=o.orderNumber
group by customerNumber
order by profit desc)

select contactLastName, contactfirstname, city, country, profit from customers c
join money
on c.customerNumber=money.customerNumber
order by profit desc
limit 5

--Question 3: How Much Can We Spend on Acquiring New Customers?

with money as (select o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) as profit from products p
join orderdetails od 
on p.productCode=od.productCode
join orders o
on od.orderNumber=o.orderNumber
group by customerNumber
order by profit desc)

select avg(profit)as ltv from money

-answer: 39039.59 is customer Lifetime Value (LTV)



