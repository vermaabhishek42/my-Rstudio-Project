library(dplyr); library(tidyr)
library(ggplot2); library(ggthemes); library(ggpubr)
library(scales)

# set the working directory for the replication work
setwd("F:/ROSA Researchers/Seonghoon Kim/replication/dofile")


#==============================================================================#
####                          Figure A6                                      ####
#==============================================================================#
plot_data <- read.csv("../processed_data/Fig_A6_input.csv", stringsAsFactors = FALSE, na.strings = "") %>%
  mutate(level = case_when(level == "0" ~ "1",
                           level == "1" ~ "2",
                           level == "2+" ~ "3+",
                           TRUE ~ level))
plot_data$measure <- factor(plot_data$measure, levels = c("BI score", "HOR score", "Eyes Test score", "IST Score"))
plotm_data <- plot_data %>% 
  filter(gender == "male")
plotm <- ggplot(plotm_data, aes(x = level, y = mean, ymin = lb, ymax = ub)) +
  facet_grid( ~ measure, scales = "free_x") +
  geom_errorbar(width = 0.3) + geom_point(size = 3) +
  labs(title = "(a) Male",
       x = "", y = "Annual labor income",
       caption = "") + 
  scale_y_continuous(label = comma, limits = c(20000, 70000)) + 
  theme_bw() +  #scale_color_economist() + theme_economist_white() + 
  theme(plot.title = element_text(size = 14, hjust = 0.5, face = "plain"),
        axis.text.x = element_text(size = 12, angle = 90, hjust = 1, vjust = 0.5,
                                   margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.text.y = element_text(hjust = 1, size = 12, 
                                   margin = margin(t = 0, r = 5, b = 0, l = 0)),
        axis.title.y = element_text(size = 12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)),
        panel.grid.major.x = element_line(colour = NA),
        panel.grid.minor.y = element_line(colour = NA),
        panel.background = element_rect(colour = "black"),
        strip.background = element_rect(fill = NA, colour = NA),
        strip.text = element_text(size = 12))

plotf_data <- plot_data %>% 
  filter(gender == "female")
plotf <- ggplot(plotf_data, aes(x = level, y = mean, ymin = lb, ymax = ub)) +
  facet_grid( ~ measure, scales = "free_x") +
  geom_errorbar(width = 0.3) + geom_point(size = 3) +
  labs(title = "(b) Female",
       x = "", y = "Annual labor income",
       caption = "") + 
  scale_y_continuous(label = comma, limits = c(10000, 40000)) + 
  theme_bw() +  #scale_color_economist() + theme_economist_white() + 
  theme(plot.title = element_text(size = 14, hjust = 0.5, face = "plain"),
        axis.text.x = element_text(size = 12, angle = 90, hjust = 1, vjust = 0.5,
                                   margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.text.y = element_text(hjust = 1, size = 12,
                                   margin = margin(t = 0, r = 5, b = 0, l = 0)),
        axis.title.y = element_text(size = 12, colour = NA,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)),
        panel.grid.major.x = element_line(colour = NA),
        panel.grid.minor.y = element_line(colour = NA),
        panel.background = element_rect(colour = "black"),
        strip.background = element_rect(fill = NA, colour = NA),
        strip.text = element_text(size = 12))

fig_a6 <- ggarrange(plotm, plotf, nrow = 1)
ggsave("../figures/Fig_A6.png", plot = fig_a6,
       width = 15, height = 7)

#==============================================================================#
####                          Figure A7                                      ####
#==============================================================================#
plot_data <- read.csv("../processed_data/Fig_A7_input.csv", stringsAsFactors = FALSE, na.strings = "") %>%
  mutate(level = case_when(level == "0" ~ "1",
                           level == "1" ~ "2",
                           level == "2+" ~ "3+",
                           TRUE ~ level))
plot_data$measure <- factor(plot_data$measure, levels = c("BI score", "HOR score", "Eyes Test score", "IST Score"))
plotm_data <- plot_data %>% 
  filter(gender == "male")
plotm <- ggplot(plotm_data, aes(x = level, y = mean, ymin = lb, ymax = ub)) +
  facet_grid( ~ measure, scales = "free_x") +
  geom_errorbar(width = 0.3) + geom_point(size = 3) +
  labs(title = "(a) Male",
       x = "", y = "Prob(Annual labor income > 0)",
       caption = "") + 
  scale_y_continuous(limits = c(0.70, 0.9)) + 
  theme_bw() +  #scale_color_economist() + theme_economist_white() + 
  theme(plot.title = element_text(size = 14, hjust = 0.5, face = "plain"),
        axis.text.x = element_text(size = 12, angle = 90, hjust = 1, vjust = 0.5,
                                   margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.text.y = element_text(hjust = 1, size = 12, 
                                   margin = margin(t = 0, r = 5, b = 0, l = 0)),
        axis.title.y = element_text(size = 12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)),
        panel.grid.major.x = element_line(colour = NA),
        panel.grid.minor.y = element_line(colour = NA),
        panel.background = element_rect(colour = "black"),
        strip.background = element_rect(fill = NA, colour = NA),
        strip.text = element_text(size = 12))

