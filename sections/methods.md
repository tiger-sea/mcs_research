\chapter{Methods}

\section{Data Collection}

\subsection{ECG Data}
% good but not checked
% need to change figure properly, figure caption???
The ECG data utilized in this study was collected in a bathtub environment for special experiment of ECG measurement in the University of Aizu [my paper]. The purpose of this setup was to integrate the experiment into regular daily activities without interfering with them. Daily data collection started from July 2017 to July 2024, covering approximately 7 years in total, though with some missing days. The subject was a healthy adult man whose height is 172 cm, and body weight ranged between 60 and 64 kg, which depends on seasonal condition. In the bathtub environment, bathing condition was typically kept nearly identical conditions, specifically, amount of bath water was about 180 liters, and the temperature was set between 37 and 40 degrees Celsius depending on the season or health condition [my paper].

For ECG measurement, a self made equipment of biosignal measurement unit was adopted to record ECG data by Lead-I\hspace{-1.2pt}I by sampling rate of 500 Hz while the subject was taking a bath. There were three electrodes on the bathtub wall, one was located on the bathtub wall close to subject's left leg, and the others were placed on it close to subject's right arm and leg respectively as shown in Figure \ref{fig:bath env}. As mentioned earlier in this section, this measurement method aimed to minimally interferes with normal daily life.

\begin{figure}[htbp]
    \centering
    \includegraphics[scale=0.5]{./Figure/computer_keyboard_hand_itai.png}
    \caption{Experiment environment for ECG measurement in bathtub}
    \label{fig:bath env}
\end{figure}

\subsection{Meteorological Factors}
% good but not checked
% insert figure of weather data? -> weather figure is at imputation part
Daily meteorological data corresponding to the ECG data were gathered from the Japan Meteorological Agency's database [database]. The location of monitoring point by the Japan Meteorological Agency was Aizu-Wakamatsu city, Fukushima, Japan [address pdf]. Aizu-Wakamatsu city is surrounded by mountain, and that yields many heavy snowy and cold days in winter, which similar to Japan Sea area. Besides, a large number of high temperauture and humid days happen in summer, lasting high temperature until late night because of the location. In spring and autumn, a difference of temperature between daytime and nighttime is relatively considerable caused by inland climate feature [pdf and pdf].

In this study, 12 meteorological factors were collected, and which include maximum, minimum, or mean representative values for each meteorological factor as shown below Table \ref{table:weather factors}. According to the statistical guideline of the Japan Meteorological Agency's database, calculation protocols for the representative values are defined as follows [pdf]. The daily mean values of temperature, relative humidity, and sea-level atmospheric pressure are recorded every hour on the hour. Similarly, total precipitation, total snowfall, and sunshine duration values are collected following the same protocol. In addition to that, the daily maximum or minimum representative values of temperature, relative humidity, sea-level atmospheric pressure, and hourly precipitation are gathered every 10 minutes, as well as the mean wind speed.

