data {
    int n_sample; // length of feature(s)
    vector[n_sample] y; // outcome variable
}

// これらをMCMCを用いて求めている
parameters {
    vector[n_sample] mu;
    real mu_zero;
    real<lower=0> sigma_w; // 水準成分の過程誤差の標準偏差
    real<lower=0> sigma_v; // 観測誤差の標準偏差
}

model {
    // mu[1] ~ normal(mu_zero, sigma_w);
    mu[1] ~ cauchy(mu_zero, sigma_w);
    for(t in 2:n_sample) {
        // mu[t] ~ normal(mu[t-1], sigma_w);
        mu[t] ~ cauchy(mu[t-1], sigma_w);

    }

    for(t in 1:n_sample) {
        // y[t] ~ normal(mu[t], sigma_v);
        y[t] ~ cauchy(mu[t], sigma_v);
    }
}
