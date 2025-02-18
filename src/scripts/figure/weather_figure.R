# Make simple plot for figure -------------------------------------------

## Import ---------------------------------------------------------------

### Data processing
library(dplyr)
library(reshape2)

### Visualization
library(ggfortify)
library(gridExtra)
library(patchwork)
library(ggplot2)
dim(df_hrv)
dim(df_weather)
## Read both HRV and weather data ---------------------------------------
df_hrv <- read.csv("./mcs_research/src/data/HRV/hrv.csv") # pure hrv data
df_weather <- read.csv("./mcs_research/src/data/weather/weather.csv") # raw weather data
df_weather <- df_weather[24:nrow(df_weather), ] # remove before 7/24
df_impute_weather<- read.csv("./mcs_research/src/data/weather/weather_imputed.csv") # imputed weather data
date <- as.Date(df_impute_weather$date)

df_weather$date <- date
df_impute_weather$date <- date

### Delete unnecessary columns ------------------------------------------
df_weather <- df_weather %>%
    select(-c("day_of_week", "max_gust",
              "max_wind_speed", "mean_press",
              "mean_vapor", "max_depth",
              "most_direction", "most_direction_dummy"))

df_impute_weather <- df_impute_weather %>%
    select(-c("day_of_week", "max_gust",
              "max_wind_speed", "mean_press",
              "mean_vapor", "max_depth",
              "most_direction", "most_direction_dummy"))


## Plot imputed data ----------------------------------------------------
# press: 0
# snow: 0
# temp: 0
# humidity: "2017-10-22" "2017-10-23" "2017-10-24"
# precipitation: "2019-10-15" "2020-06-02" "2020-06-03" "2020-06-04" "2020-06-05" "2022-10-02"
# sun: "2020-02-13"
# wind: "2020-03-29" "2021-01-05" "2022-02-11" "2024-02-06"

# df_impute_weather$flag <- rowSums(is.na(df_weather)) > 0

### Temperature ---------------------------------------------------------
data_1 <- data.frame(date = date,
                     value = df_impute_weather$mean_temp,
                     flag = is.na(df_weather$mean_temp),
                     stat = "Mean temperature (°C)")
data_2 <- data.frame(date = date,
                     value = df_impute_weather$max_temp,
                     flag = is.na(df_weather$max_temp),
                     stat = "Maximum temperature (°C)")
data_3 <- data.frame(date = date,
                     value = df_impute_weather$min_temp,
                     flag = is.na(df_weather$min_temp),
                     stat = "Minimum temperature (°C)")

data <- bind_rows(data_1, data_2, data_3)

ggplot(data = data, aes(x = date, y = value)) +
    geom_line() + 
    geom_point(data = subset(data, flag == TRUE), aes(color = "Imputed data")) +
    facet_wrap(~ stat, ncol = 1) +
    xlab("Date (YYYY-mm)") + ylab(element_blank()) +
    scale_x_date(date_labels = "%Y-%m",
                 date_breaks = "6 month",
                 limits = as.Date(c("2017-07-01", "2024-09-00"))) +
    # theme_minimal() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
          axis.text.y = element_text(size = 10),
          legend.position = "top",
          legend.title = element_blank(),
          legend.text = element_text(size=1),
          axis.title = element_text(size=10),
          strip.text = element_text(size=12))

### Sea-level atmospheric pressure --------------------------------------
data_4 <- data.frame(date = date,
                        value = df_impute_weather$mean_press_sea,
                        flag = is.na(df_weather$mean_press_sea),
                        stat = "Mean sea-level pressure (hPa)")
data_5 <- data.frame(date = date,
                         value = df_impute_weather$min_press_sea,
                         flag = is.na(df_weather$min_press_sea),
                         stat = "Minimum sea-level pressure (hPa)")

data <- bind_rows(data_4, data_5)

ggplot(data = data, aes(x = date, y = value)) +
    geom_line() + 
    facet_wrap(~ stat, ncol = 1) +
    xlab("Date") + ylab("hPa") +
    scale_x_date(date_labels = "%Y-%m",
                date_breaks = "6 month",
                limits = as.Date(c("2017-07-01", "2024-09-00"))) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
          # aspect.ratio = 3/10,
          legend.position = "none")

### Humidity ------------------------------------------------------------
data_6 <- data.frame(date = date,
                     value = df_impute_weather$mean_hum,
                     flag = is.na(df_weather$mean_hum),
                     stat = "Mean relative humidity (%)")
data_7 <- data.frame(date = date,
                     value = df_impute_weather$min_hum,
                     flag = is.na(df_weather$min_hum),
                     stat = "Minimum relative humidity (%)")

data <- bind_rows(data_6, data_7)

ggplot(data = data, aes(x = date, y = value)) +
    geom_line() + 
    geom_point(data = subset(data, flag == TRUE), aes(color = "Imputed data")) +
    facet_wrap(~ stat, ncol = 1) +
    xlab("Date") + ylab("%") +
    scale_x_date(date_labels = "%Y-%m",
                 date_breaks = "6 month",
                 limits = as.Date(c("2017-07-01", "2024-09-00"))) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
          legend.position = c(0.9,0.6),
          legend.title = element_blank())

### Precipitation ---------------------------------------------------------
data_8 <- data.frame(date = date,
                        value = df_impute_weather$total_preci,
                        flag = is.na(df_weather$total_preci),
                        stat = "Total precipitation (mm)")
