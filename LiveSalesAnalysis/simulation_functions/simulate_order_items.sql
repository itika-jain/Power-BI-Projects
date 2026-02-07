SET search_path TO sales;

drop function if exists simulate_order_items();

CREATE OR REPLACE FUNCTION simulate_order_items(p_order_id int)
RETURNS VOID AS $$
DECLARE
    v_items_count INT;
BEGIN
	v_items_count := (random() * 2 + 1)::INT;

    INSERT INTO order_items(order_id, product_id, quantity, price_per_unit)
    select
		p_order_id,
		p.product_id,
		(random() * 4 + 1)::INT,
		p.price
		from products p
		order by random()
		limit v_items_count;

    -- Update order total
    UPDATE orders
    SET total_amount = (
        SELECT SUM(quantity * price_per_unit)
        FROM order_items
        WHERE order_id = p_order_id
    )
    WHERE order_id = p_order_id;
	
END;
$$ LANGUAGE plpgsql;
