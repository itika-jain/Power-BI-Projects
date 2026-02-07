select current_database();

create table regions (
	region_id serial primary key,
	region_name varchar(50) not null unique
);

select * from regions;

create table categories(
	category_id serial primary key,
	category_name varchar(50) not null unique
);

select * from categories;

create table products(
	product_id serial primary key,
	product_name varchar(50) not null,
	category_id int references categories(category_id),
	price numeric(10,2) not null
);

select * from products;


create table customers(
	customer_id serial primary key,
	customer_name varchar(100) not null,
	email varchar(50),
	region_id int references regions(region_id),
	join_date date default current_date
);

select * from customers;

create table orders(
	order_id serial primary key,
	order_date timestamp default current_timestamp,
	customer_id int references customers(customer_id)
);

select * from orders;

create table order_items(
	order_item_id serial primary key,
	order_id int references orders(order_id),
	product_id int references products(product_id),
	quantity int not null check (quantity > 0),
	price_per_unit numeric(10,2) not null,
	total_price numeric(10,2) not null
);

select * from order_items;

create table payments(
	payment_id serial primary key,
	order_id int references orders(order_id),
	payment_method varchar(50),
	payment_status varchar(50),
	payment_amount numeric(10,2),
	payment_date timestamp default current_timestamp
);

select * from payments;


--------------------------------------------------------------------------------


insert into regions (region_name) values
('North'),
('South'),
('East'),
('West'),
('Central');

insert into categories (category_name) values
('Electronics'),
('Clothing'),
('Home & Kitchen'),
('Sports'),
('Books');

insert into products (product_name, category_id, price)
select
	'Product_' || gs,
	(random() * 4 + 1)::int,
	(random() * 9000 + 500)::numeric(10,2)
from generate_series(1,50) gs;

insert into customers(customer_name, email, region_id, join_date)
select
	'Customer_' || gs,
	'customer_' || gs || '@mail.com',
	(random() * 4 + 1)::int,
	current_date - (random() * 365)::int
from generate_series(1,200) gs;

insert into orders (customer_id, order_date)
select
	(random() * 199 + 1)::int,
	now() - (random() * interval '30 days')
from generate_series(1,1000);


INSERT INTO order_items (order_id, product_id, quantity, price_per_unit, total_price)
SELECT
    o.order_id,
    p.product_id,
    q.qty,
    p.price,
    qty * p.price
FROM orders o
JOIN LATERAL (
    SELECT product_id, price
    FROM products
    ORDER BY RANDOM()
    LIMIT (random()*3 + 1)::INT
) p ON TRUE
JOIN LATERAL (
    SELECT (RANDOM() * 4 + 1)::INT AS qty
) q ON TRUE;

insert into payments (order_id, payment_method, payment_status, payment_amount, payment_date)
select
	o.order_id,
	(array['UPI', 'Card', 'NetBanking', 'COD'])[floor(random() * 4 + 1)],
	(array['Success', 'Failed', 'Refunded', 'Pending'])[floor(random() * 4 + 1)],
	sum(oi.total_price),
	o.order_date + interval '5 minutes'
from orders o
join order_items oi on o.order_id = oi.order_id
group by o.order_id;


--------------------------------------------------------------------------------


CREATE OR REPLACE VIEW vw_order_details AS
SELECT
    o.order_id,
    o.order_date,
    c.customer_id,
    c.customer_name,
    r.region_name,
    p.product_id,
    p.product_name,
    cat.category_name,
    oi.quantity,
    oi.price_per_unit,
    oi.total_price,
    pay.payment_method,
    pay.payment_status,
    pay.payment_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN regions r ON c.region_id = r.region_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN payments pay ON o.order_id = pay.order_id;

CREATE OR REPLACE VIEW vw_kpi_summary AS
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(total_price) AS total_revenue,
    ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM order_items;

drop view if exists vw_sales_by_category;

