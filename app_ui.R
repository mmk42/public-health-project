#install packages
library(shiny)
library(ggplot2)
library(plotly)
library(shinythemes)

# read dataset 
# immunizations <- read.csv("immunizations.csv")


# --------- CREATE WIDGETS ---------- 

#cost_type_chooser <- selectInput(
  #"cost_input",
  #label = "Cost Type",
  #choices  = list("Total Cost" = "Total.Cost","Initial Year After Diagnosis Cost" = "Initial.Year.After.Diagnosis.Cost", "Continuing Phase Cost" = "Continuing.Phase.Cost"),
  #selected = "Total Cost"
#)



# --------- CREATE PAGES ---------- 
page_0 <- tabPanel(
  "Introduction",                   #title of the page, what will appear as the tab name
    mainPanel(                
      h2("Introduction"),
      h4("The recent Covid-19 pandemic draws people’s attention to the health of lung and draws
         our group’s attention two another common disease in lung, the lung cancer. According to
         the American Cancer Society, lung cancer is the second most common cancer in both men 
         and women. Based on their estimate, there are about 235760 new cases of lung cancer and 131880
         deaths from it this year. As one of the leading causes of cancer death among all genders it deserves people’s attention."),
      h2("Our Goal"),
      h4("In the project, we are presenting the cancer rate of lung cancer and the cost to heal it, to bring the audience a general 
         idea of the lung cancer. Throughout the project, we are aiming to alert people the risk of the lung cancer and some tips of the early prevention."),
      h2("Limitations"),
      h4("Although we tried to find the most comprehensive and accurate data, there is still some limitations with the datasets we found. 
         For both of the dataset, the gender category only contains female and male, which isn’t comprehensive enough. 
         In addition, the cancer rate dataset stopped update in 2017, so we missed that data from the recent couple years.
         And the cost dataset is comparably small, so that might lead to the inaccuracy."),
      h2("Resources"),
      h4("Introduction Information from: ", a("cancer.org",href = "https://www.cancer.org/cancer/lung-cancer/about/key-statistics.html")),
      h4("Cost Data from: ", a("kaggle.com",href = "https://www.kaggle.com/rishidamarla/costs-for-cancer-treatment")),
      h4("Cancer Rate Data from: ", a("fortress.wa.gov",href = "https://fortress.wa.gov/doh/wscr/Query.mvc/Query")),
      h4("Prevention Information from: ", a("cancer.org",href = "https://www.cancer.org/cancer/lung-cancer/causes-risks-prevention/prevention.html"))
    ))
page_1 <- tabPanel(
  "Cancer Cost", 
  h2("How does cost changes overtime?"),
  p("In this section we will explore data collected on the cost to heal lung cancer from 2010 to 2020. 
         Check out the visualization for different types of cost with different ways of statistic analysis!"),
  br(),
  sidebarLayout(             
    sidebarPanel( 
      #cost_type_chooser,
      radioButtons("cost_input", label = strong("Cost Type"), 
                   choices  = list("Total Cost" = 'Total.Cost',"Initial Year After
                                             Diagnosis Cost" = 'Initial.Year.After.Diagnosis.Cost', 
                                             "Continuing Phase Cost" = 'Continuing.Phase.Cost'),
                   selected = 'Total.Cost'),
      # radioButtons("plot_type", label = strong("Statistic Analysis"), 
      #              choices = list("Line Chart" = 0, "Box Plot" = 1),
      #              selected = 0),
      p("The cost in the plot is also reflecting the inflation, to get an idea of the cost 
         change without inflation, click this ", a("inflation calculator", href ="https://www.usinflationcalculator.com/"), 
        " and enter the values you get from hovering over each of the data points to the right."),
      br(),
      p("For all cost types we can see that the change in cost is very linear. We can also see that the cost
        has been consistently increasing from 2010 to 2020 for all cost types. The plot also reflects the inflation,
        so the real cost is increasing by a smaller amount each year and look less linear as the plot." ),
      p("Below is a box plot representing the distribution for the average cost of care for lung cancer for each 
      year between 2010 and 2020. The median cost is at $12624.75 and the mean is $13113.97 with a standard deviation 
      of $1586.575. The minimum average cost per year is $11349.5 and the maximum is $18842.6. Although there are a few very high outliers,
        the distributions is skewed to the left.")
    ),     
    
    mainPanel(    
      plotlyOutput(outputId = "cost_yearly"),
      plotOutput(outputId = "cost_dist"),
    )))

cancerRate_page <- tabPanel(
  title = "Cancer Rate",             
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
  "Prevention",                   
  mainPanel(
    h2("Why are we doing prevention?"),
    h4("Even not all lung cancers are preventable, there are still somethings that we can do to lower the risk."),
    h2("Stay away from tobacco"),
    h4("The best way to reduce the risk of getting lung cancer is not to smoke and avoid secondhand smoke."),
    img(src = "https://www.dhat.com/Portals/0/EasyDNNNews/14/770600p656EDNmainimg-Tobacco-DHAT.png"),
    p("picture from", a("dhat.com", href="https://www.dhat.com/Blog/More-examples/Masonry-layout-1/ArtMID/656/ArticleID/14/Reasons-to-Say-%E2%80%9CNo%E2%80%9D-to-Tobacco")),
    h2("Avoid radon exposure"),
    h4("Radon is another important cause of lung cancer, and the exposure to radon can be reduced by doing the radon test for your home."),
    img(src = "https://www.syracuseradonmitigation.com/wp-content/uploads/2018/04/AARST-Radon-Professionals-Saving-Lives-youtubemp4.to_Moment2.jpg", height="357px", width="769px"),
    p("picture from", a("syracuseradonmitigation.com", href="https://www.syracuseradonmitigation.com/the-importance-of-testing-for-radon-on-upper-levels/")),
    h2("Avoid or limit exposure to cancer-causing agents"),
    h4("Be extra careful when you get close to a known cancer causing agent."),
    img(src = "https://d251cvb8f7e7p0.cloudfront.net/image-handler/ts/20190819080858/ri/950/src/images/Article_Images/ImageForArticle_7959(1).jpg", height="357px", width="769px"),
    p("picture from", a("azobuild.com", href="https://www.azobuild.com/article.aspx?ArticleID=7959")),
    h2("Eat a healthy diet"),
    h4("Eat fruit and vegetables would reduce the risk of getting lung cancer."),
    img(src = "https://cdn1.sph.harvard.edu/wp-content/uploads/sites/21/2018/07/fruitveg.jpeg", height="357px", width="769px"),
    p("picture from", a("harvard.edu", href="https://www.hsph.harvard.edu/news/press-releases/fruit-vegetables-breast-cancer/"))
  ))

page_4 <- tabPanel(
  "Conclusion",                   
    mainPanel(  
      h2("What is the yearly change and distribution of the cost of lung cancer?"),
      h4("Based on our observations of the interactive plot of the cost we can see 
         that the average total cost from 2010 to 2020’s median is around $12624, 
         the maximum is around $18842 and the minimum is around $11349, and these 
         are only the cost for one year, which show that the healing process of cancer 
         is expensive. From the line plot and the inflation calculator we can tell that, even the price in the plot 
         is affected by the inflation, as year gets more recent the cost still increases
         as well (not as much as shown in the graph)."),
      #May be talk about the difference between three different costs 
      h2("What did we learn from analyzing the lung cancer rate?"),
      h4("Based on our observations of the interactive plot of the cancer rate we 
         can see that the lung cancer rate doesn’t have a clear trend of increasing 
         or decreasing, instead it keeps changing between increasing and decreasing. 
         However, there is an overall trend of decreasing, which tells us that as the year 
         gets recent the risk of getting lung cancer decreases, and according to the American 
         Cancer Society, one of the reasons for that is more and more people realized the danger 
         of tobacco and quite smoking. From the line plot we can also see that while male’s cancer 
         rate decreases, female’s cancer rate is increasing among years. According to the American
         Cancer Society’s ", a("study", href= "https://www.cancer.org/latest-news/study-young-women-now-have-higher-rate-for-lung-cancer-than-men-worldwide.html"),
         ", a large cause of it is the increases in adenocarcinoma, a type of lung cancer seen in smokers, in women.
         This type of lung cancer is likely to occur in young women and is the most common type in nonsmokers. Distribution wise, despite the smoker generally has 
         a larger risk of getting the lung cancer, we can see from the box plot on the cancer rate 
         that male has a higher chance of getting the lung cancer.")
    ))
# --------- DEFINING UI: PUTTING PAGES TOGETHER ---------- 
ui <- fluidPage(theme = shinytheme("superhero"), 
  navbarPage(
  theme = "superhero",
  "Lung Cancer",
  page_0,
  page_1,
  cancerRate_page,
  page_3,
  page_4
))

