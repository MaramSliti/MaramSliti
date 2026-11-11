# Selected R exercises from Autocorrelation-Adjustment.ipynb

# White noise and autocorrelation.
X <- rnorm(100)
hist(X)
acf(X)

# AirPassengers: log transform and decomposition.
Ap <- AirPassengers
plot(log(Ap))
acf(log(Ap), 50)
Dm.A <- decompose(Ap, "multiplicative")
acf(Dm.A$random, 50, na.action = na.pass)

# Trend plus noise and moving-average smoothing.
t <- 1:100
e_t <- rnorm(100)
x_t <- 2 * t + 2 + 10 * e_t
ts.plot(x_t)
acf(x_t, 40)
plot(filter(x_t, rep(1 / 5, 10), side = 2))

# Standard normal series and a random walk.
x <- rnorm(1000)
ts.plot(x)
acf(x)

set.seed(100)
e <- rnorm(1000)
rw <- numeric(1000)
for (i in 2:1000) rw[i] <- rw[i - 1] + e[i]
ts.plot(rw)
acf(rw, 100)
