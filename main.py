import uuid
import random
import psycopg2
from psycopg2.extras import execute_values
from psycopg2 import Error
from faker import Faker
from datetime import datetime, timedelta

HOST = 'localhost'
USER = 'Admin'
PASSWORD = 'Admin'
DATABASE = 'postgres'
PORT = '5432'

fake = Faker()

import os
os.environ['PGCLIENTENCODING'] = 'utf-8'
os.environ['LC_MESSAGES'] = 'C'

def create_connection():
    try:
        connection = psycopg2.connect(
            host=HOST,
            port=PORT,
            user=USER,
            password=PASSWORD,
            dbname=DATABASE,
        )
        print("Успішне підключення до бази даних.")
        return connection
    except Error as e:
        print(f"Помилка підключення: '{e}'")
        return None


def generate_and_insert_data():
    connection = create_connection()
    if connection is None:
        return

    cursor = connection.cursor()

    try:
        print("Генерація та вставка категорій і товарів")
        categories = [(str(uuid.uuid4()), fake.word().capitalize(), fake.sentence()) for _ in range(10)]
        execute_values(cursor, """
                               INSERT INTO categories (id, name, description)
                               VALUES %s ON CONFLICT DO NOTHING
                               """, categories)
        category_ids = [c[0] for c in categories]
        products = [
            (str(uuid.uuid4()), random.choice(category_ids), fake.catch_phrase(), fake.text(max_nb_chars=100),
             round(random.uniform(5.0, 500.0), 2), random.randint(10, 1000))
            for _ in range(1000)
        ]
        execute_values(cursor, """
                               INSERT INTO products (id, category_id, name, description, price, stock_quantity)
                               VALUES %s ON CONFLICT DO NOTHING
                               """, products)

        print("Генерація та вставка користувачів та їх профілів")
        users = []
        profiles = []
        for _ in range(10000):
            user_id = str(uuid.uuid4())
            users.append((user_id, fake.first_name(), fake.last_name(), fake.unique.email(), fake.phone_number(), True))
            profiles.append((str(uuid.uuid4()), user_id, fake.address().replace('\n', ', '), random.randint(0, 500)))

        execute_values(cursor, """
                               INSERT INTO users (id, first_name, last_name, email, phone, active)
                               VALUES %s ON CONFLICT DO NOTHING
                               """, users)
        execute_values(cursor, """
                               INSERT INTO user_profiles (id, user_id, delivery_address, loyalty_points)
                               VALUES %s ON CONFLICT DO NOTHING
                               """, profiles)

        print("Генерація та вставка замовлень")
        user_ids = [u[0] for u in users]
        orders = []
        for _ in range(100000):
            order_id = str(uuid.uuid4())
            order_date = datetime.now() - timedelta(days=random.randint(0, 365), hours=random.randint(0, 24))
            orders.append((order_id, random.choice(user_ids), order_date,
                           random.choice(['PENDING', 'SHIPPED', 'DELIVERED', 'CANCELLED']), 0.0))

        execute_values(cursor, """
                               INSERT INTO orders (id, user_id, order_date, status, total_amount)
                               VALUES %s ON CONFLICT DO NOTHING
                               """, orders)

        print("Генерація та вставка деталей замовлень")
        order_ids = [o[0] for o in orders]
        product_list = [(p[0], p[4]) for p in products]

        order_items = set()
        while len(order_items) < 500000:
            o_id = random.choice(order_ids)
            p_id, p_price = random.choice(product_list)
            qty = random.randint(1, 5)
            order_items.add((o_id, p_id, qty, p_price))

        execute_values(cursor, """
                               INSERT INTO order_items (order_id, product_id, quantity, unit_price)
                               VALUES %s ON CONFLICT DO NOTHING
                               """, list(order_items))

        connection.commit()
        print("Дані успішно вставлено!")

    except Error as e:
        connection.rollback()
        print(f"Помилка бази даних: '{e}'")
    finally:
        cursor.close()
        connection.close()
        print("З'єднання закрито.")


if __name__ == "__main__":
    generate_and_insert_data()