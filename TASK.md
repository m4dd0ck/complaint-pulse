# Tasks

Single-repo status, kept by hand. Last reviewed **2026-10-20**.

## Needs the owner

| Item | Why it is stuck | Added |
|---|---|---|
| **Rerun the models after the 2026-10-12 review fixes** | The review asked for the legacy `Credit reporting` product mapping, volume-weighted averages and the KPI `fmt` to be fixed; none is started, and no BigQuery credentials exist locally to rerun and test the models | 2026-10-12 |

## Queue

- [ ] Dispute rate: the staging model coalesces a null `consumer_disputed` to false after
      April 2017. Documented in the README; changing it needs a model rerun (no credentials).
- [ ] `mart_product_trends.sql` carries a comment about "top issues for this product-month"
      above a timely-response calculation (2026-10-07).
- [ ] `compile` is missing from the Makefile's `.PHONY` list; confirm whether `dbt compile`
      runs without credentials (the old README said it did; CI uses `dbt parse`).
