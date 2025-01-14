\chapter{Methods}

\section{Analysis Flow}
The analysis process consists of four main sections, each addressing a specific purpose of the study. Within these sections, more detailed descriptions are provided through relevant subsections, including ECG data collection, meteorological data collection, HRV parameters calculation, missing values imputation of meteorological data, model construction, model estimation, and model evaluation. The overall flow of the analysis process is illustrated in Figure\ref{fig:flowchart}. The flowchart highlights the major steps of the process, focusing on the main tasks required for data processing, modeling, and evaluation. Information involving model construction and model estimation are provided in the section Model.

\begin{figure}[htbp]
    \centering
    \begin{tikzpicture}[node distance=2.5cm, >=Stealth]
        \tikzstyle{mynode} = [draw, rectangle, rounded corners, minimum width=6.5cm, minimum height=1.2cm, font=\large]
    
        \node (1) [mynode] {Meteorological data collection};
        \node (2) [mynode, below of=1] {Missing values imputation};
        \node (3) [mynode, right=of 1] {ECG data collection};
        \node (4) [mynode, below of=3] {HRV parameters calculation};
        \node (5) [mynode, below=of 2] at ($(2)!0.5!(4)$) {Model design};
        \node (6) [mynode, below of=5] {Model estimation};
        \node (7) [mynode, below of=6] {Model evaluation};
    
        \draw[->, thick] (1) -- (2);
        \draw[->, thick] (3) -- (4);
        \draw[->, thick] (2) -- (5);
        \draw[->, thick] (4) -- (5);
        \draw[->, thick] (5) -- (6);
        \draw[->, thick] (6) -- (7);
    \end{tikzpicture}
    \caption{Flowchart of main analysis process}
    \label{fig:flowchart}
\end{figure}


\section{Data Collection}

\subsection{ECG Data}
The ECG data utilized in this study was collected in a bathtub environment for special experiment of ECG measurement in the University of Aizu \cite{Li_2018, my_paper}. This setup was specifically designed to seamlessly integrate the experiment into the subject's regular daily activities, minimizing any behavioral changes that could affect measurements. The data collection was carried out everyday from July 2017 to July 2024, covering approximately 7 years in total, though with 233 missing days out of 2565 days in total. Each bathing duration was approximately 17 minutes to remain 15 minutes of data after noisy part removal. The number of subjects was one, and the subject was a healthy adult male aged between 55 and 62 years, with a height of 172 cm and a body weight ranging between 60 and 64 kg, depending on seasonal conditions. The subject also had a regular habit of walking for exercise. In the bathtub environment, bathing condition was typically kept nearly identical conditions, specifically, amount of bath water was about 180 liters, and the temperature was set between 37 and 40 degrees Celsius depending on the season or health condition \cite{my_paper}.

For ECG measurement, a self made equipment of biosignal measurement unit was adopted to record ECG data by Lead-I\hspace{-1.2pt}I by sampling rate of 500 Hz while the subject was taking a bath. There were three electrodes on the bathtub wall, one was located on the bathtub wall close to subject's left leg, and the others were placed on it close to subject's right arm and leg respectively as shown in Figure \ref{fig:bath env}. The electrodes were made of stainless steel and were attached to the bathtub walls using double-sided tape. The measured ECG signals were amplified and stored in the signal data recorder. As mentioned earlier in this section, this measurement method aimed to minimally interferes with normal daily life.

\begin{figure}[htbp]
    \centering
    \includegraphics[scale=1.2]{./Figure/figure/environment.pdf}
    \caption{Experiment environment for ECG measurement in bathtub}
    \label{fig:bath env}
\end{figure}

