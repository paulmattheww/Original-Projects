library(shiny)

shinyUI(fluidPage(
  titlePanel("Number of Employees Needed, Shipping St. Louis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Select the number of cases."),
      sliderInput("Cases",
                  "NUMBER OF CASES:",
                  min=0,
                  max=30000,
                  value=13253)
      ),
    
    mainPanel(
      plotOutput("plot"))
  ),
  
  mainPanel(
    textOutput('text1'),
    textOutput('Predicted.Number'),
    textOutput('text2')
  )
))
