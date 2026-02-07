set search_path to sales_reports;


create or replace view vw_orders as
select order_id, customer_id, order_date:: date as order_date, order_date::time as order_time, order_status, total_amount
from sales.orders;