plotf_data <- plot_data %>% 
  filter(gender == "female")
plotf <- ggplot(plotf_data, aes(x = level, y = mean, ymin = lb, ymax = ub)) +
  facet_grid( ~ measure, scales = "free_x") +
  geom_errorbar(width = 0.3) + geom_point(size = 3) +
  labs(title = "(b) Female",
       x = "", y = "Prob(Annual labor income > 0)",
       caption = "") + 
  scale_y_continuous(limits = c(0.50, 0.71)) + 
  theme_bw() +  #scale_color_economist() + theme_economist_white() + 
  theme(plot.title = element_text(size = 14, hjust = 0.5, face = "plain"),
        axis.text.x = element_text(size = 12, angle = 90, hjust = 1, vjust = 0.5,
                                   margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.text.y = element_text(hjust = 1, size = 12,
                                   margin = margin(t = 0, r = 5, b = 0, l = 0)),
        axis.title.y = element_text(size = 12, colour = NA,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)),
        panel.grid.major.x = element_line(colour = NA),
        panel.grid.minor.y = element_line(colour = NA),
        panel.background = element_rect(colour = "black"),
        strip.background = element_rect(fill = NA, colour = NA),
        strip.text = element_text(size = 12))

fig_a7 <- ggarrange(plotm, plotf, nrow = 1)
ggsave("../figures/Fig_A7.png", plot = fig_a7,
       width = 15, height = 7)

#==============================================================================#
####                          Figure A8                                      ####
#==============================================================================#
plot_data <- read.csv("../processed_data/Fig_A8_input.csv", stringsAsFactors = FALSE, na.strings = "") %>%
  mutate(level = case_when(level == "0" ~ "1",
                           level == "1" ~ "2",
                           level == "2+" ~ "3+",
                           TRUE ~ level))
plot_data$measure <- factor(plot_data$measure, levels = c("BI score", "HOR score", "Eyes Test score", "IST Score"))
plotm_data <- plot_data %>% 
  filter(gender == "male")
plotm <- ggplot(plotm_data, aes(x = level, y = mean, ymin = lb, ymax = ub)) +
  facet_grid( ~ measure, scales = "free_x") +
  geom_errorbar(width = 0.3) + geom_point(size = 3)+
  labs(title = "(a) Male",
       x = "", y = "Annual labor income (excluding 0's)",
       caption = "") + 
  scale_y_continuous(label = comma, limits = c(20000, 85000)) + 
  theme_bw() +  #scale_color_economist() + theme_economist_white() + 
  theme(plot.title = element_text(size = 14, hjust = 0.5, face = "plain"),
        axis.text.x = element_text(size = 12, angle = 90, hjust = 1, vjust = 0.5,
                                   margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.text.y = element_text(hjust = 1, size = 12, 
                                   margin = margin(t = 0, r = 5, b = 0, l = 0)),
        axis.title.y = element_text(size = 12,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)),
        panel.grid.major.x = element_line(colour = NA),
        panel.grid.minor.y = element_line(colour = NA),
        panel.background = element_rect(colour = "black"),
        strip.background = element_rect(fill = NA, colour = NA),
        strip.text = element_text(size = 12))

plotf_data <- plot_data %>% 
  filter(gender == "female")
plotf <- ggplot(plotf_data, aes(x = level, y = mean, ymin = lb, ymax = ub)) +
  facet_grid( ~ measure, scales = "free_x") +
  geom_errorbar(width = 0.3) + geom_point(size = 3) +
  labs(title = "(b) Female",
       x = "", y = "Annual labur income (excluding 0's)",
       caption = "") + 
  scale_y_continuous(label = comma, limits = c(10000, 65000)) + 
  theme_bw() +  #scale_color_economist() + theme_economist_white() + 
  theme(plot.title = element_text(size = 14, hjust = 0.5, face = "plain"),
        axis.text.x = element_text(size = 12, angle = 90, hjust = 1, vjust = 0.5,
                                   margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.text.y = element_text(hjust = 1, size = 12,
                                   margin = margin(t = 0, r = 5, b = 0, l = 0)),
        axis.title.y = element_text(size = 12, colour = NA,
                                    margin = margin(t = 0, r = 10, b = 0, l = 0)),
        panel.grid.major.x = element_line(colour = NA),
        panel.grid.minor.y = element_line(colour = NA),
        panel.background = element_rect(colour = "black"),
        strip.background = element_rect(fill = NA, colour = NA),
        strip.text = element_text(size = 12))

fig_a8 <- ggarrange(plotm, plotf, nrow = 1)
ggsave("../figures/Fig_A8.png", plot = fig_a8,
       width = 15, height = 7)

