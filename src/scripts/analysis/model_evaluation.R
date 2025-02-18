# First step for estimation, prediction, and evaluation --------------------

## Import ------------------------------------------------------------------

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

### Utils
source("./mcs_research/src/scripts/analysis/kkplot.R")

## Stan setting ---------------------------------------------------------
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

## Read both HRV and weather data ---------------------------------------
df_hrv <- read.csv("./mcs_research/src/data/HRV/hrv.csv") # use pure hrv data
df_weather <- read.csv("./mcs_research/src/data/weather/weather_imputed.csv") # use imputed data
date <- as.Date(df_weather$date)

df_hrv <- left_join(df_weather, df_hrv, by = "date") %>%
    select(-c(colnames(df_weather)))

### Delete unnecessary columns ------------------------------------------
df_weather <- df_weather %>%
    select(-c("date", "day_of_week", "max_gust",
              "max_wind_speed", "mean_press",
              "mean_vapor", "max_depth",
              "most_direction", "most_direction_dummy"))

### Scale explanatory variable mean=0, sigma=1 --------------------------
original_weather <- df_weather
df_weather <- as.data.frame(scale(df_weather))

## Set list of data for stan code ---------------------------------------
num_pred <- 30 # length of prediction data
T <- nrow(df_weather) - num_pred # length of data for estimation
y <- df_hrv$LFHFratio * 100 # dependent variable y
I <- sum(is.na(y[1:T])) # not include missing values during prediction period
y[is.na(y[1:T])] <- -1 # nan flag for stan (remain missing values during prediction period)

data_list <- list(
    T = T, # data length without last num_pred days
    I = I,
    y = y[1:T], # y from 1 to T (period for estimation)
    T_pred = num_pred
)

## Estimate parameters by stan MCMC -------------------------------------
# Check: which HRV?
#        stan code includes seasonality or not?
#        correct saveRDS file name?
model <- stan(
    file = "./mcs_research/src/scripts/analysis/model/comparison.stan",
    data = data_list,
    seed = 1,
    iter = 3500, # 6000
    warmup = 1000, # 3500
    chains = 4,
    # thin = 4
    # control = c(max_treedepth = 15)
)

### Save sampling results (Need to change file name, the results are huge size of file)
saveRDS(model, file = "../../model/comparison/LFHF_percent.obj")
# model <- readRDS("../../model/full_period/simple/HR.obj")

## Check results --------------------------------------------------------
mcmc_result <- rstan::extract(model)

### WAIC ------------------------------------------------------
log_lik <- extract_log_lik(model)
waic(log_lik)
# loo(log_lik)


mean(mcmc_result$sigma_w)
mean(mcmc_result$sigma_y)
# traceplot(model, pars = c("beta", "sigma_w", "sigma_y"))
# stan_trace(model, inc_warmup = TRUE, pars = c("beta", "sigma_season"))
# rhat(model, pars = c("beta", "sigma_w", "sigma_y", "sigma_season"))
# mcmc_rhat(rhat(model, pars = "beta"))

### Plot estimated results --------------------------------------------------

#### Impute predicted values at y missing values
y_filled <- y
y_filled[y[1:T] == -1] <- apply(mcmc_result$y_mis, MARGIN = 2, mean) # impute pred of missing values

#### Make data frame of y and estimated lower/median/upper range
df_stan <- make_ci_df(data_array = mcmc_result$pred, y = y_filled, is_pred = FALSE)
imputed_loc <- ifelse((y[1:T] == -1), "imputed", "original")
plot_ssm(df_stan, title = "Estimation", imputed_loc = imputed_loc)
# p <- plot_ssm(df_stan, title = "Estimation", imputed_loc = imputed_loc)
# plotly::ggplotly(p)

resid <- df_stan$y - df_stan$fit
plot(resid, type="l")
mean(resid)

### Plot prediction result --------------------------------------------------
df_stan <- make_ci_df(mcmc_result$pred, y=y_filled, is_pred = FALSE) # estimation interval before y_pred
df_pred <- make_ci_df(mcmc_result$y_pred, y_filled, is_pred = TRUE, T = T, num_pred = num_pred)
df_all <- bind_rows(df_stan, df_pred) # combine predicted data

plot_pred(df_all, data_list$T_pred, T, focus=TRUE) # plot prediction result

### Residuals ------------------------------------------------------
error <- y_filled[(T+1):length(y_filled)] - df_pred$fit # for calculate RMSE
rmse <- sqrt(mean(error^2, na.rm = TRUE))
rmse


#### Main model loading
model_main <- readRDS("../../model/first_step_season/LFHF_percent.obj")
# model_main <- readRDS("../../model/first_step_season/.obj")
mcmc_result_main <- rstan::extract(model_main)
df_pred_main <- make_ci_df(mcmc_result_main$y_pred, y_filled, is_pred = TRUE, T = T, num_pred = num_pred)
error_main <- y_filled[(T+1):length(y_filled)] - df_pred_main$fit # for calculate RMSE
rmse_main <- sqrt(mean(error_main^2, na.rm = TRUE))
rmse_main

df_stan <- make_ci_df(mcmc_result_main$pred, y=y_filled, is_pred = FALSE) # estimation interval before y_pred
df_pred <- make_ci_df(mcmc_result_main$y_pred, y_filled, is_pred = TRUE, T = T, num_pred = num_pred)
df_all <- bind_rows(df_stan, df_pred) # combine predicted data

plot_pred(df_all, data_list$T_pred, T, focus=TRUE) # plot prediction result

(132.74 - 130.71) / 132.74 * 100
