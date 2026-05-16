with items as (
    select * from {{ ref('stg_order_items') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

sellers as (
    select * from {{ ref('stg_sellers') }}
)

select
    s.seller_id,
    s.city,
    s.state,
    count(distinct i.order_id) as total_orders,
    sum(i.price) as total_revenue,
    avg(i.price) as avg_item_price,
    sum(i.shipping_cost) as total_shipping,
    count(*) as total_items_sold,
    avg(datediff('day', o.ordered_at, o.delivered_at)) as avg_delivery_days,
    sum(case when o.delivered_at > o.estimated_delivery_at then 1 else 0 end) as late_deliveries,
    round(
        sum(case when o.delivered_at > o.estimated_delivery_at then 1 else 0 end) * 100.0
        / nullif(count(distinct i.order_id), 0), 2
    ) as late_delivery_pct
from items i
join orders o on i.order_id = o.order_id
join sellers s on i.seller_id = s.seller_id
where o.status = 'delivered'
group by s.seller_id, s.city, s.state