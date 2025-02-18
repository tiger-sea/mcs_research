// This stan model is for comparing of main model and simple model without features.
data {
    int T; // length of features
    int I; // the number of missing values
    vector[T] y; // outcome variable y (dependent variable), with missing values indicated as NaN
    int T_pred; // length of prediction day
}

parameters {
    // state space model params
    vector<lower=0, upper=10000>[T] mu; // state
    real<lower=0> sigma_w; // process noise standard deviation
    real<lower=0> sigma_y; // observation noise standard deviation
    
    // estimation missing values in y
    vector<lower=0>[I] y_mis;
}

model {
    mu[3:T] ~ normal(2*mu[2:T-1]-mu[1:T-2], sigma_w);
    
    // observation equation (for both observed and missing values)
    int miss = 0;
    for(t in 1:T) {
        if(y[t] != -1) {
            y[t] ~ normal(mu[t], sigma_y);
        } else {
            miss = miss + 1;
            y_mis[miss] ~ normal(mu[t], sigma_y);
        }
    }
}

generated quantities {
    vector[T] log_lik; // for WAIC calculation
    for(t in 1:T) {
        log_lik[t] = normal_lpdf(y[t] | mu[t], sigma_y);
    }
    
    // prediction part (variables named *_all include prediction period)
    vector[T+T_pred] mu_all;
    vector[T_pred] y_pred;
    mu_all[1:T] = mu; // same values within T
    for(t in 1:T_pred) {
        mu_all[T+t] = normal_rng(2*mu_all[T+t-1]-mu_all[T+t-2], sigma_w);
        // predict y at time T + t using the predicted alpha
        y_pred[t] = normal_rng(mu_all[T+t], sigma_y);
    }
    
    // just in case
    vector[T] pred;
    for(t in 1:T) {
        pred[t] = normal_rng(mu[t], sigma_y);
    }
}
