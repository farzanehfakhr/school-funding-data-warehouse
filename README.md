# Education Performance & School Funding Data Warehouse

A data warehouse integrating California school funding (NERD$) and student performance (CAASPP) records for the 2021–2022 academic year, built with a full ETL pipeline and a dimensional star schema. Completed as part of graduate coursework (CS779, Data Warehousing) at Boston University.

## What it does

- Integrates 10,000+ California school funding and student performance records from two disparate public data sources
- Stages, cleans, and normalizes source data into Third Normal Form (3NF), then transforms it into a dimensional star schema (`fact_school_metrics` with school, year, test, and grade dimensions) for reporting
- Resolves school-identifier mismatches between the funding and performance datasets with a cross-reference mapping layer
- Implements slowly changing dimension (SCD Type 2) logic on the school dimension to preserve historical accuracy as school attributes change over time
- Verifies BCNF normalization and validates the SCD Type 2 stored procedure behavior with before/after testing

## Key finding

Dashboards built on top of this warehouse surfaced a counter-intuitive result: several lower-funded schools outperformed higher-funded ones on standardized test scores.

## Files

| File | Description |
|---|---|
| `data_prep.py` | Converts and cleans raw funding/performance source files (Excel/text) into CSVs ready for staging |
| `schema_and_etl.sql` | Staging tables, ETL/COPY statements, 3NF normalization, and the dimensional star schema |
| `BCNF_and_SCD_Testing_Report.docx` | Testing notes verifying BCNF normalization and the SCD Type 2 stored procedure (before/after update behavior) |

## Tools

SQL (PostgreSQL), Python (pandas), ETL, dimensional modeling, Tableau (for the reporting dashboards)

---
*Completed as part of graduate coursework (CS779, Data Warehousing) at Boston University.*
