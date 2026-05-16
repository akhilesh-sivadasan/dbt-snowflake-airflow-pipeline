with source as (
    select * from {{ ref('raw_orders') }}
),

cleaned as (
    select
        order_id,
        customer_id,
        to_timestamp(order_purchase_timestamp) as ordered_at,
        to_timestamp(order_delivered_customer_date) as delivered_at,
        to_timestamp(order_estimated_delivery_date) as estimated_delivery_at,
        order_status as status
    from source
    where order_id is not null
)

select * from cleaned