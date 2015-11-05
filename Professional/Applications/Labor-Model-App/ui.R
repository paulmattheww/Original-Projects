library(shiny)

shinyUI(fluidPage(
  titlePanel("Labor Support Tool for Saint Louis Hourly Associates"),
  
  mainPanel(
    div(plotOutput('plot1', width="100%")),
    
    fluidRow(
      sliderInput("Cases",
                  "NUMBER OF CASES:",
                  min=0,
                  max=30000,
                  value=13253),
      numericInput("SpecialHours",
                   label="PLANNED SPECIAL PROJECT HOURS:",
                   value=0),
    
    div(plotOutput('plot2', width="100%")),
    
    h2(textOutput('Predicted.Number')),
    
    textOutput('text1'),
    
    p('This forecast does not account for special projects. 
      Add in the number of hours needed for special projects.')
    
  )
)))
