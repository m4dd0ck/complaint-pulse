-- mart_monthly_overview.sql
-- monthly KPIs for the overview dashboard page
-- one row per month with volume, timely %, relief rate, dispute rate

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

monthly as (
    select
        d.year_month,
        d.year,
        d.month,

        count(*) as complaint_count,

        -- response quality
        round(
            safe_divide(
                countif(c.is_timely_response),
                count(*)
            ) * 100, 1
        ) as timely_response_pct,

        -- relief rates
        round(
            safe_divide(
                countif(c.is_monetary_relief),
                count(*)
            ) * 100, 2
        ) as monetary_relief_pct,

        round(
            safe_divide(
                countif(c.is_monetary_relief or c.is_non_monetary_relief),
                count(*)
            ) * 100, 2
        ) as any_relief_pct,

        -- dispute rate
        round(
            safe_divide(
                countif(c.is_disputed),
                count(*)
            ) * 100, 2
        ) as dispute_pct,

        -- response time
        round(avg(c.response_days), 1) as avg_response_days,

        -- narrative stats
        countif(c.is_narrative_provided) as narratives_count

    from complaints c
    inner join dates d
        on c.date_received_key = d.date_key
    group by 1, 2, 3
)

select * from monthly
order by year_month
