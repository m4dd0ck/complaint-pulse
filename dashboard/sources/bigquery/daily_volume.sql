select
    date_received,
    product,
    count(*) as complaint_count
from `cfpb-dashboard`.complaint_pulse_facts.fct_complaints
group by date_received, product
order by date_received
