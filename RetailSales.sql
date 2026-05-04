-- Use Retail database
use retail;

-- Create Retail Sales Table
create table retail_sales (
	transactions_id int primary key,
    sale_date date, 
    sale_time time, 
    customer_id int, 
    gender varchar(10) , 
    age int, 
    category varchar(15), 
    quantiy int, 
    price_per_unit float, 
    cogs float, 
    total_sale float
);

-- import sales data from existing table
insert into retail_sales
select * from sales;

-- Data Cleaning
-- verify that all rows were imported
select count(*) from retail_sales;

-- rename a column name that I misspelt
alter table retail_sales 
rename column quantiy to quantity;

-- check for null values
select * from retail_sales 
where 
	transactions_id is null
    OR
    sale_date is Null
    OR
    sale_time is Null
    OR
    gender is Null
    OR
    category is null
    OR
    quantity is Null
    Or
    cogs is Null
    OR
    total_sale is null;

-- Data Exploration
-- How many sales made
select count(*) as total_sale from retail_sales;

-- How many unique customers
select count(distinct customer_id) as total_customers from retail_sales;

-- How many catgories available
select count(distinct category) as total_categories from retail_sales;

-- Data Analysis & Business Key Problems & Answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales 
where
sale_date = "2022-11-05";


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales
where
category = "Clothing"
And
quantity >= 4 
And
sale_date >= '2022-11-01'
AND 
sale_date < '2022-12-01';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as net_sale, count(*) as total_orders from retail_sales
group by 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category,round(avg(age),2) as Avg_age from retail_sales
where 
category = "Beauty";

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where
total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender,count(*) as total_trans from retail_sales
group by 1,2
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- first find the average sale for each month
select year(sale_date) as year, month(sale_date) as month, avg(total_sale) as avg_sale from retail_sales
group by 1,2
order by 1,2;

-- next find the month with the highest average sale using a window function
select year,month,avg_sale
 from(
 select year(sale_date) as year,
 month(sale_date) as month, 
 round(avg(total_sale),2) as avg_sale,
 rank() over(
 partition by year(sale_date)
 order by avg(total_sale) desc)
 As rnk
 from retail_sales
group by year(sale_date),month(sale_date))
t
where rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,sum(total_sale) as total_sales from retail_sales
group by 1
order by 2 desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct(customer_id)) as no_unique_customers from retail_sales
group by 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
With hourly_sales 
as
(
select *,
case
	when hour(sale_time) <12 then 'Morning'
    when hour(sale_time) between 12 and 17 then 'Afternoon'
    else 'Evening'
end as shift
 from retail_sales)
 select shift,count(*) as total_orders
 from hourly_sales
 group by shift;
 
 -- End Of Project :)
 
 