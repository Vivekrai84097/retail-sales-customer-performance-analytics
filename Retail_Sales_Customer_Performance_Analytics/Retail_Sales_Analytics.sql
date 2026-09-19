-- CREATED DATABASE RETAIL_ANALYTICS

create database retail_analytics;
use retail_analytics;

-- CREATED CUSTOMERS TABLE
create table customers (
	customer_id varchar(10) primary key,
    customer_name varchar(100),
    gender varchar(10),
    age int,
    city varchar(50),
    customer_segment varchar(20) 
);

-- DUPLICATE CUSTOMER IDs CHECK 

select customer_id,
count(*)
from customers
group by customer_id
having count(*) > 1;

-- NULL VALUE CHECK FOR CITY

select count(*)
from customers
where city is null;

-- NULL VALUE CHECK FOR CUSTOMER_ID

select count(*)
from customers 
where customer_id is null;

-- NULL VALUE CHECK FOR CUSTOMER_NAME

select count(*)
from customers 
where customer_name is null;

-- NULL VALUE CHECK FOR GENDER

select count(*)
from customers
where gender is null;

-- NULL VALUE CHECK FOR AGE

select count(*)
from customers
where age is null;

-- NULL VALUE CHECK FOR CUSTOMER_SEGMENT

select count(*)
from customers 
where customer_segment is null;

-- COMBINED QUERY FOR NULL CHECK FOR ALL THE COLUMNS

select 
	sum(case when customer_id is null then 1 else 0 end) as customer_id_nulls,
    sum(case when customer_name is null then 1 else 0 end) as customer_name_null,
    sum(case when gender is null then 1 else 0 end) as gender_null,
    sum(case when age is null then 1 else 0 end) as age_null,
    sum(case when city is null then 1 else 0 end) as city_null,
    sum(case when customer_segment is null then 1 else 0 end) as customer_segment_null
from customers;

-- IS CUSTOMER AGE REALISTIC

select count(*)
from customers
where age < 18 or age > 60;

-- CREATED PRODUCTS TABLE

create table products (
	product_id varchar(10) primary key,
    product_name varchar(100),
    category varchar(50),
    subcategory varchar(50),
    unit_price decimal(10, 2) 
);

-- CHECK PRODUCTS TABLE

select * from products;

-- COUNT PRODUCTS

select count(*) as total_products
from products;

-- INVALID PRICE CHECK

select count(*)
from products 
where unit_price <= 0;

-- INVALID PRODUCT check 

select * 
from products 
where unit_price <= 0;

-- NULL CHECK 

select
	sum(case when product_id is null then 1 else 0 end) as product_id_null,
    sum(case when product_name is null then 1 else 0 end) as product_name_null,
    sum(case when category is null then 1 else 0 end) as category_null,
    sum(case when subcategory is null then 1 else 0 end) as subcategory_null,
    sum(case when unit_price is null then 1 else 0 end) as unit_price_null
from products;

-- CREATED SALES TABLE

create table sales (
	order_id varchar(20) primary key,
    order_date date,
    customer_id varchar(10),
    product_id varchar(10),
    quantity int,
    discount decimal(5, 2),
    
    foreign key (customer_id) references customers(customer_id),
    foreign key (product_id) references products(product_id) 
);

-- CHECK SALES RECORD

select * from sales;

-- COUNT SALES RECORDS

select count(*) as total_sales
from sales;

-- NULL CHECK 

select
	sum(case when order_id is null then 1 else 0 end) as order_id_null,
    sum(case when order_date is null then 1 else 0 end) as order_date_null,
    sum(case when customer_id is null then 1 else 0 end) as customer_id_null,
    sum(case when product_id is null then 1 else 0 end) as product_id_null,
    sum(case when quantity is null then 1 else 0 end) as quantity_null,
    sum(case when discount is null then 1 else 0 end) as discount_null
from sales;

-- DUPLICATE ORDERS

select order_id, count(*)
from sales
group by order_id
having count(*) > 1;

-- QUANTITY VALIDATION

select count(*)
from sales
where quantity <= 0;

-- DISCOUNT VALIDATION

select count(*)
from sales 
where discount < 0 or discount > 1;

