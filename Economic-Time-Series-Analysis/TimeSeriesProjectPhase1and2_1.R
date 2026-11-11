# R code exported from the supplied TimeSeriesProjectPhase1and2_1.ipynb
# Requires the workbook files named below in the working directory.

library(forecast)
library(tseries)
library(ggplot2)
library(readxl)

data1 <- read_excel("Job Openings construction S C3.xlsx", skip = 10)
data2 <- read_excel("Industrial Production GAZ S C1.xls", skip = 10)
data3 <- read_excel("Value of wood exportation.xlsx")

head(data1, 15)
head(data2, 15)
head(data3, 15)

# Build monthly time series.
ts1 <- ts(data1$JTU2300JOL, start = c(2004, 1), frequency = 12)
ts3 <- ts(data3[[2]], start = c(1992, 2), frequency = 12)

summary(ts1)
summary(ts3)

autoplot(ts1) + ggtitle("Time Series 1 - Job Openings Construction") +
  xlab("Time") + ylab("Job Openings")
autoplot(ts3) + ggtitle("Time Series 2 - Value of Wood Exportation") +
  xlab("Time") + ylab("Export Value")

# Decomposition and stationarity.
decomp1 <- decompose(ts1)
decomp3 <- decompose(ts3)
plot(decomp1)
plot(decomp3)
adf.test(ts1)
adf.test(ts3)

# ACF and PACF for model identification.
acf(ts1, main = "ACF - Job Openings Construction")
pacf(ts1, main = "PACF - Job Openings Construction")
acf(ts3, main = "ACF - Value of Wood Exportation")
pacf(ts3, main = "PACF - Value of Wood Exportation")

# Phase 2: first differencing and stationarity checks.
ts1_diff <- diff(ts1)
ts3_diff <- diff(ts3)
autoplot(ts1_diff) + ggtitle("Differenced - Job Openings Construction")
autoplot(ts3_diff) + ggtitle("Differenced - Value of Wood Exportation")
adf.test(ts1_diff)
adf.test(ts3_diff)
acf(ts1_diff)
pacf(ts1_diff)
acf(ts3_diff)
pacf(ts3_diff)
