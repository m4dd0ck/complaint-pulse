-- mart_product_trends.sql
-- product × month aggregation for trend analysis
-- powers the product deep-dive page with category grouping

{{
    config(
        materialized='table'
    )
}}

with complaints as (
    select * from {{ ref('fct_complaints') }}
),

dates as (
    select * from {{ ref('dim_date') }}
),

products as (
    select * from {{ ref('dim_product') }}
),

product_monthly as (
    select
        d.year_month,
        d.year,
        p.product,
        p.product_category,

        count(*) as complaint_count,

        -- top issues for this product-month
        -- useful for drilling into what's driving volume
        round(
            safe_divide(
                countif(c.is_timely_response),
                count(*)
            ) * 100, 1
        ) as timely_response_pct,

        round(
            safe_divide(
                countif(c.is_monetary_relief or c.is_non_monetary_relief),
                count(*)
            ) * 100, 2
        ) as any_relief_pct,

        round(
            safe_divide(
                countif(c.is_disputed),
                count(*)
            ) * 100, 2
        ) as dispute_pct

    from complaints c
    inner join dates d
        on c.date_received_key = d.date_key
    inner join products p
        on c.product_key = p.product_key
    group by 1, 2, 3, 4
)

select * from product_monthly
order by year_month, product_category, product
