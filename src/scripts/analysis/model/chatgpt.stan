data {
  int<lower=0> N; // データポイントの数
  int<lower=0> P; // 説明変数の数
  matrix[N, P] X; // 説明変数行列
  vector[N] y; // 目的変数（心拍数）
  int<lower=1> S; // 季節性の周期（例：365日）
}

parameters {
  vector[P] beta; // 説明変数の係数
  real alpha; // 定数項
  real<lower=0> sigma_y; // 観測誤差の標準偏差
  real<lower=0> sigma_season; // 季節成分の標準偏差
  vector[S] season; // 季節成分
  real<lower=0> sigma_state; // 状態標準偏差
}

model {
  vector[N] y_hat;
  
  // 観測モデル
  for (t in 1:N) {
    y_hat[t] = alpha + X[t] * beta + season[t % S + 1];
  }
  y ~ normal(y_hat, sigma_y);
  
  // 状態モデル
  for (s in 2:S) {
    season[s] ~ normal(season[s-1], sigma_state);
  }
  season[1] ~ normal(0, sigma_state);
  
  // 事前分布
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
  sigma_y ~ cauchy(0, 2.5);
  sigma_season ~ cauchy(0, 2.5);
  sigma_state ~ cauchy(0, 2.5);
}

generated quantities {
  vector[N] y_pred;
  for (t in 1:N) {
    y_pred[t] = normal_rng(alpha + X[t] * beta + season[t % S + 1], sigma_y);
  }
}

// basic = ["mean_press", "mean_hum", "mean_temp", "mean_wind_speed", 
//             "sun_hour", "total_preci", "total_snowfall"]
// data = {
//     "N": n_sample,
//     "P": 7,
//     "X": features_std[basic].to_numpy(),
//     "y": y,
//     "S": 365
// }