-- FOREIGN KEY INTEGRITY(CUSTOMERS)

select * 
from sales
left join customers
on sales.customer_id = customers.customer_id
where customers.customer_id is null;

-- FOREIGN KEY INTEGRITY(PRODUCTS)

select *
from sales
left join products 
on sales.product_id = products.product_id
where products.product_id is null;

-- TOTAL ORDERS

select count(*) as total_orders
from sales;

-- TOTAL QUANTITY

select sum(quantity) as total_quantity
from sales;

-- TOTAL REVENUE

select 
	sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from sales s
join products p
on s.product_id = p.product_id; 

-- AVERAGE ORDER VALUE

select 
	sum(s.quantity * p.unit_price * (1 - s.discount))  / count(s.order_id) as average_order_value
from sales s 
join products p 
on s.product_id = p.product_id;

-- CUSTOMER-WISE REVENUE

select c.customer_name,
	sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from customers c 
join sales s 
	on c.customer_id = s.customer_id
join products p 
	on s.product_id = p.product_id
group by c.customer_name
order by total_revenue desc;

-- TOP 5 CUSTOMERS

select c.customer_name,
	sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from customers c 
join sales s 
	on c.customer_id = s.customer_id 
join products p 
	on s.product_id = p.product_id
group by c.customer_name
order by total_revenue desc limit 5;

-- CUSTOMERS ORDERS

select c.customer_name,
	count(s.order_id) as total_orders
from customers c 
join sales s 
	on c.customer_id = s.customer_id
group by c.customer_name;

-- CUSTOMER REVENUE + ORDERS

select c.customer_name,
	count(s.order_id) as total_orders,
	sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from customers c 
join sales s 
	on c.customer_id = s.customer_id 
join products p 
	on s.product_id = p.product_id
group by c.customer_name;

-- AVERAGE ORDER VALUE PER CUSTOMERS

select c.customer_name,
	count(s.order_id) as total_orders,
	sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue,
    sum(s.quantity * p.unit_price * (1 - s.discount)) / count(s.order_id) as average_order_value
from customers c 
join sales s 
	on c.customer_id = s.customer_id 
join products p 
	on s.product_id = p.product_id
group by c.customer_name;

-- TOP 5 CUSTOMERS BY AVERAGE ORDER VALUE

select c.customer_name,
	count(s.order_id) as total_orders,
	sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue,
    sum(s.quantity * p.unit_price * (1 - s.discount)) / count(s.order_id) as average_order_value
from customers c 
join sales s 
	on c.customer_id = s.customer_id 
join products p 
	on s.product_id = p.product_id
group by c.customer_name
order by average_order_value desc limit 5;

-- CUSTOMER SEGMENT ANALYSIS

select c.customer_segment,
	count(s.order_id) as total_orders,
	sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from customers c 
join sales s 
	on c.customer_id = s.customer_id 
join products p 
	on s.product_id = p.product_id
group by c.customer_segment;

-- CITY-WISE REVENUE

select c.city,
	count(s.order_id) as total_orders,
	sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from customers c 
join sales s 
	on c.customer_id = s.customer_id 
join products p 
	on s.product_id = p.product_id
group by c.city
order by total_revenue desc;

-- CITY-WISE AVERAGE ORDER VALUE

select c.city,
	count(s.order_id) as total_orders,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue,
    sum(s.quantity * p.unit_price * (1 - s.discount)) / count(s.order_id) as average_order_value
from customers c 
join sales s 
	on c.customer_id = s.customer_id
join products p 
	on s.product_id = p.product_id
group by c.city
order by average_order_value desc;

-- CATEGORY-WISE PERFORMANCE

select p.category,
	count(s.order_id) as total_orders,
    sum(s.quantity) as total_quantity,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from products p 
join sales s 
	on p.product_id = s.product_id
group by p.category
order by total_revenue desc;

-- PRODUCT-WISE PERFORMANCE

select p.product_name,
	p.category,
    sum(s.quantity) as total_quantity,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from products p 
join sales s 
	on p.product_id = s.product_id
group by p.product_name, p.category
order by total_revenue desc;

-- MONTHLY SALES PERFORMANCE

