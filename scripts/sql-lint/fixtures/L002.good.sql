SELECT SUM(amount) FROM orders WHERE order_date = (SELECT MAX(order_date) FROM orders)