\subsection{Meteorological Factors}
% good but not checked
% insert figure of weather data? -> weather figure is at imputation part
Daily meteorological data in corresponding days of the ECG data collection were gathered from the Japan Meteorological Agency's database \cite{database}. The location of monitoring point by the Japan Meteorological Agency was Aizu-Wakamatsu city, Fukushima, Japan \cite{address}. Aizu-Wakamatsu city is surrounded by mountain, and that yields many heavy snowy and cold days in winter, which similar to Japan Sea area. Besides, a large number of high temperature and humid days happen in summer, lasting high temperature until late night because of the location. In spring and autumn, a difference of temperature between daytime and nighttime is relatively considerable caused by inland climate feature\if0[pdf and pdf]\fi.

In this study, 12 meteorological factors were collected, and which include maximum, minimum, or mean representative values for each meteorological factor as shown below Table \ref{table:weather factors}. According to the statistical guideline of the Japan Meteorological Agency's database, calculation protocols for the representative values are defined as follows \cite{weather_stats}. The daily mean values of temperature, relative humidity, and sea-level atmospheric pressure are recorded every hour. Similarly, total precipitation, total snowfall, and sunshine duration values are collected following the same protocol. In addition to that, the daily maximum or minimum representative values of temperature, relative humidity, sea-level atmospheric pressure, and hourly precipitation are gathered every 10 minutes, as well as the mean wind speed. The total days of collected meteorological data was 2564 days, including a few missing values in some of the meteorological factors.

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
HRV parameters derived from ECG data were calculated using software MATLAB R2023a and a library HRV tool \cite{hrv_tool}. The adopted HRV parameters in this study are presented in Table \ref{table:hrv time} and Table \ref{table:hrv freq}, separating into time domain parameters and frequency domain parameters \cite{Shaffer_2017}. Before calculating HRV parameters, the ECG data were handled to convert raw ECG data into R-R interval data for HRV tool. Firstly, first one minute of the ECG data and last one minute of the ECG data were eliminated, because those parts had much noise due to movement for getting in and out. Secondly, the ECG data were filtered to suppress noise, such as hum noise and myoelectricity. Finally, R-R interval sequences were calculated after detecting each R peak and computing difference following formula \ref{formula:rri}. An example of the HRV calculation flow and R-R interval sequence results are shown in Figure \ref{fig:ecg} and Figure \ref{fig:rri}.
%Specification of the library for HRV calculation was defined ...

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
    \caption{Flow of R peaks detection and R-R interval calculation}
    \label{fig:ecg}
\end{figure}

\begin{figure}
    \centering
    \includegraphics[scale=1]{./Figure/figure/rri.png}
    \caption{An example of R-R interval sequence}
    \label{fig:rri}
\end{figure}

Many of HRV parameters have practical meaning to diagnose diseases and monitor health condition change \cite{Shaffer_2017}. For example, RMSSD, one of time domain HRV parameters, can be considered as an indicator of parasympathetic nervous system's fluctuation. LF/HF, one of frequency domain HRV parameters, could be interpreted as balance between sympathetic and parasympathetic nervous systems. Furthermore, SDNN is applied to predict mortality in medical situation, classifying the value of SDNN based on its size \cite{Shaffer_2017}. In those manner, HRV parameters are utilized in various ways to evaluate our health condition by using ECG data or any other biosignal.


\subsection{Imputation of Missing Values in Meteorological Factors}
% need to change figure properly
The meteorological data contained several missing values because of replacement or malfunction of the measurement equipment \cite{jma_process}. In total, there were 14 days which included missing values in some meteorological factors data as shown in Table \ref{table:missing}.

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
    \includegraphics[scale=0.55, angle=90]{./Figure/figure/weather.png}
    \caption{12 meteorological data for 7 years after imputing missing values}
    \label{fig:impute}
\end{figure}


\section{Model}
% Information about model design and model estimation are provided in following two subsections respectively.

