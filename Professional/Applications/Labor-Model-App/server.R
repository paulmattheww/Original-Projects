# server.R

library(caret)
source("helpers.R")

myData <- read.csv("stl_labor_model_data.csv", header=TRUE)
nightModelStl <- lm(INFERRED.NIGHT.EMPLOYEES ~ TOTAL.STL.CASES, data=myData)
nightInterceptStl <- summary(nightModelStl)$coefficients[1]
nightSlopeCasesStl <- summary(nightModelStl)$coefficients[2]


shinyServer(
  function(input, output) {
    output$text1 <- renderText({
      paste('You selected', input$Cases, 'cases to be used in this forecast.')
    })
    prediction <- reactive({ nightInterceptStl + input$Cases * nightSlopeCasesStl })
    output$Predicted.Number <- renderText({ paste('Forecasted Number of Employees is', prediction) })
})
    
