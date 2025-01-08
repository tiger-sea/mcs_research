\chapter{Results}

In this chapter, we present the estimated coefficients for each HRV parameter. Results are organized by parameter to highlight. Each section provides a detailed analysis of the effects of meteorological factors on HRV parameters based on the estimated coefficients. Besides, the improvement rate in RMSE between the primary model and the simplified model is reported to validate the estimated model and its parameters. Tables in each section include MAP estimation values and 50\% credible intervals of estimated distribution.


\section{Heart Rate}
The estimation results for HRV parameter "heart rate" are summarized in Table \ref{table:HR}. The MAP estimation values for heart rate in various meteorological factors suggest notable influences of mean temperature, maximum temperature, minimum relative humidity, total precipitation, and mean wind speed. For instance, the credible intervals of those factors indicate consistent positive/negative impacts, with higher estimation values than the others. These findings would suggest that fluctuations in heart rate may be especially sensitive to changes in those factors. Additionally, the RMSE for the primary model was 6.01 bpm, while for the simplified model it was 7.65 bpm, resulting in an improvement rate of 21.4\%. This indicates that the inclusion of meteorological factors significantly improved the model's predictive accuracy, further supporting the notion that heart rate is influenced by changes in weather conditions.

\begin{table}[htbp]
    \centering
    \caption{MAP of estimated coefficients distribution for heart rate}
    \begin{tabular}{l c}
        \hline
        \textbf{Meteorological factor} & \textbf{MAP (50\% CI)} \\
        \hline
        Mean temperature & 1.3433 (0.7591, 2.3247) \\
        Maximum temperature & 1.5229 (0.8492, 2.0623) \\
        Minimum temperature & 0.0247 (-0.2712, 0.2773) \\
        Mean relative humidity & 0.0083 (-0.0804, 0.2348) \\
        Minimum relative humidity & 0.1110 (0.0256, 0.3884) \\
        Mean sea-level atmospheric pressure & -0.0281 (-0.2252, 0.1198) \\
        Minimum sea-level atmospheric pressure & -0.0663 (-0.3290, 0.0102) \\
        Total precipitation & -0.2301 (-0.3322, -0.0690) \\
        Hourly maximum precipitation & -0.0010 (-0.0899, 0.1317) \\
        Total snowfall & 0.0025 (-0.0861, 0.0956) \\
        Total sunshine duration & 0.0427 (-0.0317, 0.2210) \\
        Mean wind speed & -0.4270 (-0.5290, -0.3247) \\
        \hline
    \end{tabular}
    \label{table:HR}
    % > mean(mcmc_result$sigma_w)
    % [1] 0.07395926
    % > mean(mcmc_result$sigma_y)
    % [1] 5.553616
    % > mean(mcmc_result$tau)
    % [1] 0.5509395
\end{table}


\section{SDNN}
For HRV parameter SDNN, we detail the estimated coefficients and their implications here. As shown in Table \ref{table:SDNN}, the MAP estimation values and its credible intervals for SDNN provide insights into the quantitative effects of meteorological factors. For example, factors such as mean, maximum, minimum temperature, mean, minimum relative humidity, total snowfall, and mean wind speed showed consistent positive/negative credible intervals. Particularly, mean temperature and mean relative humidity could have stronger effects in SDNN compared to the other factors. Furthermore, the RMSE for primary model and simplified model were 16.14 ms and 18.24 ms respectively, resulting in an improvement rate of 11.5\%. This improvement would suggest that meteorological factors were related to the fluctuation in SDNN, although the degree of improvement was not drastically.

\begin{table}[htbp]
    \centering
    \caption{MAP of estimated coefficients distribution for SDNN}
    \begin{tabular}{l c}
        \hline
        \textbf{Meteorological factor} & \textbf{MAP (50\% CI)} \\
        \hline
        Mean temperature & -2.2893 (-3.4115, -1.1023) \\
        Minimum temperature & -0.3573 (-1.4098, -0.0772) \\
        Maximum temperature & -0.2095 (-1.7819, -0.2078) \\
        Mean relative humidity & 0.6991 (0.4753, 1.2762) \\
        Minimum relative humidity & -0.1914 (-0.9066, -0.1360) \\
        Mean sea-level atmospheric pressure & 0.1232 (-0.0090, 0.6275) \\
        Minimum sea-level atmospheric pressure & 0.0191 (-0.3291, 0.2365) \\
        Total precipitation & 0.0876 (-0.0323, 0.4400) \\
        Hourly maximum precipitation & -0.0453 (-0.3265, 0.0922) \\
        Total snowfall & -0.3084 (-0.5110, -0.1341) \\
        Total sunshine duration & 0.0198 (-0.1969, 0.2245) \\
        Mean wind speed & 0.5629 (0.3540, 0.7542) \\
        \hline
    \end{tabular}
    \label{table:SDNN}
    % > mean(mcmc_result$sigma_w)
    % [1] 0.02043965
    % > mean(mcmc_result$sigma_y)
    % [1] 11.03271
    % > mean(mcmc_result$tau)
    % [1] 0.8796063
