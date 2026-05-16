with customer_orders as (
    select * from {{ ref('int_customer_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
)

select
    c.customer_id,
    c.city,
    c.state,
    coalesce(co.total_orders, 0) as total_orders,
    coalesce(co.lifetime_revenue, 0) as lifetime_revenue,
    coalesce(co.total_items, 0) as total_items,
    co.first_order_at,
    co.last_order_at,
    datediff('day', co.last_order_at, current_date()) as days_since_last_order,
    case
        when co.total_orders is null then 'never_purchased'
        when co.total_orders >= 3 and co.lifetime_revenue >= 500 then 'high_value'
        when co.total_orders >= 2 then 'repeat'
        when datediff('day', co.last_order_at, current_date()) <= 90 then 'recent'
        else 'at_risk'
    end as customer_segment
from customers c
left join customer_orders co on c.customer_id = co.customer_id