.PHONY: build run test clean deps seed dashboard-dev dashboard-build dashboard-sources

build:
	uv sync
	uv run dbt deps --profiles-dir .

run:
	uv run dbt run --profiles-dir .

test:
	uv run dbt test --profiles-dir .

seed:
	uv run dbt seed --profiles-dir .

clean:
	rm -rf target/ dbt_packages/ logs/

deps:
	uv run dbt deps --profiles-dir .

compile:
	uv run dbt compile --profiles-dir .

dashboard-dev:
	cd dashboard && npm run dev

dashboard-build:
	cd dashboard && npm run build:strict

dashboard-sources:
	cd dashboard && npm run sources
