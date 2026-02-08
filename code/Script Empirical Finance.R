# Packages (install once if needed)
install.packages(c("dplyr", "moments"))
library(dplyr)
library(moments)



names(returns)[names(returns) == "returns_France equity"] <- "returns_France_equity"
View(returns)

# 1) Clean data: remove the first NA row
returns_clean <- returns %>%
  filter(
    !is.na(returns_MSCI),
    !is.na(`returns_France_equity`),
    !is.na(returns_Gold)
  )

# 2) Descriptive statistics function (course-consistent)
desc_stats <- function(x) {
  x <- x[is.finite(x)]
  c(
    Mean = mean(x),
    Median = median(x),
    Min = min(x),
    Max = max(x),
    SD = sd(x),
    Skewness = skewness(x),
    ExcessKurtosis = kurtosis(x) - 3,
    P5 = as.numeric(quantile(x, 0.05)),
    P95 = as.numeric(quantile(x, 0.95))
  )
}

# 3) Build the table (rows = ETFs)
stats_table <- rbind(
  MSCI_World    = desc_stats(returns_clean$returns_MSCI),
  France_Equity = desc_stats(returns_clean$`returns_France_equity`),
  Gold          = desc_stats(returns_clean$returns_Gold)
)

# 4) Round for presentation
stats_table <- round(stats_table, 6)
stats_table

#Testing normality (JB test)

install.packages("tseries")
library(tseries)

jb_MSCI   <- jarque.bera.test(returns_clean$returns_MSCI)
jb_France <- jarque.bera.test(returns_clean$returns_France_equity)
jb_Gold   <- jarque.bera.test(returns_clean$returns_Gold)

jb_MSCI
jb_France
jb_Gold


# Correlation matrix of returns
cor_matrix <- cor(
  returns[, c("returns_MSCI",
              "returns_France_equity",
              "returns_Gold")],
  use = "complete.obs"
)

round(cor_matrix, 3)

# Calculate autocorrelations up to lag 20 (returns)
acf_MSCI   <- acf(returns_clean$returns_MSCI, plot = FALSE, lag.max = 20)
acf_France <- acf(returns_clean$returns_France_equity, plot = FALSE, lag.max = 20)
acf_Gold   <- acf(returns_clean$returns_Gold, plot = FALSE, lag.max = 20)

# Extract the values (remove lag 0)
lags <- 1:20
ac_table <- data.frame(
  Lag = lags,
  ACF_MSCI   = as.numeric(acf_MSCI$acf)[-1],
  ACF_France = as.numeric(acf_France$acf)[-1],
  ACF_Gold   = as.numeric(acf_Gold$acf)[-1]
)

round(ac_table, 3)


# Autocorrelation plots
par(mar = c(4, 4, 2, 1))

acf(returns_clean$returns_MSCI,
    main = "Autocorrelation of MSCI World returns")

acf(returns_clean$returns_MSCI,
    main = "Autocorrelation of France Equity returns")

acf(returns_clean$returns_Gold,
    main = "Autocorrelation of Gold returns")

par(mfrow = c(1,1)) # reset layout

# If you don't have a risk-free series, set rf = 0
rf <- 0

df <- returns_clean %>%
  dplyr::mutate(
    M_ex  = returns_MSCI - rf,
    F_ex  = returns_France_equity - rf,
    G_ex  = returns_Gold - rf
  )
m_fr <- lm(F_ex ~ M_ex, data = df)  # France vs Market
m_au <- lm(G_ex ~ M_ex, data = df)  # Gold vs Market

summary(m_fr)
summary(m_au)

# test the reliability

install.packages(c("sandwich", "lmtest"))
library(sandwich)
library(lmtest)

# Robust (HC) t-tests
coeftest(m_fr, vcov. = vcovHC(m_fr, type = "HC1"))
coeftest(m_au, vcov. = vcovHC(m_au, type = "HC1"))


library(strucchange)

# Define breakpoint (mid-sample)
break_point <- floor(nrow(df) / 2)
chow_fr <- sctest(F_ex ~ M_ex, type = "Chow", point = break_point, data = df)
chow_fr

chow_au <- sctest(G_ex ~ M_ex, type = "Chow", point = break_point, data = df)
chow_au

# Compute mean returns and volatility
# Mean weekly returns
mean_fr <- mean(df$F_ex)
mean_au <- mean(df$G_ex)

# Volatility (standard deviation)
sd_fr <- sd(df$F_ex)
sd_au <- sd(df$G_ex)

#Sharpe ratios
sharpe_fr <- mean_fr / sd_fr
sharpe_au <- mean_au / sd_au

#Treynor Ratios (using estimated betas)
beta_fr <- coef(m_fr)["M_ex"]
beta_au <- coef(m_au)["M_ex"]

treynor_fr <- mean_fr / beta_fr
treynor_au <- mean_au / beta_au


#Summary table
performance[, -1] <- round(performance[, -1], 4)
performance

df$M_ex <- returns_clean$returns_MSCI

mean_m <- mean(df$M_ex)
sd_m   <- sd(df$M_ex)

sharpe_m <- mean_m / sd_m

treynor_m <- mean_m

comparison <- data.frame(
  ETF = c("Market (MSCI World)", "France Equity", "Gold"),
  Sharpe = round(c(sharpe_m, sharpe_fr, sharpe_au), 4),
  Treynor = round(c(treynor_m, treynor_fr, treynor_au), 4)
)

comparison
