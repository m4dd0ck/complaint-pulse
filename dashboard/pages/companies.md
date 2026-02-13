---
title: Companies
---

# Company Scorecard

Performance metrics for companies with 100+ complaints on record.

```sql company_data
select *
from bigquery.mart_company_scorecard
order by complaint_count desc
```

```sql company_kpis
select
    count(*) as total_companies,
    sum(complaint_count) as total_complaints,
    round(avg(timely_response_pct), 1) as avg_timely_pct,
    round(avg(dispute_pct), 1) as avg_dispute_pct
from bigquery.mart_company_scorecard
```

<BigValue data={company_kpis} value=total_companies title="Companies Tracked" fmt="num0" />
<BigValue data={company_kpis} value=avg_timely_pct title="Avg Timely Response" fmt="num1" suffix="%" />
<BigValue data={company_kpis} value=avg_dispute_pct title="Avg Dispute Rate" fmt="num1" suffix="%" />

## Company Rankings

<DataTable
    data={company_data}
    rows=25
    search=true
>
    <Column id=company title="Company" />
    <Column id=complaint_count title="Complaints" fmt="num0" />
    <Column id=timely_response_pct title="Timely %" fmt="num1" />
    <Column id=avg_response_days title="Avg Response Days" fmt="num1" />
    <Column id=monetary_relief_pct title="Monetary Relief %" fmt="num1" />
    <Column id=dispute_pct title="Dispute %" fmt="num1" />
    <Column id=product_count title="Products" />
</DataTable>

## Timely Response Comparison (Top 20 by Volume)

```sql top_companies_timely
select
    company,
    complaint_count,
    timely_response_pct
from bigquery.mart_company_scorecard
order by complaint_count desc
limit 20
```

<BarChart
    data={top_companies_timely}
    x=company
    y=timely_response_pct
    title="Timely Response Rate - Top 20 Companies"
    swapXY=true
    yMin=80
/>

## Volume vs Dispute Rate

```sql volume_vs_dispute
select
    company,
    complaint_count,
    dispute_pct,
    timely_response_pct
from bigquery.mart_company_scorecard
where complaint_count >= 1000
```

<ScatterPlot
    data={volume_vs_dispute}
    x=complaint_count
    y=dispute_pct
    tooltipTitle=company
    xAxisTitle="Total Complaints"
    yAxisTitle="Dispute Rate (%)"
    title="Complaint Volume vs Dispute Rate (1,000+ complaints)"
/>
