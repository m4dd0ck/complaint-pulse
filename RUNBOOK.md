# Runbook

Procedures for Complaint Pulse. `README.md` describes what each command does; this file says
when to run it and in what order. Everything past the parse step needs a BigQuery login.

## On open

```bash
git status --short
git log -3 --oneline
```

## On close

```bash
uv run dbt deps --profiles-dir .
uv run dbt parse --profiles-dir .
```

These are what CI runs; they need no credentials. `make test` runs the dbt tests against the
warehouse and belongs to a build, not to a close.

## Build the warehouse

1. `gcloud auth login` and `gcloud auth application-default login`, with a project you can
   write to set as the default. `profiles.yml` names the project and dataset.
2. `make build`, then `uv run dbt debug --profiles-dir .` to prove the connection.
3. `make seed`, `make run`, `make test`. A failing test is a data change upstream or a broken
   model; read the failing test name before touching SQL.
4. Every test failing with `Table ... was not found` means the tables are gone, not broken.
   A BigQuery sandbox project (no billing account) deletes each table 60 days after it is
   built; the datasets stay, empty. Re-run step 3 to rebuild them.

## Refresh the dashboard

1. `cd dashboard && npm ci` once.
2. `make dashboard-sources` pulls the marts into Evidence's cache; rerun after every
   `make run`.
3. `make dashboard-dev` for the dev server; `make dashboard-build` for a static build in
   `dashboard/build/`.

## Deploy

Not deployed. `make dashboard-build` renders a static site that nothing hosts; publishing it
would mean an Evidence Cloud or Pages setup plus a credential for the source refresh, which has
not been done on purpose (the data needs BigQuery either way).

## Release

1. Bump `version` in `pyproject.toml` (there is no package `__version__`), then `uv lock`
   (CI installs with `--locked`).
2. Commit `chore: Release vX.Y.Z`, tag `git tag -a vX.Y.Z`, push `main` and the tag.
3. `gh release create vX.Y.Z` with handwritten notes; mark it latest.

## Restore on a new machine

1. Install uv, Node.js 18+ and the Google Cloud SDK; log in to gcloud.
2. Clone the repo; `make build`; `cd dashboard && npm ci`.
3. Build the warehouse as above. Nothing in the repo holds data or credentials.

## Validate

```bash
uv run dbt deps --profiles-dir .
uv run dbt parse --profiles-dir .
make test
make dashboard-build
```
