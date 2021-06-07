#install packages
library(shiny)
library(ggplot2)
library(plotly)
library(shinythemes)

# read dataset 
# immunizations <- read.csv("immunizations.csv")


# --------- CREATE WIDGETS ---------- 

cost_type_chooser <- selectInput(
  "cost_input",
  label = "Cost Type",
  choices  = list("Total Cost" = "Total.Cost","Initial Year After Diagnosis Cost" = "Initial.Year.After.Diagnosis.Cost", "Continuing Phase Cost" = "Continuing.Phase.Cost"),
  selected = "Total Cost"
)



# --------- CREATE PAGES ---------- 
page_0 <- tabPanel(
  "Introduction",                   #title of the page, what will appear as the tab name
  sidebarLayout(             
    sidebarPanel( 
      
    ),           
    mainPanel(                
      p("The introduction and overview goes here. Include purpose, why it's important, prior research, sources, methods we used to analyze data
        "),

      
    )))
page_1 <- tabPanel(
  "Cancer Cost",                   
  sidebarLayout(             
    sidebarPanel( 
      cost_type_chooser
    ),           
    mainPanel(    
      plotOutput(outputId = "cost_yearly"),
      plotOutput(outputId = "cost_dist")
    )))

cancerRate_page <- tabPanel(
  title = "Cancer Rate",             #title of the page, what will appear as the tab name
  h2("How does lung cancer rate changes overtime?"),
  p("In this section we will explore data on the lung cancer rates rates from 2007 to 2017. 
         Check out the lung cancer rate for different genders and year range with different ways of statistic analysis!"),
  br(),
  sidebarLayout(   
    sidebarPanel( 
      radioButtons("gender", label = strong("Gender"), 
                   choices = list("All" = 'All', "Male" = 'Male', "Female" = 'Female'),
                   selected = 'All'),
      sliderInput("year", label = strong("Year Range"), min = 2007, 
                  max = 2017, value = c(2007, 2017), step = 1),
      radioButtons("trend", label = strong("Statistic Analysis"), 
                   choices = list("Line Chart" = 0, "Line Chart with Confidence Interval" = 1, "Box Plot" = 2),
                   selected = 0)
    ),           
    mainPanel(                # typically where you place your plots + texts
      plotOutput(outputId = "rate_plot"),
      br(),
      textOutput("result_one"),
      textOutput("result_two"),
      textOutput("result_three"),
      textOutput("result_four"),
      br(),
      textOutput("result_five"),
      textOutput("result_six"),
      br()
      
    )
  )
)

page_3 <- tabPanel(
  "Conclusion",                   
  sidebarLayout(             
    sidebarPanel( 
      
    ),           
    mainPanel(                
    )))
# --------- DEFINING UI: PUTTING PAGES TOGETHER ---------- 
ui <- fluidPage(theme = shinytheme("superhero"), 
  navbarPage(
  theme = "superhero",
  "Lung Cancer",
  page_0,
  page_1,
  cancerRate_page,
  page_3
))

