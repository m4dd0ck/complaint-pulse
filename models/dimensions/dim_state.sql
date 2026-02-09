-- dim_state.sql
-- state dimension joining complaint states with census population data
-- population enables per-capita complaint rates which are more meaningful
-- than raw counts (Florida has more complaints than Wyoming, obviously)

{{
    config(
        materialized='table'
    )
}}

with complaint_states as (
    select distinct state
    from {{ ref('stg_complaints') }}
    where state is not null
),

populations as (
    select * from {{ ref('state_populations') }}
),

joined as (
    select
        cs.state as state_code,
        coalesce(p.state_name, cs.state) as state_name,
        coalesce(p.region, 'Other') as region,
        p.population

    from complaint_states cs
    left join populations p
        on cs.state = p.state_code
)

select * from joined
