# Statistical Analysis of Gas Turbine Emissions

Collaborative academic R project analyzing annual gas-turbine measurements from 2011–2015 and their relationship with CO and NOx emissions.

## Dataset
The original archive includes one CSV per year (2011–2015). The scripts prompt for these local CSV files; the raw source datasets are not bundled in this repository.

## Methods
- Combine five annual datasets and explore distributions and missing values.
- Detect and treat outliers using boxplots/IQR-based rules.
- Apply KNN imputation and min-max normalization.
- Explore distributional assumptions and variance differences.
- Apply hypothesis tests and multiple linear regression to emissions variables.
- Inspect the 2015 dataset separately with regression diagnostics and ANOVA-style tests.

## Files
- gas_turbine_analysis.R — cleaned end-to-end starter workflow already present in this folder.
- gas_turbine_original_analysis.R — updated from the original multi-year R script supplied in stats.zip.
- gas_turbine_2015_data_exploration.R — R exploration and regression script adapted from the 2015 work.

The archive also contained an AI4I predictive-maintenance CSV, but that file is a dataset only and is not described here as a completed predictive-maintenance project.

## Tools
R, ggplot2, VIM, car and base statistical modelling.

## Academic collaboration
The original report credits multiple contributors. This repository documents collaborative academic work and does not claim sole authorship of the original report.
