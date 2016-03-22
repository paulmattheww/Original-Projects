library(shiny)

shinyUI(fluidPage(
  titlePanel("Roadnet ROI Simulator"),
  
  mainPanel(
    plotOutput('plot1'),
    
    fluidRow(
      sliderInput("fuel",
                  "Savings in Fuel:",
                  min=-0.01,
                  max=0.15,
                  value=0.03),
      
      sliderInput("driver",
                  "Savings in Driver Compensation:",
                  min=-0.01,
                  max=0.15,
                  value=0.02),
      
      sliderInput("truck",
                  "Probability of 1 Truck Off Road by March 2017:",
                  min=0.01,
                  max=0.99,
                  value=0.5),
      
      sliderInput("inflator",
                  "Implementation Budget Overage:",
                  min=1.0,
                  max=2.0,
                  value=1.0),
      
      numericInput("telematics",
                   label="Telematics (Use $19,171 if simulating with Telematics):",
                   value=0),
      
      numericInput("maintenance",
                   label="Anticipated Savings on Maintenance:",
                   value=0),
      
      numericInput("analyst",
                   label="Anticipated Savings to Analyst's Time:",
                   value=0),
      
      numericInput("router",
                   label="Anticipated Savings to Router's Time:",
                   value=0),
    

    br()

  )
)))
