-- dim_product.sql
-- product dimension from distinct product/sub_product combinations
-- includes a simplified category for high-level grouping in dashboards

{{
    config(
        materialized='table'
    )
}}

with products as (
    select distinct
        product,
        sub_product
    from {{ ref('stg_complaints') }}
    where product is not null
),

categorized as (
    select
        {{ dbt_utils.generate_surrogate_key(['product', 'sub_product']) }} as product_key,
        product,
        coalesce(sub_product, 'Not specified') as sub_product,

        -- simplified grouping for overview charts
        -- collapses 18 products into ~8 categories
        case
            when product like '%Mortgage%' then 'Mortgage'
            when product like '%Credit card%' then 'Credit & Prepaid'
            when product like '%Credit reporting%' then 'Credit Reporting'
            when product like '%Debt collection%' then 'Debt Collection'
            when product like '%Student loan%' then 'Student Loan'
            when product like '%Vehicle%' or product like '%Consumer Loan%' then 'Vehicle & Consumer Loan'
            when product like '%Checking%' or product like '%Bank account%' then 'Banking'
            when product like '%Payday%' or product like '%personal loan%' then 'Personal Loan'
            when product like '%Money transfer%' then 'Money Transfer'
            else 'Other'
        end as product_category

    from products
)

select * from categorized
