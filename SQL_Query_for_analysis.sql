-- ----------------------------- Wallmart data analysis -------------------------------------------------------------
Create database if not exists SalesDataWalmart;
show databaSES;
use salesdatawalmart;
show tables;
-- Create table
CREATE TABLE IF NOT EXISTS sales(
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
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
select * from sales;


-- --------------------------------- NEW FEATURE ADD ---------------------------------------------------------------------------
-- FEATURE NAME (time_of_day) like - Morning, Afternoon, Evening

select time from sales;
select time,
	(CASE 
		when time between "00:00:00" and "12:00:00" then "Morning"
        when time between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	END
    ) as time_of_day
from sales;

-- -- for add new column ----
Alter table sales add column time_of_day varchar(20);

-- -------for adding new values which we get from case statement in new column 

Update sales 
SET time_of_day = (
	CASE
		when time between "00:00:00" and "12:00:00" then "Morning"
        when time between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	END
    );
    
-- ----  NEW FEATURE (Day_name) (Like - Sun, Mon, Tues, Wed, Thur, Fri, Sat) -------------

### for adding new column day_name
Alter table sales add column day_name varchar(20);



Select date,
	dayname(date)
 from sales;
 
### for adding new values in day_name new column with case statement
Update sales
SET day_name = dayname(date);

-- --------- Adding new column of month_name --------------

Alter table sales add column month_name varchar(15);

Select date,
	monthname(date)
from sales;

----- Value in month column with condithion
Update sales
SET month_name = monthname(date);



-- --------------------------  EDA (EXPLORATORY DATA ANALYSIS) ------------------------------------------
-- unique city name and unique city count --
Select distinct city, count(distinct city) from sales;

-- unique city count --
Select count(distinct city) from sales;

-- unique city name --
Select distinct city from sales;

-- total city name --
Select city from sales;

-- total city count --
Select count(city) from sales;



-- unique branch name and unique branch count --

Select distinct branch, count(Distinct branch) from sales;

-- total unique branch -- 
Select Distinct branch from sales;

-- total unique branch count -- 
Select count(Distinct branch) from sales;

-- total branch --
Select branch from sales;

-- total branch count --
select count(branch) from sales;

-- --------- In which city is each branch ------------
Select distinct city, branch from sales;

select distinct city, branch from sales where branch = "A";
select distinct city, branch from sales where branch = "B";
select distinct city, branch from sales where branch = "C";



--  Count Unique Product --

Select Count(Distinct product_line) from sales;

--  Unique Product --

Select Distinct product_line from sales;

-- -------- Payment Method ----------------

Select Count(distinct payment) from sales;
Select distinct payment from sales;
 
 -- count of credit card --
select count(payment) from sales where payment= "Credit card";

-- count of ewallet --
select count(payment) from sales where payment= "Ewallet";

-- count of cash --
select count(payment) from sales where payment= "Cash";

-- payament with there number of usage
select payment, count(payment) from sales group by payment;

-- pament usage and there count is desending order --
select payment, count(payment) as payment_method from sales group by payment order by payment_method desc;

-- Max usage --
select distinct payment, count(payment) as max_usage_method from sales group by payment order by count(*) desc limit 1;

-- Second max usage payment methos --
select payment, count(payment) from sales group by payment order by count(*) desc limit 3 offset 1;

-- Third max usage payment methos --
select distinct payment, count(payment) from sales group by payment order by count(*) desc limit 3 offset 2;

-- ---------------------------------------------------------------------------------------------------------------
-- What is the most selling product line? --
select product_line , count(Product_line) as total_product_sale from sales group by product_line order by total_product_sale desc;

-- second max --
select product_line , count(Product_line) as total_product_sale from sales group by product_line order by total_product_sale desc limit 1 offset 1;

-- lowest selling product --
select product_line , count(Product_line) as total_product_sale from sales group by product_line order by total_product_sale  limit 1;

-- second lowest selling product --
select product_line , count(Product_line) as total_product_sale from sales group by product_line order by total_product_sale  limit 1 offset 1;

-- -------------------------------------------------------------------------------------------------
-- What is the total revenue by month? --
select month_name, sum(total) as total_revenue from sales group by month_name order by total_revenue desc;

-- What is the max total revenue of which month? --
select month_name, sum(total) as total_revenue from sales group by month_name order by total_revenue desc limit 1;

-- What is the lowest total revenue of which month? --
select month_name, sum(total) as total_revenue from sales group by month_name order by total_revenue limit 1;

-- ----------------------------------------------------------------------------------------------------------------
-- What month had the largest COGS? -- 
select month_name as month, sum(cogs) as cogs from sales group by month order by cogs desc;

-- ----------------------------------------------------------------------------------------------------------------
-- What product line had the largest revenue? --
select product_line, sum(total) as revenue from sales group by product_line order by revenue desc;

-- What product line had the one largest revenue? --
select product_line, sum(total) as revenue from sales group by product_line order by revenue desc limit 1;

-- What product line had the second largest revenue? --
select product_line, sum(total) as revenue from sales group by product_line order by revenue desc limit 1 offset 1;

-- What product line had the lowset revenue? --
select product_line, sum(total) as revenue from sales group by product_line order by revenue limit 1;

-- What product line had the second lowset revenue? --
select product_line, sum(total) as revenue from sales group by product_line order by revenue limit 1 offset 1;

-- --------------------------------------------------------------------------------------------------------------------
-- What is the city with the largest revenue? --
select branch, city, sum(total) as total_revenue from sales group by city, branch order by total_revenue desc;

-- What is the city with the lowset revenue? --
select 
branch, city, sum(total) as total_revenue 
from sales 
group by city, branch
order by total_revenue limit 1;

-- ------------------------------------------------------------------------------------------------------------------------
-- What product line had the largest VAT? -- 
select product_line, avg(tax_pct) as avg_tax from sales group by product_line order by avg_tax desc; 

-- -------------------------------------------------------------------------------------------------------------------------
-- Which branch sold more products than average product sold?--
select branch, sum(quantity) as qty from sales group by branch having sum(quantity) > (select avg(quantity) from sales);
select avg(quantity) from sales;

-- -------------------------------------------------------------------------------------------------------------------------
-- What is the most common product line by gender? --
select gender, product_line, count(gender)as total_cnt from sales group by gender , product_line order by total_cnt desc;

select count(gender) from sales where gender = "Male";

-- ---------------------------------------------------------------------------------------------------------------------------
-- What is the average rating of each product line? --
 select product_line, round(avg(rating),2) avg_rate from sales group by product_line order by avg_rate desc ;

-- --------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------- Sales --------------------------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday
select time_of_day, count(*) as total_sale from sales group by time_of_day order by total_sale desc;

-- Number of sales made in each time of the day per weekday by day
select time_of_day, count(*) as total_sale from sales where day_name = "Sunday" group by time_of_day order by total_sale desc;

-- Number of sales made in each time of the day per weekday by day wise
select time_of_day, day_name, count(*) as total_sale from sales group by day_name , day_name order by total_sale desc;


-- Which of the customer types brings the most revenue? --
select customer_type, sum(total) as total_revenue from sales group by customer_type order by total_revenue desc;


-- Which city has the largest tax percent/ VAT (**Value Added Tax**)? --
select city, avg(tax_pct) as vat from sales group by city order by vat desc;

-- Which customer type pays the most in VAT? --
Select customer_type, avg(tax_pct) as VAT
from sales
group by customer_type
order by VAT desc;

-- Which gender type pays the most in VAT? --
Select gender, avg(tax_pct) as VAT
from sales
group by gender
order by VAT desc;

-- -------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------- Customer -----------------------------------------------------------------------------------------

-- How many unique customer types does the data have?--
select distinct customer_type , 
count(customer_type) as total_customer 
from sales 
group by customer_type 
order by total_customer desc;

-- How many unique payment methods does the data have? --
select distinct  payment , 
count(payment) as payment_method
from sales 
group by payment 
order by payment_method desc;

-- What is the most common customer type?--
select customer_type, count(customer_type) as most_common_customer from sales
group by customer_type
order by most_common_customer
desc;

-- Which customer type buys the most? --
select customer_type, count(product_line) from sales group by customer_type;

-- What is the gender of most of the customers? --
select gender, count(customer_type) as count_cust from sales group by gender order by count_cust desc;

-- What is the gender distribution per branch? --
select gender, count(customer_type) as count_cust from sales where branch = "A" group by gender order by count_cust desc;
select gender, count(customer_type) as count_cust from sales where branch = "B" group by gender order by count_cust desc;
select gender, count(customer_type) as count_cust from sales where branch = "C" group by gender order by count_cust desc;

--  Which time of the day do customers give most ratings? --
select time_of_day, avg(rating) as rating from sales group by time_of_day order by rating desc;

-- Which time of the day do customers give most ratings per branch? --
select branch, avg(rating) as rating from sales group by branch order by rating desc;

--  Which time of the day do customers give most ratings? --
select time_of_day, avg(rating) as rating from sales where branch = "A" group by time_of_day order by rating desc;
select time_of_day, avg(rating) as rating from sales where branch = "B" group by time_of_day order by rating desc;
select time_of_day, avg(rating) as rating from sales where branch = "C" group by time_of_day order by rating desc;

-- Which day fo the week has the best avg ratings? --
select day_name, avg(rating) as rating from sales group by day_name order by rating desc;
select day_name, avg(rating) as rating from sales group by day_name order by rating desc limit 1;

-- Which day of the week has the best average ratings per branch? --
select day_name, avg(rating) as rating from sales where branch = "A" group by day_name order by rating desc;
select day_name, avg(rating) as rating from sales where branch = "B" group by day_name order by rating desc;
select day_name, avg(rating) as rating from sales where branch = "C" group by day_name order by rating desc;







