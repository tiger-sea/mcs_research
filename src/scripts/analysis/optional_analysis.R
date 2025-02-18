# Feature selection by size of coefficients after model estimation ------
## consider long-term trend
## y - long-term trend, analysis of the residuals

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
# model <- readRDS("../../model/full_period/seasonal/LFHF_percent.obj")
model <- readRDS("../../model/full_period/simple/HR.obj")

## Check results --------------------------------------------------------
mcmc_result <- rstan::extract(model)


### Plot estimated results --------------------------------------------------

#### Impute predicted values at y missing values
y_filled <- y
y_filled[y[1:T] == -1] <- apply(mcmc_result$y_mis, MARGIN = 2, mean) # impute pred of missing values

#### Make data frame of y and estimated lower/median/upper range
df_stan <- make_ci_df(data_array = mcmc_result$mu, y = y_filled, is_pred = FALSE)
imputed_loc <- ifelse((y[1:T] == -1), "imputed", "original")
diff_mu <- df_stan$y - df_stan$fit

p <- plot_ssm(df_stan, title = "", imputed_loc = imputed_loc) +
    xlab("Date") + ylab(TeX("Heart rate (bpm)")) # + theme(plot.title = element_text(hjust = 0.5))
p
# p + ylim(c(60, NaN)) # for HR
# p + ylim(c(NaN, 110)) # for SDNN, RMSSD
# p + ylim(c(NaN, 1200)) # for LF
# p + ylim(c(NaN, 1500)) # for HF
# ggsave("./mcs_research/src/fig/analysis/mu/LFHF_percent.png", dpi=1000, width = 8000, height = 3200, units = "px")
# ggsave("./mcs_research/src/fig/analysis/pred/HR.png", dpi=1000, width = 8000, height = 3200, units = "px")

# plotly::ggplotly(p)

#### Plot y - mu
ggplot(df_stan, aes(x=time)) +
    geom_line(aes(y=diff_mu)) + ylab("y - trend") + xlab("Date") +
    scale_x_date(date_labels = "%Y-%m",
                 date_breaks = "6 month") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
          aspect.ratio = 3/10,)
# ggsave("./mcs_research/src/fig/analysis/option/LFHF_percent/diff_mu.png", dpi=1000, width = 8000, height = 3200, units = "px")

acf(diff_mu, lag.max = 30)
pacf(diff_mu, lag.max = 30)


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
