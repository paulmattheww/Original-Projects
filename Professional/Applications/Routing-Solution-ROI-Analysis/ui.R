library(shiny)

shinyUI(fluidPage(
  titlePanel("Roadnet ROI Simulator"),
  
  mainPanel(
    plotOutput('plot1'),
    
    tabsetPanel(
      tabPanel('Facts & Assumptions', 
               h3('Facts & Assumptions'),
               p('KC mileage data was unavailable at the time of data gather. 
                  This increases uncertainty surrounding being capable of 
                  combining routes that are underutilized by capacity and proximity alone. 
                  It is still likely that overall capacity utilization will increase, even amongst crowded routes.'),
               p('Rural routes are more difficult to combine, even on a daily basis, 
                 due to the large number of miles that they travel per day.')),
      
      tabPanel('Reactively Generated Data', 
                dataTableOutput('data')),
    
      tabPanel('User-Set Parameters',
        fluidRow(
          numericInput("negotiations",
                       label="Negotiate Annual Roadnet Fee w/o Telematics (Quote of $79,002/yr):",
                       value=79002.12),
          
          sliderInput("fuel",
                      "Annual % Savings in Fuel Consumption:",
                      min=-0.01,
                      max=0.15,
                      value=0.03),
          
          sliderInput("driver",
                      "Annual % Savings in Driver Compensation:",
                      min=-0.01,
                      max=0.15,
                      value=0.02),
          
          sliderInput("truck",
                      "Probability of 1 Truck Off Road by March 2017:",
                      min=0.01,
                      max=0.99,
                      value=0.5),
          
          sliderInput("inflator",
                      "Implementation & Consulting Cost Inflator:",
                      min=1.0,
                      max=2.0,
                      value=1.0),
          
          numericInput("telematics",
                       label="Annual Telematics Cost ($19,171):",
                       value=0),
          
          numericInput("maintenance",
                       label="Anticipated Savings on Maintenance ($/mo):",
                       value=0),
          
          numericInput("analyst",
                       label="Value of Having Vital Operational Data & Advanced Analytics ($/mo):",
                       value=0),
          
          numericInput("router",
                       label="Anticipated Savings to Router's Time ($/mo):",
                       value=0))),
        

    br()

  )
)))
