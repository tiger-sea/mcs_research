\chapter{Methods}

\section{Data Collection}

\subsection{ECG Data}
% good but not checked
% figure is missing, figure caption???
The ECG data utilized in this study was collected in a bathtub environment for special experiment of ECG measurement in the University of Aizu. The purpose of this setup was to integrate the experiment into regular daily activities without interfering with them. Daily data collection started from July 2017 to July 2024, covering approximately 7 years in total, though with some missing days. The subject was a healthy adult man whose height is 172 cm, and body weight ranged between 60 and 64 kg, which depends on seasonal condition. In the bathtub environment, bathing condition was typically kept nearly identical conditions, specifically, amount of bath water was about 180 liters, and the temperature was set between 37 and 40 degrees Celsius depending on the season or health condition [my paper]

For ECG measurement, a self made equipment of biosignal measurement unit was adopted to record ECG data while the subject was taking bath by Lead-I\hspace{-1.2pt}I. There were three electrodes on the bathtub wall, one was located on the bathtub wall close to subject's left leg, and the others were placed on it close to subject's right arm and leg respectively as shown in Fig. \ref{fig:bath env}. As mentioned earlier in this section, this measurement method minimally interferes with normal daily life.

\begin{figure}[htbp]
    \centering
    \includegraphics[scale=0.5]{./Figure/computer_keyboard_hand_itai.png}
    \caption{Experiment environment for ECG measurement in bathtub}
    \label{fig:bath env}
\end{figure}

\subsection{Meteorological Factors}
% not finished
% xxxxxxxxxx part would be feature of aizu-wakamatsu weather
Daily meteorological data corresponding to the ECG data was gathered from the Japan Meteorological Agency's database [database]. The location of monitoring point by the Japan Meteorological Agency was Aizu-Wakamatsu city, Fukushima, Japan [address pdf]. xxxxxxxxx In this study, 12 meteorological factors were collected, and which include maximum, minimum, or mean representative values for each meteorological factor as shown below Table \ref{table:weather factors}.

\begin{table}[htbp]
  \centering
  \caption{Collected daily 12 meteorological factors' types}
  \label{table:weather factors}
  \begin{tabular}{l l}
    \hline
    \textbf{Factor} & \textbf{Trait} \\
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

According to the statistical guideline of the Japan Meteorological Agency's database, calculation protocols for the representative values are defined as follows [pdf]. The daily mean values of temperature, relative humidity, and sea-level atmospheric pressure are recorded every hour on the hour. Similarly, total precipitation, total snowfall, and sunshine duration values are collected following the same protocol. In addition to that, the daily maximum or minimum representative values of temperature, relative humidity, sea-level atmospheric pressure, and hourly precipitation are gathered every 10 minutes, as well as the mean wind speed.

\section{Pre-processing}

\subsection{HRV Calculation}
% not finished
% insert figure of processing ECG???
HRV parameters derived from ECG data are calculated using software MATLAB R2023a and a library HRV tool [hrv tool github]. The adopted HRV parameters in this study are presented in Table \ref{table:hrv time} and Table \ref{table:hrv freq}, separating into time domain parameters and frequency domain parameters [an overview]. Before calculating HRV parameters, the ECG data was handled to convert raw ECG data into R-R interval data for HRV tool. Firstly, first one minute of the ECG data and last one minute of the ECG data were eliminated, because those parts had much noise due to movement for getting in and out. Secondly, the ECG data was filtered to suppress noise, such as hum noise and myoelectricity. Finally, R-R interval sequences were calculated by detecting each R peak and computing difference following formula \ref{formula:rri}.

\begin{equation}
\label{formula:rri}
RR_i = (R\ peak)_{i+1} - (R\ peak)_i
\end{equation}

Specification of the library for HRV calculation was defined的な?xxxxxxxxxxxxxxxxxx

\begin{table}[htbp]
    \centering
    \caption{Calculated HRV parameters in time domain}
    \label{table:hrv time}
    \begin{tabular}{l c l}
    \hline
    \textbf{Parameter} & \textbf{Unit} & \textbf{Note} \\ \hline
    Heart rate & beat/min & The number of heart beats in a minute \\
    SDNN       & msec & Standard deviation of NN intervals \\
    RMSSD      & msec & Root mean square of successive RR interval differences \\
    pNN50      & -  & Ratio of successive RR intervals that differ by more than 50 ms \\
    TINN       & msec & Baseline width of the RR interval histogram \\
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
    LF/HF & (-)    & Ratio of LF and HF \\
    \hline
    \end{tabular}
\end{table}

Many of HRV parameters have practical meaning to diagnose diseases and monitor health condition change [an overview]. For example, 


\subsection{Imputation of Missing Values in Meteorological Factors}
The meteorological data contained several missing values because of replacement or malfunction of the measurement equipment [url]. In total, there were 14 days which included missing values in some meteorological factors data.

Missing values in explanatory variable were not acceptable to the model used in this study. Therefore, the missing values were processed before the meteorological data is utilized in the model. The missing values were imputed by the seven-year average value for the same dates with missing data as presented in Formula \ref{formula:impute}. This pre-processing was conducted with software Python 3.11.8 and one of its libraries, Polars 0.20.19.

\begin{equation}
\label{formula:impute}
Average_{date, factor} = \frac{1}{n} \sum_{i=1}^{n} X_{i, factor}
\end{equation}
\centerline{(for the same date with missing values)}


\section{Model}

\subsection{Bayesian Approach}

\subsection{Space State Model}

\section{Method flow}
The analysis method in this study follows a figure below.
make graph



[my paper]: https://ieeexplore.ieee.org/document/10359319
[database]: https://www.data.jma.go.jp/stats/etrn/index.php
[address pdf]: https://www.jma-net.go.jp/fukushima/gyoumu/wakamatsu.html
[pdf]: https://www.data.jma.go.jp/stats/data/kaisetu/shishin/shishin_all.pdf
[url]: https://www.data.jma.go.jp/stats/etrn/kako_data.html
