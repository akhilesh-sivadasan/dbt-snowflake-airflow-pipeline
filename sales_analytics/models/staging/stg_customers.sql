with source as (
    select * from {{ ref('raw_customers') }}
),

cleaned as (
    select
        customer_id,
        customer_city as city,
        customer_state as state
    from source
    where customer_id is not null
)

select * from cleaned