 setwd("~/Git Repository/my-Rstudio-Project/replication/Replicated file Abhishek Verma")
 # Install necessary packages (only once)
   install.packages("ggplot2")
install.packages("tibble")
install.packages("dplyr")
install.packages("tidyr")


  
   library(ggplot2)
 library(tibble)
 library(dplyr)



 # Step 1: Simulate long-format data
  data <- tibble(
    +     male = factor(c("Male", "Male", "Male", "Male", "Female", "Female", "Female", "Female")),
    +     category = factor(rep(c("Retired", "Unemployed", "Home-maker", "Others"), 2),
                            +                       levels = c("Retired", "Unemployed", "Home-maker", "Others")),
    +     proportion = c(0.40, 0.25, 0.15, 0.10, 0.30, 0.35, 0.20, 0.05) )
    
     # Step 2: Plot grouped bar chart
    ggplot(data, aes(x = category, y = proportion, fill = category)) +
    +     geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.6) +
    +     facet_wrap(~ male, nrow = 1) +
    +     scale_y_continuous(limits = c(0, 0.7), breaks = seq(0, 0.7, by = 0.1)) +
    +     labs(
      +         title = "Proportion by Labor Force Status and Gender",
      +         x = NULL,
      +         y = "Proportion" )
      +     
    +     theme_minimal(base_size = 14) +
    +     theme(
      +         legend.position = "bottom",
      +         plot.background = element_rect(fill = "white", color = NA),
      +         panel.background = element_rect(fill = "white", color = NA),
      +         strip.text = element_text(face = "bold") )
      +     
   
     ggsave("labor_status_by_gender.png", width = 8, height = 5, dpi = 300)
  > 