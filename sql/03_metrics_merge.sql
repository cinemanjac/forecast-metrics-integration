-- ======================================================================
-- Forecast Metrics Pipeline
-- ======================================================================

-- Description:
-- Initializes a MERGE operation to attach forecast performance metrics
-- to the target dataset. Metric calculations (MAE, RMSE) are performed
-- within the source subquery, after which results are conditionally
-- written back to the target table.

-- Execution:
-- Designed to run on a scheduled basis (weekly)

-- Note:
-- Replace `your_project.your_dataset.synthetic_dataset`
-- with your own BigQuery table path
-- ======================================================================


-- Define target table and start MERGE operation
MERGE `your_project.your_dataset.synthetic_dataset` AS target


-- Build source dataset with embedded metric calculations
USING (

-- Extract last 12 months of data and compute aggregated utilisation
WITH extraction AS (

  SELECT
    date,
    DATE_TRUNC(date, ISOWEEK) AS isoweek,
    product,
    region,

    utilisation,
    forecast_weekly,
    forecast_monthly,

    -- aggregated utilisation
    AVG(utilisation) OVER (PARTITION BY DATE_TRUNC(date, ISOWEEK), product, region) AS utilisation_weekly,
    AVG(utilisation) OVER (PARTITION BY DATE_TRUNC(date, MONTH), product, region) AS utilisation_monthly

  FROM `your_project.your_dataset.synthetic_dataset`

  -- Filter to last 12 months (production logic).
  -- For demo dataset (limited to a few months), this condition still works
  -- but effectively selects all available data.
  WHERE date >= DATE_SUB(CURRENT_DATE(), INTERVAL 12 MONTH)
),


-- Compute weekly forecast accuracy metrics
weekly AS (

  SELECT
    product,
    region,

    AVG(ABS(utilisation_weekly - forecast_weekly)) AS MAE_weekly,
    SQRT(AVG(POWER(utilisation_weekly - forecast_weekly, 2))) AS RMSE_weekly

  FROM (
    SELECT DISTINCT
      product,
      region,
      utilisation_weekly,
      forecast_weekly
    FROM extraction
  )

  GROUP BY product, region
),


-- Compute monthly forecast accuracy metrics
monthly AS (

  SELECT
    product,
    region,

    AVG(ABS(utilisation_monthly - forecast_monthly)) AS MAE_monthly,
    SQRT(AVG(POWER(utilisation_monthly - forecast_monthly, 2))) AS RMSE_monthly

  FROM (
    SELECT DISTINCT
      product,
      region,
      utilisation_monthly,
      forecast_monthly
    FROM extraction
  )

  GROUP BY product, region
)


-- Final dataset with derived metrics
SELECT
  *,

  -- error coefficients
  SAFE_DIVIDE(RMSE_monthly, MAE_monthly) AS error_coeff_monthly,
  SAFE_DIVIDE(RMSE_weekly, MAE_weekly) AS error_coeff_weekly

FROM monthly
JOIN weekly
  USING (product, region)

) AS source


-- Apply update to the target table
ON target.product = source.product
AND target.region = source.region

-- Update only latest snapshot
-- In production, this uses CURRENT_DATE()
-- In demo, a fixed date is used due to static dataset
WHEN MATCHED
-- AND target.date = CURRENT_DATE()
AND target.date = '2026-04-30'

THEN UPDATE SET
  target.MAE_monthly = source.MAE_monthly,
  target.RMSE_monthly = source.RMSE_monthly,
  target.MAE_weekly = source.MAE_weekly,
  target.RMSE_weekly = source.RMSE_weekly,
  target.error_coeff_monthly = source.error_coeff_monthly,
  target.error_coeff_weekly = source.error_coeff_weekly;
