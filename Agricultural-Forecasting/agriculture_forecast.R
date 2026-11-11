# Agricultural Production Forecasting (USA)
# Based on the monthly Agriculture production USA workbook supplied by the author.
# Place agriculture_production_usa.csv beside this script.

required <- c("forecast", "tseries", "readr")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) install.packages(missing)
library(forecast)
library(tseries)
library(readr)

data <- read_csv("agriculture_production_usa.csv", show_col_types = FALSE)
stopifnot(all(c("date", "production") %in% names(data)))
data$date <- as.Date(data$date)
data <- data[order(data$date), ]
data$production <- as.numeric(data$production)
data <- data[complete.cases(data[, c("date", "production")]), ]

start_year <- as.integer(format(min(data$date), "%Y"))
start_month <- as.integer(format(min(data$date), "%m"))
production_ts <- ts(data$production, start = c(start_year, start_month), frequency = 12)

print(summary(production_ts))
plot(production_ts, main = "US Agricultural Production", xlab = "Year", ylab = "Production")

if (length(production_ts) >= 24) {
  decomposition <- stl(production_ts, s.window = "periodic")
  plot(decomposition)
}
print(adf.test(production_ts))

# Hold out the final 24 months, fit a seasonal ARIMA model and evaluate.
h <- min(24, max(1, floor(length(production_ts) * 0.2)))
train_ts <- head(production_ts, length(production_ts) - h)
test_ts <- tail(production_ts, h)
fit <- auto.arima(train_ts, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)
print(summary(fit))
fc <- forecast(fit, h = h)
print(accuracy(fc, test_ts))
plot(fc, main = "Agricultural Production Forecast with Holdout")
lines(test_ts, col = "red", lwd = 2)

# Refit on the full series and generate a 12-month forecast.
final_fit <- auto.arima(production_ts, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)
future_fc <- forecast(final_fit, h = 12)
print(future_fc)
plot(future_fc, main = "12-Month Agricultural Production Forecast")
