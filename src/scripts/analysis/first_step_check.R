# Feature selection by size of coefficients after model estimation ------

## Import ---------------------------------------------------------------

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
library(latex2exp)

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
num_pred <- 1 # 30 # length of prediction data
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

## Load MCMC sample data ------------------------------------------------
# change y into proper HRv param and file name in readRDS
# check include season or not
# model <- readRDS("../../model/first_step/HR.obj")
# model <- readRDS("../../model/first_step_season/VLF.obj")
# model <- readRDS("../../model/full_period/seasonal/RMSSD.obj")
model <- readRDS("../../model/full_period/simple/HR.obj")

## Check results --------------------------------------------------------
mcmc_result <- rstan::extract(model)

### WAIC ----------------------------------------------------------------
log_lik <- extract_log_lik(model)
waic(log_lik)
# loo(log_lik)

### Beta distribution (coefficients)  -----------------------------------
beta_hist <- as.data.frame(mcmc_result$beta)
colnames(beta_hist) <- colnames(df_weather)
beta_hist <- melt(beta_hist)
colnames(beta_hist) <- c("beta", "value")

label_list <- c(`mean_temp`="Mean temperature",
                `max_temp`="Maximum temperature",
                `min_temp`="Minimum temperature",
                `mean_hum`="Mean relative humidity",
                `min_hum`="Minimum relative humidity",
                `mean_press_sea`="Mean sea-level pressure",
                `min_press_sea`="Minimum sea-level pressure",
                `total_preci`="Total precipitation",
                `hourly_max_preci`="Hourly maximum precipitation",
                `total_snowfall`="Total snowfall",
                `sun_hour`="Total sunshine duration",
                `mean_wind_speed`="Mean wind speed")

label <- as_labeller(label_list)

ggplot(beta_hist, aes(x=value)) +
    geom_histogram(bins = 100) +
    facet_wrap(~beta, labeller = label) +
    # ggtitle("Sampling distribution") +
    xlab("Coefficient size") +
    ylab("Count")

# ggsave("./mcs_research/src/fig/mcmc_result/LFHF_percent.png", dpi=1000, width = 8229, height = 4447, units = "px")

#### EAP estimation
eap_result <- data.frame(colnames(df_weather),
                          apply(mcmc_result$beta, MARGIN = 2, mean)) # EAP value

colnames(eap_result) <- c("feature", "coef_mean")
eap_result[order(abs(eap_result$coef_mean), decreasing = TRUE), ]
eap_result[order(abs(eap_result$coef_mean), decreasing = TRUE)[1:6], ]

eap_result$coef_mean <- round(eap_result$coef_mean, 4)
eap_result[order(abs(eap_result$coef_mean), decreasing = TRUE), ]
eap_result[order(abs(eap_result$coef_mean), decreasing = TRUE)[1:6], ]

#### MAP estimation
get_map <- function(param_samples) {
    dens <- density(param_samples)
    map_value <- dens$x[which.max(dens$y)]
    return(map_value)
}
map_result <- data.frame(colnames(df_weather),
                        apply(mcmc_result$beta, 2, get_map))
colnames(map_result) <- c("feature", "coef_max")
map_result[order(abs(map_result$coef_max), decreasing = TRUE), ]
map_result$coef_max <- round(map_result$coef_max, 5)
map_result[order(abs(map_result$coef_max), decreasing = TRUE), ]
# map_result[order(abs(map_result$coef_max), decreasing = TRUE)[1:6], ]

#### Organize both
beta_result <- cbind(eap_result, map_result$coef_max)
colnames(beta_result) <- c("feature", "coef_mean", "coef_max")
beta_result[order(abs(beta_result$coef_mean), decreasing = TRUE)[1:6], ]

# beta_result[x,2] / sqrt(var(original_weather$)) # inverse transform

#### 50% Credible interval
ci_result <- data.frame(colnames(df_weather),
                        map_result$coef_max,
                        t(apply(mcmc_result$beta, 2, quantile, probs = c(0.25, 0.75))))
colnames(ci_result) <- c("feature", "map", "lwr", "upr")
ci_result$lwr <- round(ci_result$lwr, 4)
ci_result$upr <- round(ci_result$upr, 4)
ci_result[order(abs(map_result$coef_max), decreasing = TRUE),]
ci_result <- ci_result %>%
    mutate(feature = recode(feature, !!!label_list))
ci_result

# ci_result$map
# round(ci_result$map, )