select date_format(s.order_date, '%M') as month_name,
	count(s.order_id) as total_orders,
    sum(s.quantity) as total_quantity,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from sales s 
join products p 
	on s.product_id = p.product_id
group by month_name, month(s.order_date)
order by month(s.order_date);

-- CATEGORY + PRODUCT PERFORMANCE

select p.category,
	p.product_name,
    sum(s.quantity) as total_quantity,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from products p 
join sales s 
	on p.product_id = s.product_id
group by p.category, p.product_name
order by total_revenue desc;

-- TOP PRODUCT IN EACH CATEGORY

with product_revenue as (
	select p.category,
		p.product_name,
        sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
	from products p 
    join sales s 
		on p.product_id = s.product_id
	group by p.category, p.product_name
), 
ranked_product as (
	select 
		category,
        product_name,
        total_revenue,
        rank() over(partition by category order by total_revenue desc) as rnk
        from product_revenue
)
select
	category,
    product_name,
    total_revenue
from ranked_product
where rnk = 1;

-- CITY-WISE TOP CUSTOMER

with city_revenue as (
	select c.city,
		c.customer_name,
        sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
	from customers c 
    join sales s 
		on c.customer_id = s.customer_id
	join products p 
		on s.product_id = p.product_id
	group by c.city, c.customer_name
),
ranked_customer as (
	select 
		city,
        customer_name,
        total_revenue,
        rank() over(partition by city order by total_revenue desc) as rnk
	from city_revenue
)
select 
	city,
    customer_name,
    total_revenue
from ranked_customer
where rnk = 1;

-- REPEAT CUSTOMERS

select c.customer_name,
	count(s.order_id) as total_order,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from customers c 
join sales s 
	on c.customer_id = s.customer_id
join products p 
	on s.product_id = p.product_id
group by c.customer_name
having total_order > 1
order by total_revenue desc;

-- HIGH VALUE CUSTOMERS

select c.customer_name,
	count(s.order_id) as total_order,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from customers c 
join sales s 
	on c.customer_id = s.customer_id
join products p 
	on s.product_id = p.product_id
group by c.customer_name
having total_revenue > 50000
order by total_revenue desc;

-- CUSTOMER CONTRIBUTION %

select 
	c.customer_name,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue,
    (
		sum(s.quantity * p.unit_price * (1 - s.discount)) 
        / 
		(
			select sum(s2.quantity * p2.unit_price * (1 - s2.discount))
			from sales s2
            join products p2
				on s2.product_id = p2.product_id
		)
	) * 100 as revenue_percentage
from customers c 
join sales s 
	on c.customer_id = s.customer_id
join products p 
	on s.product_id = p.product_id
group by c.customer_name
order by revenue_percentage desc;

-- PRODUCT REVENUE CONTRIBUTION %

select p.product_name,
	sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue,
    (
		sum(s.quantity * p.unit_price * (1 - s.discount))
        / 
         (
			select sum(s2.quantity * p2.unit_price * (1 - s2.discount))
            from sales s2
            join products p2
				on s2.product_id = p2.product_id
			)
		) * 100 as revenue_percentage
from products p 
join sales s 
	on p.product_id = s.product_id
group by p.product_name
order by revenue_percentage desc;

-- TOP 5 PRODUCT

select p.product_name,
	p.category,
    sum(s.quantity) as total_quantity,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from products p 
join sales s 
	on p.product_id = s.product_id
group by p.product_name, p.category
order by total_revenue desc limit 5;

-- BOTTOM 5 PRODUCT

select p.product_name,
	p.category,
    sum(s.quantity) as total_quantity,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from products p 
join sales s 
	on p.product_id = s.product_id
group by p.product_name, p.category
order by total_revenue asc limit 5;

-- HIGH - DISCOUNT ORDERS

select s.order_id,
	p.product_name,
    s.quantity,
    s.discount,
    s.quantity * p.unit_price * (1 - s.discount) as total_revenue
from sales s 
join products p 
	on s.product_id = p.product_id
where s.discount >= 0.08;

-- CATEGORY CONTRIBUTION % 

