select
    product,
    issue,
    count(*) as complaint_count
from `cfpb-dashboard`.complaint_pulse_facts.fct_complaints
group by product, issue
order by complaint_count desc
