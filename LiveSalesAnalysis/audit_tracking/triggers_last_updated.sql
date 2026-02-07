-- Project: Live Sales Data Simulation System
-- Description: Auto-update last_updated column using triggers
-- Schema: sales


SET search_path TO sales;


-- Step 1: Create function
CREATE OR REPLACE FUNCTION update_last_updated_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Step 2: Attach trigger to tables
DROP TRIGGER IF EXISTS trg_products_updated ON products;
CREATE TRIGGER trg_products_updated
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_last_updated_column();

DROP TRIGGER IF EXISTS trg_customers_updated ON customers;
CREATE TRIGGER trg_customers_updated
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE FUNCTION update_last_updated_column();

DROP TRIGGER IF EXISTS trg_orders_updated ON orders;
CREATE TRIGGER trg_orders_updated
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION update_last_updated_column();

DROP TRIGGER IF EXISTS trg_order_items_updated ON order_items;
CREATE TRIGGER trg_order_items_updated
BEFORE UPDATE ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_last_updated_column();


DROP TRIGGER IF EXISTS trg_payments_updated ON payments;
CREATE TRIGGER trg_payments_updated
BEFORE UPDATE ON payments
FOR EACH ROW
EXECUTE FUNCTION update_last_updated_column();
