// This code could be main seasonal stan code.
// This code is available with data including missing values in dependent variable y.
// But, maybe not allowed to use data including missing values in explanatory variable x.
data {
    int T; // length of features
    int D; // the number of features
    int I; // the number of missing values
    matrix[T, D] features; // explanatory variable x (independent variable)
    vector[T] y; // outcome variable y (dependent variable), with missing values indicated as NaN
}

parameters {
    // state space model params
    vector<lower=-100, upper=1000>[T] mu; // state
    real<lower=0> sigma_w; // process noise standard deviation
    real<lower=0> sigma_y; // observation noise standard deviation

    // estimation missing values in y
    vector<lower=0>[I] y_mis;

    // seasonality
    vector[T] season;
    real<lower=0> sigma_season;

    // prior distribution params
    vector[D] beta; // partial regression coefficients
    real<lower=0> tau; // parameter of prior distribution for beta
}

transformed parameters {
    // mu (state) including trend and seasonality
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
    for (d in 1:D) {
        beta[d] ~ double_exponential(0, tau);
    }

    for(t in 7:T) {
        season[t] ~ normal(-sum(season[t-6:t-1]), sigma_season);
    }

    // state equation
    mu[2:T] ~ normal(mu[1:T-1], sigma_w); // 1st trend
    // mu[3:T] ~ normal(2*mu[2:T-1]-mu[1:T-2], sigma_w); // 2nd trend

    // observation equation (for both observed and missing values)
    int miss = 0;
    for(t in 1:T) {
        if(y[t] != -1) {
            y[t] ~ normal(alpha[t], sigma_y);
        } else {
            miss = miss + 1;
            y_mis[miss] ~ normal(alpha[t], sigma_y);
        }
    }
}

generated quantities {
    vector[T] log_lik; // for WAIC calculation
    for(t in 1:T) {
        log_lik[t] = normal_lpdf(y[t] | alpha[t], sigma_y);
    }
    
    // just in case
    vector[T] pred;
    for(t in 1:T) {
        pred[t] = normal_rng(alpha[t], sigma_y);
    }
}
