# Complaint Pulse: agent rules

Instructions for coding agents working in this repo; a human reader wants `README.md`. Read
`README.md` for how it works, `RUNBOOK.md` for procedures, `TASK.md` for what is open. The
owner's global agent rules apply on top of these.

- Public repo: no personal data, account numbers, keys or third-party names in any file. The
  BigQuery login is `gcloud`'s; no key file ever enters the repo.
- Real-time commits only; never backdate or set `GIT_AUTHOR_DATE`. No AI attribution.
- Release steps: `RUNBOOK.md` §Release.
- Nothing past `dbt parse` can be verified without BigQuery credentials: say so instead of
  claiming a model change was tested.
