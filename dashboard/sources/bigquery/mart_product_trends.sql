select
    year_month,
    year,
    product,
    product_category,
    complaint_count,
    timely_response_pct,
    any_relief_pct,
    dispute_pct
from `cfpb-dashboard`.complaint_pulse_marts.mart_product_trends
order by year_month, product_category, product
