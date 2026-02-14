SET search_path TO sales;

DROP FUNCTION if exists simulate_payment();

CREATE OR REPLACE FUNCTION simulate_payment(p_order_id int)
RETURNS VOID AS $$
DECLARE
    v_amount NUMERIC;
	v_status TEXT;
	v_method TEXT;
	r NUMERIC;
	
BEGIN
    SELECT total_amount INTO v_amount
    FROM orders
    WHERE order_id = p_order_id;


	r := random();

	if r < 0.45 then
		v_method := 'Card';
	elsif r < 0.75 then
		v_method := 'UPI';
	elsif r < 0.90 then
		v_method := 'NetBanking';
	else
		v_method := 'COD';
	end if;

	r := random();

    IF r < 0.92 THEN
        v_status := 'Success';
    ELSIF r < 0.96 THEN
        v_status := 'Failed';
    ELSIF r < 0.99 THEN
        v_status := 'Pending';
    ELSE
        v_status := 'Refunded';
    END IF;

	if v_method = 'COD' then
		v_status := 'Pending';
	end if;
	

    INSERT INTO payments(order_id, payment_method, payment_status, payment_amount)
    VALUES (
        p_order_id,
        v_method,
		v_status,
		v_amount
    );

    UPDATE orders
    SET order_status = 
		CASE
			when v_status = 'Success' then 'Completed'
			when v_status = 'Pending' then 'Processing'
			when v_status = 'Failed' then 'Failed'
			when v_status = 'Refunded' then 'Cancelled'
		END
    WHERE order_id = p_order_id;
	
END;
$$ LANGUAGE plpgsql;
