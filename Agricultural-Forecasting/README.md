# Agricultural Production Forecasting (USA)

A monthly time-series forecasting project built from the supplied **Agriculture production USA** workbook.

## Data
- 312 monthly observations.
- Series begins in January 1992.
- The source workbook was converted to the included CSV for reproducible use.

## Workflow
- Build a monthly R time-series object.
- Inspect summary statistics, trend and seasonality.
- Apply STL decomposition and an Augmented Dickey-Fuller stationarity test.
- Fit a seasonal ARIMA model with a 24-month holdout when sufficient history is available.
- Evaluate the holdout forecast and refit on the full series for a 12-month forecast.

## Files
- agriculture_production_usa.csv — data converted from the supplied workbook.
- agriculture_forecast.R — R forecasting workflow.

The uploaded folder contained the dataset but no original agricultural forecasting script/notebook. The included R workflow was prepared from that dataset; no forecast metrics are claimed without running it.
