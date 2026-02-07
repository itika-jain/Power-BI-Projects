set search_path to sales_reports;

create or replace view vw_regions as
select region_id, region_name
from sales.regions;