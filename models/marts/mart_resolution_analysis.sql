-- mart_resolution_analysis.sql
-- resolution outcomes by submission channel and month
-- powers the consumer experience page

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

resolution_stats as (
    select
        d.year_month,
        d.year,
        c.submitted_via,
        c.company_response,

        count(*) as complaint_count,

        -- response metrics
        round(
            safe_divide(
                countif(c.is_timely_response),
                count(*)
            ) * 100, 1
        ) as timely_response_pct,

        round(avg(c.response_days), 1) as avg_response_days,

        -- demographic breakdown
        countif(c.is_servicemember) as servicemember_count,
        countif(c.is_older_american) as older_american_count

    from complaints c
    inner join dates d
        on c.date_received_key = d.date_key
    group by 1, 2, 3, 4
)

select * from resolution_stats
order by year_month, submitted_via, company_response
