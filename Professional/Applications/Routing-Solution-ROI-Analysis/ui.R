library(shiny)

shinyUI(fluidPage(
  titlePanel("Roadnet ROI Simulator"),
  
  mainPanel(
    plotOutput('plot1'),
    
    tabsetPanel(
      tabPanel('Key Considerations', 
               h3('Key Considerations'),
               p('This tool can be used in negotiations by running what-if scenarios in real time.'),
               p('Finance\'s numbers for total statewide driver compensation is $5.45MM, 
                 however initial numbers were estimated at $4.2MM.'),
               p('Last year we consumed 524,570 gallons of diesel at a weighted average price of 
                 $2.54/gal. This analysis assumes 8% inflation over this price per gallon.'),
               p('KC mileage data was unavailable at the time of data gather. 
                 This increases uncertainty surrounding being capable of 
                 combining entire routes that are underutilized by capacity & route proximity alone. 
                 It is still likely that overall capacity utilization will increase, even amongst crowded routes.'),
               p('Rural routes are more difficult to combine, even on a daily basis, 
                 due to the large number of miles that they travel per day.'),
               p('While it will be more expensive to do Telematics, we are have considerably less 
                 certainty on fuel savings if we do not have it. We will also have less visibility into 
                 driving habits of associates.'),
               p('Currently, Ops data is sub-optimally organized. Roadnet will solve many
                 of our operational data issues, and will lay the foundation for further exploration.
                 It will also create a wonderful foundation for a BI tool, and will likely work in concert with said tool.'),
               p('There are definitive plans to replace the AS400 with a new ERP system. Currently routing is done through 
                 the AS400, so if we do not move forward with Roadnet then we will still need to 
                 identify a solution for routing in the new system. '),
               p('There are likely to be many behavioral implications with Roadnet. We will need 
                 new onboarding paperwork, cell software orientation, and an initial meeting with 
                 all drivers to ensure they know how things will change. We will also
                 need to set up new SOPs for routers to maintain data, and establish expectations/responsibilities.'),
               p('STL drivers are paid by the case; this incentive may not align with the goal of saving fuel.'),
               p('Sales cut-offs will need to be uniformly enforced statewide. Currently STL is more 
                 lenient than KC.')),
      
      tabPanel('Reactively Generated Data', 
               dataTableOutput('data')),
      
      tabPanel('User-Defined Parameters',
               fluidRow(
                 column(12, wellPanel(
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
                                label="Annual Telematics Cost ($19,171 or $0):",
                                value=0),
                   
                   numericInput("safety",
                                label="Anticipated Savings from Improved Safety ($/mo):",
                                value=0),
                   
                   numericInput("analyst",
                                label="Value of Improved Data Organization & Advanced Analytics ($/mo):",
                                value=0),
                   
                   numericInput("router",
                                label="Anticipated Savings -OR- Costs to Router's Time ($/mo):",
                                value=0))))),
      
      tabPanel('Key Outputs', wellPanel(
               h3('Key Outputs'),
               br(),
               downloadButton('downloadData', 'Download Version'),
               br(),
               br(),
               h4('Return at end of year 3:'), 
               p(textOutput('net_savings_year_3')),
               br(),
               h4('Number of months til positive returns:'), 
               p(textOutput('months_to_roi')),
               br(),
               h4('Number of miles saved per truck per production day:'), 
               p(textOutput('miles_saved_per_truck')),
               br())
      ),
      
      
      br()
      
))))
