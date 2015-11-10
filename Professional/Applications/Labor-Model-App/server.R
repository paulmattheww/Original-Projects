# server.R
library(shiny)
library(caret)
library(ggplot2)
library(gridExtra)
library(ggthemes)
library(ggExtra)
library(dplyr)
library(lubridate)


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
x <- ggplot(data=myData, aes(x=TOTAL.STL.CASES, y=INFERRED.NIGHT.EMPLOYEES))

dayShift <- 8
nightShift <- 10

shinyServer(
  function(input, output) {
   
    prediction <- reactive({ 
      round(nightInterceptStl + input$Cases * nightSlopeCasesStl, 1) 
      })
    
    goodPrediction <- reactive({ 
      round(prediction() + (input$SpecialHours / nightShift), 1)
      })
    
    output$Predicted.Number <- renderText({ paste('Shipping Employees Needed:', goodPrediction()) 
      })
    
    output$plot1 <- renderPlot({
      g + geom_density(alpha=0.4) + 
        ggtitle(expression(atop('Employees per Evening (STL)',
                                atop(italic('Based on a 10 hour day'), "")))) +
        theme(legend.position='bottom') + geom_vline(xintercept=goodPrediction(), colour='red') +
        labs(x='Number of Night Shift Employees') + geom_rug(aes(colour=Type)) + 
        theme_pander()
    }, height=250)
      
    output$plot2 <- renderPlot({
      p + geom_density(alpha=0.4, fill='green') + 
        ggtitle(expression(atop('Distribution of Daily Cases (STL)',
                                atop(italic('Based on 2015 data Jan - Sept'), "")))) +
        theme(legend.position='bottom') + geom_vline(xintercept=input$Cases, colour='red') +
        labs(x='Total Cases Produced (Daily)') + geom_rug() +
        theme_pander() 
    }, height=250)
    
    output$plot3 <- renderPlot({
      x + geom_point() + 
        geom_smooth(method="lm", se=T, colour='black') +
        labs(title="Number of Employees as a funciton of Total Cases (STL)",
             x="Total Cases STL", y="Number of Employees (Inferred from Hours) STL") +
        theme_pander() + geom_vline(xintercept=input$Cases, colour='blue') +
        geom_hline(yintercept=goodPrediction(), colour='blue') + geom_rug()
    }, height=400, width=550)
    
    CPMH <- reactive({
      round(input$Cases / (round(goodPrediction(), 0) * 10), 2)
    })
    
    output$cpmhText <- renderText({
      paste('If all', goodPrediction(), 'employees work a 10 hour day, then we will achieve a CPMH of', CPMH())
    })
    
    monthAvg <- reactive({
      as.matrix(myData %>% filter(MONTH == input$Month) %>% 
         select(one_of(c('MONTH', 'INFERRED.NIGHT.EMPLOYEES', 'TOTAL.STL.CASES'))))
    })
    
    avgWorkersMonth <- reactive({
      round(mean(monthAvg()[,2]), 1)
    })
    
    maxDay <- reactive({
      round(max(monthAvg()[,2]), 1)
    })
    
    totalCases <- reactive({
      round(mean(monthAvg()[,3]))
    })
    
    output$avgWorkersMonth <- renderText({
      paste('For the month selected, the average nightly shipping employees needed was', avgWorkersMonth(), 
            'while the maximum number of shipping employees needed was', maxDay(),'. 
            This month saw an average of', totalCases(), 'cases produced per production day.')
    })
    
})
    