select p.category,
	sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue,
    (
		sum(s.quantity * p.unit_price * (1 - s.discount))
        /
			( 
				select sum(s2.quantity * p2.unit_price * (1 - s2.discount))
                from sales s2
                join products p2
					on s2.product_id = p2.product_id
				)
			) * 100 as revenue_percentage
from products p
join sales s 
	on p.product_id = s.product_id
group by p.category
order by revenue_percentage desc;

-- MONTHLY REVENUE ANALYSIS

select date_format(s.order_date, '%M') as month_name,
	count(s.order_id) as total_orders,
    sum(s.quantity) as total_quantity,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from sales s 
join products p 
	on s.product_id = p.product_id
group by month(s.order_date), month_name
order by month(s.order_date);

-- MONTH-OVER-MONTH REVENUE CHANGE

with monthly_revenue as (
	select 
		month(s.order_date) as month_number,
        date_format(s.order_date, '%M') as month_name,
        sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
	from sales s 
    join products p 
		on s.product_id = p.product_id
	group by month(s.order_date), date_format(s.order_date, '%M')
),
revenue_with_previous as (
	select 
		month_number,
        month_name,
        total_revenue,
        lag(total_revenue) over(order by month_number) as previous_month_revenue
	from monthly_revenue
)
select 
	month_name,
    total_revenue,
    previous_month_revenue,
    total_revenue - previous_month_revenue as revenue_change
from revenue_with_previous
order by month_number;

-- MONTHLY REVENUE GROWTH %

with monthly_revenue as (
	select 
		month(s.order_date) as month_number,
        date_format(s.order_date, '%M') as month_name,
        sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
	from sales s 
    join products p 
		on s.product_id = p.product_id
	group by month(s.order_date), date_format(s.order_date, '%M')
), 
revenue_with_previous as (
	select 
		month_number,
        month_name,
        total_revenue,
        lag(total_revenue) over(order by month_number) as previous_month_revenue
	from monthly_revenue
)
select 
	month_name,
    total_revenue,
    previous_month_revenue,
    (
		(total_revenue - previous_month_revenue) / previous_month_revenue) * 100 as revenue_growth_percentage
from revenue_with_previous
order by month_number;

-- RUNNING TOTAL REVENUE

with monthly_revenue as (
	select 
		month(s.order_date) as month_number,
        date_format(s.order_date, '%M') as month_name,
        sum(s.quantity * p.unit_price * (1 - s.discount)) as monthly_revenue
	from sales s 
    join products p 
		on s.product_id = p.product_id
	group by month(s.order_date), date_format(s.order_date, '%M')
)
select 
	month_name,
    monthly_revenue,
    sum(monthly_revenue) over(order by month_number) as running_total_revenue
from monthly_revenue
order by month_number;

-- BEST & WORST REVENUE MONTH

with monthly_revenue as (
	select 
		month(s.order_date) as month_number,
        date_format(s.order_date, '%M') as month_name,
        sum(s.quantity * p.unit_price * (1 - s.discount)) as monthly_revenue
	from sales s 
    join products p 
		on s.product_id = p.product_id
	group by month(s.order_date), date_format(s.order_date, '%M')
)
select 
	month_name,
    monthly_revenue
from monthly_revenue
where monthly_revenue = (
	select max(monthly_revenue)
    from monthly_revenue
)
or monthly_revenue = (
	select min(monthly_revenue)
    from monthly_revenue
);

-- REVENUE CONCENTRATION

with customer_revenue as (
	select 
		c.customer_name,
		sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
	from customers c
    join sales s 
		on c.customer_id = s.customer_id
	join products p 
		on s.product_id = p.product_id
	group by c.customer_name
),
 top_5 as (
	select 
		customer_name,
        total_revenue
	from customer_revenue
    order by total_revenue desc limit 5
)
select 
	sum(total_revenue) as top_5_revenue,
    (select sum(total_revenue) from customer_revenue) as total_revneue,
    (sum(total_revenue) / (select sum(total_revenue) from customer_revenue)) * 100 as top_5_revenue_percentage
from top_5;

-- DISCOUNT IMPACT ON REVENUE

