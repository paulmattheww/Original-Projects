library(shiny)

shinyUI(fluidPage(
  titlePanel('Mortgage Simulator & Calculator'),
  
  mainPanel(
    plotOutput('plot1'),
    
      tabsetPanel(
      
      tabPanel('Reactively Generated Data', 
               dataTableOutput('mortgage_data')),
      
      tabPanel('User-Defined Parameters',
               fluidRow(
                 column(12, wellPanel(
#                    selectInput('term', 
#                                label='Mortgage Term',
#                                choices=c('30 Year'=30, '15 Year'=15),
#                                value='30 Year'),
                   
                   numericInput("principal",
                                label="Home Value (USD$):",
                                value=236000),
                   
                   numericInput("down",
                                label="Percent Down Payment (%):",
                                value=0.20),
                   
                   numericInput('interest', 
                               'Annual Interest Rate of Loan (%):',
                               value=0.04),
                   
                   sliderInput('opportunity_cost', 
                                'Opportunity Cost of Capital (%):',
                                min = 0.00,
                                max = 0.15,
                                value=1.06))))),
                   
                  
                   
                   
      
      tabPanel('Key Outputs', 
               wellPanel(
                 h3('NPV of Cumulative Interest Over Life of Loan'),
                 p(textOutput('npv_interest')),
                 h3('Total Cost of Loan'),
                 p(textOutput('total_cost_of_loan')),
                 h3('Monthly Payment'),
                 p(textOutput('payment'))),
      
     
      br())
      
))))
