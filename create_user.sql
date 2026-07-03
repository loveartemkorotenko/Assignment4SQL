-- ========================================================
-- 1. СТВОРЕННЯ 3 КОРИСТУВАЧІВ З РІЗНИМИ ПРАВАМИ 
-- ========================================================
-- Адміністратор
CREATE ROLE ecom_admin LOGIN PASSWORD 'admin';
GRANT ALL PRIVILEGES ON DATABASE ecommerce_db TO ecom_admin;

-- Менеджер з продажів
CREATE ROLE sales_manager LOGIN PASSWORD 'sales';
GRANT SELECT, INSERT, UPDATE ON orders, order_items TO sales_manager;

-- Аналітик
CREATE ROLE data_analyst LOGIN PASSWORD '123';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO data_analyst;
