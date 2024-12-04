# Main code for estimation, prediction, and evaluation --------------------

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
library(plotly)


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


### Delete small coefficients variables ---------------------------------
df_weather <- df_weather %>%
    select(-c())

### Scale explanatory variable mean=0, sigma=1 --------------------------
original_weather <- df_weather
df_weather <- as.data.frame(scale(df_weather))

## Set list of data for stan code ---------------------------------------
num_pred = 30 # length of prediction data
T <- nrow(df_weather) - num_pred # length of data for estimation
y <- df_hrv$HR # dependent variable y
I <- sum(is.na(y[1:T])) # not include missing values during prediction period
y[is.na(y[1:T])] <- -1 # nan flag for stan (remain missing values during prediction period)

data_list <- list(
    T = T, # data length without last num_pred days
    D = ncol(df_weather), # the number of features
    I = I, # the number of nan values in y
    features = as.matrix(df_weather[1:T, ]), # explanatory variable
    y = y[1:T], # y from 1 to T (period for estimation)
    T_pred = num_pred,
    features_pred = t(t(df_weather[(T+1):(T+num_pred), ]))
)



## Estimate parameters by stan MCMC -------------------------------------
model <- stan(
    file = "./mcs_research/src/scripts/analysis/model/first_step_season.stan",
    data = data_list,
    seed = 1,
    iter = 500,
    warmup = 250,
    chains = 4,
    # control = c(max_treedepth = 15)
)

# saveRDS(model, file = "../../model/bwp_season_HR_30.obj")

## Check results --------------------------------------------------------
mcmc_result <- rstan::extract(model)

### WAIC ------------------------------------------------------
log_lik <- extract_log_lik(model)
waic(log_lik)
# loo(log_lik)

### Beta distribution (coefficients)  -----------------------------------
beta_hist <- as.data.frame(mcmc_result$beta)
colnames(beta_hist) <- colnames(df_weather)
beta_hist <- melt(beta_hist)
colnames(beta_hist) <- c("beta", "value")

ggplot(beta_hist, aes(x=value)) +
    geom_histogram(bins = 50) +
    facet_wrap(~beta)

#### Organize coefficients results
beta_result <- data.frame(colnames(df_weather),
                          apply(mcmc_result$beta, MARGIN = 2, mean))

colnames(beta_result) <- c("feature", "coef_mean")
beta_result[order(abs(beta_result$coef_mean), decreasing = TRUE), ]


traceplot(model, pars = c("beta", "sigma_w", "sigma_y", "sigma_season"))
# stan_trace(model, inc_warmup = TRUE, pars = c("beta", "sigma_season"))
# rhat(model, pars = c("beta", "sigma_w", "sigma_y", "sigma_season"))
# mcmc_rhat(rhat(model, pars = "beta"))

median(mcmc_result$sigma_y)

ggplot() +
    geom_line(aes(x=1:T, y=apply(mcmc_result$season, 2, mean)))

### Plot estimated results --------------------------------------------------

#### Impute predicted values at y missing values
y_filled <- y
y_filled[y[1:T] == -1] <- apply(mcmc_result$y_mis, MARGIN = 2, mean) # impute pred of missing values

#### Make data frame of y and estimated lower/median/upper range
df_stan <- make_ci_df(data_array = mcmc_result$mu, y = y_filled, is_pred = FALSE)

plot_ssm(df_stan, title = "Estimation")

### Plot prediction result --------------------------------------------------
df_stan <- make_ci_df(mcmc_result$pred, y=y_filled, is_pred = F) # prediction interval before y_pred
df_pred <- make_ci_df(mcmc_result$y_pred, y_filled, is_pred = TRUE, T = T, num_pred = num_pred)
df_all <- bind_rows(df_stan, df_pred) # combine predicted data

plot_pred(df_all, data_list$T_pred, T, focus=TRUE) # plot prediction result

### Residuals ------------------------------------------------------
resid <- y_filled - df_all$fit
# gg <- ggplot() +
#     geom_line(aes(x=df_all$time, y=resid))
# ggplotly(gg)
plot(resid, type = "l") # see residuals between y and estimation/prediction

acf(resid, na.action = na.pass, lag.max = 100) # autocorrelation

PP.test(y_filled[1:T]-df_all$fit[1:T]) # something to test stationarity

mean(y-df_all$fit, na.rm = TRUE) # mean of residuals, 0 would be best

# hist(data_list$y - df_stan$fit, breaks = 100)
hist(df_pred$fit - df_pred$y, breaks = 100)

# check evaluation index
# sqrt(sum((df_stan$fit - data_list$y) ^ 2) / data_list$T) # RMSE
sqrt(sum((df_pred$fit - df_pred$y) ^ 2, na.rm = TRUE) / data_list$T_pred) # RMSE

plot(df_pred$fit - df_pred$y, type="l")
acf((df_pred$fit - df_pred$y), lag.max = 30, na.action = na.pass)
