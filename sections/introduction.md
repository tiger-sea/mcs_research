\chapter{Introduction}

\section{Background}
In recent years, various symptoms, such as headache, which are widely believed to be caused by meteorological changes, have been attracting attention and are referred to as meteoropathy. Meteoropathy is considered as a new disease or syndrome \cite{meteoQ} that represents any pathological reactions in some way related to weather conditions, and it could occur to people who have diseases which are sensitive to weather changes and even healthy people. Some people troubling in meteoropathy do not notice they have symptoms related to meteorological factors, hence the symptoms or intensity in individuals are different from person to person, and it is difficult to be diagnosed as meteoropathy.

Indeed, according to a survey conducted by a Japanese company Weathernews.inc in 2020 and 2023, considerable number of people reported they are suffering from meteoropathy \cite{wni_2020, wni_2023}. \if0 ???Pi chart??? \fi For example, more than half of the participants in the survey have experienced headache on days with bad weather. Besides this, dizziness, joint pain, and stiff neck are also symptoms which are mainly mentioned by them as shown in Figure \ref{fig:survey}. The number of people who perceived suffering from meteoropathy has been increasing according to the survey. Additionally, a study showed that nearly 30\% of people in the world have experienced symptoms associated with meteoropathy \cite{review_2023}. A few services have launched to provide prediction of the onset of meteoropathy over the past several years \cite{zutool, wni_tool} to deal with the symptoms in advance in Japan. Consequently, numerous people are interested in why the symptoms appear and how we can address them in order to maintain a healthy condition.

\begin{figure}[htbp]
    \centering
    \includegraphics[scale=0.7]{./Figure/figure/survey.png}
    \caption{Percentage of the survey "What is your biggest symptom?" conducted in 2020 \cite{wni_2020}}
    \label{fig:survey}
\end{figure}


\section{Previous Studies}
There have been several studies that examined relationship between specific diseases and meteorological factors. L. Ma et al. \cite{L_2020} and A. Costilla-Esquivel et al. \cite{Costilla_2014} mentioned that the number of patients of respiratory diseases are influenced by meteorological factors. The former reported that the factors having a greater impact on the number of patients with respiratory diseases are daily minimum temperature, minimum atmospheric pressure, and minimum wind speed. In contrast, the latter insisted that weekly minimum temperature, median relative humidity, and total precipitation were effective factors on the number of weekly patients of respiratory diseases. Although minimum temperature is one of common factors in both studies, the latter concluded it could have a reducing effect on the target variable, conflicting the former study's conclusion.

Azzouzi and Ichchou \cite{Hamida_2020}, and Fagerlund A.J. et al. \cite{Fagerlund_2019} evaluated pain intensity level associating with meteorological factors. Azzouzi and Ichchou examined pain caused by rheumatoid arthritis using patients' pain assessment from computerized medical record. They stated that minimum temperature and atmospheric pressure were negatively correlated to pain intensity. Besides, Fagerlund A.J. et al. focused on pain intensity with fibromyalgia, using questionnaire form data. They reported low atmospheric pressure and high relative humidity induced stronger pain intensity. There is a common factor between the two previous studies, however, few meteorological factors overlapped.

In addition to effects on physical body, mental health could be changed by weather. For example, Lee et al. \cite{Lee_2018} described maximum temperature and relative humidity caused fatigue, utilizing diary form questionnaire. They also suggested that women's health condition were more sensitive than men to weather change. Additionally, Lickiewicz et al. \cite{Lickiewicz_2020} also investigated mental health aggravation with psychiatric setting. They pointed that decrease of atmospheric pressure and increase of temperature worsened mental health condition. They suggested weather change in macro scale, such as air mass and weather fronts also could have an effect on our health condition.

Although the previous studies mentioned above focused on certain diseases, there are some previous studies with healthy individuals who perceived weather-related change in their condition. Mazza et al. \cite{meteoQ} proposed a concept Meteorosensitivity defined as "biological susceptibility to feel the effect of particular atmospherical events on [the] mind and body" and a questionnaire METEO-Q to detect meteoropathy. Besides, Oniszczenko \cite{Oniszczenko_2020} assessed the relationship between meteoropathy and meteorosensitivity with questionnaire METEO-Q \cite{meteoQ}, and showed that a large correlation was found between them among women. Therefore, the more sensitive they are to changes in weather, the more possibly they are to experience meteoropathy symptoms.

