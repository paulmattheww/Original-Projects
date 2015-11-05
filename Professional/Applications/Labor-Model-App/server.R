# server.R
library(shiny)
library(caret)


myData <- read.csv("stl_labor_model_data.csv", header=TRUE)
nightModelStl <- lm(INFERRED.NIGHT.EMPLOYEES ~ TOTAL.STL.CASES, data=myData)
nightInterceptStl <- summary(nightModelStl)$coefficients[1]
nightSlopeCasesStl <- summary(nightModelStl)$coefficients[2]


shinyServer(
  function(input, output) {
    
    output$text1 <- renderText({
      paste('You selected', input$Cases, 'cases to be used in this forecast.')
    })
    
    prediction <- reactive({ round(nightInterceptStl + input$Cases * nightSlopeCasesStl, 1) 
      })
    
    output$Predicted.Number <- renderText({ paste('Forecasted Number of Employees is', prediction()) 
      })
    
    output$text2 <- renderText({
      'This forecast does not account for special projects. Add in the number of hours needed for special projects.'
    })
})
    
