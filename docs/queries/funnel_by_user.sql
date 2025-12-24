-- Funnel extraction at user level
-- Expected schema: (user_id, event_type, event_time, product_id, category_code, brand, price, user_session)
-- Each row represents one user and whether they reached each funnel step

SELECT
    user_id,

    -- Whether the user ever viewed a product
    MAX(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS has_view,

    -- Whether the user ever added a product to cart
    MAX(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS has_cart,

    -- Whether the user ever completed a purchase
    MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS has_purchase

FROM events
GROUP BY user_id;