Furthermore, other than the study carried out by Lee et al \cite{Lee_2018}, several studies also described that women were easier to perceive weather changes and more severe symptoms, and it is related to onset of meteoropathy \cite{Oniszczenko_2020, Rzeszutek_2020}. However, Bellini et al. \cite{Bellini_2015} conducted a survey about meteoropathy using METEO-Q with adult outpatients, and they reported that men showed higher level of meteoropathy than women.

In many previous papers, the researchers have stated results that patients are affected by weather, but some of those results are not consistent. For example, focusing on atmospheric pressure, some concluded that it had a positive effect, while others suggested it was either not effective or had a negative effect. That would be because of differences in methodology such as data collection conditions. For instance, there are studies that utilized questionnaire-based experiments, however, the details of the questionnaires were different. Summary of the previous studies are shown in Table \ref{table:prior studies}, highlighting these inconsistent findings.

\renewcommand{\arraystretch}{1.4}
\begin{sidewaystable}[htbp]
    \centering
    \caption{Summary of previous studies introduced the section}
    \label{table:prior studies}
    \begin{tabular}{l l l l}
        \hline
        \textbf{Author, Year} & \textbf{Symptom} & \textbf{Effective factor(s)} & \textbf{Data format} \\
        \hline
        L. Ma et al., 2021 \cite{L_2020} & Respiratory diseases & Temperature, atmospheric pressure, wind speed & Medical record \\ \hline
        Costilla-Esquivel A et al., 2013 \cite{Costilla_2014} & Respiratory diseases & Temperature, humidity, precipitation & Public database \\ \hline
        Azzouzi H \& Ichchou L, 2020 \cite{Hamida_2020} & Rheumatoid Arthritis & Temperature, atmospheric pressure & Medical record \\ \hline
        Fagerlund AJ et al., 2019 \cite{Fagerlund_2019} & Fibromyalgia & Relative humidity, atmospheric pressure & Questionnaire \\ \hline
        Lee M et al., 2018 \cite{Lee_2018} & Fatigue & Temperature, relative humidity & Daily diary \\ \hline
        Lickiewicz J et al., 2020 \cite{Lickiewicz_2020} & Aggressive emotion & Temperature, atmospheric pressure & Medical record \\ \hline
        Mazza M et al. 2012 \cite{meteoQ} & Meteoropathy & Sex (Women) & Questionnaire (METEO-Q) \\ \hline
        Oniszczenko W, 2020 \cite{Oniszczenko_2020} & Affective temperaments & Sex (Women) & Questionnaire (METEO-Q) \\ \hline
        Rzeszutek M et al., 2020 \cite{Rzeszutek_2020} & Meteoropathy & Sex (Women) & Questionnaire (METEO-Q) \\ \hline
        Bellini S et al., 2015 \cite{Bellini_2015} & Meteoropathy & Sex (Men) & Qestionnaire (METEO-Q) \\
        \hline
    \end{tabular}
\end{sidewaystable}
\renewcommand{\arraystretch}{1.0}

Moreover, a few previous studies suggested that meteoropathy may be linked to the \ac{ANS}. For instance, Sato et al. \cite{Sato_1999} examined a behavior of mice which had pain and were exposed to low atmospheric pressure in controlled room. They observed that lowering atmospheric pressure induced more severe pain-related behaviors. On the other hand, when the mice with a surgically removed \ac{SNS} were exposed to the same conditions, and the pain-related behaviors were no longer observed. This finding suggests that the ANS, particularly the SNS, plays a significant role in the onset of meteoropathy. Also, Oniszczenko et al. \cite{Oniszczenko_2020} claimed that the mechanism of emotion could be affected by weather, if weather impacted on ANS functions, because ANS would link to the mechanism of emotion, and many organs.


\section{Aim of the Study}
Although various studies have sought to understand the causes of meteoropathy, they are still not fully clarified. To our knowledge, few previous studies have conducted an analysis of long-term quantitative data related to \ac{HRV} parameters. Some of HRV parameters closely associated with changes in our health condition are related to the dynamics of the ANS, which has been suggested to be affected by meteorological factors in several studies. In the current study, we examined the association between HRV parameters and meteorological factors in order to assess what meteorological factors have impacts on them, based on \ac{ECG} data as quantitative measures. Additionally, we discussed how we manage the symptoms and explored the future developments in order to contribute to maintaining health.

Achieving these aims would provide valuable insights into what meteorological factors influence HRV parameters' dynamics.
