data {
    int T; // length of features
    int D; // the number of features
    matrix[T, D] features; // explanatory variable x (independent variable)
    vector[T] y; // outcome variable y (dependent vairable)

    int T_pred; // length of prediction day
    matrix[T_pred, D] features_pred; // features for prediction
}

parameters {
    // state space model params
    vector<lower=0, upper=10000>[T] mu; // state
    real<lower=0> sigma_w; // process noise standard deviation
    real<lower=0> sigma_y; // observation noise standard deviation

    // seasonality
    vector[T] season;
    real<lower=0> sigma_season;

    // prior distribution params
    vector[D] beta; // partial regression coefficients
    real<lower=0> tau; // parameter of prior distribition for beta
}

transformed parameters {
    // mu (state) included trend and seasonality
    vector[T] mu_with_component;
    for(t in 1:T) {
        mu_with_component[t] = mu[t] + season[t];
    }
    
    // regression model
    vector<lower=0>[T] alpha;
    for(t in 1:T) {
        alpha[t] = mu_with_component[t] + dot_product(features[t, ], beta);
    }
}

model {
    // prior distribution for each beta (coefficient)
    for(d in 1:D) {
        beta[d] ~ double_exponential(0, tau);
    }

    // https://tjo.hatenablog.com/entry/2020/04/29/152412
    // seasonality estimation (assume 7 days seasonality)
    for(t in 7:T) {	
        season[t] ~ normal(-sum(season[(t-6):(t-1)]), sigma_season);
    }

    // State equation
    // mu[2:T] ~ normal(mu[1:T-1], sigma_w);
    mu[3:T] ~ normal(2*mu[2:T-1]-mu[1:T-2], sigma_w);

    // Observation equation
    y ~ normal(alpha, sigma_y);
}

generated quantities {
    vector[T] log_lik; // for WAIC calculation
    for(t in 1:T) {
        log_lik[t] = normal_lpdf(y[t] | alpha[t], sigma_y);
    }

    // prediction part (variables named *_all include prediction period)
    // seasonality
    vector[T+T_pred] season_all;
    season_all[1:T] = season; // same values within T
    for(t in 1:T_pred) {
        season_all[T+t] = normal_rng(-sum(season_all[(T+t-7):(T+t-1)]), sigma_season);
    }

    vector[T+T_pred] mu_all;
    vector[T+T_pred] mu_with_component_all; // mu + seasonality
    vector[T+T_pred] alpha_all; // mu + seasonality and regression
    vector[T_pred] y_pred;
    mu_all[1:T] = mu; // same values within T
    mu_with_component_all[1:T] = mu_with_component; // same value within T
    alpha_all[1:T] = alpha; // same values within T
    for(t in 1:T_pred) {
        // mu_all[T+t] = normal_rng(2*mu_all[T+t-1]-mu_all[T+t-2], sigma_w); // 2nd trend term
        mu_all[T+t] = normal_rng(2*mu_all[T+t-1]-mu_all[T+t-2], sigma_w);
        mu_with_component_all[T+t] = mu_all[T+t] + season_all[T+t];

        // Calculate alpha at time T + t
        alpha_all[T+t] = mu_with_component_all[T+t] + dot_product(features_pred[t, ], beta);

        // Predict y at time T + t using the predicted alpha
        y_pred[t] = normal_rng(alpha_all[T+t], sigma_y);
    }
    
    // just in case
    vector[T] pred;
    for(t in 1:T) {
        pred[t] = normal_rng(alpha[t], sigma_y);
    }
}