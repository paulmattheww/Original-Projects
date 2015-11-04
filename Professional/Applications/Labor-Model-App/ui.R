library(shiny)

shinyUI(fluidPage(
  titlePanel("Number of Employees Needed"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Select the number of cases to be thrown."),
      sliderInput("Cases",
                  "NUMBER OF CASES:",
                  min=1000,
                  max=30000,
                  value=13253)
      ),
    
    mainPanel(
      plotOutput("plot"))
  )
))
