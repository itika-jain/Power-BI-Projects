set search_path to sales_reports;

create or replace view vw_customers as
select customer_id, customer_name, email, join_date, region_id
from sales.customers;