select 
	sum(
		case
			when s.discount >= 0.08
            then s.quantity * p.unit_price * (1 - s.discount)
			else 0
		end
	) as high_discount_revenue,
    
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue,
    (
		sum(
			case
				when s.discount >= 0.08
                then s.quantity * p.unit_price * (1 - s.discount)
				else 0
			end
		)
		/
	    sum(s.quantity * p.unit_price * (1 - s.discount))
	) * 100 as high_discount_revenue_percentage
from sales s 
join products p 
	on s.product_id = p.product_id;
    
-- LOW PERFORMING CITY

select 
	c.city,
    count(s.order_id) as total_orders,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from customers c 
join sales s 
	on c.customer_id = s.customer_id
join products p 
	on s.product_id = p.product_id
group by c.city
order by total_revenue asc limit 1;

-- LOW PERFORMING CATEGORY

select 
	p.category,
    count(s.order_id) as total_orders,
    sum(s.quantity) as total_quantity,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from products p 
join sales s 
	on p.product_id = s.product_id
group by p.category
order by total_revenue asc limit 1;

-- CUSTOMER WITH REVENUE > 50000 AND ORDERS > 2

select 
    c.customer_name,
    count(s.order_id) as total_orders,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from customers c 
join sales s 
	on c.customer_id = s.customer_id
join products p 
	on s.product_id = p.product_id
group by c.customer_name
having total_revenue > 50000 and total_orders > 2;

-- CITY WITH HIGH ORDERS

select 
	c.city,
    count(s.order_id) as total_orders,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from customers c
join sales s 
	on c.customer_id = s.customer_id
join products p 
	on s.product_id = p.product_id
group by c.city
order by total_orders desc limit 1;

-- CUSTOMER WITH HIGH REVENUE

select 
	c.customer_name,
    count(s.order_id) as total_orders,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from customers c
join sales s 
	on c.customer_id = s.customer_id
join products p 
	on s.product_id = p.product_id
group by c.customer_name
order by total_revenue desc limit 1;

-- CUSTOMER REVENUE AND AVERAGE REVENUE

with customer_revenue as (
select 
	c.customer_name,
    sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
from customers c
join sales s 
	on c.customer_id = s.customer_id
join products p 
	on s.product_id = p.product_id
group by c.customer_name
)
select 
	customer_name,
	total_revenue
from customer_revenue
where total_revenue > (
	select avg(total_revenue)
    from customer_revenue
)
order by total_revenue desc;

-- CITY-WISE TOP CUSTOMER

with city_customer_revenue as (
	select 
		c.city,
        c.customer_name,
        sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
	from customers c 
    join sales s 
		on c.customer_id = s.customer_id
	join products p 
		on s.product_id = p.product_id
	group by c.city, c.customer_name
),
ranked_customer as (
	select 
		city,
        customer_name,
        total_revenue,
        rank() over(partition by city order by total_revenue desc) as rnk
        from city_customer_revenue
)
select 
	city,
    customer_name,
    total_revenue
from ranked_customer
where rnk = 1
order by city;

-- PRODUCT ABOVE CATEGORY AVERAGE REVENUE

with product_revenue as (
	select 
		p.category,
        p.product_id,
        p.product_name,
        sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
	from products p 
    join sales s 
		on p.product_id = s.product_id
	group by p.category, p.product_id, p.product_name
),
category_avg as (
	select 
		category,
        product_name,
        total_revenue,
        avg(total_revenue) over(partition by category) as avg_category_revenue
	from product_revenue
)
select 
	category,
    product_name,
    total_revenue
from category_avg
where total_revenue > avg_category_revenue
order by category, total_revenue desc;

-- CUSTOMER CATEGORY ANALYSIS

with customer_category_revenue as (
	select 
		c.customer_id,
        c.customer_name,
        p.category,
        sum(s.quantity * p.unit_price * (1 - s.discount)) as total_revenue
	from customers c 
    join sales s 
		on c.customer_id = s.customer_id
	join products p 
		on s.product_id = p.product_id
	group by c.customer_id, c.customer_name, p.category
),
ranked_category as (
	select 
		customer_name,
        category,
        total_revenue,
        rank() over(partition by customer_id order by total_revenue desc) as category_rnk
	from customer_category_revenue
)
select 
	customer_name,
    category,
    total_revenue
from ranked_category
where category_rnk = 1
order by customer_name;