\end{table}


\section{RMSSD}
The outcomes of HRV parameter RMSSD estimations provide insights into the effects of meteorological changes. Table \ref{table:RMSSD} shows the MAP estimation values and credible intervals for RMSSD, and the MAP estimation values were generally small in all meteorological factors, with all credible intervals spanning zero, indicating a lack of enough evidence for clear associations. To some extent, mean temperature, minimum sea-level atmospheric pressure, and total precipitation were estimated relatively larger compared to the others. Moreover, the RMSE was 14.56 ms for primary model and 15.45 ms for simplified model, resulting in an improvement rate of 5.7\%. This outcome may indicate that RMSSD was slightly associated with meteorological factors, although the estimated parameters lacked confidence.

\begin{table}[htbp]
    \centering
    \caption{MAP of estimated coefficients distribution for RMSSD}
    \begin{tabular}{l c}
        \hline
        \textbf{Meteorological factor} & \textbf{MAP (50\% CI)} \\
        \hline
        Mean temperature & 0.0037 (-0.0394, 0.0757) \\
        Minimum temperature & 0.0011 (-0.0265, 0.1042) \\
        Maximum temperature & 0.0002 (-0.0367, 0.0808) \\
        Mean relative humidity & -0.0011 (-0.0487, 0.0547) \\
        Minimum relative humidity & 0.0004 (-0.0778, 0.0332) \\
        Mean sea-level atmospheric pressure & -0.0003 (-0.0534, 0.0483) \\
        Minimum sea-level atmospheric pressure & -0.0025 (-0.0857, 0.0295) \\
        Total precipitation & 0.0047 (-0.0084, 0.1340) \\
        Hourly maximum precipitation & 0.0014 (-0.0098, 0.1259) \\
        Total snowfall & -0.0005 (-0.0943, 0.0239) \\
        Total sunshine duration & -0.0004 (-0.0590, 0.0476) \\
        Mean wind speed & -0.0004 (-0.0403, 0.0642) \\
        \hline
    \end{tabular}
    \label{table:RMSSD}
\end{table}


\section{pNN50}
For pNN50, the MAP estimation values were consistently very low, and the credible intervals included zero for all meteorological factors as shown in Table \ref{table:pNN50}. These results imply that any association between pNN50 and meteorological factors is close to zero or remains uncertain for some reason. However, it might be argued that total precipitation have relatively stronger influence on pNN50, as it had the largest MAP estimation value among the factors. Furthermore, the RMSE for the primary model was 3.09\%, while for the simplified model it was 3.11\%, resulting in an improvement rate of 0.6\%. Given these results, it may be difficult to assert that reliable estimates were obtained for pNN50.

\begin{table}[htbp]
    \centering
    \caption{MAP of estimated coefficients distribution for pNN50}
    \begin{tabular}{l c}
        \hline
        \textbf{Meteorological factor} & \textbf{MAP (50\% CI)} \\
        \hline
        Mean temperature & 0.00049 (-0.0060, 0.0164) \\
        Minimum temperature & 0.00042 (-0.0051, 0.0153) \\
        Maximum temperature & 0.00010 (-0.0079, 0.0137) \\
        Mean relative humidity & 0.00014 (-0.0061, 0.0136) \\
        Minimum relative humidity & 0.00001 (-0.0221, 0.0035) \\
        Mean sea-level atmospheric pressure & -0.00007 (-0.0091, 0.0114) \\
        Minimum sea-level atmospheric pressure & 0.00009 (-0.0164, 0.0047) \\
        Total precipitation & 0.00075 (-0.0003, 0.0347) \\
        Hourly maximum precipitation & 0.00022 (-0.0067, 0.0122) \\
        Total snowfall & -0.00022 (-0.0105, 0.0065) \\
        Total sunshine duration & 0.00008 (-0.0147, 0.0063) \\
        Mean wind speed & 0.00028 (-0.0123, 0.0052) \\
        \hline
    \end{tabular}
    \label{table:pNN50}
    % > mean(mcmc_result$sigma_w)
    % [1] 0.002956826
    % > mean(mcmc_result$sigma_y)
    % [1] 2.195766
    % > mean(mcmc_result$tau)
    % [1] 0.0234494
    %  beta[1]  beta[2]  beta[3]  beta[4]  beta[5]  beta[6]  beta[7]  beta[8]  beta[9] beta[10] beta[11] 
    % 1.090496 1.040277 1.091333 1.093820 1.043003 1.012307 1.044960 1.042073 1.129676 1.030331 1.045866 
    % beta[12]  sigma_w  sigma_y      tau 
    % 1.020509 1.232442 1.004775 1.141935
