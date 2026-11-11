# R code exported from the supplied Lab3TimeSeries.ipynb
# Structural-break regression and seasonal terms for an ICT production series.

ICT <- "https://raw.githubusercontent.com/sami-sifi/DATA-17-18/refs/heads/master/Production%20TIC/production%20TIC.txt"
ICT.v <- read.table(ICT, header = FALSE)
ts.plot(ICT.v)

ict.ts <- ts(ICT.v, start = c(1992, 1), frequency = 12)
plot(log(ict.ts))

if (!requireNamespace("strucchange", quietly = TRUE)) install.packages("strucchange")
library(strucchange)
t <- 1:length(ict.ts)
p.break <- breakpoints(log(ict.ts) ~ t, h = 10)
print(p.break)

test1 <- lm(log(ict.ts) ~ breakfactor(p.break) * t)
summary(test1)
plot(log(ict.ts))
lines(fitted(p.break), col = 2)
acf(log(ict.ts), 50)

MC <- matrix(0, length(ict.ts), 6)
MS <- matrix(0, length(ict.ts), 6)
for (i in 1:6) MC[, i] <- cos(2 * pi * t / (12 / i))
for (i in 1:6) MS[, i] <- sin(2 * pi * t / (12 / i))
test2 <- lm(log(ict.ts) ~ breakfactor(p.break) * t + MC + MS)
summary(test2)
