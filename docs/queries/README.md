# SQL Extraction Layer — Design Notes

This directory contains **analytics-layer SQL queries** used to define the data contract for downstream analysis and experimentation.

The SQL files here are written to reflect how a Product Data Scientist would interact with a typical analytics warehouse (e.g., BigQuery, Snowflake), focusing on **logical correctness and semantic clarity**, rather than execution on a specific database engine.

---

## Design Principles

### 1. User-Level Abstraction
All funnel metrics are defined at the **user level**, not the event level.

This aligns with:
- The experimental unit used in A/B testing
- The need to avoid event-level noise
- Clear interpretation of conversion behavior

As a result, aggregation is consistently performed using `GROUP BY user_id`.

---

### 2. Separation of Responsibilities
SQL is used strictly for:
- Defining what constitutes a funnel step
- Selecting and aggregating relevant fields
- Producing clean, analysis-ready tables

All statistical analysis, visualization, and inference are intentionally deferred to Python (Pandas / NumPy), ensuring:
- Reproducibility
- Flexibility
- Clear separation between data extraction and decision logic

---

### 3. Funnel Definition Logic
Funnel steps (e.g., view, cart, purchase) are encoded using explicit boolean flags:

```sql
MAX(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END)
```
This formulation emphasizes reach rather than frequency, which is more appropriate for conversion analysis.

### 4. Segmentation as a Diagnostic Tool
Segmentation queries (e.g., cart-to-purchase by price segment) are designed to:
- Identify responsibility segments
- Surface heterogeneity in conversion behavior
- Guide deeper investigation in later analysis stages

Early segmentation variables (such as price tiers) are treated as proxies, with final segment definitions refined during the Python analysis phase.

---

### Disclaimer
The SQL queries in this directory are written as design artifacts and are not tied to any proprietary production database.

They assume a generic event-log schema and are intended to demonstrate analytical thinking, not database-specific optimizations.

---
