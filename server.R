
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#

library(ggplot2) # a for making pretty plots
library(shiny)
library(reshape)
library(rgdal)
#install.packages(c("caret", "party", "partykit", "tidyverse", "lava"))
library(lava)
library(tidyverse)
library(caret)
library(party)
library(partykit)


#data_sets <- c("UNRA1","UNRA2","UNRA3","UNRA4","UNRA5")

#mydata <- read.csv("ww/UNRA1.csv", header = FALSE)
# house data
house_train <- read_csv(file = "../Land Value Prediction/TrainDataset.csv")


#District data
district<-c("Kampala","Wakiso")

#Area data
area<-c("Namugongo","Bukerere","Gayaza","Busabala","Komambogo","Kajjansi","Mengo","Lubowa","Kira Bulindo")

#Electricity data
power<-c("Yes","No")
#Road network data
road_ntwk<-c("Good","Moderate")

#Hospital data
hospital<-c("Yes","No")
#Living Stnadards data
livingstdrd<-c("High","Low","Mooderate")
#Population data
population<-c("High","Scarce","Moderate")
#Land_Size data
land_size<-c(1,2,3,4,6)
#Year data
year<-c(2007:2022)


################################################################################################################################################################################################
################################
Logged = FALSE;
PASSWORD <- data.frame(Brukernavn = "po", Passord = "123")

shinyServer(function(input, output) {
  # Define server logic required to summarize and view the selected dataset
  source("login.R",  local = TRUE)
  
  
  observe({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    
    hola<-read.csv(inFile$datapath, header=input$header, sep=input$sep,
                   quote=input$quote)
    
    write.csv(hola, file="../Land Value Prediction/TrainDataset.csv",row.names=FALSE,col.names=TRUE)
    
  })
  
  
  output$choose_District <- renderUI({
    selectInput("district", "District",as.list(district))
  })
  
 
  output$choose_Area <- renderUI({
    selectInput("area", "Area",as.list(area))
  })

  
  output$choose_Power <- renderUI({
    selectInput("power", "Power",as.list(power))
  })

  
  output$choose_Roadntwk <- renderUI({
    selectInput("road_ntwk", "Area",as.list(road_ntwk))
  })

  
  output$choose_hospital <- renderUI({
    selectInput("hospital", "Hospital",as.list(hospital))
  })

  
  output$choose_livingstdrd <- renderUI({
    selectInput("livingstdrd", "Living Standards",as.list(livingstdrd))
  })

  
  output$choose_population <- renderUI({
    selectInput("population", "Population",as.list(population))
  })

  
  output$choose_land_size <- renderUI({
    selectInput("land_size", "Land Size",as.list(land_size))
  })
 
  
  output$choose_year <- renderUI({
    selectInput("year", "Year",as.list(year))
  })
 
  
  
  
  ###########################initiating and Training the model##############################
  
  # Print numbers of rows and columns
  #dim(house_train)
  
  # Print the names of each dataframe
  #names(house_train)
  
  # Open each dataset in a window.
  #View(house_train)
  
  #We need to do a little bit of data cleaning before starting. 
  #Specifically, we need to convert all character columsn to factor: 
  # Do this by running the following code:
  # Convert all character columns to factor
  
  house_train <- house_train %>%
    mutate_if(is.character, factor)
  
  #goal in the following models is to predict price
  # Set training method to "none" for simple fitting
  #  Note: This is for demonstration purposes, you would almost
  #   never do this for a 'real' prediction task!
  
  ctrl_none <- trainControl(method = "none")
  
  
  #Using train() fit a regression model called 
  #price_glm predicting price using all features in house_train.
  #For the form argument, use price ~ .
  #For the data argument, use house_train in the data argument
  #For the method argument, use method = glm for regression
  #For the trControl argument, use your ctrl_none object you created before
  
  price_glm <- train(form = Price ~.,
                     data = house_train,
                     method = "glm",
                     trControl = ctrl_none)
  
  
  ##########################################################
  price_glm$finalModel
  summary(price_glm)
  
  #Using predict() save the fitted values of price_glm object as glm_fit:
  # Save fitted values of regression model
  glm_fit <- predict(price_glm)
  summary(glm_fit)
  
  #glm_fitpredicted <-predict(price_glm, data.frame(District ="Kampala",Area ="Namugongo",Electricity ="Yes",Road_Network="Moderate",Hospital ="Yes",Living_Standards="High",Population="Moderate",Land_Size=1,Year=2010 ))
  
  
  ################################################################################################################################################################################################
  ################################...... plots and texts on  the different tabs
  
  output$summary <- renderPrint({  
    #summary Displays
#Min.  1st Qu.   Median     Mean  3rd Qu.     Max. price values from the regression model
    formatC(summary(glm_fit) , format="d", big.mark=',')
    
    
  })
  
  output$histogram <- renderPlot({
    as.numeric(paste(factor( glm_fit)))
    
     # Draw plot
    hist(glm_fit, col = "#75AADB", border = "white",
         xlab = "Land Prices",
         main = "Histogram of trained Regression model")
    
    
    
  },height=600)
  
  
  output$price <-renderPrint({  
    
    
    glm_fitpredicted <-predict(price_glm, data.frame(District =input$district,Area =input$area,Electricity =input$power,Road_Network=input$road_ntwk,Hospital =input$hospital,Living_Standards=input$livingstdrd,Population=input$population,Land_Size=as.numeric(paste(factor(input$land_size))),Year=as.numeric(paste(factor(input$year)))))
    formatC(glm_fitpredicted , format="d", big.mark=',')
    
    
    
  })
  
  
  
  

  
})


