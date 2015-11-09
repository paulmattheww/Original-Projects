library(shiny)

shinyUI(fluidPage(
  titlePanel("Labor Support Tool for Saint Louis Hourly Associates"),
  
  mainPanel(
    plotOutput('plot3'),
    
    br(),
    
    fluidRow(
      splitLayout(
        sliderInput("Cases",
                    "NUMBER OF CASES:",
                    min=0,
                    max=30000,
                    value=13253),
        numericInput("SpecialHours",
                     label="PLANNED SPECIAL PROJECT HOURS:",
                     value=0)),
    
    h2(textOutput('Predicted.Number')),
    
    textOutput('cpmhText'),
    
    br(),
    
    splitLayout(cellWidths = c('50%','50%'),
                plotOutput('plot1'),
                plotOutput('plot2')),

    br(),
    
    numericInput("Month",
                 label="CHOOSE A MONTH",
                 value=1)),
    
    textOutput('avgWorkersMonth'),
    
    br(),
    
    br(),
    
    p('This forecast is based on a linear regression model. All variables were considered carefully prior to making the model.')
    
  )
))
