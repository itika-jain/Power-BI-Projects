set search_path to sales;
TRUNCATE TABLE payments, order_items, orders, customers, products RESTART IDENTITY CASCADE;


insert into regions (region_name) values
('North'),
('South'),
('East'),
('West'),
('Central') on conflict (region_name) do nothing;


insert into categories (category_name) values
('Electronics'),
('Clothing'),
('Home & Kitchen'),
('Sports'),
('Books') on conflict (category_name) do nothing;


insert into products (product_name, category_id, price)
select
	'Product_' || gs,
	c.category_id,
	(random() * 9000 + 500)::numeric(10,2)
from generate_series(1,50) gs
join lateral (
	select category_id
	from categories
	order by random() + gs
	limit 1
)c on true;


insert into customers (customer_name, email, region_id, join_date)
select
	'Customer_' || gs,
	'customer_' || gs || '@mail.com',
	r.region_id,
	current_date - (random() * 365)::int
from generate_series(1,200) gs
join lateral (
	select region_id
	from regions
	order by random() + gs
	limit 1
)r on true;


insert into orders (order_date, customer_id, order_status)
select
	now() - (random() * interval '30 days'),
	c.customer_id,
	(array['Completed', 'Failed', 'Processing', 'Cancelled'])[floor(random() * 4 + 1)]	
from generate_series(1,1000) gs
join lateral (
	select customer_id
	from customers
	order by random() + gs
	limit 1
)c on true;


INSERT INTO order_items (order_id, product_id, quantity, price_per_unit)
SELECT
    o.order_id,
    p.product_id,
    (floor(random()*5) + 1)::int as quantity,
    p.price
FROM orders o
JOIN LATERAL (
    SELECT product_id, price
    FROM products
    ORDER BY RANDOM() + o.order_id
    LIMIT (floor(random()*3) + 1)::INT
) p on TRUE;


UPDATE orders o
SET total_amount = oi_sum.total
FROM (
    SELECT order_id, SUM(quantity * price_per_unit) AS total
    FROM order_items
    GROUP BY order_id
) AS oi_sum
WHERE o.order_id = oi_sum.order_id;


insert into payments (order_id, payment_method, payment_status, payment_amount, payment_date)
select
	o.order_id,
	(array['UPI', 'Card', 'NetBanking', 'COD'])[floor(random() * 4 + 1)],
	case
		when o.order_status = 'Completed' then 'Success'
		when o.order_status = 'Cancelled' then 'Refunded'
		when o.order_status = 'Failed' then 'Failed'
		else 'Pending'
	end,
	o.total_amount,
	o.order_date + interval '5 minutes'
from orders o;