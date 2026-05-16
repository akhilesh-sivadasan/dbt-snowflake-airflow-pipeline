with source as (
    select * from {{ ref('raw_order_items') }}
),

cleaned as (
    select
        order_id,
        order_item_id as item_number,
        product_id,
        seller_id,
        cast(price as decimal(10,2)) as price,
        cast(freight_value as decimal(10,2)) as shipping_cost
    from source
    where order_id is not null
)

select * from cleaned