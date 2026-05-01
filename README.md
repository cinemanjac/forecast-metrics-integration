# Forecast Metrics Integration

This project demonstrates how forecast performance metrics (MAE, RMSE, RMSE/MAE ratio)
can be integrated into an existing dataset using a production-style SQL pipeline.

---

## Overview

The pipeline calculates forecast accuracy metrics at weekly and monthly levels
and attaches them to the main dataset for monitoring purposes.

The project simulates a real-world scenario where new analytical metrics are
added to an existing data model and made available for downstream reporting
(e.g., dashboards).

---

## Project Structure

* `/data`
  Synthetic dataset used for demonstration

* `/notebook`
  Dataset generation logic (Python / pandas)

* `/sql`
  SQL pipeline for:

  * schema setup
  * metric calculation
  * metric integration

---

## Key Components

### 1. Schema Setup

Adds placeholder columns for forecast metrics

### 2. Metrics Calculation

Computes MAE and RMSE using aggregated utilisation

### 3. Metrics Integration

Uses a MERGE statement to update the dataset with calculated metrics
