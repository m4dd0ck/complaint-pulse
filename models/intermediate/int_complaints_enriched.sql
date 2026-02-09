-- int_complaints_enriched.sql
-- adds derived flags and dimension keys to staged complaints
-- these flags power the dashboard filters and breakdowns

{{
    config(
        materialized='view'
    )
}}

with complaints as (
    select * from {{ ref('stg_complaints') }}
),

enriched as (
    select
        complaint_id,
        date_received,
        date_sent_to_company,
        product,
        sub_product,
        issue,
        sub_issue,
        narrative,
        company_public_response,
        company,
        state,
        zip_code,
        submitted_via,
        company_response,
        consumer_consent_provided,
        tags,
        is_timely_response,
        is_disputed,
        response_days,

        -- date key for joining to dim_date
        cast(format_date('%Y%m%d', date_received) as int64) as date_received_key,

        -- relief flags derived from company_response
        -- "Closed with monetary relief" means the consumer got money back
        case
            when company_response = 'Closed with monetary relief' then true
            else false
        end as is_monetary_relief,

        case
            when company_response = 'Closed with non-monetary relief' then true
            else false
        end as is_non_monetary_relief,

        -- whether consumer shared their story
        case
            when narrative is not null and narrative != '' then true
            else false
        end as is_narrative_provided,

        -- demographic flags from tags
        case
            when tags like '%Servicemember%' then true
            else false
        end as is_servicemember,

        case
            when tags like '%Older American%' then true
            else false
        end as is_older_american

    from complaints
)

select * from enriched
