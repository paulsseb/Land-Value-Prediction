library(shinythemes)
library(shiny)


rm(list = ls())
shinyUI(fluidPage(
  theme = shinytheme("superhero"),
  tags$head(
    tags$style(HTML("
      @import url('../ww/css.txt');
    "))
  ),
 
  #cerulean, cosmo, cyborg, darkly, flatly, journal, lumen, paper, readable, sandstone, simplex, slate, spacelab, superhero, united, yeti.
  # Application title

  # Application title
  titlePanel( 
    headerPanel(
      h1("Land Value Prediction", 
         style = "font-family: 'Segoui', cursive;
         font-weight: 500; line-height: 1.1; 
         color:white;"))),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      uiOutput("choose_District"),
      hr(),
      
      

      uiOutput("choose_Area"),
      hr(),
      
      uiOutput("choose_Power"),
      hr(),
      
      uiOutput("choose_Roadntwk"),
      hr(),
      
      
      
      uiOutput("choose_hospital"),
      hr(),
      
      uiOutput("choose_livingstdrd"),
      hr(),
      
      
      
      uiOutput("choose_population"),
      hr(),
      
      uiOutput("choose_land_size"),
      hr(),
      
      
      
      uiOutput("choose_year"),
      hr()
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
     
      tabsetPanel(
        tabPanel("Train Results", verbatimTextOutput("summary") ,plotOutput("histogram",height=600)), 
        tabPanel("Predict land value", verbatimTextOutput("price")), 
        tabPanel("Amin Login", uiOutput("uiLogin"),
                 textOutput("pass"),uiOutput("upload"))
      )
      
    )
  )
))
