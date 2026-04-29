-- Schema Setup: Add Forecast Metrics Columns

-- Description:
-- Extends the dataset schema by adding placeholder columns
-- for forecast performance metrics (MAE, RMSE) and error coefficients.
-- Values are calculated and updated separately in the metrics pipeline.

-- Execution:
-- Run once before starting the metrics pipeline

-- Note:
-- Replace `your_project.your_dataset.synthetic_dataset`
-- with your own BigQuery table path
-- ======================================================================


ALTER TABLE `your_project.your_dataset.synthetic_dataset`
ADD COLUMN MAE_monthly FLOAT64,
ADD COLUMN RMSE_monthly FLOAT64,
ADD COLUMN MAE_weekly FLOAT64,
ADD COLUMN RMSE_weekly FLOAT64,
ADD COLUMN error_coeff_monthly FLOAT64,
ADD COLUMN error_coeff_weekly FLOAT64;
