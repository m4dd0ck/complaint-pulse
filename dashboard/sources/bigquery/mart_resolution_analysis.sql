select
    year_month,
    year,
    submitted_via,
    company_response,
    complaint_count,
    timely_response_pct,
    avg_response_days,
    servicemember_count,
    older_american_count
from `cfpb-dashboard`.complaint_pulse_marts.mart_resolution_analysis
order by year_month, submitted_via, company_response
