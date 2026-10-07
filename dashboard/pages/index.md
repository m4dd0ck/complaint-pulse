---
title: Complaint Pulse
---

# CFPB Consumer Complaint Dashboard

Analysis of 3.4 million consumer financial complaints filed with the Consumer Financial Protection Bureau (2011-2023).

```sql total_complaints
select
    sum(complaint_count) as total,
    -- weight each month's rate by its volume; a plain avg() of percentages overstates quiet months
    round(sum(timely_response_pct * complaint_count) / sum(complaint_count), 1) as avg_timely_pct,
    round(sum(any_relief_pct * complaint_count) / sum(complaint_count), 1) as avg_relief_pct,
    round(sum(dispute_pct * complaint_count) / sum(complaint_count), 1) as avg_dispute_pct,
    round(sum(cast(avg_response_days as double) * complaint_count) / sum(complaint_count), 1) as avg_response_days
from bigquery.mart_monthly_overview
```

<BigValue
    data={total_complaints}
    value=total
    title="Total Complaints"
    fmt="num0"
/>
<BigValue
    data={total_complaints}
    value=avg_timely_pct
    title="Avg Timely Response"
    fmt="num1"
    suffix="%"
/>
<BigValue
    data={total_complaints}
    value=avg_relief_pct
    title="Avg Relief Rate"
    fmt="num1"
    suffix="%"
/>
<BigValue
    data={total_complaints}
    value=avg_dispute_pct
    title="Avg Dispute Rate"
    fmt="num1"
    suffix="%"
/>

## Monthly Complaint Volume

```sql monthly_trend
select
    year_month,
    complaint_count
from bigquery.mart_monthly_overview
order by year_month
```

<LineChart
    data={monthly_trend}
    x=year_month
    y=complaint_count
    title="Complaints per Month"
    yAxisTitle="Complaints"
/>

## Complaints by Product Category

```sql product_breakdown
select
    product_category,
    sum(complaint_count) as total_complaints
from bigquery.mart_product_trends
group by product_category
order by total_complaints desc
```

<BarChart
    data={product_breakdown}
    x=product_category
    y=total_complaints
    title="Total Complaints by Product Category"
    swapXY=true
/>

## Timely Response Rate Over Time

```sql timely_trend
select
    year_month,
    timely_response_pct
from bigquery.mart_monthly_overview
order by year_month
```

<LineChart
    data={timely_trend}
    x=year_month
    y=timely_response_pct
    title="Company Timely Response Rate (%)"
    yAxisTitle="Timely %"
    yMin=80
/>

## Top 10 States by Complaint Volume

```sql top_states
select
    state_name,
    complaint_count,
    complaints_per_100k
from bigquery.mart_state_summary
order by complaint_count desc
limit 10
```

<DataTable
    data={top_states}
    rows=10
>
    <Column id=state_name title="State" />
    <Column id=complaint_count title="Total Complaints" fmt="num0" />
    <Column id=complaints_per_100k title="Per 100K Pop." fmt="num1" />
</DataTable>
