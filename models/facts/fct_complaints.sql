-- fct_complaints.sql
-- one row per complaint with dimension keys and all derived flags
-- this is the central fact table that all marts aggregate from

{{
    config(
        materialized='table'
    )
}}

with complaints as (
    select * from {{ ref('int_complaints_enriched') }}
),

products as (
    select * from {{ ref('dim_product') }}
),

final as (
    select
        -- keys
        c.complaint_id,
        c.date_received_key,
        p.product_key,
        c.state,

        -- dates
        c.date_received,
        c.date_sent_to_company,

        -- attributes
        c.product,
        c.sub_product,
        c.issue,
        c.sub_issue,
        c.company,
        c.zip_code,
        c.submitted_via,
        c.company_response,
        c.company_public_response,
        c.consumer_consent_provided,
        c.tags,
        c.narrative,

        -- measures
        c.response_days,

        -- boolean flags
        c.is_timely_response,
        c.is_disputed,
        c.is_monetary_relief,
        c.is_non_monetary_relief,
        c.is_narrative_provided,
        c.is_servicemember,
        c.is_older_american

    from complaints c
    left join products p
        on c.product = p.product
        and coalesce(c.sub_product, 'Not specified') = p.sub_product
)

select * from final
