# server.R
library(shiny)
library(caret)
library(ggplot2)


myData <- read.csv("stl_labor_model_data.csv", header=TRUE)
nightModelStl <- lm(INFERRED.NIGHT.EMPLOYEES ~ TOTAL.STL.CASES, data=myData)
nightInterceptStl <- summary(nightModelStl)$coefficients[1]
nightSlopeCasesStl <- summary(nightModelStl)$coefficients[2]

actual <- data.frame(myData$NUMBER.OF.EMPLOYEES)
actual$TYPE <- 'Actual'
names(actual) <- c('Number.Night.Employees', 'Type')
inferred <- data.frame(myData$INFERRED.NIGHT.EMPLOYEES)
inferred$TYPE <- 'Inferred'
names(inferred) <- c('Number.Night.Employees', 'Type')
forHist <- rbind(inferred, actual)

g <- ggplot(data=forHist, aes(Number.Night.Employees, fill=Type))
nightDist <- function(input) {
  renderPlot({
    g + geom_density(alpha=0.2) + 
      ggtitle(expression(atop('Actual Number of Night Employees per Evening vs. Inferred Number of Employees (STL)',
                              atop(italic('Based on a 10 hour day'), "")))) +
      theme(legend.position='bottom') + geom_vline(xintercept=input, colour='red')
  })
}

shinyServer(
  function(input, output) {
    
    output$text1 <- renderText({
      paste('You selected', input$Cases, 'cases to be used in this forecast.')
    })
    
    prediction <- reactive({ round(nightInterceptStl + input$Cases * nightSlopeCasesStl, 1) 
      })
    
    output$Predicted.Number <- renderText({ paste('Shipping Employees Needed:', prediction()) 
      })
    
    output$plot1 <- renderPlot({
      g + geom_density(alpha=0.2) + 
        ggtitle(expression(atop('Employees per Evening vs. Inferred Number of Employees (STL)',
                                atop(italic('Based on a 10 hour day'), "")))) +
        theme(legend.position='bottom') + geom_vline(xintercept=prediction(), colour='red')
    })
      
    
})
    
