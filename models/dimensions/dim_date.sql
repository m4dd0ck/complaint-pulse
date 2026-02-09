-- dim_date.sql
-- date dimension covering the full CFPB complaint range (2011-2024)
-- generated from a date spine rather than from the data itself
-- so we have complete coverage even if some dates have zero complaints

{{
    config(
        materialized='table'
    )
}}

with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2011-01-01' as date)",
        end_date="cast('2025-01-01' as date)"
    ) }}
),

dates as (
    select
        cast(date_day as date) as date_day,
        cast(format_date('%Y%m%d', date_day) as int64) as date_key,

        -- calendar attributes
        extract(year from date_day) as year,
        extract(quarter from date_day) as quarter,
        extract(month from date_day) as month,
        extract(week from date_day) as week_of_year,
        extract(dayofweek from date_day) as day_of_week,
        format_date('%B', date_day) as month_name,
        format_date('%A', date_day) as day_name,
        format_date('%Y-%m', date_day) as year_month,
        format_date('%Y-Q%Q', date_day) as year_quarter,

        -- flags
        case
            when extract(dayofweek from date_day) in (1, 7) then true
            else false
        end as is_weekend

    from date_spine
)

select * from dates