\end{table}


\section{TINN}
Table \ref{table:TINN} presents the MAP estimation values and credible intervals for TINN. Similar to RMSSD and pNN50, the MAP estimation values were small, and the credible intervals included zero for all meteorological factors. Whereas, some meteorological factors had relatively larger MAP values and credible intervals with biased range, such as mean, maximum temperature, minimum relative humidity, and minimum sea-level atmospheric pressure. These findings for specific factors may suggest potential associations with TINN, though the credible intervals still spanning zero indicate uncertain results. Additionally, the RMSE were 78.61 ms for primary model and 84.13 ms for simplified model, showing a 6.5\% improvement. While the estimated results provide lack evidence, this slight improvement might suggest some degree of association between TINN and meteorological factors.

\begin{table}[htbp]
    \centering
    \caption{MAP of estimated coefficients distribution for TINN}
    \begin{tabular}{l c}
        \hline
        \textbf{Meteorological factor} & \textbf{MAP (50\% CI)} \\
        \hline
        Mean temperature & -0.0317 (-1.8174, 0.0108) \\
        Minimum temperature & -0.0160 (-1.2393, 0.0739) \\
        Maximum temperature & -0.0567 (-1.6995, 0.0061) \\
        Mean relative humidity & 0.0062 (-0.2241, 0.6734) \\
        Minimum relative humidity & 0.0207 (-0.0427, 1.1243) \\
        Mean sea-level atmospheric pressure & 0.0031 (-0.2207, 0.7075) \\
        Minimum sea-level atmospheric pressure & 0.0244 (-0.0281, 1.0944) \\
        Total precipitation & 0.0090 (-0.1583, 0.6857) \\
        Hourly maximum precipitation & 0.0131 (-0.1619, 0.6554) \\
        Total snowfall & -0.0092 (-0.8098, 0.1381) \\
        Total sunshine duration & -0.0062 (-0.5683, 0.2083) \\
        Mean wind speed & 0.0009 (-0.2482, 0.4976) \\
        \hline
    \end{tabular}
    \label{table:TINN}
\end{table}

\section{VLF}
For HRV parameter VLF, we describe the estimated coefficients and their relationship in this section. Table \ref{table:VLF} provides the MAP estimation values and credible intervals for VLF, including possibly effective factors with higher MAP estimation values. The credible intervals for VLF in several meteorological factors had constant positive/negative impacts including mean, maximum, minimum temperature, mean relative humidity, mean sea-level atmospheric pressure, hourly maximum precipitation, and mean wind speed. Based on the results, those meteorological factors can be considered to have had relatively larger impacts on VLF. Besides, the RMSE for primary model and simplified model were 458.77 $ms^2$, 446.74 $ms^2$ respectively, resulting in an improvement rate of 2.6\%. This result may indicate that VLF was associated with meteorological factors, although the degree of improvement was not large.

