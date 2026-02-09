-- mart_company_scorecard.sql
-- per-company metrics for the company comparison page
-- filtered to companies with 100+ complaints to avoid noisy outliers

{{
    config(
        materialized='table'
    )
}}

with complaints as (
    select * from {{ ref('fct_complaints') }}
),

company_stats as (
    select
        company,

        count(*) as complaint_count,

        -- response metrics
        round(
            safe_divide(
                countif(is_timely_response),
                count(*)
            ) * 100, 1
        ) as timely_response_pct,

        round(avg(response_days), 1) as avg_response_days,

        -- outcome metrics
        round(
            safe_divide(
                countif(is_monetary_relief),
                count(*)
            ) * 100, 2
        ) as monetary_relief_pct,

        round(
            safe_divide(
                countif(is_monetary_relief or is_non_monetary_relief),
                count(*)
            ) * 100, 2
        ) as any_relief_pct,

        round(
            safe_divide(
                countif(is_disputed),
                count(*)
            ) * 100, 2
        ) as dispute_pct,

        -- product mix
        count(distinct product) as product_count,

        -- date range
        min(date_received) as first_complaint_date,
        max(date_received) as last_complaint_date

    from complaints
    group by company
)

select * from company_stats
-- only include companies with meaningful sample size
where complaint_count >= 100
order by complaint_count desc
