with orders as (
    select * from {{ ref('stg_orders') }}
),

items as (
    select
        order_id,
        count(*) as item_count,
        count(distinct seller_id) as seller_count,
        sum(price) as order_revenue,
        sum(shipping_cost) as order_shipping
    from {{ ref('stg_order_items') }}
    group by order_id
),

payments as (
    select * from {{ ref('int_order_payments') }}
)

select
    o.order_id,
    o.customer_id,
    o.ordered_at,
    o.delivered_at,
    o.estimated_delivery_at,
    o.status,
    i.item_count,
    i.seller_count,
    i.order_revenue,
    i.order_shipping,
    i.order_revenue + i.order_shipping as order_total,
    p.payment_count,
    p.total_payment,
    p.primary_payment_type,
    datediff('day', o.ordered_at, o.delivered_at) as delivery_days,
    datediff('day', o.ordered_at, o.estimated_delivery_at) as estimated_delivery_days,
    case
        when o.delivered_at <= o.estimated_delivery_at then 'on_time'
        when o.delivered_at > o.estimated_delivery_at then 'late'
        else 'pending'
    end as delivery_status
from orders o
left join items i on o.order_id = i.order_id
left join payments p on o.order_id = p.order_id