\begin{table}[htbp]
    \centering
    \caption{MAP of estimated coefficients distribution for VLF}
    \begin{tabular}{l c}
        \hline
        \textbf{Meteorological factor} & \textbf{MAP (50\% CI)} \\
        \hline
        Mean temperature & -3.19877 (-41.3828, -3.0369) \\
        Minimum temperature & -2.02846 (-18.9517, -1.3188) \\
        Maximum temperature & -1.78833 (-17.6527, -0.7156) \\
        Mean relative humidity & 3.40616 (1.6849, 11.4811) \\
        Minimum relative humidity & -0.05980 (-6.4729, 3.3482) \\
        Mean sea-level atmospheric pressure & 2.86103 (2.4916, 19.4262) \\
        Minimum sea-level atmospheric pressure & 0.18124 (-7.0335, 3.2416) \\
        Total precipitation & 0.39241 (-2.1729, 5.9141) \\
        Hourly maximum precipitation & 2.60146 (0.9209, 11.0100) \\
        Total snowfall & 1.03373 (-0.5560, 6.7514) \\
        Total sunshine duration & -0.54539 (-8.9971, 0.8158) \\
        Mean wind speed & 0.89891 (0.5911, 8.5995) \\
        \hline
    \end{tabular}
    \label{table:VLF}
    % > mean(mcmc_result$sigma_w)
    % [1] 0.3306483
    % > mean(mcmc_result$sigma_y)
    % [1] 282.542
    % > mean(mcmc_result$tau)
    % [1] 12.17782
\end{table}


\section{LF}
In this section, the estimated values for HRV parameter LF are shown. The MAP estimation values and credible intervals are summarized in Table \ref{table:LF} for LF. The MAP estimation values were small in general, additionally, the credible intervals were spanning wide range and including zero. However, the credible interval of only total precipitation was constantly estimated as positive, which could suggest that it had a positive effect on LF. Moreover, the RMSE were 439.2 $ms^2$ for primary model and 441.62 $ms^2$ for simplified model, showing 0.5\% improvement. Similar to pNN50, it may be difficult to argue that reliable estimates were obtained for LF.

\begin{table}[htbp]
    \centering
    \caption{MAP of estimated coefficients distribution for LF}
    \begin{tabular}{l c}
        \hline
        \textbf{Meteorological factor} & \textbf{MAP (50\% CI)} \\
        \hline
        Mean temperature & -0.0147 (-4.8709, 0.0900) \\
        Minimum temperature & -0.0023 (-2.0605, 0.1997) \\
        Maximum temperature & -0.0363 (-0.8752, 0.7408) \\
        Mean relative humidity & 0.0084 (-0.3693, 1.1165) \\
        Minimum relative humidity & -0.0148 (-1.1588, 0.2999) \\
        Mean sea-level atmospheric pressure & 0.0780 (-0.0142, 3.1469) \\
        Minimum sea-level atmospheric pressure & 0.0207 (-1.3165, 0.2792) \\
        Total precipitation & 0.0938 (0.0770, 3.4360) \\
        Hourly maximum precipitation & 0.0177 (-0.4172, 0.9148) \\
        Total snowfall & -0.0048 (-1.0847, 0.2458) \\
        Total sunshine duration & -0.0774 (-2.3933, 0.0046) \\
        Mean wind speed & 0.0206 (-0.1305, 1.3662) \\
        \hline
    \end{tabular}
    \label{table:LF}
    % > mean(mcmc_result$sigma_w)
    % [1] 0.1929948
    % > mean(mcmc_result$sigma_y)
    % [1] 96.42358
    % > mean(mcmc_result$tau)
    % [1] 2.558782
    %  beta[1]  beta[2]  beta[3]  beta[4]  beta[5]  beta[6]  beta[7]  beta[8]  beta[9] beta[10] beta[11] 
    % 1.442061 1.209549 1.059287 1.088452 1.204257 1.037402 1.077068 1.262187 1.574126 1.072342 1.076362 
    % beta[12]  sigma_w  sigma_y      tau 
    % 1.076082 1.805033 1.093000 1.577420 
\end{table}


\section{HF}
Table \ref{table:HF} outlines the MAP estimation values and credible intervals for HF. Similar to LF, the MAP estimation values were generally low with credible intervals including zero, and the credible interval of only total precipitation was constantly positive. The consistency of meteorological factors with significant impacts might be reasonable, as LF and HF belong to the same frequency domain of HRV parameters. In terms of RMSE, it was 258.98 $ms^2$ for primary model and 262.33 $ms^2$ for simplified model, resulting in an improvement rate of 1.3\%. This result might suggest that LF was related to meteorological factors, although the improvement rate was not drastically.

