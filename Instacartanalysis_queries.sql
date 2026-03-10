SELECT 'orders' AS tbl, COUNT(*) AS rows FROM orders
UNION ALL
SELECT 'order_products_prior', COUNT(*) FROM order_products_prior
UNION ALL
SELECT 'order_products_train', COUNT(*) FROM order_products_train
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'aisles', COUNT(*) FROM aisles
UNION ALL
SELECT 'departments', COUNT(*) FROM departments

-- Top 10 most odered products

SELECT 
    p.product_name,
    d.department,
    a.aisle,
    COUNT(*) AS times_ordered,
    ROUND(AVG(op.reordered) * 100, 1) AS reorder_rate_pct
FROM order_products_prior op
JOIN products p ON p.product_id = op.product_id
JOIN aisles a ON a.aisle_id = p.aisle_id
JOIN departments d ON d.department_id = p.department_id
GROUP BY p.product_name, d.department, a.aisle
ORDER BY times_ordered DESC
LIMIT 10

-- Department sales breakdown:

SELECT
    d.department,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 1) AS share_pct,
    ROUND(AVG(op.reordered) * 100, 1) AS reorder_rate_pct
FROM order_products_prior op
JOIN products p ON p.product_id = op.product_id
JOIN departments d ON d.department_id = p.department_id
GROUP BY d.department
ORDER BY total_orders DESC

-- When do people order? (day + hour):

SELECT
    order_dow,
    CASE order_dow
        WHEN 0 THEN 'Saturday'
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
    END AS day_name,
    order_hour_of_day,
    COUNT(*) AS orders
FROM orders
GROUP BY order_dow, order_hour_of_day
ORDER BY orders DESC
LIMIT 10

-- — Customer loyalty segmentation:

SELECT
    CASE 
        WHEN total_orders >= 20 THEN 'Power User (20+ orders)'
        WHEN total_orders >= 10 THEN 'Loyal (10-19 orders)'
        WHEN total_orders >= 5  THEN 'Regular (5-9 orders)'
        WHEN total_orders >= 2  THEN 'Returning (2-4 orders)'
        ELSE 'One-time buyer'
    END AS customer_segment,
    COUNT(*) AS users,
    ROUND(AVG(total_orders), 1) AS avg_orders,
    ROUND(AVG(avg_days_between_orders), 1) AS avg_days_between_orders
FROM (
    SELECT 
        user_id,
        MAX(order_number) AS total_orders,
        AVG(days_since_prior_order) AS avg_days_between_orders
    FROM orders
    GROUP BY user_id
) user_stats
GROUP BY customer_segment
ORDER BY avg_orders DESC