# Gas Turbine Emissions: Statistical Analysis Workflow
# Place authorized annual CSV files in data/ as gt_2011.csv ... gt_2015.csv.
# Expected columns include AT, AP, AH, AFDP, GTEP, TIT, TAT, TEY, CDP, CO, NOX.

packages <- c("VIM", "ggplot2", "car")
missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) install.packages(missing)

library(VIM)
library(ggplot2)
library(car)

years <- 2011:2015
paths <- file.path("data", paste0("gt_", years, ".csv"))
if (!all(file.exists(paths))) {
  stop("Add the five authorized annual CSV files to ./data before running.")
}

annual <- lapply(paths, read.csv)
gt <- do.call(rbind, annual)

cat("Dimensions:\n"); print(dim(gt))
cat("Structure:\n"); str(gt)
cat("Summary:\n"); print(summary(gt))
cat("Missing values by column:\n"); print(colSums(is.na(gt)))

numeric_cols <- names(gt)[vapply(gt, is.numeric, logical(1))]
par(mfrow = c(3, 4))
for (nm in numeric_cols) boxplot(gt[[nm]], main = nm, ylab = nm)
par(mfrow = c(1, 1))

# Winsorization-style capping helper for exploratory sensitivity analysis.
cap_outliers <- function(x) {
  q <- quantile(x, c(.25, .75), na.rm = TRUE)
  lim <- 1.5 * IQR(x, na.rm = TRUE)
  x[x < q[1] - lim] <- q[1] - lim
  x[x > q[2] + lim] <- q[2] + lim
  x
}

# Apply only to selected columns after reviewing the plots.
selected <- intersect(c("AP", "TIT", "CO", "NOX", "TAT"), names(gt))
gt_clean <- gt
for (nm in selected) gt_clean[[nm]] <- cap_outliers(gt_clean[[nm]])

# Optional KNN imputation; keep a copy of the original data for comparison.
gt_imputed <- VIM::kNN(gt_clean, k = 5)

# Correlation matrix for numeric variables.
cor_matrix <- cor(gt_imputed[, numeric_cols, drop = FALSE],
                  use = "pairwise.complete.obs")
print(round(cor_matrix, 3))

# Example multiple linear regression models for emissions.
if (all(c("CO", "AT", "AP", "AH", "AFDP", "GTEP", "TIT", "TAT", "TEY", "CDP") %in% names(gt_imputed))) {
  co_model <- lm(CO ~ AT + AP + AH + AFDP + GTEP + TIT + TAT + TEY + CDP,
                 data = gt_imputed)
  print(summary(co_model))
  print(car::vif(co_model))
  par(mfrow = c(2, 2)); plot(co_model); par(mfrow = c(1, 1))
}

if (all(c("NOX", "AT", "AP", "AH", "AFDP", "GTEP", "TIT", "TAT", "TEY", "CDP") %in% names(gt_imputed))) {
  nox_model <- lm(NOX ~ AT + AP + AH + AFDP + GTEP + TIT + TAT + TEY + CDP,
                  data = gt_imputed)
  print(summary(nox_model))
  print(car::vif(nox_model))
  par(mfrow = c(2, 2)); plot(nox_model); par(mfrow = c(1, 1))
}
