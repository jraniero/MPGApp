#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("MPG and Weight dependency"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      h3("Select cars with weight less than:"),
      sliderInput("wt",
                  "Maximum Weight:",
                  min = min(mtcars$wt)-0.1,
                  max = max(mtcars$wt)+0.1,
                  value = mean(mtcars$wt)),
      h3("Select cars with transmission type in:"),
       checkboxGroupInput(
       "transmission",
       "Transmission Type",
       c("Automatic"="Automatic","Manual"="Manual"),
       c("Automatic","Manual"),
       TRUE
       ),
      span("Data in set: "),
      textOutput("nbSamples",inline=TRUE),
      submitButton("Calculate Regression")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       p("This plot shows the mtcars data, with one regression line for automatic transmission, another for manual and the user selectable regression"),
       p("The user selectable regression takes the cars with less weight than the one specified by the user, and with any of the selected transmission types"),
       plotOutput("distPlot"),
       span("Squared residual sum for selected parameters regression:"),
       textOutput("regression",inline=TRUE),
       br(),
       span("Squared residual sum for Automatic and Manual regression:"),
       textOutput("stdRegression",inline=TRUE)
    )
  )
))
