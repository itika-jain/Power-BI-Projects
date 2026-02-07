set search_path to sales_reports;

create or replace view vw_categories as
select category_id, category_name
from sales.categories;