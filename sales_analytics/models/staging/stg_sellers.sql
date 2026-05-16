with source as (
    select * from {{ ref('raw_sellers') }}
),

cleaned as (
    select
        seller_id,
        seller_city as city,
        seller_state as state
    from source
    where seller_id is not null
)

select * from cleaned