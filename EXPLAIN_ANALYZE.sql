DROP INDEX IF EXISTS idx_orders_order_date;
EXPLAIN ANALYZE SELECT * FROM orders WHERE order_date >= '2023-01-01';\

CREATE INDEX idx_orders_order_date ON orders(order_date);
EXPLAIN ANALYZE SELECT * FROM orders WHERE order_date >= '2023-01-01';