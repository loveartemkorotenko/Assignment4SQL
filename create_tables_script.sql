
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS user_profiles CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(36) PRIMARY KEY,
    first_name VARCHAR(200) NOT NULL,
    last_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    phone VARCHAR(20),
    registration_date TIMESTAMP DEFAULT now(),
    active BOOLEAN DEFAULT TRUE
);

COMMENT ON TABLE users IS 'Table to store main user information';
COMMENT ON COLUMN users.id IS 'Unique identifier for each user';
COMMENT ON COLUMN users.email IS 'User email, must be unique';

CREATE TABLE IF NOT EXISTS user_profiles (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    delivery_address VARCHAR(500),
    loyalty_points INT DEFAULT 0 CHECK (loyalty_points >= 0)
);

COMMENT ON TABLE user_profiles IS 'Table to store additional user profile details (1:1 relationship)';
COMMENT ON COLUMN user_profiles.user_id IS 'Reference to users table, UNIQUE enforces 1:1 relationship';

CREATE TABLE IF NOT EXISTS categories (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(200) NOT NULL UNIQUE,
    description VARCHAR(500)
);

COMMENT ON TABLE categories IS 'Table to store product categories';

CREATE TABLE IF NOT EXISTS products (
    id VARCHAR(36) PRIMARY KEY,
    category_id VARCHAR(36) NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    name VARCHAR(200) NOT NULL,
    description VARCHAR(1000),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0)
);

COMMENT ON TABLE products IS 'Table to store product information';
COMMENT ON COLUMN products.category_id IS 'Reference to category (1:many relationship)';
COMMENT ON COLUMN products.price IS 'Product price, cannot be negative';

CREATE TABLE IF NOT EXISTS orders (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT now(),
    status VARCHAR(50) DEFAULT 'PENDING',
    total_amount DECIMAL(10, 2) DEFAULT 0.0 CHECK (total_amount >= 0)
);

COMMENT ON TABLE orders IS 'Table to store user orders';
COMMENT ON COLUMN orders.user_id IS 'Reference to user who placed the order';

CREATE TABLE IF NOT EXISTS order_items (
    order_id VARCHAR(36) NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id VARCHAR(36) NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (order_id, product_id)
);

COMMENT ON TABLE order_items IS 'Junction table to store items within an order (many:many relationship)';
COMMENT ON COLUMN order_items.quantity IS 'Number of products ordered, must be > 0';

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_order_date ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);