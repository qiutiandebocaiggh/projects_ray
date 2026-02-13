# DA Portfolio: 3 Reproducible Analytics Projects (PostgreSQL)

This repo contains three end-to-end analytics projects designed to simulate real DA/AE delivery:
**raw → staging → marts → metrics**, with reproducible SQL scripts and KPI tables.

## Projects
1) **Phoenix (Education SaaS analytics demo)**  
   - Simulated textbook orders + attendance data
   - Outputs daily KPIs: orders, GMV, attendance rate, active schools  
   - Folder: `phoenix-analytics-demo/`

2) **Putian (B2B project & revenue analytics demo)**  
   - Simulated B2B projects as “orders” with payments and milestones  
   - Outputs KPIs: contract value, collected revenue, outstanding revenue, collection rate, delay metrics  
   - Folder: `putian-b2b-analytics-demo/`

3) **E-commerce (Olist) analytics platform**  
   - Real public e-commerce dataset (Olist), ingested into Postgres
   - Outputs daily KPIs (orders, paid orders, GMV, AOV, new vs returning customers) and bonus KPIs (monthly repeat rate, delivery on-time)
   - Folder: `ecommerce-analytics-platform/`

## Tech Stack
- PostgreSQL 16 (Docker)
- SQL (pipeline with numbered scripts)
- Optional: pgloader for loading SQLite Olist dataset (not committed to this repo)

## Quick Start (Database)
From `infra/`:
```bash
cd infra
docker compose up -d
docker exec -it da_postgres psql -U ray -d postgres -c "\l"
