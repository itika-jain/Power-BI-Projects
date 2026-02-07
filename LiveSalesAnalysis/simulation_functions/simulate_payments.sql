SET search_path TO sales;

DROP FUNCTION if exists simulate_payment();

CREATE OR REPLACE FUNCTION simulate_payment(p_order_id int)
RETURNS VOID AS $$
DECLARE
    v_amount NUMERIC;
	v_status TEXT;
BEGIN
    SELECT total_amount INTO v_amount
    FROM orders
    WHERE order_id = p_order_id;

    v_status := (ARRAY['Success', 'Pending', 'Failed', 'Refunded'])[floor(random() * 4) + 1];

    INSERT INTO payments(order_id, payment_method, payment_status, payment_amount)
    VALUES (
        p_order_id,
        (ARRAY['Card','UPI','NetBanking', 'COD'])[floor(random()*4)+1],
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
