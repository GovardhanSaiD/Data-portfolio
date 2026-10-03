-- BASICS 
use classicmodels;

show databases;

select * from customers;

-- q1 .. list all the customer from USA sorted by customer_name
select * from customers where country = 'USA' order by customerName;

-- q2 .. 10 most expensive products by buyPrice
select * from products order by buyPrice desc limit 10;

-- q3 .. find all orders with status Cancelled or on Hold
select * from orders where status in ('On Hold','Cancelled');

-- AGGREGATES AND GROUP BY

-- q4 .. Total payments recieved per year
select year(paymentDate) as year,sum(amount) as Total_payments_received from payments group by year(paymentDate) order by year;

-- q5 .. Number of cus in each country, highest first
select count(*) as number_of_customers,country from customers 
group by country order by count(*) desc;

-- q6 .. Average buyPrice per productline
select round(avg(buyPrice),2) avg_buyPrice_per_productLine,productLine from products 
group by productLine;

-- HAVING
-- q7 .. Countries with more than 5 cus
select country,count(customerNumber) as count_of_cus from customers 
group by country having count(customerNumber) > 5;

-- q8 .. Customers whose total payments exceed the average total payment across all customers
select customerNumber,sum(amount) as total_payment from payments
group by customerNumber having sum(amount) > 
(select avg(customer_total) as average_of_total_payments from 
(select c.customerNumber,sum(p.amount) as customer_total from customers c 
join payments p on c.customerNumber = p.customerNumber 
group by p.customerNumber) as t);
	

-- JOINS
-- Q9 .. Each Customer name and number of orders(including 0 orders)
select c.customerName,count(o.orderNumber) Number_of_orders from customers c left join orders o on c.customerNumber = o.customerNumber
group by c.customerNumber order by Number_of_orders desc;

-- q10 .. Products that never been Ordered
select p.productCode,p.productName from products p left join orderdetails od on p.productCode = od.productCode 
where od.productCode is null;

-- q11 .. Top 5 cus by Revenue
select c.customerNumber,c.customerName,sum(od.quantityOrdered * od.priceEach) as Total_Revenue from customers c 
join orders o on c.customerNumber = o.customerNumber
join orderdetails od on o.orderNumber = od.orderNumber
group by c.customerNumber order by Total_Revenue desc limit 5;

-- q12 .. Total Sales per ProductLine
select p.productLine,sum(od.quantityOrdered * od.priceEach) as Total_sales from products p 
join orderdetails od on p.productCode = od.productCode 
group by p.productLine;


