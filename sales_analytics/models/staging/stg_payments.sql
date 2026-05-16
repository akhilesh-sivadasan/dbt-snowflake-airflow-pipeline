with source as (
    select * from {{ ref('raw_payments') }}
),

cleaned as (
    select
        order_id,
        payment_type,
        payment_installments as installments,
        cast(payment_value as decimal(10,2)) as amount
    from source
    where order_id is not null
)

select * from cleaned