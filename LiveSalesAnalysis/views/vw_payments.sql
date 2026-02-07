set search_path to sales_reports;

create or replace view vw_payments as
select payment_id, order_id, payment_date, payment_method, payment_status, payment_amount
from sales.payments;