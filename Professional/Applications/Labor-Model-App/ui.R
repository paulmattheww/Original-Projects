library(shiny)

shinyUI(fluidPage(
  titlePanel("Number of Employees Needed, Shipping St. Louis"),
  
  mainPanel(
    helpText("Select the number of cases."),
    
    sliderInput("Cases",
                "NUMBER OF CASES:",
                min=0,
                max=30000,
                value=13253),
    
    h2(textOutput('Predicted.Number')),
    
    plotOutput('plot1'),
    
    textOutput('text1'),
    
    p('This forecast does not account for special projects. 
      Add in the number of hours needed for special projects.')
    
  )
))
