
-- ========================================================
-- СТВОРЕННЯ VIEW
-- ========================================================
-- Представлення для аналітики популярності товарів
CREATE OR REPLACE VIEW popular_products AS
SELECT 
    p.id, 
    p.name AS product_name, 
    c.name AS category_name, 
    SUM(oi.quantity) AS total_sold
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name, c.name
ORDER BY total_sold DESC;

-- Процедура для нарахування бонусних балів користувачу
CREATE OR REPLACE PROCEDURE add_loyalty_points(p_user_id VARCHAR, p_points INT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE user_profiles
    SET loyalty_points = loyalty_points + p_points
    WHERE user_id = p_user_id;
END;
$$;

-- ========================================================
-- ТРИГЕР
-- ========================================================
-- Функція, яка зменшує залишок товару на складі при створенні замовлення
CREATE OR REPLACE FUNCTION reduce_stock_after_order()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE id = NEW.product_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Тригер, який викликає цю функцію автоматично
CREATE TRIGGER trg_after_order_item_insert
AFTER INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION reduce_stock_after_order();