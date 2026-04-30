## SQL Layer Overview

This folder contains SQL scripts used to simulate a production-style
forecast monitoring pipeline.

### Files

* `01_schema_setup.sql`
  Adds placeholder columns for forecast metrics to the dataset.

* `02_metrics_calculation.sql`
  Computes forecast accuracy metrics (MAE, RMSE).
  This script can be executed in BigQuery without billing enabled.

* `03_metrics_merge.sql`
  Full production-style pipeline using MERGE to update the dataset
  with calculated metrics.

--

### Execution Notes

BigQuery free tier does not allow DML operations (e.g., MERGE)
without billing enabled.

To explore the project:

1. Run `02_metrics_calculation.sql` to see how metrics are calculated
2. Review `03_metrics_merge.sql` to understand how results are
   integrated into the main dataset in production

--

### Design Approach

The pipeline separates:

* metric calculation (analytical layer)
* metric integration (data engineering layer)

This reflects a typical production setup where transformations
are modular and reusable.