\subsection{Analysis Model}
The HRV parameters data were time-dependent sequence, therefore, time series approach was adopted in this study. State space model, one of time series analysis approaches, was utilized and designed to estimate the size of each meteorological factor's effect. In this study, standardized ($mean = 0, std = 0$) meteorological data which were mentioned earlier was input data as explanatory variables to the model, and each HRV parameter was target variable. State space model comprises two equations, state equation and observation equation, which are described as follow Formula \ref{formula:ssm} \cite{Kitagawa_2019}.

\begin{equation}
    \label{formula:ssm}
    \begin{split}
        x_t &= T_tx_{t-1} + v_t \\[10pt]
        y_t &= Z_tx_t + \epsilon_t
    \end{split}
\end{equation}

Using a state space model allows us to derive estimation results in a more interpretable form, as the model separates the estimation into states values and observations values, with explanatory variables considered as influences on the observation values. Additionally, a pre-processing to remove stationarity, such as data transformation by computing differences seen in estimation using AR and ARIMA model \cite{Oi_2012}, which may cause a loss of information called excessive difference, is required to estimate. The process is not essential in a state space model, which could avoid compromising the information contained in the data. Furthermore, even if there are missing values in the target variables, model estimation remains possible, and missing data imputation for target variables is feasible as well, since the estimation of states and observations are handled separately.

The regression model adopted in this study is shown below. Formula \ref{formula:state} is state equation $\mu$ containing second-order trend term $\mu_{t-2}$, which could capture trend of the data \cite{Motohashi_2012}. The trend component may be comprehended as reflecting long-term tendencies by unobserved factors other than the meteorological factors. Formula \ref{formula:obs} is observation equation, which included regression term for estimating the effect of meteorological factors \cite{Fukaya_2016}.

\begin{equation}
    \label{formula:state}
    \mu_t = 2\mu_{t-1} - \mu_{t-2} + v_t, v_t \sim Normal(0, \sigma_v^2)
\end{equation}
\begin{equation}
    \label{formula:obs}
    y_t = \mu_t + \boldsymbol{X}_t\boldsymbol{b} + \epsilon_t, \epsilon_t \sim Normal(0, \sigma_\epsilon^2)
\end{equation}

where $\boldsymbol{X}$ indicates explanatory variable, that is, meteorological data, $\boldsymbol{b}$ is regression coefficients vector with 12 dimensions for each variable, and $v_t$ and $\epsilon_t$ are error term which follow normal distribution with mean 0 and standard deviation $\sigma_v$, $\sigma$ respectively.

The space state model mentioned above is also written in state space expression in the manner of Formula \ref{formula:ssm} \cite{Yamaguchi_2004}. State vector $x_t$ was defined as \ref{formula:state vec} with 14 dimensions, where $\mu_t$ and $\mu_{t-1}$ are trend components, and $b_1, \cdots, b_{12}$ are regression components.

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

Observation vector $Z_t$ with 14 dimensions was constructed with below \ref{formula:obs equation}, which includes each meteorological factor's data at time $t$ $X_{1,t}, \cdots, X_{12,t}$.

\begin{equation}
    \label{formula:obs equation}
    Z_t = 
    \begin{pmatrix}
        1 & 0 & X_{1,t} & \cdots & X_{12,t}
    \end{pmatrix}
\end{equation}

Estimation of state space model was realized using R 4.2.3 and RStan 2.32.2.


\subsection{Bayesian Approach}
Recently, data analysis with bayesian approach is becoming more popular, because the estimated results are easier to interpret than conventional statistical methods such as p-value \cite{Hiroyuki_2021}. For example, conventional statistical methods including maximum likelihood estimation output a point as estimated result, which might be difficult to understand uncertainty of the results. Additionally, indicators such as p-value are claimed that several problems could be happened without precisely proper usage of p-value and knowledge to understand \cite{Toyoda_2017}.

