-- Project: Live Sales Data Simulation System
-- Description: Add last_updated column to all tables
-- Schema: sales

SET search_path TO sales;


ALTER TABLE products ADD COLUMN last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE customers ADD COLUMN last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE orders ADD COLUMN last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE order_items ADD COLUMN last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE payments ADD COLUMN last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP;