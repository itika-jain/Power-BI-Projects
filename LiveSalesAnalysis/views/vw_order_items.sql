set search_path to sales_reports;

create or replace view vw_order_items as
select order_item_id, order_id, product_id, quantity, price_per_unit, quantity*price_per_unit as item_total
from sales.order_items;