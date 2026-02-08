# Empirical Finance – ETF Performance Analysis (R)

## Overview
This group project analyzes the performance and diversification properties of three Exchange-Traded Funds (ETFs) using empirical finance methods in R and Excel. The goal is to compare a global equity ETF, a country-specific equity ETF, and a gold ETF in terms of returns, risk, market exposure, and risk-adjusted performance.

ETFs studied:
- MSCI World UCITS ETF (global market proxy)
- France Equity UCITS ETF (national equity exposure)
- Gold UCITS ETF (alternative asset)

Weekly prices are converted to arithmetic returns and normalized (base 100) to compare relative performance.


## Methods
- Descriptive statistics (mean, volatility, skewness, kurtosis)
- Jarque–Bera normality test
- Correlation and autocorrelation analysis
- Jensen’s alpha regression
- Chow test for coefficient stability
- Sharpe and Treynor ratios for risk-adjusted performance


## Key Results
- Equity ETFs show negative skewness and fat tails; gold returns are close to normal.
- Strong correlation between MSCI World and France Equity; gold has low correlation with equities.
- Jensen regressions show significant market exposure for France Equity (β ≈ 0.76) and limited exposure for Gold (β ≈ 0.56).
- No statistically significant Jensen’s alpha for either narrow ETF.
- Chow tests indicate stable coefficients over time.
- Gold exhibits higher Sharpe and Treynor ratios, providing diversification benefits relative to equities.



## Files
- R script: data processing and estimations  
- Excel files: organization and figures  
- PDF report: full methodology and interpretation



## Team
Group academic project:
- LAZRAQ Wahiba
- NAJM-SBAI Hiba

### My contribution (Wahiba Lazraq)
- Data preprocessing in R  
- Return computation and visualization  
- Jensen regressions and Chow tests  
- Risk-adjusted performance analysis  
- Results interpretation



## Tools
- R
- Microsoft Excel
