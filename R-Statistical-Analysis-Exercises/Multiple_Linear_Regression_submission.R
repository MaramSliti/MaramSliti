# Max ozone (maxO3) analysis supplied in Multiple_Linear_Regression_submission.r
filtered_data <- read.table(file = file.choose(), header = TRUE, sep = ";", dec = ",")
summary(filtered_data)
str(filtered_data)

# Iterative backward variable removal as in the submitted exercise.
model0 <- lm(maxO3 ~ . - obs - vent - pluie, data = filtered_data)
model1 <- lm(maxO3 ~ . - Vx15, data = filtered_data)
model2 <- lm(maxO3 ~ . - Vx15 - T9, data = filtered_data)
model3 <- lm(maxO3 ~ . - Vx15 - T9 - Ne15, data = filtered_data)
model4 <- lm(maxO3 ~ . - Vx15 - T9 - Ne15 - Ne12, data = filtered_data)
model5 <- lm(maxO3 ~ . - Vx15 - T9 - Ne15 - Ne12 - T15, data = filtered_data)
model6 <- lm(maxO3 ~ . - Vx15 - T9 - Ne15 - Ne12 - T15 - Vx12, data = filtered_data)
print(summary(model6))
par(mfrow = c(2, 2))
plot(model6)

# Non-parametric comparisons for categorical predictors.
table(filtered_data$vent)
tapply(filtered_data$maxO3, filtered_data$vent, shapiro.test)
kruskal.test(filtered_data$maxO3, filtered_data$vent)

table(filtered_data$pluie)
tapply(filtered_data$maxO3, filtered_data$pluie, shapiro.test)
wilcox.test(maxO3 ~ pluie, data = filtered_data)
