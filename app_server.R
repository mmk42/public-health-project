# load packages 
library(ggplot2)
library(dplyr)
library(plotly)
library(shiny)


#clean data
# ------- COST PAGE --------- 

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

# ------- CANCER RATE PAGE --------- 
lung_raw <- read.csv("./data/WSCR_lung_raw.csv")


# plots
server <- function(input, output, session) {
  # ------- COST PAGE --------- 
  
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
  
  # ------- CANCER RATE PAGE --------- 
  
  observe({
    if(input$year[1] == input$year[2]){
      if (input$year[1] == 2007) {
        updateSliderInput(session, "year", value = c(input$year[1], input$year[2] + 2))
      } else if (input$year[2] == 2017) {
        updateSliderInput(session, "year", value = c(input$year[1] - 2, input$year[2]))
      } else {
        updateSliderInput(session, "year", value = c(input$year[1] - 1, input$year[2] + 1))
      }
    } else if (input$year[2] - input$year[1] == 1) {
      if (input$year[1] == 2007) {
        updateSliderInput(session, "year", value = c(input$year[1], input$year[2] + 1))
      } else {
        updateSliderInput(session, "year", value = c(input$year[1] - 1, input$year[2]))
      }
    }
  })
  output$rate_plot <- renderPlot({
    prep_yearly_data <- lung_raw %>%
      filter(Gender == input$gender) %>%
      filter(Year >= input$year[1]) %>%
      filter(Year <= input$year[2])
    
    #####################################################
    # Cancer Rate vs Year
    #####################################################
    
    if(input$trend == 0) {
      yearly_cancer_plot <- prep_yearly_data %>%
        ggplot(mapping = aes(x = Year, y = (Annual.Observations/Annual.Population) * 10000)) +
        geom_point() +
        scale_x_continuous(breaks = 2007:2017) +
        geom_line() +
        geom_smooth(method = "lm", se = FALSE, formula = y ~ x) +
        labs(y = "Lung Cancer Rate per 100,000", title= "Yearly Diagnosis")
      yearly_cancer_plot
    } else if (input$trend == 1) {
      yearly_cancer_plot <- prep_yearly_data %>%
        ggplot(mapping = aes(x = Year, y = (Annual.Observations/Annual.Population) * 10000)) +
        geom_point() +
        scale_x_continuous(breaks = 2007:2017) +
        geom_line() +
        geom_smooth(method = "lm", se = TRUE, formula = y ~ x) +
        labs(y = "Lung Cancer Rate per 100,000", title= "Yearly Diagnosis")
      
      yearly_cancer_plot
    } else if (input$trend == 2) {
      prep_compare_data <- lung_raw %>%
        filter(lung_raw$Gender != "All") %>%      
        filter(Year >= input$year[1]) %>%
        filter(Year <= input$year[2])
      
      female_data <- prep_compare_data %>% 
        filter(Gender == "Female")
      
      male_data <- prep_compare_data %>% 
        filter(Gender == "Male")
      
      if (input$gender == "All") {
        compare_plot <- prep_compare_data %>%
          ggplot(aes(x = Gender, y = (Annual.Observations/Annual.Population) * 100000, fill = Gender)) +
          geom_boxplot() +
          labs(y = "Lung Cancer Rate per 100,000")
      } 
      else if (input$gender == "Male") {
        compare_plot <- male_data %>%
          ggplot(aes(x = Gender, y = (Annual.Observations/Annual.Population) * 100000, fill = Gender)) +
          geom_boxplot() +
          scale_fill_manual(values = "blue")
        labs(y = "Lung Cancer Rate per 100,000")
      } else if (input$gender == "Female") {
        compare_plot <- female_data %>%
          ggplot(aes(x = Gender, y = (Annual.Observations/Annual.Population) * 100000, fill = Gender)) +
          geom_boxplot() +
          labs(y = "Lung Cancer Rate per 100,000")
      }
      print(compare_plot)
    }
    
  })
  
  output$result_one <- renderText({
    high_year <- lung_raw %>%
      filter(Gender == input$gender) %>%
      filter(Year >= input$year[1]) %>%
      filter(Year <= input$year[2]) %>%
      mutate("Rate" = (Annual.Observations/Annual.Population)) %>%
      filter(Rate == max(Rate)) %>%
      select(Year)
    
    if(input$trend == 0 | input$trend == 1){
      paste("Year with highest cancer rate: ", paste0(high_year))
    }
    
  })
  
  output$result_two <- renderText({
    low_year <- lung_raw %>%
      filter(Gender == input$gender) %>%
      filter(Year >= input$year[1]) %>%
      filter(Year <= input$year[2]) %>%
      mutate("Rate" = (Annual.Observations/Annual.Population)) %>%
      filter(Rate == min(Rate)) %>%
      select(Year)
    
    if(input$trend == 0 | input$trend == 1){
      paste("Year with lowest cancer rate: ", paste0(low_year))
    } 
    
  })
  
  output$result_three <- renderText({
    data_for_slope <- lung_raw %>%
      filter(Gender == input$gender) %>%
      filter(Year >= input$year[1]) %>%
      filter(Year <= input$year[2]) %>%
      mutate("Rate" = (Annual.Observations/Annual.Population) * 100000)
    
    fit <- summary(lm(Rate ~ Year, data = data_for_slope))
    
    if(input$trend == 0 | input$trend == 1){
      paste("Slope : ", paste0(signif(fit$coef[[2]], 5)))
    } 
  })
  
  output$result_four <- renderText({
    data_for_slope <- lung_raw %>%
      filter(Gender == input$gender) %>%
      filter(Year >= input$year[1]) %>%
      filter(Year <= input$year[2]) %>%
      mutate("Rate" = (Annual.Observations/Annual.Population) * 100000)
    
    fit <- summary(lm(Rate ~ Year, data = data_for_slope))
    
    if(input$trend == 0 | input$trend == 1){
      paste("Adjusted. R^2 : ", paste0(signif(fit$adj.r.squared)))
    }
  })
  
  output$result_five <- renderText({ 
    data_for_slope <- lung_raw %>%
      filter(Gender == input$gender) %>%
      filter(Year >= input$year[1]) %>%
      filter(Year <= input$year[2]) %>%
      mutate("Rate" = (Annual.Observations/Annual.Population) * 100000)
    
    fit <- summary(lm(Rate ~ Year, data = data_for_slope))
    decide <- paste0(signif(fit$coef[[2]], 5))
    
    if(input$trend == 0 | input$trend == 1){
      if (decide > 0) {
        paste("Here we have a graph showing the relationship between the cancer rate and year. 
        The regression line has a positive slope meaning that as the year increased, the cancer rate increased. 
        It is worth noting that year to year, the the cancer rate has fluctuated and the 2007 rate is very close to the 2017 rate.")
      } else if (decide < 0) {
        paste("Here we have a graph showing the relationship between the cancer rate and year. 
        The regression line has a negative slope meaning that as the year increased, the cancer rate decreased. 
        It is worth noting that year to year, the the cancer rate has fluctuated because of the low r^2 value, 
        and the 2007 rate is very close to the 2017 rate.")
      }
    }
  })
  
  output$result_six <- renderText({
    prep_compare_data <- lung_raw %>%
      filter(lung_raw$Gender != "All")
    
    female_data <- prep_compare_data %>% 
      filter(Gender == "Female") %>%
      filter(Year >= input$year[1]) %>%
      filter(Year <= input$year[2])
    
    male_data <- prep_compare_data %>% 
      filter(Gender == "Male") %>%
      filter(Year >= input$year[1]) %>%
      filter(Year <= input$year[2])
    
    #Statistical Testing
    F_mean <- female_data %>% 
      summarise(mean((Annual.Observations/Annual.Population) * 100000)) 
    M_mean <- male_data %>% 
      summarise(mean((Annual.Observations/Annual.Population) * 100000)) 
    
    F_median <- female_data %>% 
      summarise(median((Annual.Observations/Annual.Population) * 100000)) 
    M_median <- male_data %>% 
      summarise(median((Annual.Observations/Annual.Population) * 100000)) 
    
    F_sd <- female_data %>% 
      summarise(sd((Annual.Observations/Annual.Population) * 100000)) 
    M_sd <- male_data %>% 
      summarise(sd((Annual.Observations/Annual.Population) * 100000)) 
    
    if(input$trend == 2) {
      if(input$gender == "Male") {
        paste("Here we have box plots of cancer rates for males from ", paste0(input$year[1]), "to ", paste0(input$year[2]), ". ", 
              "We can see that the median cancer rate for males is ", paste0(M_median), " per 100,000 population; ", 
              "the mean cancer rate for males is ", paste0(M_mean), " per 100,000 population; ", 
              " the standard deviation for males is ", paste0(M_sd), " per 100,000 population.")
      } else if (input$gender == "Female") {
        paste("Here we have box plots of cancer rates for females from ", paste0(input$year[1]), "to ", paste0(input$year[2]), ". ", 
              "We can see that the median cancer rate for females is ", paste0(F_median), " per 100,000 population; ", 
              "the mean cancer rate for females is ", paste0(F_mean), " per 100,000 population; ", 
              " the standard deviation for females is ", paste0(F_sd), " per 100,000 population.")
      } else if (input$gender == "All") {
        paste("Here we have box plots of cancer rates for females and males from ", paste0(input$year[1]), "to ", paste0(input$year[2]), ". ", 
              "We can see that the median cancer rate for males is ", paste0(M_median), " per 100,000 population; ", 
              "the median cancer rate for females is ", paste0(F_median), " per 100,000 population. ", 
              "The mean cancer rate for males is ", paste0(M_mean), " per 100,000 population; ", 
              "the mean cancer rate for females is ", paste0(F_mean), " per 100,000 population; ", 
              " the standard deviation for males is ", paste0(M_sd), " per 100,000 population; ", 
              " the standard deviation for females is ", paste0(F_sd), " per 100,000 population.")
      }
    }
  })
  
}
