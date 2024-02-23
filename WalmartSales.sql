create table if not exists sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment varchar(20) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating double
);

Select * from sales; 

-- Add column (time_of_day)
alter table sales add column time_of_day varchar(15);
update sales
	set time_of_day = (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END);
    
-- Add column (time_of_day)
alter table sales add column Day_Name varchar(10);
update sales
	set Day_Name = DAYNAME(date); 

-- Add column (month_name)
alter table sales add column month_name varchar(15);
update sales
	set month_name = monthname(date);


------------------------- Analyze-------------------------
-- Unique cities
select 
	distinct(city) 
from 
	sales;

-- City with branch
select 
	distinct(city),
    branch
from sales;

------------------------- Products -------------------------
-- Unique product lines 
select 
	distinct(product_line)
from 
	sales;
    
-- Most selling product line 
select 
	product_line,
    count(product_line)
from 
	sales
group by 
	product_line
order by 
	count(product_line) desc;
    
-- Most selling product 
select
	product_line,
    sum(quantity) as qty
from 
	sales
group by
	product_line
order by 
	qty desc;
    
-- Most used payment method?

Select 
	payment,
    count(payment) as TOTAL_USED
from 
	sales
group by 
	payment 
order by count(payment) desc;

-- Total revenue by month
select 
	month_name as MONTH,
    sum(total) as TOTAL
from 
	sales
group by 
	MONTH
order by 
	Total desc;
    
-- Month with the largest COGS
select
	month_name AS MONTH,
	SUM(cogs)  AS COGS
from 
	sales
group by
	MONTH 
order by 
	COGS;

-- Product line with the largest revenue
Select 
	product_line,
    sum(total) as Total
from 
	sales
group by
	product_line
order by 
	Total desc;
    
-- City with the largest revenue
select 
	city,
    sum(total) as Total
from
	sales
group by
	city
order by 
	Total desc;
    
-- Product with the largest VAT
select
	product_line,
	AVG(tax_pct) as AVG_tax
from 
	sales
group by 
	product_line
order by 
	avg_tax DESC;
    
-- Fetch each product line and add a column to those product and categorize it

select 
	product_line,
    avg(quantity) as Total,
    (case
		when avg(quantity) >= avg(quantity) then 'Good'
        when avg(quantity) < avg(quantity) then 'Bad' END) as category
from 
	sales
group by 
	product_line;
    
-- The Branch that sold more products than average product sold
select 
	branch, 
    sum(quantity)
from 
	sales
group by
	branch
having 
	sum(quantity) > (select avg(quantity)from sales);

-- Most common product line by gender
select 
	product_line,
	gender,
    count(gender) as total_cnt
from sales
group by 
	gender, product_line
order by 
	total_cnt DESC;

-- Average rating of each product line
select 
	product_line,
    round(avg(rating),2) Avg_rating
from 
	sales
group by
	product_line
order by 
	Avg_rating desc;

-------------------------  Customers -------------------------------

-- Number of payment methods
select
	distinct payment
from sales;

-- Most common customer type
select 
	customer_type,
    count(customer_type) as Total
from 
	sales
group by 
	customer_type
order by 
	Total desc;

-- Most common gender of the customers
select
	gender,
	COUNT(*) as gender_cnt
from 
	sales
group by  
	gender
order by  
	gender_cnt DESC;

-- Gender distribution per branch
select 
	branch,
    gender,
    count(gender) as Total
from sales
group by 
	branch, gender 
order by 
	Total;

-- Time of the day when customers give most ratings
select
	time_of_day,
	AVG(rating) AS avg_rating
from sales
group by 
	time_of_day
order by 
	avg_rating DESC;

-- Time of the day when customers give most ratings per branch
select
	time_of_day,
	branch,
    avg(rating) as promedio
from sales
group by 
	time_of_day, branch
order by 
	promedio desc;

-- Which day fo the week has the best avg ratings?
select
	day_name,
	AVG(rating) AS avg_rating
from sales
group by 
	day_name 
order by
	avg_rating DESC;

-- Day of the week with the best average ratings per branch?
select 
	day_name,
    branch,
	COUNT(day_name) total_sales
from sales
group by 
	day_name, branch
order by 
	total_sales DESC;

-------------------------  Sales ---------------------------------

-- Number of sales made in each time of the day per weekday 
select
	time_of_day,
	COUNT(*) as total_sales
from sales
group by 
	time_of_day 
order by 
total_sales DESC;

-- Customer types that brings the most revenue
select 
	customer_type,
    sum(total) as revenue
from 
	sales	
group by 
	customer_type
order by
	revenue;

-- City with the largest tax/VAT %
select 
	city,
    round(avg(tax_pct),2) tax
from 
	sales
group by 
	city 
order by 
	tax desc;

-- Customer type that pays the most in VAT
select 
	customer_type,
    avg(tax_pct) as Total
from 
	sales
group by 
	customer_type
order by 
	Total
