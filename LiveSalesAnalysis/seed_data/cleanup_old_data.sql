SET search_path TO sales;

-- Function to clean simulation data older than 2 months
CREATE OR REPLACE FUNCTION cleanup_old_data()
RETURNS VOID AS $$
DECLARE
    deleted_orders INT;
    deleted_payments INT;
BEGIN
    -- Delete payments older than 2 months
    DELETE FROM payments
    WHERE payment_date < now() - interval '2 months'
    RETURNING 1 INTO deleted_payments;

    -- Delete orders older than 2 months (order_items will cascade if FK set)
    DELETE FROM orders
    WHERE order_date < now() - interval '2 months'
    RETURNING 1 INTO deleted_orders;


	PERFORM setval('payments_payment_id_seq', COALESCE((SELECT MAX(payment_id) FROM payments),0) + 1, false);

    PERFORM setval('orders_order_id_seq', COALESCE((SELECT MAX(order_id) FROM orders),0) + 1, false);

    PERFORM setval('order_items_order_item_id_seq', COALESCE((SELECT MAX(order_item_id) FROM order_items),0) + 1, false);

    RAISE NOTICE 'Cleanup complete: %, % old orders and payments deleted.', deleted_orders, deleted_payments;
END;
$$ LANGUAGE plpgsql;