# Gas turbine 2015: exploratory analysis and regression
# Adapted from the supplied workdataset.R / 2015 exploration code.
# Select the 2015 gas turbine CSV file when prompted.

if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("car", quietly = TRUE)) install.packages("car")
library(ggplot2)
library(car)

data2015 <- read.csv(file.choose(), header = TRUE)
print(summary(data2015))
print(str(data2015))
cat("Dimensions:", dim(data2015), "\n")
cat("Missing values:", sum(is.na(data2015)), "\n")
print(colSums(is.na(data2015)))

features <- intersect(
  c("AT", "AP", "AH", "AFDP", "GTEP", "TIT", "TAT", "TEY", "CDP"),
  names(data2015)
)
for (feature in features) {
  boxplot(data2015[[feature]], main = paste("Boxplot:", feature))
}

# IQR capping for selected variables when present.
cap_iqr <- function(x) {
  q <- quantile(x, c(0.25, 0.75), na.rm = TRUE)
  width <- 1.5 * IQR(x, na.rm = TRUE)
  x[x < q[1] - width] <- q[1] - width
  x[x > q[2] + width] <- q[2] + width
  x
}
for (feature in intersect(c("AP", "TIT", "CO", "NOX", "TAT"), names(data2015))) {
  data2015[[feature]] <- cap_iqr(data2015[[feature]])
}

# Multiple linear regression for CO when the required response/predictors exist.
predictors <- intersect(c("AT", "AP", "AH", "AFDP", "GTEP", "TIT", "TAT", "TEY", "CDP"),
                        names(data2015))
if ("CO" %in% names(data2015) && length(predictors) > 0) {
  model <- lm(reformulate(predictors, response = "CO"), data = data2015)
  print(summary(model))
  par(mfrow = c(2, 2))
  plot(model)
  par(mfrow = c(1, 1))
  print(car::Anova(model, type = 2))
}
