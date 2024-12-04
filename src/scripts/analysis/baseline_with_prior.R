# Baseline with horse (or another sparse prior distribution) ------------

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
source("./mcs_research/src/scripts/analysis/kkplot.R")


## Stan setting ---------------------------------------------------------
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

## Read both HRV and weather data ---------------------------------------
# df_hrv <- read.csv("./mcs_research/src/data/HRV/hrv_inputed.csv") # sonouchi dekiru
df_hrv <- read.csv("./mcs_research/src/data/HRV/hrv.csv") # 2274 data
df_weather <- read.csv("./mcs_research/src/data/weather/weather_imputed.csv") # sonouchi tsukau
df_weather <- read.csv("./mcs_research/src/data/weather/trash/weather_std_date_adjusted.csv") # 2274
date <- as.Date(df_weather$date)

### Delete unnecessary columns
df_weather <- df_weather %>%
                    select(-c("date", "day_of_week", "max_gust",
                              "max_wind_speed", "mean_press",
                              "mean_vapor", "max_depth",))


## Set list of data for stan code ---------------------------------------
num_pred <- 30 # length of prediction data
T <- nrow(df_weather) - num_pred # length of data for estimation
y <- df_hrv$TINN # dependent variable y
data_list <- list(
    T = T, # data length without last num_pred days
    D = ncol(df_weather), # the number of features
    features = as.matrix(df_weather[1:T, ]), # explanatory variable
    y = y[1:T], # dependent variable
    T_pred = num_pred, # length of prediction
    # explanatory data of prediction
    features_pred = as.matrix(df_weather[(T+1):(T+num_pred), ])
)

## Parameters estimation by stan MCMC -----------------------------------
model <- stan(
    file = "./mcs_research/src/scripts/analysis/model/baseline_with_prior.stan",
    data = data_list,
    seed = 1,
    iter = 500,
    warmup = 250,
    chains = 4,
    # control = c(max_treedepth = 15)
)

# saveRDS(model, file = "../../model/bwp_season_HR_30.obj")

## Results check --------------------------------------------------------
mcmc_result <- rstan::extract(model)

### WAIC calculation
log_lik <- extract_log_lik(model)
waic(log_lik)
# loo(log_lik)

### beta (coefficients) 
beta_hist <- as.data.frame(mcmc_result$beta)
colnames(beta_hist) <- colnames(df_weather)
beta_hist <- melt(beta_hist)
colnames(beta_hist) <- c("beta", "value")

ggplot(beta_hist, aes(x=value)) +
    geom_histogram(bins = 50) +
    facet_wrap(~beta)

### organize coefficients results
beta_result <- data.frame(colnames(df_weather),
           apply(mcmc_result$beta, MARGIN = 2, mean))

colnames(beta_result) <- c("feature", "coef_mean")
beta_result[order(abs(beta_result$coef_mean), decreasing = TRUE),]

# traceplot(model, pars = c("beta", "sigma_w", "sigma_y"))
stan_trace(model, inc_warmup = TRUE, pars = c("beta", "sigma_w", "sigma_y"))
rhat(model, pars = c("beta", "sigma_w", "sigma_y"))
# mcmc_rhat(rhat(model, pars = "beta"))

### Plot estimated results --------------------------------------------------
# df_stan <- make_ci_df(mcmc_result$mu) # mu, alpha
res <- t(apply(
    X = mcmc_result$alpha, # not for *_all, cuz useless, and for mu, alpha, pred
    MARGIN = 2,
    FUN = quantile,
    probs = c(0.025, 0.5, 0.975)
))

colnames(res) <- c("lwr", "fit", "upr")

df_stan <- cbind(
    data.frame(y = y[1:nrow(res)], time=date[1:nrow(res)]),
    as.data.frame(res)
)

plot_ssm(df_stan)

### Plot prediction result --------------------------------------------------
df_stan <- make_ci_df(mcmc_result$pred) # prediction interval before y_pred
res_pred <- t(apply(
    X = mcmc_result$y_pred, # for y_pred
    MARGIN = 2, # row-major (process by row)
    FUN = quantile,
    probs=c(0.025, 0.5, 0.975)
))
colnames(res_pred) <- c("lwr", "fit", "upr")

# prepare data frame of predicted values
df_pred <- cbind(
    data.frame(y = y[(T+1):(T+num_pred)], time=date[(T+1):(T+num_pred)]),
    as.data.frame(res_pred)
)

df_all <- bind_rows(df_stan, df_pred) # combine predicted data

plot_ssm(df_all)

plot_pred(df_all, data_list$T_pred, T, focus = F) # plot prediction result

# check residuals
# hist(data_list$y - df_stan$fit, breaks = 100)
hist(df_pred$fit - df_pred$y, breaks = 100)

# check evaluation index
# sqrt(sum((df_stan$fit - data_list$y) ^ 2) / data_list$T) # RMSE
sqrt(sum((df_pred$fit - df_pred$y) ^ 2) / data_list$T_pred) # RMSE

plot(df_pred$fit - df_pred$y, type="l")
acf((df_pred$fit - df_pred$y), lag.max = 30)
