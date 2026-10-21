.PHONY: build run test clean deps seed dashboard-dev dashboard-build dashboard-sources

build: ## Install the Python dependencies and the dbt packages
	uv sync
	uv run dbt deps --profiles-dir .

run: ## dbt run against BigQuery
	uv run dbt run --profiles-dir .

test: ## dbt test
	uv run dbt test --profiles-dir .

seed: ## dbt seed
	uv run dbt seed --profiles-dir .

clean: ## Remove target/, dbt_packages/ and logs/
	rm -rf target/ dbt_packages/ logs/

deps: ## Install the dbt packages
	uv run dbt deps --profiles-dir .

compile: ## dbt compile
	uv run dbt compile --profiles-dir .

dashboard-dev: ## Evidence dev server, in dashboard/
	cd dashboard && npm run dev

dashboard-build: ## Strict static build of the dashboard
	cd dashboard && npm run build:strict

dashboard-sources: ## Pull the marts from BigQuery into the Evidence cache
	cd dashboard && npm run sources
