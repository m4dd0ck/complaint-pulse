---
title: Consumer Experience
---

# Consumer Experience

How complaints get resolved, response times, and outcomes across submission channels.

## Resolution Outcomes

```sql resolution_totals
select
    company_response,
    sum(complaint_count) as total_complaints
from bigquery.mart_resolution_analysis
group by company_response
order by total_complaints desc
```

<BarChart
    data={resolution_totals}
    x=company_response
    y=total_complaints
    title="Complaint Resolution Outcomes"
    swapXY=true
/>

## Average Response Time Trend

```sql response_time_trend
select
    year_month,
    round(sum(cast(avg_response_days as double) * complaint_count) / sum(complaint_count), 1) as avg_response_days
from bigquery.mart_resolution_analysis
group by year_month
order by year_month
```

<LineChart
    data={response_time_trend}
    x=year_month
    y=avg_response_days
    title="Average Response Time (Days)"
    yAxisTitle="Days"
/>

## Submission Channel Breakdown

```sql channel_stats
select
    submitted_via,
    sum(complaint_count) as total_complaints,
    round(avg(timely_response_pct), 1) as avg_timely_pct,
    round(sum(cast(avg_response_days as double) * complaint_count) / sum(complaint_count), 1) as avg_response_days
from bigquery.mart_resolution_analysis
group by submitted_via
order by total_complaints desc
```

<BarChart
    data={channel_stats}
    x=submitted_via
    y=total_complaints
    title="Complaints by Submission Channel"
/>

<DataTable data={channel_stats} rows=all>
    <Column id=submitted_via title="Channel" />
    <Column id=total_complaints title="Complaints" fmt="num0" />
    <Column id=avg_timely_pct title="Timely %" fmt="num1" />
    <Column id=avg_response_days title="Avg Response Days" fmt="num1" />
</DataTable>

## Servicemember Complaints

```sql servicemember_trend
select
    year_month,
    sum(servicemember_count) as servicemember_complaints,
    sum(complaint_count) as total_complaints,
    round(sum(servicemember_count) * 100.0 / nullif(sum(complaint_count), 0), 1) as servicemember_pct
from bigquery.mart_resolution_analysis
group by year_month
order by year_month
```

<LineChart
    data={servicemember_trend}
    x=year_month
    y=servicemember_complaints
    title="Servicemember Complaints Over Time"
    yAxisTitle="Complaints"
/>

## Older American Complaints

```sql older_american_trend
select
    year_month,
    sum(older_american_count) as older_american_complaints,
    sum(complaint_count) as total_complaints,
    round(sum(older_american_count) * 100.0 / nullif(sum(complaint_count), 0), 1) as older_american_pct
from bigquery.mart_resolution_analysis
group by year_month
order by year_month
```

<LineChart
    data={older_american_trend}
    x=year_month
    y=older_american_complaints
    title="Older American Complaints Over Time"
    yAxisTitle="Complaints"
/>
