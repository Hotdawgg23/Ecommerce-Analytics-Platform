# E-commerce Sales & Customer Analytics Platform

End-to-end analytics project: Python ETL → PostgreSQL → SQL analysis →
EDA → RFM customer segmentation (ML) → Power BI dashboards.

Dataset: [Olist Brazilian E-Commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
(~100k orders, 2016-2018, multiple relational tables).

## Project structure
```
ecommerce-analytics/
├── data/raw/              <- put downloaded Olist CSVs here
├── db/
│   ├── schema.sql          <- run this first (creates tables)
│   └── staging_elt_example.sql  <- optional ELT-pattern demo
├── src/
│   ├── config.py            <- DB connection settings
│   └── ingest.py             <- ETL script (extract, clean, load)
├── sql/
│   └── business_queries.sql  <- analysis queries (grows as you go)
├── notebooks/                <- EDA + RFM/clustering notebooks
├── powerbi/                  <- .pbix file goes here
└── docs/                      <- README, architecture notes, screenshots
```

## Setup (do this once)

1. **Install Postgres** locally (or use a free cloud instance e.g. Supabase/Neon).
   Create a database: `ecommerce_analytics`

2. **Download the dataset** from Kaggle, unzip all CSVs into `data/raw/`

3. **Python environment**
   ```bash
   pip install -r requirements.txt
   cp .env.example .env   # then fill in your DB credentials
   ```

4. **Create the schema**
   ```bash
   psql -h localhost -U postgres -d ecommerce_analytics -f db/schema.sql
   ```

5. **Run the ETL**
   ```bash
   cd src
   python ingest.py
   ```
   This extracts the raw CSVs, cleans/transforms them in pandas, and
   loads them into your Postgres tables. Check row counts printed
   at the end against the raw CSV row counts as a sanity check.

## Day-by-day plan (compressed to 1-3 days)

**Day 1 — Data engineering**
- [ ] Download dataset, run `schema.sql`, run `ingest.py`
- [ ] Verify row counts, spot-check a few joins in psql/pgAdmin
- [ ] (Optional) Load `staging_elt_example.sql` too, to have an ELT talking point

**Day 2 — SQL + EDA + ML**
- [ ] Extend `sql/business_queries.sql` with all business questions you want dashboard pages for
- [ ] Notebook: EDA — trends, distributions, delivery/review correlation
- [ ] Notebook: pull the RFM query into pandas, scale it, run K-Means, label segments (Champions/Loyal/At-Risk/Lost), write labeled RFM table back to Postgres as `customer_segments` table

**Day 3 — Power BI + polish**
- [ ] Connect Power BI directly to Postgres
- [ ] Build the 4 dashboard pages (Overview, Customer Segments, Product Performance, Geography/Logistics)
- [ ] Write up README/architecture diagram, push to GitHub, take dashboard screenshots for resume/LinkedIn

## Resume bullet (draft — edit once built)
> Built an end-to-end e-commerce analytics platform: designed a
> PostgreSQL star schema, built a Python ETL pipeline processing
> 100k+ orders, performed EDA and RFM-based customer segmentation
> using K-Means clustering, and delivered a 4-page Power BI
> dashboard connected live to the database.
