library(shiny)


# TESTING VERSION
# runApp('C:/Users/pmwash/Desktop/R_files/Applications/Roadnet ROI Simulator/TESTING')

shinyUI(fluidPage(
  titlePanel("Roadnet ROI Simulator"),
  
  mainPanel(
    plotOutput('plot1'),
      
      tabPanel('User-Defined Parameters',
               fluidRow(
                 column(12, wellPanel(
                   selectInput('product_selection',
                               label='Select Version of Product to Simulate',
                               choices=c('Cloud Routing Only'='C-R', 'On-Premise Routing Only'='OP-R',
                                         'Cloud Routing Dispatch Mobile'='C-RDM', 'On-Premise Routing Dispatch Mobile'='OP-RDM'),
                               selected='Cloud Routing Only'),
            
                   
                   sliderInput("fuel",
                               "Annual % Savings in Fuel Consumption (KC assumed to save 0.3 gal for every 1 gal saved in STL):",
                               min=0.00,
                               max=0.15,
                               value=0.03),
                   
                   sliderInput("driver",
                               "Annual % Savings in Driver Hours (All houses except STL):",
                               min=0.00,
                               max=0.15,
                               value=0.014),
                   
                   sliderInput("n_telematics_units",
                               label="Number of Telematics Units to Install ($288/unit install plus estimated monthly cost per truck):",
                               min=0,
                               max=70,
                               value=0),
                   
                   sliderInput("truck",
                               "Number of Trucks Off Road by March 2017:",
                               min=0.00,
                               max=2.00,
                               value=0.0),
                   
                   sliderInput("inflator",
                               "Initial Implementation & Consulting Cost Inflator:",
                               min=1.0,
                               max=2.0,
                               value=1.0),
                   
                   sliderInput("interest",
                               "Interest Rate for Net Present Value (Opportunity Cost of Foregone Returns from Alternative Investments):",
                               min=0,
                               max=0.20,
                               value=0.08),
                   
                   numericInput("safety",
                                label="Value of Organizational Clarity surrounding routing portion of ERP project ($/mo):",
                                value=0),
                   
                   numericInput("analyst",
                                label="Value of Improved Data Organization & Advanced Analytics ($/mo):",
                                value=0),
                   
                   numericInput("router",
                                label="Anticipated Savings -OR- Costs to Router's Time ($/mo):",
                                value=0)
                   
                   )))),


      tabPanel('Reactively Generated Data', 
               dataTableOutput('data')),
      

      tabPanel('Key Outputs', wellPanel(
               h3('Key Outputs'),
               br(),
               downloadButton('downloadData', 'Download Version'),
               br(), #discounted_net_savings_year_3
               br(),
               h4('Net present value at end of year 3:'), 
               p(textOutput('discounted_net_savings_year_3')),
               br(),
               h4('Un-discounted net savings at end of year 3:'), 
               p(textOutput('net_savings_year_3')),
               br(),
               h4('Number of months til positive returns:'), 
               p(textOutput('months_to_roi')),
               br(),
               h4('Number of miles saved per truck per production day:'), 
               p(textOutput('miles_saved_per_truck')),
               br(),
               h4('Minutes saved per driver per day:'), 
               p(textOutput('delivery_hours_saved')),
               br())
      ),
      
      
      br()
      
)))
# runApp('C:/Users/pmwash/Desktop/R_files/Applications/Roadnet ROI Simulator/TESTING')


