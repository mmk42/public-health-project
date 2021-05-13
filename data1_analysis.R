library(dplyr)
library(ggplot2)

# Read data
lung_raw <- read.csv("data/WSCR_lung_raw.csv")
# View(lung_raw)

prep_yearly_data <- lung_raw %>%
  filter(lung_raw$Gender == "All")
# View(prep_yearly_data)

yearly_cancer_plot <- prep_yearly_data %>%
  ggplot(mapping = aes(x = Year, y = Annual.Observations/Annual.Population)) +
  geom_point() +
  scale_x_continuous(breaks = 2007:2017) +
  geom_line() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(y = "Cancer Rate", title= "Yearly Diagnosis")

prep_compare_data <- lung_raw %>%
  filter(lung_raw$Gender != "All")
# View(prep_compare_data)

compare_plot <- prep_compare_data %>%
  ggplot(aes(x = Gender, y = Annual.Observations/Annual.Population, fill = Gender)) +
  geom_boxplot() +
  labs(y = "Cancer Rate")
  
  
  



