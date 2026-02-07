-- Project: Live Sales Data Simulation System
-- Description: Function to simulate new orders
-- Schema: sales

SET search_path TO sales;

DROP FUNCTION if exists simulate_new_order();

CREATE OR REPLACE FUNCTION simulate_new_order()
RETURNS INT AS $$
DECLARE
    v_customer INT;
    v_order_id INT;
BEGIN

	if random() < 0.3 then
		v_customer := simulate_new_customer();

	
    -- Pick random customer
	else
    	SELECT customer_id INTO v_customer
    	FROM customers
    	ORDER BY RANDOM()
    	LIMIT 1;
	end if;

    -- Insert order
    INSERT INTO orders (customer_id, order_status, total_amount)
    VALUES (v_customer, 'Processing', 0)
    RETURNING order_id INTO v_order_id;

	return v_order_id;

END;
$$ LANGUAGE plpgsql;