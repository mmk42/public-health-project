# load packages 
library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)




# ------- CLEAN DATA --------- 

cost_data <- read.csv("./data/cost.csv")

cost_data <- cost_data %>% 
  rename(
    "cancer" = "Cancer.Site",
  ) %>% 
  mutate(year = substr(Year, 1, 4)) %>% 
  filter(cancer == "Lung")

#Statistical Testing
cost_mean <- cost_data %>% 
  summarise(mean(Total.Costs))


cost_median <- cost_data %>% 
  summarise(median(Total.Costs))

cost_max <- cost_data %>% 
  summarise(max(Total.Costs))

cost_min <- cost_data %>% 
  summarise(min(Total.Costs))

cost_range = cost_max - cost_min

cost_sd <- cost_data %>% 
  summarise(sd(Total.Costs))


# ------- INTERACTIVE VISUALIZAION PLOT ------- 
server <- function(input, output) {
  
  # Cost distribution plot
  cost_distribution <- cost_data %>%
    ggplot(aes_string(x = "cancer", y = "Total.Costs")) +
    geom_boxplot() +
    coord_flip() +
    labs(
      title = "Total Costs Distribution On Lung Cancer Over 10 Years",
      x = "Cancer Type",
      y = "Costs($)"
    )
  output$cost_dist <- renderPlot({
    plot(cost_distribution)
  })
  
  
  #cost over time plot
  cost_data_relation <- cost_data %>% 
    group_by(year) %>% 
    summarise(mean(Total.Costs)) %>% 
    rename(
      "Total.Costs" = "mean(Total.Costs)"
    )
  cost_over_year <- ggplot(cost_data_relation, aes_string(x = "year", y = "Total.Costs", group=1)) +
    geom_line(linetype = "dashed", color="red")+
    geom_point() +
    labs(
      title = "Total Costs Change On Lung Cancer Over Time",
      x = "Year",
      y = "Total Costs($)"
    )
  
  output$cost_yearly <- renderPlot({
    plot(cost_over_year)
  }) 
  

  
  
  
}