In this study, model estimation was conducted using Bayesian approach to obtain credible interval of the estimated values and \ac{MAP}. Particularly, \ac{MCMC}, one of sampling methods from posterior (estimated) distribution, was adopted to obtain estimation results. In Bayesian estimation process, multiple dimensional integration is necessary to normalize the posterior distribution which has multiple estimation parameters. According to Bayes' theorem, the posterior distribution of the estimation parameter $\theta$ given the observed data $y$, is expressed in Formula \ref{formula:bayes}.

\begin{equation}
    \label{formula:bayes}
    \begin{split}
        p(\theta|y) &= \frac{p(y|\theta)p(\theta)}{p(y)} \\[8pt]
                    &= \frac{p(y|\theta)p(\theta)}{\int_{\theta}p(y|\theta)p(\theta)d\theta} \\[8pt]
                    &\propto p(y|\theta)p(\theta) \\[8pt]
    \end{split}
\end{equation}

where $p(y|\theta)$ denotes the likelihood, describing the probability of the data $y$ under a specific parameter $\theta$; $p(\theta)$ represents the prior distribution, which holds prior knowledge or assumption about $\theta$; and $p(y)$ is the marginal likelihood which is constant value as normalization term. To obtain the posterior distribution, it is necessary to compute $p(y)$ by integrating over all possible values of $\theta$. This integration would span a high dimensional parameter space, leading to a multiple dimension integral which is computationally impassible to solve analytically.

To understand the characteristics of estimated posterior distribution, it is necessary to obtain a representative value. One of the representative values is MAP described as Formula \ref{formula:map}, which identifies the most probable value of each regression coefficient \cite{Ikeda_2014}. Here, b corresponds to each regression coefficient of meteorological factor data explained above, and y represents meteorological factors used in this study. Applying to the estimated posterior distribution of each b generate the MAP estimation value for the b. In this study, the MAP estimation values were primarily focused on to discuss and interpret the results. 

\begin{equation}
    \label{formula:map}
    \begin{split}
        \hat{b}_{map} &= argmax_b p(b|y) \\[8pt]
                      &= argmax_b \frac{p(y|b)p(b)}{p(y)}
    \end{split}
\end{equation}

MCMC is one of computing methods of high dimensional integral in Bayesian estimation, providing a solution by approximating the posterior distribution. Rather than directly computing the integral, MCMC methods generate a large number of random samples from the posterior distribution by utilizing Markov chain. This sampling approach enables us to estimate representative values from the posterior distribution, such as mean, median, and credible intervals.

The prior distribution of the regression coefficients was specified as a Laplace distribution to encourage sparsity in the coefficients and feature selection. This approach helped to identify the most relevant features by shrinking less impactful coefficients toward zero, enhancing model interpretability \cite{Ibuki_2013}.

In recent years, analysis methods focusing on interpretability and explanability have been attracting attention. These analysis methods, state space model with bayesian approach, would be advanced as the point of view of interpretable model design compared to deep neural network which has millions of parameters. 

\section{Model Evaluation}
To assess the validity of the estimated models for each HRV parameter, we compared them with a simplified model. Specifically, the simplified model excluded regression term of meteorological factors but maintained the same structure as the primary model. We then evaluated the improvement by comparing the \ac{RMSE} of the 30-day predictions from both models. This approach allowed us to determine whether including meteorological factors contributed to better predictive performance and provide reasonable model estimation of their effects.

For model evaluation, we ensured that the 30-day prediction data were completely excluded from the estimation process and used solely for validation purposes.


% \centering
% \smartdiagramset{
%     font = \fontsize{16}{22}\selectfont,
%     text width = 8cm,
%     back arrow disabled,
%     uniform color list=black!50 for 10 items}
% \tikzset{module/.append style={
%     top color=white,
%     bottom color=white},
%     every shadow/.style = {fill=none, shadow scale=0}}
% \smartdiagram[flow diagram]{
%   Data collection of weather and ECG data,
%   Pre-processing to impute weather missing valeus, and calculate HRV parameters,
%   Model construction,
%   Coefficients estimation,
%   Evaluation}
