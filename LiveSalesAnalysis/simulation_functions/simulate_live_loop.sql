SET search_path TO sales;

DO $$
DECLARE
    i INT;
	j INT;
	v_order int;
	v_order_count INT;
    random_fail FLOAT;
BEGIN

	-- perform cleanup_old_data();
    FOR i IN 1..10 LOOP  -- run 10 cycles, adjust as needed

		v_order_count := (floor(random() * 5) + 1)::INT;

		for j in 1..v_order_count loop
        	-- Step 1: Create new order
        	v_order := simulate_new_order();

        	-- Step 2: Add items to the new order
        	PERFORM simulate_order_items(v_order);

        	PERFORM simulate_payment(v_order);  

        	-- Wait 5 seconds before next cycle
        	PERFORM pg_sleep((random() * 5)::INT);
		END LOOP;
    END LOOP;
END;
$$;