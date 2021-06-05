#Analysis of the cost

library(dplyr)
library(tidyr)
library(ggplot2)

cost_data <- read.csv("./data/cost.csv")

# Costs ($) per year in millions of 2010 dollars
cost_data <- cost_data %>% 
  rename(
    "cancer" = "Cancer.Site",
    #"Total.Costs" = "Total.Costs"
  ) %>% 
  mutate(year = substr(Year, 1, 4)) %>% 
  select(cancer, year, Total.Costs) %>% 
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


#Distribution Plot
#Shows the distribution of the total cost on lung cancer from 2010 to 2020.
cost_distribution <- cost_data %>%
  ggplot(aes(x = cancer, y = Total.Costs)) +
  geom_boxplot() +
  coord_flip() +
  labs(
    title = "Total Costs Distribution On Lung Cancer Over 10 Years",
    x = "Cancer Type",
    y = "Total Costs($)"
  )


#Relationship Plot
#Shows the trend of the avearge total cost per year on lung cancer from 2010 to 2020.

cost_data_relation <- cost_data %>% 
  group_by(year) %>% 
  summarise(mean(Total.Costs)) %>% 
  rename(
    "Total.Costs" = "mean(Total.Costs)"
  )

cost_over_year <- ggplot(cost_data_relation, aes(x = year, y = Total.Costs, group=1)) +
  geom_line(linetype = "dashed", color="red")+
  geom_point() +
  labs(
    title = "Total Costs Change On Lung Cancer Over Time",
    x = "Year",
    y = "Total Costs($)"
  )

