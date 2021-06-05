#install packages
library(shiny)
library(ggplot2)
library(plotly)

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
page_2 <- tabPanel(
  "Cancer Rates",                   
  sidebarLayout(             
    sidebarPanel( 
      
    ),           
    mainPanel(                
      
    )))
page_3 <- tabPanel(
  "Conclusion",                   
  sidebarLayout(             
    sidebarPanel( 
      
    ),           
    mainPanel(                
    )))
# --------- DEFINING UI: PUTTING PAGES TOGETHER ---------- 
ui <- navbarPage(
  "Lung Cancer",
  page_0,
  page_1,
  page_2,
  page_3
  #insert other pages here
)

