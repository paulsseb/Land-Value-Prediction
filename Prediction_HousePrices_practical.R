
#install.packages(c("caret", "party", "partykit", "tidyverse", "lava"))
library(tidyverse)
library(caret)
library(party)
library(partykit)


# house data
house_train <- read_csv(file = "../Land Value Prediction/TrainDataset.csv")

#Print numbers of rows and columns
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

#Explore your price_glm object by 
#looking at price_glm$finalModel and using summary(), what do you find?

price_glm$finalModel
summary(price_glm)

#Using predict() save the fitted values of price_glm object as glm_fit:
# Save fitted values of regression model
glm_fit <- predict(price_glm)
glm_fitpredicted <-predict(price_glm, data.frame(District ="Kampala",Area ="Namugongo",Electricity ="Yes",Road_Network="Moderate",Hospital ="Yes",Living_Standards="High",Population="Moderate",Land_Size=1,Year=2010 ))

#Print your glm_fit object, look at summary statistics with summary(glm_fit),
#and create a histogram with hist() do they make sense?

glm_fit[1:10] # Only first 10
summary(glm_fit)
hist(glm_fit)







