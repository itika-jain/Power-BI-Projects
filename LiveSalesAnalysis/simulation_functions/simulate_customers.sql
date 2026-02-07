set search_path to sales;

create or replace function simulate_new_customer()
returns int as $$
declare
	v_customer_id int;

begin
	insert into customers(customer_name, email, region_id, join_date)
	values(
		'Customer_' || floor(random()*100000),
		'customer_' || floor(random()*100000) || '@mail.com',
		(select region_id from regions order by random() limit 1),
		current_date
	)
	returning customer_id into v_customer_id;

	return v_customer_id;
end;
$$ language plpgsql;