CREATE OR REPLACE VIEW vw_sales_by_category AS
SELECT
    cat.category_name,
    SUM(oi.total_price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY cat.category_name;

CREATE OR REPLACE VIEW vw_sales_by_region AS
SELECT
    r.region_name,
    SUM(oi.total_price) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN regions r ON c.region_id = r.region_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY r.region_name;

CREATE OR REPLACE VIEW vw_payment_status AS
SELECT
    payment_status,
    COUNT(*) AS transactions,
    SUM(payment_amount) AS total_amount
FROM payments
GROUP BY payment_status;


-----------------------------------------------------------------


CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_customers_region_id ON customers(region_id);
CREATE INDEX idx_payments_order_id ON payments(order_id);

CREATE INDEX idx_orders_order_date ON orders(order_date);


-----------------


ALTER TABLE orders ADD COLUMN last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE order_items ADD COLUMN last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE payments ADD COLUMN last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP;


------------------


CREATE OR REPLACE FUNCTION update_last_updated_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.last_updated = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_orders_updated
BEFORE UPDATE ON orders
FOR EACH ROW EXECUTE FUNCTION update_last_updated_column();

CREATE TRIGGER trg_order_items_updated
BEFORE UPDATE ON order_items
FOR EACH ROW EXECUTE FUNCTION update_last_updated_column();

CREATE TRIGGER trg_payments_updated
BEFORE UPDATE ON payments
FOR EACH ROW EXECUTE FUNCTION update_last_updated_column();


--------------------


CREATE OR REPLACE FUNCTION simulate_live_orders()
RETURNS VOID AS $$
DECLARE
    v_customer INT;
    v_product INT;
    v_order INT;
    v_qty INT;
    v_price NUMERIC;
BEGIN
    -- Random customer
    SELECT customer_id INTO v_customer
    FROM customers ORDER BY RANDOM() LIMIT 1;

    -- Random product
    SELECT product_id, price INTO v_product, v_price
    FROM products ORDER BY RANDOM() LIMIT 1;

    v_qty := (RANDOM()*3 + 1)::INT;

    -- Insert order
    INSERT INTO orders(customer_id, order_date)
    VALUES (v_customer, NOW())
    RETURNING order_id INTO v_order;

    -- Insert order item
    INSERT INTO order_items(order_id, product_id, quantity, price_per_unit, total_price)
    VALUES (v_order, v_product, v_qty, v_price, v_qty * v_price);

    -- Insert payment (success mostly)
    INSERT INTO payments(order_id, payment_method, payment_status, payment_amount, payment_date)
    VALUES (
        v_order,
		(array['UPI', 'Card', 'Net Banking', 'COD'])[floor(random()*4 + 1)],
		CASE when random() < 0.9 then 'Success' else 'Failed' end,
		v_qty * v_price,
		now()
);
END;
$$ LANGUAGE plpgsql; 


-------------------------


CREATE OR REPLACE FUNCTION run_live_simulation()
RETURNS VOID AS $$
BEGIN
    PERFORM simulate_live_orders();
    PERFORM simulate_live_orders();
    PERFORM simulate_live_orders();
END;
$$ LANGUAGE plpgsql;


--------------------


CREATE OR REPLACE FUNCTION simulate_failure_spike()
RETURNS VOID AS $$
BEGIN
    UPDATE payments
    SET payment_status = 'Failed'
    WHERE payment_id IN (
        SELECT payment_id FROM payments ORDER BY RANDOM() LIMIT 20
    );
END;
$$ LANGUAGE plpgsql;


------------------------


CREATE OR REPLACE FUNCTION cleanup_old_data()
RETURNS VOID AS $$
BEGIN
    DELETE FROM payments
    WHERE order_id IN (
        SELECT order_id FROM orders
        WHERE order_date < NOW() - INTERVAL '60 days'
    );

    DELETE FROM order_items
    WHERE order_id IN (
        SELECT order_id FROM orders
        WHERE order_date < NOW() - INTERVAL '60 days'
    );

    DELETE FROM orders
    WHERE order_date < NOW() - INTERVAL '60 days';
END;
$$ LANGUAGE plpgsql;


----------------------------


SELECT cleanup_old_data();
SELECT simulate_failure_spike();
select run_live_simulation();


SELECT * FROM orders ORDER BY order_id DESC LIMIT 5;
SELECT * FROM order_items ORDER BY order_item_id DESC LIMIT 5;
SELECT * FROM payments ORDER BY payment_id DESC LIMIT 5;