\begin{table}[htbp]
    \centering
    \caption{Collected daily 12 meteorological factors' types}
    \label{table:weather factors}
    \begin{tabular}{l l}
        \hline
        \textbf{Factor} & \textbf{Statistics} \\
        \hline
        Temperature ($ ^\circ C $) & Mean \\
                                   & Maximum \\
                                   & Minimum \\
        Relative humidity (\%) & Mean \\
                               & Minimum\\
        Sea-level atmospheric pressure (hPa) & Mean \\
                                             & Minimum \\
        Precipitation (mm) & Total \\
                           & Hourly maximum \\
        Snowfall (cm) & Total \\
        Sunshine duration (hour) & Total \\
        Wind speed (m/s) & Mean \\
        \hline
    \end{tabular}
\end{table}


\section{Pre-processing}

\subsection{HRV Calculation}
% good but not checked
% need to resize the figures
% what do i do about specification of the library for HRV calculation was defined part???
HRV parameters derived from ECG data were calculated using software MATLAB R2023a and a library HRV tool [hrv tool github]. The adopted HRV parameters in this study are presented in Table \ref{table:hrv time} and Table \ref{table:hrv freq}, separating into time domain parameters and frequency domain parameters [an overview]. Before calculating HRV parameters, the ECG data were handled to convert raw ECG data into R-R interval data for HRV tool. Firstly, first one minute of the ECG data and last one minute of the ECG data were eliminated, because those parts had much noise due to movement for getting in and out. Secondly, the ECG data were filtered to suppress noise, such as hum noise and myoelectricity. Finally, R-R interval sequences were calculated after detecting each R peak and computing difference following formula \ref{formula:rri}. An example of the HRV calculation flow and R-R interval sequence results are shown in Figure \ref{fig:ecg} and Figure \ref{fig:rri}.
%Specification of the library for HRV calculation was defined ... like resampling rate, fft or ar? something like that

\begin{table}[htbp]
    \centering
    \caption{Calculated HRV parameters in time domain}
    \label{table:hrv time}
    \begin{tabular}{l c l}
        \hline
        \textbf{Parameter} & \textbf{Unit} & \textbf{Note} \\ \hline
        Heart rate & beat/min & The number of heart beats in a minute \\
        SDNN       & ms & Standard deviation of NN intervals \\
        RMSSD      & ms & Root mean square of successive RR interval differences \\
        pNN50      & \%  & Ratio of successive RR intervals that differ by more than 50 ms \\
        TINN       & ms & Baseline width of the RR interval histogram \\
        \hline
    \end{tabular}
\end{table}

\begin{table}[htbp]
    \centering
    \caption{Calculated HRV parameters in frequency domain}
    \label{table:hrv freq}
    \begin{tabular}{l c l}
        \hline
        \textbf{Parameter} & \textbf{Unit} & \textbf{Note} \\ \hline
        VLF   & ms$^2$ & Absolute power of the very-low-frequency band (0.0033 - 0.04 Hz) \\
        LF    & ms$^2$ & Absolute power of the low-frequency band (0.04 - 0.15 Hz) \\
        HF    & ms$^2$ & Absolute power of the high-frequency band (0.15 - 0.4 Hz) \\
        LF/HF & \%     & Ratio of LF and HF \\
        \hline
    \end{tabular}
\end{table}

\begin{equation}
    \label{formula:rri}
    RR_i = (R\ peak)_{i+1} - (R\ peak)_i
\end{equation}

\begin{figure}
    \centering
    \includegraphics[scale=1]{./Figure/figure/ecg_preprocess.png}
    \caption{Flow of R peaks detection for R-R interval calculation}
    \label{fig:ecg}
\end{figure}

\begin{figure}
    \centering
    \includegraphics[scale=1]{./Figure/figure/rri.png}
    \caption{An example of R-R interval sequence}
    \label{fig:rri}
\end{figure}

Many of HRV parameters have practical meaning to diagnose diseases and monitor health condition change [an overview]. For example, RMSSD, one of time domain HRV parameters, can be considered as an indicator of parasympathetic nervous system's fluctuation. LF/HF, one of frequency domain HRV parameters, could be interpreted as balance between sympathetic and parasympathetic nervous systems. Furthermore, SDNN is applied to predict mortality in medical situation, classifying the value of SDNN based on its size [an overview]. In those manner, HRV parameters are utilized in various ways to evaluate our health condition by using ECG data or any other biosignal.


\subsection{Imputation of Missing Values in Meteorological Factors}
% good but not checked
% need to change figure properly
The meteorological data contained several missing values because of replacement or malfunction of the measurement equipment [url]. In total, there were 14 days which included missing values in some meteorological factors data as shown in Table \ref{table:missing}.

\begin{table}[htbp]
    \centering
    \renewcommand{\arraystretch}{1.2}
    \caption{List of dates included missing values in meteorological data}
    \label{table:missing}
    \begin{tabular}{l l}
        \hline
        \textbf{Factor} & \textbf{Missing dates (YYYY-MM-DD)} \\
        \hline
        Temperature & No missing dates \\
        Relative humidity & 2017-10-22, 2017-10-23, 2017-10-24 \\
        Sea-level atmospheric pressure & No missing dates \\
        Precipitation & 2019-10-15, 2020-06-02, 2020-06-03, \\
                      & 2020-06-04, 2020-06-05, 2022-10-02 \\
        Snowfall & No missing dates \\
        Sunshine duration & 2020-02-13 \\
        Wind speed & 2020-03-29, 2021-01-05, 2022-02-11, 2024-02-06 \\
        \hline
    \end{tabular}
    \renewcommand{\arraystretch}{1.0} % I don't know why, but blank line is necessary below
    
    *Mean, maximum, or minimum for each meteorological factor had same missing dates
\end{table}

Missing values in explanatory variable were not acceptable to the model used in this study. Therefore, the missing values were processed before the meteorological data were utilized in the model. The missing values were imputed by the seven-year average value for the same dates with missing data as presented in Formula \ref{formula:impute}, and the imputed results are shown in Figure \ref{fig:impute}. This pre-processing was conducted with software Python 3.11.8 and one of its libraries, Polars 0.20.19.

\begin{equation}
    \label{formula:impute}
    % Average_{date, factor} = \frac{1}{n} \sum_{i=1}^{n} X_{year_i, date, factor}
    Average_{date, factor} = \sum_{i \in Year} X_{i, date, factor}
\end{equation}
(where $Year$ is the set of years excluding those with missing values, and date and factor refer to the same date and meteorological factor)

\begin{figure}[htbp]
    \centering
    \includegraphics[scale=0.5]{./Figure/figure/weather.png}
    \caption{12 meteorological data for 7 years after imputing missing values}
    \label{fig:impute}
\end{figure}


\section{Model}

\subsection{State Space Model}
The HRV parameters data were time dependent sequence, therefore, time series approach was adopted in this study. State space model, one of time series analysis approaches, was utilized to estimate the size of each meteorological factor's effect. In this study, standardized ($mean = 0, std = 0$) meteorological data which were mentioned earlier was input data as explanatory variables to the model, and each HRV parameter was target variable. State space model comprises two equations, state equation and observation equation, which are described as follow Formula \ref{formula:ssm} [kitagawa].

\begin{equation}
    \label{formula:ssm}
    \begin{split}
        x_t = T_tx_{t-1} + v_t \\
        y_t = Z_tx_t + \epsilon_t
    \end{split}
\end{equation}

Using a state space model allows us to derive estimation results in a more interpretable form, as the model separates the estimation into states values and observations values, with explanatory variables considered as influences on the observation values. Additionally, a pre-processing to remove stationary, such as data transformation by computing differences seen in estimation using AR and ARIMA model, is not essential process in a state space model, which could avoid compromising the information contained in the data. Furthermore, even if there are missing values in the target variables, model estimation remains possible, and missing data imputation for target variables is feasible as well, since the estimation of states and observations are handled separately.

The regression model adopted in this study is shown below. Formula \ref{formula:state} is state equation $\mu$ containing second-order difference term $\mu_{t-2}$, which could capture trend of the data. The trend component may be comprehended as reflecting long-term tendencies by unobserved factors other than the meteorological factors. Formula \ref{formula:obs} is observation equation, which included regression term for estimating the effect of meteorological factors.

\begin{equation}
    \label{formula:state}
    \mu_t = 2\mu_{t-1} - \mu_{t-2} + v_t, v_t \sim Normal(0, \sigma_v^2)
\end{equation}

\begin{equation}
    \label{formula:obs}
    y_t = \mu_t + \boldsymbol{X}_t\boldsymbol{b} + \epsilon_t, \epsilon_t \sim Normal(0, \sigma_\epsilon^2)
\end{equation}

where $\boldsymbol{X}$ indicates explanatory variable, that is, meteorological data, $\boldsymbol{b}$ is regression coefficients vector with 12 dimensions for each variable, and $v_t$ and $\epsilon_t$ are error term which follow normal distribution with mean 0 and standard deviation $\sigma_v$, $\sigma$ respectively.

The space state model mentioned above is also written in state space expression in the manner of Formula \ref{formula:ssm}. State vector $x_t$ was defined as \ref{formula:state vec} with 14 dimensions, where $\mu_t$ and $\mu_{t-1}$ are trend components, and $b_1, \cdots, b_{12}$ are regression components.

\begin{equation}
    \label{formula:state vec}
     x_t = 
    \begin{pmatrix}
       \mu_t & \mu_{t-1} & b_1 & \cdots & b_{12}
    \end{pmatrix}^t
\end{equation}

State transition matrix $T_t$ was described as \ref{formula:state transition} with 14 $\times$ 14 dimensions.

\begin{equation}
    \label{formula:state transition}
    T_t = T = 
    \begin{pmatrix}
        T_\mu & 0 \\
        0     & T_w \\
    \end{pmatrix}
\end{equation}

Here, $T_\mu$ and $T_w$ are submatrix corresponding to trend component and coefficients component respectively as shown below.

\begin{equation}
    \label{formula:state transition sub mu}
    T_\mu = 
    \begin{pmatrix}
        2 & -1 \\
        1 & 0 \\
    \end{pmatrix}
\end{equation}

\begin{equation}
    \label{formula:state transition sub b}
    T_w = 
    \begin{pmatrix}
        1 &        & 0 \\
          & \ddots &   \\
        0 &        & 1 \\
    \end{pmatrix}
\end{equation}


Observation vector $Z_t$ with 14 dimensions was constructed with below \ref{formula:obs equation}, which includes each meteorological factor's data at time $t$ $\X_{1,t}, \cdots, X_{12,t}$.

\begin{equation}
    \label{formula:obs equation}
    Z_t = 
    \begin{pmatrix}
        1 & 0 & X_{1,t} & \cdots & X_{12,t}
    \end{pmatrix}
\end{equation}

Estimation of state space model was realized using R 4.2.3 [r] and RStan 2.32.2 [stan].

\subsection{Bayesian Approach}
Recently, data analysis with bayesian approach is becoming more popular, because the estimated results are easier to interpret than conventional statistical methods such as p-value [psychological bayes]. For example, conventional statistical methods including maximum likelihood estimation output a point as estimated result, which might be difficult to understand uncertainty of the results. Additionally, indicators such as p-value are claimed that several problems could be happened without precisely proper usage of p-value and knowledge to understand [ASA].

In this study, model estimation was conducted using Bayesian approach to obtain credible interval of the estimated values. Particularly, \ac{MCMC}, one of sampling methods from posterior (estimated) distribution, was adopted to obtain estimation results. In Bayesian estimation process, multiple dimensional integration is necessary to normalize the posterior distribution which has multiple estimation parameters. According to Bayes' theorem, the posterior distribution of the estimation parameter $\theta$ given the observed data $y$, is expressed in Formula \ref{formula:bayes}.

\begin{equation}
    \label{formula:bayes}
    \begin{split}
        p(\theta|y) &= \frac{p(y|\theta)p(\theta)}{p(y)} \\[8pt]
                    &= \frac{p(y|\theta)p(\theta)}{\int_{\theta}p(y|\theta)p(\theta)d\theta} \\[8pt]
                    &\propto p(y|\theta)p(\theta) \\[8pt]
    \end{split}
\end{equation}

where $p(y|\theta)$ denotes the likelihood, describing the probability of the data $y$ under a specific parameter $\theta$; $p(\theta)$ represents the prior distribution, which holds prior knowledge or assumption about $\theta$; and $p(y)$ is the marginal likelihood which is constant value as normalization term. To obtain the posterior distribution, it is necessary to compute $p(y)$ by integrating over all possible values of $\theta$. This integration would span a high dimensional parameter space, leading to a multiple dimension integral which is computationally impassible to solve analytically.

MCMC is one of computing methods of high dimensional integral in Bayesian estimation, providing a solution by approximating the posterior distribution. Rather than directly computing the integral, MCMC methods generate a large number of random samples from the posterior distribution by utilizing Markov chain. This sampling approach enables us to estimate representative values from the posterior distribution, such as mean, median, and credible intervals. In this study, mainly \ac{MAP} was calculated by Formula \ref{formula:map} for analysis.

\begin{equation}
    \label{formula:map}
    \begin{split}
        \hat{\theta}_{map} &= argmax_\theta p(\theta|y) \\[8pt]
                           &= argmax_\theta \frac{p(y|\theta)p(\theta)}{p(y)}
    \end{split}
\end{equation}

In R and RStan adopted \ac{HMC} method to implement and enhance MCMC sampling, introducing principles from physics. The HMC method applies Hamiltonian dynamics, ********* . chain, burn in, sampling,

The prior distribution of the regression coefficients was specified as a Laplace distribution to encourage sparsity in the coefficients and feature selection. This approach helped to identify the most relevant features by shrinking less impactful coefficients toward zero, enhancing model interpretability [lasso].

In recent years, analysis methods focusing on interpretability and explanability have been attracting attention. These analysis methods, state space model with bayesian approach, would be advanced as the point of view of interpretable model construction compared to deep neural network which has millions of parameters. 

\section{Method flow}

The analysis part consisted of 7 components for several purposes which were explained above; meteorological data collection, ECG measurement, missing values imputation of meteorological data, HRV parameters calculation, model construction, model estimation, and results evaluation. The flow of them are shown in Figure \ref{fig:flowchart}.

\begin{figure}[htbp]
    \centering
    \begin{tikzpicture}[node distance=2.5cm, >=Stealth]
        \tikzstyle{mynode} = [draw, rectangle, rounded corners, minimum width=6.5cm, minimum height=1.2cm, font=\large]
    
        \node (1) [mynode] {Meteorological data collection};
        \node (2) [mynode, below of=1] {Missing values imputation};
        \node (3) [mynode, right=of 1] {ECG measurement};
        \node (4) [mynode, below of=3] {HRV parameters calculation};
        \node (5) [mynode, below=of 2] at ($(2)!0.5!(4)$) {Model construction};
        \node (6) [mynode, below of=5] {Model estimation};
        \node (7) [mynode, below of=6] {Results evaluation};
    
        \draw[->, thick] (1) -- (2);
        \draw[->, thick] (3) -- (4);
        \draw[->, thick] (2) -- (5);
        \draw[->, thick] (4) -- (5);
        \draw[->, thick] (5) -- (6);
        \draw[->, thick] (6) -- (7);
    \end{tikzpicture}
    \caption{Analysis flowchart}
    \label{fig:flowchart}
\end{figure}

[my paper]: https://ieeexplore.ieee.org/document/10359319
[database]: https://www.data.jma.go.jp/stats/etrn/index.php
[address pdf]: https://www.jma-net.go.jp/fukushima/gyoumu/wakamatsu.html
[pdf]: https://www.data.jma.go.jp/stats/data/kaisetu/shishin/shishin_all.pdf
[url]: https://www.data.jma.go.jp/stats/etrn/kako_data.html
