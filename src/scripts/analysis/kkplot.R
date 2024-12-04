plot_ssm <- function(df, title = "", imputed_loc) {
    ggplot(data = df, aes(x=time, y=y)) +
        geom_point(aes(color=imputed_loc), alpha=0.6, size=0.9) +
        scale_color_manual(values = c("imputed" = "red", "original" = "black")) +
        geom_line(aes(y=fit), linewidth=1.2, color="red") +
        geom_ribbon(aes(ymin=lwr, ymax=upr), alpha=0.3) +
        scale_x_date(date_labels = "%Y-%m",
                     date_breaks = "6 month",
                     limits = as.Date(c("2017-07-01", "2024-09-00"))) +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
              aspect.ratio = 3/10,
              legend.position = "none") +
        labs(title = paste(title)) # + +
        # ylim(c(NA, NA))
}

plot_pred <- function(df, len_pred, T, focus=TRUE) {
    # plot around prediction part
    if(focus) {
        ggplot(data = df, aes(x=time, y=y)) +
            geom_point(alpha=0.6, size=0.9, na.rm=TRUE) +
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
            geom_point(alpha=0.6, size=0.9, na.rm=TRUE) +
            geom_line(aes(y=fit), linewidth=1.2, color="red") +
            geom_ribbon(aes(ymin=lwr, ymax=upr), alpha=0.3) +
            geom_vline(aes(xintercept=time[T])) +
            annotate("text", x=as.Date(df$time[T]+70),y=max(y, na.rm = TRUE), label="Pred") +
            scale_x_date(date_labels = "%Y-%m",
                         date_breaks = "6 month",
                         limits = as.Date(c("2017-07-01", "2024-09-10"))) +
            theme(axis.text.x = element_text(angle = 90, vjust = 0.5),
                  aspect.ratio = 3/10,) +
            labs(title = "Estimated and predicted data")
    }

}


make_ci_df <- function(data_array, y, is_pred = FALSE, T = 0, num_pred = 30) {
    # Make data.frame including credible interval lower/median/upper
    # is_pred: This param indicates y is predction data or not.
    #          If TRUE, y is prediction data, so length should be around 30.
    # T: Length of estimation data
    # num_pred: Length of prediction data
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
            as.data.frame(res)
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