\begin{table}[htbp]
    \centering
    \caption{MAP of estimated coefficients distribution for HF}
    \begin{tabular}{l c}
        \hline
        \textbf{Meteorological factor} & \textbf{MAP (50\% CI)} \\
        \hline
        Mean temperature & 0.0136 (-1.2754, 0.8652) \\
        Minimum temperature & -0.0040 (-0.8072, 1.3170) \\
        Maximum temperature & 0.0283 (-0.7777, 1.2450) \\
        Mean relative humidity & 0.0235 (-0.1006, 2.4250) \\
        Minimum relative humidity & 0.0373 (-0.5740, 1.4737) \\
        Mean sea-level atmospheric pressure & 0.0059 (-0.2580, 1.9597) \\
        Minimum sea-level atmospheric pressure & -0.0198 (-0.8515, 0.9038) \\
        Total precipitation & 0.0878 (0.0670, 3.9918) \\
        Hourly maximum precipitation & -0.0050 (-0.4923, 1.4054) \\
        Total snowfall & -0.0030 (-1.2025, 0.5656) \\
        Total sunshine duration & -0.0282 (-1.8295, 0.2735) \\
        Mean wind speed & 0.0047 (-0.9862, 0.5763) \\
        \hline
    \end{tabular}
    \label{table:HF}
    % > mean(mcmc_result$sigma_w)
    % [1] 0.254838
    % > mean(mcmc_result$sigma_y)
    % [1] 159.7364
    % > mean(mcmc_result$tau)
    % [1] 2.179371
    % beta[1]  beta[2]  beta[3]  beta[4]  beta[5]  beta[6]  beta[7]  beta[8]  beta[9] beta[10] beta[11] 
    % 1.069977 1.008001 1.101356 1.025642 1.018909 1.019626 1.015474 1.025367 1.059469 1.124901 1.091818 
    % beta[12]  sigma_w  sigma_y      tau 
    % 1.004964 1.302461 1.008268 1.111015 
\end{table}


\newpage % maybe
\section{LF/HF}
For HRV parameter LF/HF, the MAP estimation values and credible intervals are shown in Table \ref{table:LFHF}. The MAP estimation values were derived as very low values in all meteorological factors, with the credible intervals including zero, implicitly expressing a insufficient evidence for distinct link between them. Focusing on the credible intervals, some meteorological factors had relatively larger values, such as various temperature measures and mean relative humidity, although the results remain still uncertain. Furthermore, the RMSE for the primary model and simplified model were 130.71\% and 132.74\% respectively, resulting in an improvement rate of 1.5\%. Similar to HF, this result might suggest that LF/HF was associated with meteorological factors, although the improvement rate was not large.

\begin{table}[htbp]
    \centering
    \caption{MAP of estimated coefficients distribution for LF/HF}
    \begin{tabular}{l c}
        \hline
        \textbf{Meteorological factor} & \textbf{MAP (50\% CI)} \\
        \hline
        Mean temperature & -0.0335 (-1.6065, 0.1106) \\
        Minimum temperature & -0.0445 (-2.4983, 0.0355) \\
        Maximum temperature & -0.0598 (-1.6215, 0.0532) \\
        Mean relative humidity & -0.0183 (-1.4413, 0.0953) \\
        Minimum relative humidity & -0.0100 (-0.2573, 0.7489) \\
        Mean sea-level atmospheric pressure &  0.0051 (-0.9012, 0.1911) \\
        Minimum sea-level atmospheric pressure &  0.0112 (-0.8861, 0.2494) \\
        Total precipitation & -0.0147 (-1.0588, 0.1044) \\
        Hourly maximum precipitation & -0.0120 (-0.6232, 0.2451) \\
        Total snowfall & -0.0090 (-0.9979, 0.1895) \\
        Total sunshine duration & -0.0062 (-0.9182, 0.2065) \\
        Mean wind speed & 0.0009 (-0.1115, 0.9800) \\
        \hline
    \end{tabular}
    \label{table:LFHF}
    % > mean(mcmc_result$sigma_w)
    % [1] 0.09058886
    % > mean(mcmc_result$sigma_y)
    % [1] 85.70232
    % > mean(mcmc_result$tau)
    % [1] 1.54139
    %  beta[1]  beta[2]  beta[3]  beta[4]  beta[5]  beta[6]  beta[7]  beta[8]  beta[9] beta[10] beta[11] 
    % 1.106510 1.040639 1.386245 1.033231 1.159276 1.101166 1.337336 1.172227 1.253324 1.597170 1.329101 
    % beta[12]  sigma_w  sigma_y      tau 
    % 1.043007 1.954085 1.055189 1.866230 
\end{table}

