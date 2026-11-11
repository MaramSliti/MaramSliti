# Gas turbine emissions: multi-year data preparation and statistical analysis
# Adapted from the original R script supplied in stats.zip.
# Select five annual CSV files (2011 through 2015) when prompted.

if (!requireNamespace("VIM", quietly = TRUE)) install.packages("VIM")
library(VIM)

annual_files <- lapply(1:5, function(i) {
  read.csv(file.choose(), header = TRUE, stringsAsFactors = FALSE)
})
names(annual_files) <- 2011:2015
gas_turbine <- do.call(rbind, annual_files)

cat("Merged dimensions:", dim(gas_turbine), "\n")
print(summary(gas_turbine))
cat("Missing values by variable:\n")
print(colSums(is.na(gas_turbine)))

# Inspect potential outliers using boxplots; mark them as missing before imputation.
numeric_cols <- names(gas_turbine)[vapply(gas_turbine, is.numeric, logical(1))]
par(mfrow = c(3, 4))
for (column in numeric_cols) {
  boxplot(gas_turbine[[column]], main = column)
  outliers <- boxplot(gas_turbine[[column]], plot = FALSE)$out
  gas_turbine[[column]][gas_turbine[[column]] %in% outliers] <- NA
}
par(mfrow = c(1, 1))

# KNN imputation; *_imp helper columns are removed from the analysis table.
gas_turbine_imputed <- VIM::kNN(gas_turbine)
imputed_columns <- grep("_imp$", names(gas_turbine_imputed), value = TRUE)
gas_turbine_clean <- gas_turbine_imputed[, !names(gas_turbine_imputed) %in% imputed_columns,
                                         drop = FALSE]
print(summary(gas_turbine_clean))

# Min-max normalization for numeric variables, leaving constant columns unchanged.
normalize_minmax <- function(x) {
  limits <- range(x, na.rm = TRUE)
  if (!all(is.finite(limits)) || diff(limits) == 0) return(x)
  (x - limits[1]) / diff(limits)
}
normalized_data <- as.data.frame(lapply(gas_turbine_clean, function(x) {
  if (is.numeric(x)) normalize_minmax(x) else x
}))
print(summary(normalized_data))

# Exploratory emissions model from the submitted workflow.
if (all(c("NOX", "AP", "AT") %in% names(normalized_data))) {
  nox_model <- lm(NOX ~ AP + AT, data = normalized_data)
  print(summary(nox_model))
  par(mfrow = c(2, 2))
  plot(nox_model)
  par(mfrow = c(1, 1))
}
