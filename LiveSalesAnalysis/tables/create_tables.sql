set search_path to sales;


create table regions (
	region_id serial primary key,
	region_name varchar(50) not null unique
);


create table categories(
	category_id serial primary key,
	category_name varchar(50) not null unique
);


create table products(
	product_id serial primary key,
	product_name varchar(50) not null,
	category_id int not null references categories(category_id),
	price numeric(10,2) not null
);


create table customers(
	customer_id serial primary key,
	customer_name varchar(100) not null,
	email varchar(50),
	region_id int not null references regions(region_id),
	join_date date default current_date
);


create table orders(
	order_id serial primary key,
	order_date timestamp default current_timestamp,
	customer_id int not null references customers(customer_id),
	order_status varchar(50) not null check (order_status in ('Processing', 'Completed', 'Cancelled', 'Failed')) default 'Processing',
	total_amount numeric(10,2) default 0
);


create table order_items(
	order_item_id serial primary key,
	order_id int not null references orders(order_id),
	product_id int not null references products(product_id),
	quantity int not null check (quantity > 0),
	price_per_unit numeric(10,2) not null
);


create table payments(
	payment_id serial primary key,
	order_id int  not null references orders(order_id),
	payment_method varchar(50) check (payment_method in ('UPI', 'Card', 'Net Banking', 'COD')),
	payment_status varchar(50) not null check (payment_status in ('Success', 'Faild', 'Refunded', 'Pending')),
	payment_amount numeric(10,2) not null,
	payment_date timestamp default current_timestamp
);