library(dplyr)
library(ggplot2)

# Read data
lung_raw <- read.csv("data/WSCR_lung_raw.csv")
# View(lung_raw)

prep_yearly_data <- lung_raw %>%
  filter(lung_raw$Gender == "All")
# View(prep_yearly_data)

#####################################################
# Cancer Rate vs Year
#####################################################

yearly_cancer_plot <- prep_yearly_data %>%
  ggplot(mapping = aes(x = Year, y = Annual.Observations/Annual.Population)) +
  geom_point() +
  scale_x_continuous(breaks = 2007:2017) +
  geom_line() +
  geom_smooth(method = "lm", se = FALSE, formula = y ~ x) +
  labs(y = "Cancer Rate", title= "Yearly Diagnosis")

#yearly_cancer_plot


#####################################################
# Cancer Dist female and male
#####################################################

prep_compare_data <- lung_raw %>%
  filter(lung_raw$Gender != "All")
# View(prep_compare_data)

female_data <- prep_compare_data %>% 
  filter(Gender == "Female")

male_data <- prep_compare_data %>% 
  filter(Gender == "Male")
#Statistical Testing
F_mean <- female_data %>% 
  summarise(mean(Annual.Observations/Annual.Population)) 
M_mean <- male_data %>% 
  summarise(mean(Annual.Observations/Annual.Population))

F_median <- female_data %>% 
  summarise(median(Annual.Observations/Annual.Population))
M_median <- male_data %>% 
  summarise(median(Annual.Observations/Annual.Population))

F_max <- female_data %>% 
  summarise(max(Annual.Observations/Annual.Population))
M_max <- male_data %>% 
  summarise(max(Annual.Observations/Annual.Population))

F_min <- female_data %>% 
  summarise(min(Annual.Observations/Annual.Population))
M_min <- male_data %>% 
  summarise(min(Annual.Observations/Annual.Population))

F_range = F_max - F_min
M_range = M_max - M_min

F_sd <- female_data %>% 
  summarise(sd(Annual.Observations/Annual.Population))
M_sd <- male_data %>% 
  summarise(sd(Annual.Observations/Annual.Population))

compare_plot <- prep_compare_data %>%
  ggplot(aes(x = Gender, y = Annual.Observations/Annual.Population, fill = Gender)) +
  geom_boxplot() +
  labs(y = "Cancer Rate")
  
  
  



