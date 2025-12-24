-- Segment-level funnel: cart -> purchase conversion
-- Purpose: identify responsibility segments (where conversion drop-off concentrates)
-- Expected schema: (user_id, event_type, event_time, price)

WITH user_flags AS (
    SELECT
        user_id,
        -- user-level reach flags
        MAX(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS has_cart,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS has_purchase,
        -- a simple user-level segmentation anchor (proxy): user's max observed price
        MAX(price) AS user_max_price
    FROM events
    GROUP BY user_id
),
segmented AS (
    SELECT
        user_id,
        has_cart,
        has_purchase,
        CASE
            WHEN user_max_price >= 200 THEN 'high_price'
            ELSE 'low_price'
        END AS price_segment
    FROM user_flags
)
SELECT
    price_segment,
    COUNT(*) AS n_users,
    SUM(has_cart) AS n_cart_users,
    SUM(CASE WHEN has_cart = 1 AND has_purchase = 1 THEN 1 ELSE 0 END) AS n_cart_to_purchase_users,
    1.0 * SUM(CASE WHEN has_cart = 1 AND has_purchase = 1 THEN 1 ELSE 0 END) / NULLIF(SUM(has_cart), 0) AS cart_to_purchase_cr
FROM segmented
GROUP BY price_segment
ORDER BY price_segment;

-- Note: price_segment is a proxy segmentation; final responsibility segment will be defined in Python (e.g., new vs returning).

