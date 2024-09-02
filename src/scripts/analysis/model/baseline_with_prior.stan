data {
    int T; // length of features
    int D; // the number of features
    matrix[T, D] features; // explanatory variable x (independent variable)
    vector[T] y; // outcome variable y (dependent vairable)
}

parameters {
    vector<lower=0, upper=10000>[T] mu; // state
    real<lower=0, upper=10000> mu_zero; // initial state
    real<lower=0> sigma_w; // process noise standard deviation
    real<lower=0> sigma_v; // observation noise standard deviation

    // vector[T] trend;
    // real<lower=0> sigma_trend;

    vector[D] beta; // partial regression coefficients

    real<lower=0> tau; // parameter of prior distribition for beta
}

transformed parameters {
    vector<lower=0>[T] alpha; // for regression model
    for(t in 1:T) {
        alpha[t] = mu[t] + dot_product(features[t, ], beta);
    }
}

model {

    // prior distribution for each beta (coefficient)
    for(d in 1:D) {
        beta[d] ~ double_exponential(0, tau);
    }

    // trend estimation
    // for(t in 3:T) {
    //     trend[t] ~ normal(2*trend[t-1]-trend[t-2], sigma_trend);
    // }


    // State equation
    mu[1] ~ normal(mu_zero, sigma_w);
    for(t in 2:T) {
        mu[t] ~ normal(mu[t-1], sigma_w);
    }

    // Observation equation
    for(t in 1:T) {
        y[t] ~ normal(alpha[t], sigma_v);
    }
}

generated quantities {
    vector[T] log_lik; // for WAIC calculation
    for(t in 1:T) {
        log_lik[t] = normal_lpdf(y[t] | alpha[t], sigma_v);
    }

    vector[T] y_pred; // prediction
    for(t in 1:T) {
        y_pred[t] = normal_rng(alpha[t], sigma_v);
    }
}
