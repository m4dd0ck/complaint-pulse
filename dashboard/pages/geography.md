---
title: Geography
---

# Geographic Analysis

Complaint patterns across US states, normalized by population for fair comparison.

```sql state_data
select *
from bigquery.mart_state_summary
where state_code is not null
```

## Complaints Per 100K Residents

```sql state_map_data
select
    state_code as state,
    complaints_per_100k as value,
    state_name,
    complaint_count
from bigquery.mart_state_summary
where state_code is not null
    and complaints_per_100k is not null
```

<USMap
    data={state_map_data}
    state=state
    value=value
    title="Complaints per 100K Population"
    colorScale="#236aa4"
/>

## State Rankings

<DataTable
    data={state_data}
    rows=all
    search=true
>
    <Column id=state_name title="State" />
    <Column id=complaint_count title="Total Complaints" fmt="num0" />
    <Column id=complaints_per_100k title="Per 100K Pop." fmt="num1" />
    <Column id=timely_response_pct title="Timely %" fmt="num1" />
    <Column id=any_relief_pct title="Relief %" fmt="num1" />
    <Column id=dispute_pct title="Dispute %" fmt="num1" />
    <Column id=top_product title="Top Product" />
    <Column id=region title="Region" />
</DataTable>

## Regional Comparison

```sql regional
select
    region,
    sum(complaint_count) as total_complaints,
    round(sum(cast(complaint_count as double)) / sum(cast(population as double)) * 100000, 1) as complaints_per_100k,
    round(avg(timely_response_pct), 1) as avg_timely_pct,
    round(avg(dispute_pct), 1) as avg_dispute_pct
from bigquery.mart_state_summary
where region is not null and region != 'Other'
group by region
order by complaints_per_100k desc
```

<BarChart
    data={regional}
    x=region
    y=complaints_per_100k
    title="Complaints per 100K by Region"
    yAxisTitle="Per 100K Pop."
/>

<DataTable data={regional} rows=all>
    <Column id=region title="Region" />
    <Column id=total_complaints title="Total Complaints" fmt="num0" />
    <Column id=complaints_per_100k title="Per 100K Pop." fmt="num1" />
    <Column id=avg_timely_pct title="Timely %" fmt="num1" />
    <Column id=avg_dispute_pct title="Dispute %" fmt="num1" />
</DataTable>
