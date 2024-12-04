library(rstan)
library(bayesplot)
library(ggfortify)
library(gridExtra)
library(ggplot2)
library(loo)

# stan setting
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# read both HRV and weather data
df_hrv <- read.csv("./mcs_research/src/data/HRV/hrv.csv")
df_weather <- read.csv("./mcs_research/src/data/weather/weather_std.csv")
date <- df_weather$date
date <- as.Date(date)

colnames(df_weather)

# set list of data for stan code
data_list <- list(
    n_sample = length(df_weather$mean_press),
    D = 7,
    mean_press = df_weather$mean_press,
    mean_hum = df_weather$mean_hum,
    mean_temp = df_weather$mean_temp,
    mean_wind_speed = df_weather$mean_wind_speed,
    sun_hour = df_weather$sun_hour,
    total_preci = df_weather$total_preci,
    total_snowfall = df_weather$total_snowfall,
    y = df_hrv$RMSSD
)

# model estimation
model <- stan(
    file = "./mcs_research/src/scripts/analysis/model/basic.stan",
    data = data_list,
    seed = 1,
    iter = 1000,
    warmup = 500
)

# saveRDS(model, file = "./mcs_research/src/scripts/analysis/model/basic_6_cauchy.obj")

# WAIC calculation
log_lik <- extract_log_lik(model)
waic(log_lik)
loo(log_lik)

# check results
mcmc_sample <- rstan::extract(model)

hist(mcmc_sample$b_1)
hist(mcmc_sample$b_2)
hist(mcmc_sample$b_3)
hist(mcmc_sample$b_4)
hist(mcmc_sample$b_5)
hist(mcmc_sample$b_6)
hist(mcmc_sample$b_7)
hist(mcmc_sample$sigma_w)
hist(mcmc_sample$sigma_v)

traceplot(model, pars = c("b_1", "b_2", "sigma_w", "sigma_v"))
traceplot(model, pars = c("b_7"))
stan_trace(model, inc_warmup = TRUE, pars = c("b_4"))
rhat(model, pars = c("b_4"))

# plot estimated results
model_mu <- t(apply(
    X = mcmc_sample$alpha,
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
                 date_breaks = "6 month") +
    ylim(c(-20, 250))

# check residuals
hist(data_list$y-stan_df$fit, breaks = 100)

sqrt(sum((stan_df$fit - data_list$y) ^ 2) / data_list$n_sample) # RMSE

