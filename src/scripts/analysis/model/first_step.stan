data {
    int T; // length of features
    int D; // the number of features
    int I; // the number of missing values
    matrix[T, D] features; // explanatory variable x (independent variable)
    vector[T] y; // outcome variable y (dependent variable), with missing values indicated as NaN

    int T_pred; // length of prediction day
    matrix[T_pred, D] features_pred; // features for prediction
}

parameters {
    // state space model params
    vector<lower=0, upper=10000>[T] mu; // state
    real<lower=0> sigma_w; // process noise standard deviation
    real<lower=0> sigma_y; // observation noise standard deviation

    // prior distribution params
    vector[D] beta; // partial regression coefficients
    real<lower=0> tau; // parameter of prior distribution for beta

    // estimation missing values in y
    vector[I] y_mis;
}

transformed parameters {
    // regression model
    vector[T] alpha;
    for (t in 1:T) {
        alpha[t] = mu[t] + dot_product(features[t, ], beta);
    }
}

model {
    // prior distribution for each beta (coefficient)
    for (d in 1:D) {
        beta[d] ~ double_exponential(0, tau);
    }

    // state equation
    mu[3:T] ~ normal(2 * mu[2:T-1] - mu[1:T-2], sigma_w);

    // observation equation (for both observed and imputed values)
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
