# Baseline with horse (or another sparse prior distribution) ####

## Import ####

### Bayes
library(rstan)
library(bayesplot)
library(loo)

### Data processing
library(dplyr)
library(reshape2)

### Visualization
library(ggfortify)
library(gridExtra)
library(patchwork)
library(ggplot2)

## Stan setting ####
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

## Read both HRV and weather data ####
df_hrv <- read.csv("./mcs_research/src/data/HRV/hrv.csv")
df_weather <- read.csv("./mcs_research/src/data/weather/weather_std.csv")
date <- df_weather$date
date <- as.Date(date)

### Delete unnecessary columns
df_weather <- df_weather %>%
                select(-c("max_gust", "max_wind_speed", "mean_press"))

plot(df_hrv$HR, type="l")
## Set list of data for stan code ####
data_list <- list(
    T = length(df_weather$mean_press),
    D = ncol(df_weather[-1:-2]),
    features = t(t(df_weather[-1:-2])),
    y = df_hrv$HR
)

## Parameters estimation by stan MCMC ####
model <- stan(
    file = "./mcs_research/src/scripts/analysis/model/baseline.stan",
    data = data_list,
    seed = 1,
    iter = 5000,
    warmup = 2000,
    control = c(max_treedepth = 15)
)

# saveRDS(model, file = "./mcs_research/src/scripts/analysis/model/basic_6_cauchy.obj")

## Results check ####

mcmc_result <- rstan::extract(model)

## WAIC calculation
log_lik <- extract_log_lik(model)
waic(log_lik)
# loo(log_lik)

## check results

### beta (coefficients) 
beta_hist <- as.data.frame(mcmc_result$beta)
colnames(beta_hist) <- colnames(df_weather[-1:-2])
beta_hist <- melt(beta_hist)
colnames(beta_hist) <- c("beta", "value")

ggplot(beta_hist, aes(x=value)) +
    geom_histogram(bins = 50) +
    facet_wrap(~beta)

hist(mcmc_result$beta[, 1], breaks = 100)
hist(mcmc_result$sigma_w)
hist(mcmc_result$sigma_v)

# organize coefficients results
beta_result <- data.frame(colnames(df_weather[-1:-2]),
           apply(mcmc_result$beta, MARGIN = 2, mean))
colnames(beta_result) <- c("feature", "coef_mean")
beta_result[order(beta_result$coef_mean),]
beta_result[order(abs(beta_result$coef_mean), decreasing = TRUE),]


traceplot(model, pars = c("beta", "sigma_w", "sigma_v"))
stan_trace(model, inc_warmup = TRUE, pars = c("beta"))
mcmc_rhat(rhat(model, pars = "beta"))

# plot estimated results
model_mu <- t(apply(
    X = mcmc_result$alpha,
    MARGIN = 2,
    FUN = quantile,
    probs=c(0.025, 0.5, 0.975)
))

colnames(model_mu) <- c("lwr", "fit", "upr")

stan_df <- cbind(
    data.frame(y = data_list$y, time=date),
    as.data.frame(model_mu)
)

ggplot(data = stan_df, aes(x=time, y=y)) +
    geom_point(alpha=0.6, size=0.9) +
    geom_line(aes(y=fit), linewidth=1.2, color="red") +
    geom_ribbon(aes(ymin=lwr, ymax=upr), alpha=0.3) +
    title("") +
    scale_x_date(date_labels = "%Y-%m",
                 date_breaks = "6 month",) +
    theme(axis.text.x = element_text(angle = 90),
          aspect.ratio = 3/10)

# check residuals
hist(data_list$y-stan_df$fit, breaks = 100)

# check evaluation index
sqrt(sum((stan_df$fit - data_list$y) ^ 2) / data_list$T) # RMSE

ggplot() +
    geom_line(aes(x=date, y=data_list$y)) +
    theme(aspect.ratio = 3/10)