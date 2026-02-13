select
    state_code,
    state_name,
    region,
    population,
    complaint_count,
    complaints_per_100k,
    timely_response_pct,
    any_relief_pct,
    dispute_pct,
    top_product
from `cfpb-dashboard`.complaint_pulse_marts.mart_state_summary
order by complaint_count desc
