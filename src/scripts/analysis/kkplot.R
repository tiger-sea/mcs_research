plot_ssm <- function(df) {
    ggplot(data = df, aes(x=time, y=y)) +
        geom_point(alpha=0.6, size=0.9) +
        geom_line(aes(y=fit), linewidth=1.2, color="red") +
        geom_ribbon(aes(ymin=lwr, ymax=upr), alpha=0.3) +
        scale_x_date(date_labels = "%Y-%m",
                     date_breaks = "6 month",) +
        theme(axis.text.x = element_text(angle = 90),
              aspect.ratio = 3/10,)
}

plot_pred <- function(df, len_pred, T, focus=TRUE) {
    # plot around prediction part
    if(focus) {
        ggplot(data = df, aes(x=time, y=y)) +
            geom_point(alpha=0.6, size=0.9) +
            geom_line(aes(y=fit), linewidth=1.2, color="red") +
            geom_ribbon(aes(ymin=lwr, ymax=upr), alpha=0.3) +
            geom_vline(aes(xintercept=time[T])) +
            scale_x_date(date_labels = "%Y-%m-%d",
                         date_breaks = "7 day",
                         limits = c(df$time[(T-60)], df_all$time[(T+len_pred)])) +
            theme(axis.text.x = element_text(angle = 45, hjust = 1),
                  aspect.ratio = 3/10,) +
            labs(title = paste(len_pred, " days prediction"))
    } else {
        ggplot(data = df, aes(x=time, y=y)) +
            geom_point(alpha=0.6, size=0.9) +
            geom_line(aes(y=fit), linewidth=1.2, color="red") +
            geom_ribbon(aes(ymin=lwr, ymax=upr), alpha=0.3) +
            geom_vline(aes(xintercept=time[T])) +
            annotate("text", x=as.Date(df$time[T-100]),y=max(y), label="Train") +
            scale_x_date(date_labels = "%Y-%m",
                         date_breaks = "6 month",) +
            theme(axis.text.x = element_text(angle = 90),
                  aspect.ratio = 3/10,)
    }

}

make_ci_df <- function(data_array, is_pred = FALSE) {
    # make data.frame including credible interval lower/median/upper
    res <- t(apply(
        X = data_array, # not for *_all, for mu, alpha, y_pred
        MARGIN = 2,
        FUN = quantile,
        probs = c(0.025, 0.5, 0.975)
    ))
    
    colnames(res) <- c("lwr", "fit", "upr")
    if(is_pred) {
        df <- cbind(
            data.frame(y = y[(T+1):(T+num_pred)], time=date[(T+1):(T+num_pred)]),
            as.data.frame(res_pred)
        )
    } else {
        df <- cbind(
            data.frame(y = y[1:nrow(res)], time=date[1:nrow(res)]),
            as.data.frame(res)
        )
    }
    invisible(df)
}

calc_coef <- function(b, x, y) {
    # unused
    # calculate coefficient from standardized coefficient
    # https://avilen.co.jp/personal/knowledge-article/multiple-regression-analysis/
    return (b * sqrt(var(y)) / sqrt(var(x, na.rm = T)))
}
