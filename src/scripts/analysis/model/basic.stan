data {
    int n_sample; // length of feature(s)
    int D; // the number of features

    vector[n_sample] mean_press;
    vector[n_sample] mean_hum;
    vector[n_sample] mean_temp;
    vector[n_sample] mean_wind_speed;
    vector[n_sample] sun_hour;
    vector[n_sample] total_preci;
    vector[n_sample] total_snowfall;   
    
    vector[n_sample] y; // outcome variable
}

// these parameters will be estimated
parameters {
    vector<lower=0, upper=10000>[n_sample] mu;
    real<lower=0, upper=10000> mu_zero;
    real<lower=0> sigma_w; // 水準成分の過程誤差の標準偏差
    real<lower=0> sigma_v; // 観測誤差の標準偏差
    
    real b_1;
    real b_2;
    real b_3;
    real b_4;
    real b_5;
    real b_6;
    real b_7;

    // vector[n_sample] trend;
    // real<lower=0> sigma_trend;

    // vector<lower=0>[D] lambda;
    // real<lower=0> tau;
}

transformed parameters {
    vector[n_sample] alpha;
    for(t in 1:n_sample) {
        alpha[t] = mu[t] +
                        b_1 * mean_press[t] +
                        b_2 * mean_hum[t] +
                        b_3 * mean_wind_speed[t] +
                        b_4 * mean_temp[t] +
                        b_5 * sun_hour[t] +
                        b_6 * total_preci[t] +
                        b_7 * total_snowfall[t];
    }
}

model {

    // lambda ~ cauchy(0, 1);
    // tau ~ cauchy(0, 1);
    // b_1 ~ normal(0, lambda[1]*tau);
    // b_2 ~ normal(0, lambda[2]*tau);
    // b_3 ~ normal(0, lambda[3]*tau);
    // b_4 ~ normal(0, lambda[4]*tau);
    // b_5 ~ normal(0, lambda[5]*tau);
    // b_6 ~ normal(0, lambda[6]*tau);
    // b_7 ~ normal(0, lambda[7]*tau);

    // for(t in 3:n_sample) {
    //     trend[t] ~ normal(2*trend[t-1]-trend[t-2], sigma_trend);
    // }

    mu[1] ~ normal(mu_zero, sigma_w);
    for(t in 2:n_sample) { // state equation
        mu[t] ~ normal(mu[t-1], sigma_w);
    }

    for(t in 1:n_sample) { // output equation
        y[t] ~ normal(alpha[t], sigma_v);
    }
}

generated quantities {
    vector[n_sample] log_lik;
    for(t in 1:n_sample) {
        log_lik[t] = normal_lpdf(y[t] | alpha[t], sigma_v);
    }

    vector[n_sample] y_pred; // prediction
    for(t in 1:n_sample) {
        y_pred[t] = normal_rng(alpha[t], sigma_v);
    }
}
