#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
mycars<-mtcars
mycars$am<-as.factor(mycars$am)
levels(mycars$am)<-c("Automatic","Manual")
fitaut<-lm(mpg~wt,mycars[mycars$am=="Automatic",])
fitman<-lm(mpg~wt,mycars[mycars$am=="Manual",])
fitall<-lm(mpg~wt,mycars)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  inputWeight<-reactive({return (input$wt)})
  #print(class(inputWeight()))
  inputTransmission<-reactive({return(input$transmission)})
  selectedData<-reactive(
    {
      subset(mycars,wt<inputWeight() & am %in% inputTransmission())
    }
  )
  fitall<-reactive({
    #fitall<-lm(mpg~wt,mycars,subset=(wt<input$wt & am %in% input$transmission))
    fitall<- lm(mpg~wt,selectedData())
    return(fitall)
           })
  
  residuals<-reactive({
    predict(fitall(),newdata=mycars)-mycars$mpg
  })

  output$distPlot <- renderPlot({

  
    # generate bins based on input$bins from ui.R
    #x    <- faithful[, 2] 
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    plot(mpg~wt,data=mycars,col=am)
    abline(v=input$wt,col="green")
    abline(a=fitman$coefficients[1],b=fitman$coefficients[2],col="red",lty=3)
    abline(a=fitaut$coefficients[1],b=fitaut$coefficients[2],col="blue",lty=3)
    if(length(selectedData()$mpg)>0)
    {
      abline(a=fitall()$coefficients[1],b=fitall()$coefficients[2],col="green",lty=2)
    }
      else
      {
        text(x=mean(mycars$wt),y=mean(mycars$mpg),labels="No data found",col="red")
      }
    legend("top",
           c("Manual","Automatic","Manual Reg.","Automatic Reg.","User reg.","Maximum weight"),
           lty=c(NA,NA,3,3,2,1),pch=c(20,20,NA,NA,NA,NA),
           col=c("red","blue","red","blue","green","green"),
           ncol=2
           )
  })
  
  output$nbSamples<-renderText(ifelse(length(selectedData()$mpg)>0,
                                      length(selectedData()$mpg),
                                      "No data found, please adjust parameters"
                                      ))

  output$regression<-renderText({ifelse(length(inputTransmission())>0,
                                        ifelse(length(selectedData()$mpg)>0,
                                               sum(residuals()^2),
                                               "No data in set"),
                                        "Please select at least one transmission type")})

  output$stdRegression<-renderText({sum(fitman$residuals^2)+sum(fitaut$residuals^2)})
})
