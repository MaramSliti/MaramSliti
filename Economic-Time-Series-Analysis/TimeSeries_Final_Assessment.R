# Exported from the user-provided R notebook: Time Series final assessment
# Datasets are not included; place the referenced workbooks in the working directory.

options(repos = c(CRAN = "https://cran.r-project.org"))
required <- c("forecast", "tseries", "ggplot2", "readxl", "dplyr")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) install.packages(missing)
library(forecast)
library(tseries)
library(ggplot2)
library(readxl)
library(dplyr)

# The notebook's final-assessment input workbooks.
df1 <- read_excel("Industrial Production GAZ S C1.xlsx", skip = 10)
df2 <- read_excel("monthly sales garden equip S c3.xlsx", skip = 6)

# Inspect input structures before selecting the columns.
str(df1)
str(df2)
df1 <- df1 %>% rename(Date = observation_date, Value = IPG2211A2N)
ts1 <- ts(df1$Value, start = c(1990, 1), frequency = 12)

# Convert monthly period and string-valued sales into a numeric series.
df2_clean <- df2 %>%
  filter(grepl("^[0-9,]+$", Value)) %>%
  mutate(Date = as.Date(paste0("01-", Period), format = "%d-%b-%Y"),
         Value = as.numeric(gsub(",", "", Value)))
ts2 <- ts(df2_clean$Value, start = c(1992, 1), frequency = 12)

print(summary(ts1))
print(summary(ts2))
autoplot(ts1) + ggtitle("Industrial Production")
autoplot(ts2) + ggtitle("Monthly Garden Equipment Sales")
ggseasonplot(ts1, year.labels = TRUE)
ggseasonplot(ts2, year.labels = TRUE)
ggsubseriesplot(ts1)
ggsubseriesplot(ts2)

# Decomposition, ACF/PACF and stationarity checks.
stl_ts1 <- stl(ts1, s.window = "periodic", robust = TRUE)
stl_ts2 <- stl(ts2, s.window = "periodic", robust = TRUE)
plot(stl_ts1)
plot(stl_ts2)
acf(ts1, lag.max = 50)
pacf(ts1, lag.max = 50)
acf(ts2, lag.max = 50)
pacf(ts2, lag.max = 50)

ts1_diff <- diff(ts1)
ts2_diff <- diff(ts2)
print(adf.test(ts1_diff, alternative = "stationary"))
print(adf.test(ts2_diff, alternative = "stationary"))
autoplot(ts1_diff) + ggtitle("Differenced Industrial Production")
autoplot(ts2_diff) + ggtitle("Differenced Garden Equipment Sales")

# Automatic ARIMA model fitting and residual diagnostics.
fit_ts1 <- auto.arima(ts1_diff)
fit_ts2 <- auto.arima(ts2_diff)
print(summary(fit_ts1))
print(summary(fit_ts2))
checkresiduals(fit_ts1)
checkresiduals(fit_ts2)
print(Box.test(residuals(fit_ts1), lag = 20, type = "Ljung-Box"))
print(Box.test(residuals(fit_ts2), lag = 20, type = "Ljung-Box"))
