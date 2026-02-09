-- mart_state_summary.sql
-- state-level complaint metrics with per-capita rates
-- per-capita rates are the interesting number here - raw counts just
-- reflect population size which isn't very insightful

{{
    config(
        materialized='table'
    )
}}

with complaints as (
    select * from {{ ref('fct_complaints') }}
),

states as (
    select * from {{ ref('dim_state') }}
),

-- find the most common product per state using a window function
-- BigQuery doesn't support correlated subqueries referencing other tables
top_products as (
    select
        state,
        product,
        row_number() over (partition by state order by count(*) desc) as rn
    from complaints
    where state is not null
    group by state, product
),

state_stats as (
    select
        c.state as state_code,
        s.state_name,
        s.region,
        s.population,

        count(*) as complaint_count,

        -- per-capita rate (per 100K population)
        -- this is the key metric - normalizes for population differences
        round(
            safe_divide(
                count(*),
                s.population
            ) * 100000, 1
        ) as complaints_per_100k,

        -- response metrics
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
        ) as dispute_pct,

        tp.product as top_product

    from complaints c
    left join states s
        on c.state = s.state_code
    left join top_products tp
        on c.state = tp.state
        and tp.rn = 1
    where c.state is not null
    group by
        c.state,
        s.state_name,
        s.region,
        s.population,
        tp.product
)

select * from state_stats
order by complaint_count desc
