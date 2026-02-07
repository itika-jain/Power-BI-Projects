set search_path to sales_reports;

create or replace view vw_products as
select product_id, product_name, category_id, price
from sales.products;