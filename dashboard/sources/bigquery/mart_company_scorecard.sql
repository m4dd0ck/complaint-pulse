select
    company,
    complaint_count,
    timely_response_pct,
    avg_response_days,
    monetary_relief_pct,
    any_relief_pct,
    dispute_pct,
    product_count,
    first_complaint_date,
    last_complaint_date
from `cfpb-dashboard`.complaint_pulse_marts.mart_company_scorecard
order by complaint_count desc
