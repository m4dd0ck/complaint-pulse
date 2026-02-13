---
title: Products
---

# Product Analysis

Deep dive into complaint patterns across financial product categories.

```sql categories
select distinct product_category
from bigquery.mart_product_trends
order by product_category
```

<Dropdown
    name=selected_category
    data={categories}
    value=product_category
    title="Product Category"
    defaultValue="Credit Reporting"
/>

## Complaint Trends by Product

```sql product_trends
select
    year_month,
    product,
    complaint_count
from bigquery.mart_product_trends
where product_category = '${inputs.selected_category}'
order by year_month
```

{#if product_trends.length > 0}
<LineChart
    data={product_trends}
    x=year_month
    y=complaint_count
    series=product
    title="Monthly Complaints - {inputs.selected_category}"
    yAxisTitle="Complaints"
/>
{:else}
<p>Select a product category above to see trends.</p>
{/if}

## Category Overview

```sql category_summary
select
    product_category,
    sum(complaint_count) as total_complaints,
    round(avg(timely_response_pct), 1) as avg_timely_pct,
    round(avg(any_relief_pct), 1) as avg_relief_pct,
    round(avg(dispute_pct), 1) as avg_dispute_pct
from bigquery.mart_product_trends
group by product_category
order by total_complaints desc
```

<BarChart
    data={category_summary}
    x=product_category
    y=total_complaints
    title="Total Complaints by Category"
    swapXY=true
/>

<DataTable
    data={category_summary}
    rows=all
>
    <Column id=product_category title="Category" />
    <Column id=total_complaints title="Total Complaints" fmt="num0" />
    <Column id=avg_timely_pct title="Timely %" fmt="num1" />
    <Column id=avg_relief_pct title="Relief %" fmt="num1" />
    <Column id=avg_dispute_pct title="Dispute %" fmt="num1" />
</DataTable>

## Top Issues

```sql issues
select
    issue,
    complaint_count
from bigquery.top_issues
where product in (
    select distinct product
    from bigquery.mart_product_trends
    where product_category = '${inputs.selected_category}'
)
order by complaint_count desc
limit 15
```

{#if issues.length > 0}
<BarChart
    data={issues}
    x=issue
    y=complaint_count
    title="Top 15 Issues - {inputs.selected_category}"
    swapXY=true
/>
{/if}
