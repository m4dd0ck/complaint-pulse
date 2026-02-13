select
    year_month,
    year,
    month,
    complaint_count,
    timely_response_pct,
    monetary_relief_pct,
    any_relief_pct,
    dispute_pct,
    avg_response_days,
    narratives_count
from `cfpb-dashboard`.complaint_pulse_marts.mart_monthly_overview
order by year_month
