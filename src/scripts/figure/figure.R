# Make simple plot for figure -------------------------------------------

## Import ---------------------------------------------------------------

### Data processing
library(dplyr)
library(reshape2)

### Visualization
library(ggfortify)
library(gridExtra)
library(patchwork)
library(ggplot2)

df <- data.frame(symptom = c("Headache", "Stiff neck", "Joint pain", "Backache", "Fatigue",
                           "Dizziness", "Sleepiness", "Nausea", "Swelling", "Other"),
                 value = c(51.0, 13.4, 12.8, 7.2, 7.0, 2.9, 1.0, 0.4, 0.3, 4.0))


ggplot(df, aes(fill = symptom)) +
    geom_col(aes(x=reorder(symptom, -value), y=value)) +
    xlab(element_blank()) +
    ylab("Percentage of the survey (%)") +
    theme_minimal() +
    theme(legend.position = "none", # c(0.8, 0.7),
          legend.title = element_blank(),
          axis.text.x = element_text(face = "bold", size = 14, angle = 90, vjust = 0.4),
          axis.text.y = element_text(face = "bold", size = 14),
          axis.title = element_text(face = "bold", size = 13),
          legend.text = element_text(face = "bold"),
          aspect.ratio = 7/10)
ggsave("./mcs_research/src/fig/paper/survey.png", dpi = 500)

