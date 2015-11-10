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
    
    selectInput("Month",
                 label="CHOOSE A MONTH",
                 c('January'='1', 'February'='2', 'March'='3',
                   'April'='4', 'May'='5', 'June'='6',
                   'July'='7', 'August'='8'))),
    
    h4(textOutput('avgWorkersMonth')),
    
    br(),
    
    br(),
    
    p('This forecast is based on a linear regression model. All variables were considered 
      carefully prior to making the model. The data used to train this model is January through
      August of 2015. Annomalous days were removed, such as the first week of January. This model 
      can be trained further as time goes on to improve accuracy.')
    
  )
))
