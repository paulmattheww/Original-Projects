# server.R
library(shiny)
library(caret)
library(ggplot2)
library(gridExtra)


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
p <- ggplot(data=myData, aes(TOTAL.STL.CASES))

dayShift <- 8
nightShift <- 10

shinyServer(
  function(input, output) {
    
    output$text1 <- renderText({
      paste('You selected', input$Cases, 'cases to be used in this forecast.')
    })
    
    prediction <- reactive({ round(nightInterceptStl + input$Cases * nightSlopeCasesStl, 1) 
      })
    
    goodPrediction <- reactive({ round(prediction() + (input$SpecialHours / nightShift), 1)
      })
    
    output$Predicted.Number <- renderText({ paste('Shipping Employees Needed:', goodPrediction()) 
      })
    
    output$plot1 <- renderPlot({
      g + geom_density(alpha=0.4) + 
        ggtitle(expression(atop('Employees per Evening vs. Inferred Number of Employees (STL)',
                                atop(italic('Based on 2015 data Jan - Sept'), "")))) +
        theme(legend.position='bottom') + geom_vline(xintercept=goodPrediction(), colour='red') +
        labs(x='Number of Night Shift Employees') + geom_rug()
    })
      
    output$plot2 <- renderPlot({
      p + geom_density(alpha=0.4, fill='green') + 
        ggtitle(expression(atop('Disitrubtion of Daily Cases (STL)',
                                atop(italic('Based on a 10 hour day'), "")))) +
        theme(legend.position='bottom') + geom_vline(xintercept=input$Cases, colour='red') +
        labs(x='Total Cases Produced (Daily)') + geom_rug()
    })
    
})
    
