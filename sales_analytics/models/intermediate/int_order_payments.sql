with payments as (
    select
        order_id,
        count(*) as payment_count,
        sum(amount) as total_payment,
        max(payment_type) as primary_payment_type
    from {{ ref('stg_payments') }}
    group by order_id
)

select * from payments