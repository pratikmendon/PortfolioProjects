Use sales;

-- 1. Show all customer records
SELECT * FROM customers;

-- 2. Show total number of customers
SELECT count(*) FROM customers;

-- 3. Show transactions for Chennai market (market code for chennai is Mark001
select * from transactions where market_code = "Mark001";

-- 4. Show distrinct product codes that were sold in chennai
select distinct(product_code) from transactions where market_code = "Mark001";

-- 5 Show transactions where currency is US dollars
select * from transactions 
where currency = "USD";


-- 6. Show transactions in 2020 join by date table
select t.*, d.* 
from transactions t
inner join `date` d
on t.order_date = d.`date`
where d.`year` = 2020;

-- 7. Show total revenue in year 2020
select sum(t.sales_amount) 
from transactions t
inner join `date` d
on t.order_date = d.`date`
where d.`year` = 2020
and t.currency="INR\r" or t.currency="USD\r";


-- 8. Show total revenue in year 2020, January Month,
select sum(t.sales_amount) 
from transactions t
inner join `date` d
on t.order_date = d.`date`
where d.`year` = 2020
and (t.currency="INR\r" or t.currency="USD\r")
and d.month_name = "January";

-- 9.Show total revenue in year 2020 in Chennai

select sum(t.sales_amount) 
from transactions t
inner join `date` d
on t.order_date = d.`date`
where d.`year` = 2020
and t.market_code = "Mark001";


select distinct(product_code) from transactions where market_code = "Mark001";

SELECT DISTINCT(currency) FROM transactions;
select count(*) from transactions where currency = 'INR\r';
select count(*) from transactions where currency = 'INR';
select count(*) from transactions where currency = 'USD\r';
select count(*) from transactions where currency = 'USD';