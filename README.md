# Complaint Pulse

dbt + BigQuery pipeline for CFPB consumer complaint data. Star schema over 3.4M complaints, served through an Evidence.dev dashboard with 5 interactive pages.

## Stack

| Tool | Role |
|------|------|
| BigQuery | Source warehouse (`bigquery-public-data.cfpb_complaints`) |
| dbt | SQL transforms, star schema, data tests |
| Evidence.dev | SQL + Markdown dashboard framework |
| uv | Python/dbt dependency management |

## Data Model

### Layers

| Layer | Purpose | Materialization |
|-------|---------|-----------------|
| staging | Clean raw data, normalize products, fix zip codes | View |
| intermediate | Derive flags (relief type, demographics) | View |
| dimensions | Date spine, product categories, state populations | Table |
| facts | One row per complaint with all attributes and flags | Table |
| marts | Aggregated tables for dashboard pages | Table |

### Models

**Dimensions:**
- `dim_date` - Calendar attributes (2011-2024) from date spine
- `dim_product` - Normalized products with simplified category grouping
- `dim_state` - States with 2020 census population for per-capita rates

**Facts:**
- `fct_complaints` - Central fact table, one row per complaint

**Marts:**
- `mart_monthly_overview` - Monthly KPIs (volume, timely %, relief %, dispute %)
- `mart_product_trends` - Product x month aggregation with category grouping
- `mart_company_scorecard` - Per-company metrics, filtered to 100+ complaints
- `mart_state_summary` - State metrics with per-capita complaint rates
- `mart_resolution_analysis` - Resolution outcomes by channel and month

## Dashboard Pages

1. **Overview** - KPI cards, monthly volume trend, product breakdown, top states
2. **Products** - Category filter, trend lines, issue breakdown, comparative table
3. **Companies** - Searchable scorecard, timely response comparison, volume vs dispute scatter
4. **Geography** - US choropleth map (per-capita rates), state rankings, regional comparison
5. **Consumer Experience** - Resolution outcomes, response time trends, channel analysis, demographic breakdowns

## Quick Start

### Prerequisites

- Python 3.11+
- [uv](https://github.com/astral-sh/uv) package manager
- Google Cloud SDK with BigQuery access
- Node.js 18+

### Setup

```bash
cd complaint-pulse

# Install Python/dbt dependencies
uv sync
uv run dbt deps --profiles-dir .

# Verify BigQuery connection
uv run dbt debug --profiles-dir .

# Load seed data and run all models
uv run dbt seed --profiles-dir .
uv run dbt run --profiles-dir .
uv run dbt test --profiles-dir .

# Extract mart data for dashboard
cd dashboard && npm ci
npm run sources

# Start dashboard dev server
npm run dev
```

### Makefile Commands

```bash
make build          # Install deps + dbt packages
make run            # Run all dbt models
make test           # Run dbt tests
make seed           # Load seed data
make compile        # Compile SQL (no BigQuery credentials needed)
make dashboard-dev  # Start Evidence dev server
```

## Data Source

[CFPB Consumer Complaint Database](https://www.consumerfinance.gov/data-research/consumer-complaints/) - public dataset of complaints filed against financial companies. Available in BigQuery as `bigquery-public-data.cfpb_complaints.complaint_database`.

The dataset contains ~3.4M complaints from 2011 through early 2023, covering products like mortgages, credit cards, debt collection, and credit reporting.

## Project Structure

```
complaint-pulse/
├── models/
│   ├── staging/         # Clean and normalize raw data
│   ├── intermediate/    # Derive flags and enrich
│   ├── dimensions/      # Conformed dimensions
│   ├── facts/           # Fact table
│   └── marts/           # Dashboard-ready aggregations
├── seeds/               # State population reference data
├── macros/              # Product name normalization
├── dashboard/           # Evidence.dev (npm project)
│   ├── pages/           # 5 markdown dashboard pages
│   └── sources/         # BigQuery connection + queries
├── dbt_project.yml
├── profiles.yml
└── packages.yml
```

## License

MIT
