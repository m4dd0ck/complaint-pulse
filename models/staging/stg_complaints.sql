-- stg_complaints.sql
-- staging model for CFPB consumer complaints
-- cleans up the raw data: normalizes products, fixes zip codes,
-- renames boolean fields with is_ prefix for clarity

{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ source('cfpb', 'complaint_database') }}
),

cleaned as (
    select
        complaint_id,

        -- dates (both are DATE type in source)
        date_received,
        date_sent_to_company,

        -- product normalization - CFPB renamed several categories over the years
        -- without this mapping, trend charts show artificial drops/spikes
        {{ normalize_product('product') }} as product,
        subproduct as sub_product,

        -- complaint details
        issue,
        subissue as sub_issue,
        consumer_complaint_narrative as narrative,
        company_public_response,

        -- company and location
        company_name as company,
        state,
        -- zip_code comes through as "12345.0" in some records, strip the decimal
        regexp_replace(cast(zip_code as string), r'\.0$', '') as zip_code,

        -- submission and response
        submitted_via,
        company_response_to_consumer as company_response,
        consumer_consent_provided,
        tags,

        -- source booleans are already BOOL in BigQuery, just rename with is_ prefix
        coalesce(timely_response, false) as is_timely_response,
        coalesce(consumer_disputed, false) as is_disputed,

        -- calculate how long CFPB took to forward the complaint
        date_diff(date_sent_to_company, date_received, day) as response_days

    from source
)

select * from cleaned
where complaint_id is not null
  and date_received is not null
