# Practical Assignment 4

### Файли на гіті:
-  Загалом файл містить 4 файли:
-      `main.py` для генерації данних у таблиці
-      `create_users.sql` для створення 3х різних користувачів
-      `create_view.sql` для створення в'юшки, реферальної системи(нарах бонусів), тригера, функції для зменшення обсягу товарів на складі
  
### Зроблена робота:
  1) **Розроблено схему для E-commerce**
  2) **Зв'язки між таблицями:**
  - **1:1** - `users` та `user_profiles`
  - **1:many** - `users` та `orders`, `categories` та `products`
  - **many:many** - `orders` та `products` (через проміжну таблицю `order_items`)
  3) **Обмеження (Constraints):** Використано `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, та `CHECK` для забезпечення цілісності даних.
  4) **Індексування, оптимізація** Написано Python-скрипт, який генерує 500 000+ записів у таблиці `order_items` для тестування оптимізації індексів.

### ДОДАТКОВІ
  1) Створено 3 різних користувачів (`ecom_admin`, `sales_manager`, `data_analyst`) з різними рівнями доступу. (файл `create_users.sql`)
  2) Створено 1 View (`popular_products` для аналітики продажів). (create_view.sql)
  3) Створено 1 Stored Procedure (`add_loyalty_points` для нарахування бонусів користувачам). (`create_view.sql`)
  4) Створено 1 Trigger та Function (`trg_after_order_item_insert` для автоматичного списання кількості товару зі складу після замовлення). (`create_view.sql`)

---

## Структура бази даних (ERD)

https://mermaid.live/edit#pako:eNqlVFtvmzAU_iuWn1aJRtxCAm-I0A21WSJC9lAhIQ88ggo2M0YaI_nvxSFltKGa1vntyN_lfMcHWhjTBEMLYrbKUMpQEbKQgO7sd66_A8fj7S09noto62_uvAd3BywQQsVSwAFVIZzAt2Djr0TVAwtEGlDmKMYjuGMH7ueN77kDp5Nf7Z3gFSumhKOMjHgX5bFP5AXuuqcJUs_MSJzXydhx0P8r9zvOKUkrwGnPfh2xfSnF-Wb7zhfb_6QZNyBLwPZ-6lKV5RuAC5TlYD8ATmPVP7P9d3VxWVeYRR3i7l4aWYjjfQ1AThuU8yYqaUZ4ddXA6Ck-mI2gAk9FG0b-sVQx4jilrOmTjVEr1_HW9gMoWRbjt3ErTuOn6GeNCM94c9XUZYP-d9BjROCt3V1gr7eAsqQDJF3j076XfXvXvOefW5DemIxhJaNJHfNpoJjBVXoowZRlCbQ4q7EEC8y6fexK2ApACPkBFziE4kNIEHvqFp8ITonII6XFC43ROj1A6wfKq66qSxH08t8YIJh0ERxaEw4tTTXOGtBq4S9oKepMNxemphsLQ9c109Qk2EDLMGaqKi8VU58bmrw0FycJ_j67yrOFqsimZiryYjk35fn89AwUCVb7