data_9 <- data.frame(date = date,
                         value = df_impute_weather$hourly_max_preci,
                         flag = is.na(df_weather$hourly_max_preci),
                         stat = "Hourly maximum precipitation (mm)")

data <- bind_rows(data_8, data_9)

ggplot(data = data, aes(x = date, y = value)) +
    geom_line() + 
    geom_point(data = subset(data, flag == TRUE), aes(color = "Imputed data")) +
    facet_wrap(~ stat, ncol = 1) +
    xlab("Date") + ylab("mm") +
    scale_x_date(date_labels = "%Y-%m",
                 date_breaks = "6 month",
                 limits = as.Date(c("2017-07-01", "2024-09-00"))) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
          legend.position = c(0.9,0.9),
          legend.title = element_blank())

### Snow ---------------------------------------------------------
data_10 <- data.frame(date = date,
                     value = df_impute_weather$total_snowfall,
                     flag = is.na(df_weather$total_snowfall),
                     stat = "Total snowfall (cm)")

data <- bind_rows(data_10)

ggplot(data = data, aes(x = date, y = value)) +
    geom_line() + 
    geom_point(data = subset(data, flag == TRUE), aes(color = "Imputed data")) +
    facet_wrap(~ stat, ncol = 1) +
    xlab("Date") + ylab("cm") +
    scale_x_date(date_labels = "%Y-%m",
                 date_breaks = "6 month",
                 limits = as.Date(c("2017-07-01", "2024-09-00"))) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
          legend.position = c(0.9,0.9),
          legend.title = element_blank())

### Sunshine duration ---------------------------------------------------------
data_11 <- data.frame(date = date,
                      value = df_impute_weather$sun_hour,
                      flag = is.na(df_weather$sun_hour),
                      stat = "Total sunshine duration (hour)")

data <- bind_rows(data_11)

ggplot(data = data, aes(x = date, y = value)) +
    geom_line() + 
    geom_point(data = subset(data, flag == TRUE), aes(color = "Imputed data")) +
    facet_wrap(~ stat, ncol = 1) +
    xlab("Date") + ylab("cm") +
    scale_x_date(date_labels = "%Y-%m",
                 date_breaks = "6 month",
                 limits = as.Date(c("2017-07-01", "2024-09-00"))) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
          legend.position = c(0.9,0.9),
          legend.title = element_blank())

### Wind speed ---------------------------------------------------------
data_12 <- data.frame(date = date,
                      value = df_impute_weather$mean_wind_speed,
                      flag = is.na(df_weather$mean_wind_speed),
                      stat = "Mean wind speed (m/s)")

data <- bind_rows(data_12)

ggplot(data = data, aes(x = date, y = value)) +
    geom_line() + 
    geom_point(data = subset(data, flag == TRUE), aes(color = "Imputed data")) +
    facet_wrap(~ stat, ncol = 1) +
    xlab("Date") + ylab("cm") +
    scale_x_date(date_labels = "%Y-%m",
                 date_breaks = "6 month",
                 limits = as.Date(c("2017-07-01", "2024-09-00"))) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
          legend.position = c(0.9,0.9),
          legend.title = element_blank())

## all ---------------------------------------------------------


data <- bind_rows(data_1, data_2, data_3, data_4, data_5, data_6,
                  data_7, data_8, data_9, data_10, data_11, data_12)

ggplot(data = data, aes(x = date, y = value)) +
    geom_line(aes(color = "Measured data")) + 
    geom_point(data = subset(data, flag == TRUE), aes(color = "Imputed data")) +
    facet_wrap(~factor(stat, c("Mean temperature (°C)",
                               "Maximum temperature (°C)",
                               "Minimum temperature (°C)",
                               "Mean relative humidity (%)",
                               "Minimum relative humidity (%)",
                               "Mean sea-level pressure (hPa)",
                               "Minimum sea-level pressure (hPa)",
                               "Total precipitation (mm)",
                               "Hourly maximum precipitation (mm)",
                               "Total snowfall (cm)",
                               "Total sunshine duration (hour)",
                               "Mean wind speed (m/s)")), ncol = 2, scales = "free_y") +
    xlab("Date (YYYY-mm)") +
    ylab(element_blank()) +
    scale_x_date(date_labels = "%Y-%m",
                 date_breaks = "6 month",
                 limits = as.Date(c("2017-07-01", "2024-09-00"))) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
          axis.text.y = element_text(size = 7),
          legend.position = "top",
          legend.title = element_blank(),
          legend.text = element_text(size=10.5)) +
    scale_color_manual(values = c("Measured data" = "black", "Imputed data" = "red"))

ggsave("./mcs_research/src/fig/paper/weather.png", height = 6600, width = 7200, dpi = 1000, units = "px")


## acf ---------------------------------------------------------
acf_results <- apply(df_weather, 2, acf, plot=FALSE)

acf_df <- lapply(names(acf_results), function(var_name) {
    data.frame(
        lag = acf_results[[var_name]]$lag[, 1, 1],
        acf = acf_results[[var_name]]$acf[, 1, 1],
        variable = var_name
    )
}) %>% bind_rows()
ggplot(acf_df, aes(x = lag, y = acf)) +
    geom_bar(stat = "identity", width = 0.1) +
    facet_wrap(~variable, scales = "free_y", ncol=4) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    labs(title = "ACF Plots", x = "Lag", y = "ACF")

ggsave("./mcs_research/src/fig/weather/acf.png", dpi = 500, height = 3000, width = 5000, units = "px")

## scatter ---------------------------------------------------------

plot(df_hrv$ or diff_mu?)