#### check values
mean(mcmc_result$sigma_w)
mean(mcmc_result$sigma_y)
mean(mcmc_result$tau)

get_map(mcmc_result$sigma_w)
get_map(mcmc_result$sigma_y)
get_map(mcmc_result$tau)

ggplot() +
    geom_histogram(aes(x=mcmc_result$tau), bins = 100) +
    xlab("Coefficient size") +
    ylab("Count")

#### MCMC sampling check
labels <- c("Mean sea-level pressure", "Minimum sea-level pressure", "Mean relative humidity",
            "Minimum relative humidity", "Total precipitation", "Hourly maximum precipitation",
            "Total snowfall", "Total sunshine duration", "Mean temperature", "Minimum temperature",
            "Maximum temperature", "Mean wind speed")
p <- traceplot(model, pars = c("beta")) # , "sigma_w", "sigma_y"))
p + facet_wrap(~parameter, labeller = labeller(parameter = setNames(labels, paste0("beta[", 1:12, "]"))),scales = "free_y")
# this traceplot's xticks are from 3500 to 6000, which may be pointed out.

# stan_trace(model, inc_warmup = TRUE, pars = c("beta", "sigma_season"))
rhat(model, pars = c("beta", "sigma_w", "sigma_y", "tau"))
# mcmc_rhat(rhat(model, pars = "beta"))

ggplot() +
    geom_line(aes(x=1:T, y=apply(mcmc_result$season, 2, mean)))

ggplot() +
    geom_line(aes(x=1:T, y=apply(mcmc_result$mu, 2, mean)-apply(mcmc_result$mu_with_component, 2, mean)+apply(mcmc_result$season, 2, mean)))

### Plot estimated results --------------------------------------------------

#### Impute predicted values at y missing values
y_filled <- y
y_filled[y[1:T] == -1] <- apply(mcmc_result$y_mis, MARGIN = 2, mean) # impute pred of missing values

#### Make data frame of y and estimated lower/median/upper range
df_stan <- make_ci_df(data_array = mcmc_result$mu, y = y_filled, is_pred = FALSE)
imputed_loc <- ifelse((y[1:T] == -1), "imputed", "original")
diff_mu <- df_stan$y - df_stan$fit

plot_ssm(df_stan, title = "", imputed_loc = imputed_loc) +
    xlab("Date") + ylab("TINN (ms)")
p <- plot_ssm(df_stan, title = "", imputed_loc = imputed_loc) +
    xlab("Date") + ylab(TeX("Heart rate (ms)")) # + theme(plot.title = element_text(hjust = 0.5))
# p
p + ylim(c(60, NaN)) # for HR
# p + ylim(c(NaN, 110)) # for SDNN, RMSSD
# p + ylim(c(NaN, 1200)) # for LF
# p + ylim(c(NaN, 1500)) # for HF
# ggsave("./mcs_research/src/fig/analysis/HF.png", dpi=1000, width = 8229, height = 4447, units = "px")

# plotly::ggplotly(p)


### Plot prediction result --------------------------------------------------
df_stan <- make_ci_df(mcmc_result$pred, y=y_filled, is_pred = FALSE) # prediction interval before y_pred
df_pred <- make_ci_df(mcmc_result$y_pred, y_filled, is_pred = TRUE, T = T, num_pred = num_pred)
df_all <- bind_rows(df_stan, df_pred) # combine predicted data

plot_pred(df_all, data_list$T_pred, T, focus=FALSE) # plot prediction result

mean(mcmc_result$sigma_season)

### Residuals ------------------------------------------------------
resid <- y_filled - df_all$fit
# plot(resid, type = "l") # see residuals between y and estimation/prediction
acf(resid, na.action = na.pass, lag.max = 100) # autocorrelation

PP.test(resid[1:T]) # something to test stationarity

mean(resid, na.rm = TRUE) # mean of residuals, 0 would be best

# hist(data_list$y - df_stan$fit, breaks = 100)
hist(df_pred$fit - df_pred$y, breaks = 100)

# check evaluation index
# sqrt(sum((df_stan$fit - data_list$y) ^ 2) / data_list$T) # RMSE
sqrt(sum((df_pred$fit - df_pred$y) ^ 2, na.rm = TRUE) / data_list$T_pred) # RMSE

plot(df_pred$fit - df_pred$y, type="l")
acf((df_pred$fit - df_pred$y), lag.max = 30, na.action = na.pass)
