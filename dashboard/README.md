# complaint-pulse dashboard

Evidence.dev pages over the `complaint_pulse` marts in BigQuery.

```bash
npm ci
npm run sources   # pulls the marts (needs BigQuery credentials, see ../README.md)
npm run dev       # http://localhost:3000
```

Pages: `index.md` (overview), `products.md`, `companies.md`, `geography.md`, `experience.md`.
