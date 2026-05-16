with orders as (
    select * from {{ ref('stg_orders') }}
),

items as (
    select
        order_id,
        count(*) as item_count,
        sum(price) as order_revenue,
        sum(shipping_cost) as order_shipping
    from {{ ref('stg_order_items') }}
    group by order_id
),

customer_orders as (
    select
        o.customer_id,
        count(distinct o.order_id) as total_orders,
        sum(i.order_revenue) as lifetime_revenue,
        sum(i.item_count) as total_items,
        min(o.ordered_at) as first_order_at,
        max(o.ordered_at) as last_order_at
    from orders o
    left join items i on o.order_id = i.order_id
    where o.status = 'delivered'
    group by o.customer_id
)

select * from customer_orders