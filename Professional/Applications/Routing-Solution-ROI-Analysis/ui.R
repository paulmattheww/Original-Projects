library(shiny)

shinyUI(fluidPage(
  titlePanel("Roadnet ROI Simulator"),
  
  mainPanel(
    plotOutput('plot1'),
    
    tabsetPanel(
      tabPanel('Key Considerations', 
               h3('Key Considerations'),
               p('This tool can be used in negotiations by running what-if scenarios in real time, even with
                 the vendor present.'),
               p('All figures in this model were carefully procured from Subject-Matter Experts. All
                 arithmetic has been checked for accuracy.'),
               p('Statewide driver compensation in 2015 was $5.45MM, 
                 which was used as a base for percentage delivery savings. However, it is assumed
                 that STL will not see the same savings due to the fact that drivers are 
                 paid by the case and not by the hour. Thus, STL is adjusted out of the savings for labor.'),
               p('Last year we consumed 524,570 gallons of diesel at a weighted average price of 
                 $2.54/gal. This analysis assumes 8% inflation over this price per gallon. 
                 It is assumed that KC will save only 0.3 gallons of fuel for every 1 gallon STL stands
                 to save from the implementation of Roadnet.'),
               p('KC mileage data was unavailable at the time of data gather. 
                 This increases uncertainty surrounding being capable of 
                 combining entire routes that are underutilized by capacity & route proximity alone. 
                 It is still likely that overall capacity utilization will increase, even amongst crowded routes.'),
               p('Rural routes are more difficult to combine 
                 due to the large number of miles that they travel per day and time-constraints
                 placed on the number of hours drivers are allowed to work by law.'),
               p('While it will be more expensive to do Telematics, we have considerably less 
                 certainty on fuel savings if we do not have it. We will also have less visibility into 
                 driving habits of associates. The number of Telematics units is a variable that can
                 be changed using this tool. The reason for this is that we are likely to get the best 
                 bang-for-the-buck by using Telematics on long-haul, rural routes where the driver
                 is likely to spend considerable time each day driver over 60 miles per hour. By 
                 setting a speed-limit with Telematics we will be sure to gain some fuel savings.'),
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
               p('Sales cut-offs will need to be uniformly enforced statewide in order 
                 for the system to be used to its fullest potential. Currently STL is more 
                 lenient than KC.'),
               p('Our first truck lease is not up until March of 2017. If we are to get one truck off 
                 the road by this date then we will see an increased savings from April 2017 forward. 
                 The probability figure will discount these savings through simple multiplication.
                 Eliminating one truck is not a critical necesary condition to realizing an ROI,
                 and is much less important than we originally estimated.')),
      
      tabPanel('Reactively Generated Data', 
               dataTableOutput('data')),
      
      tabPanel('User-Defined Parameters',
               fluidRow(
                 column(12, wellPanel(
                   numericInput("negotiations",
                                label="Negotiate Annual Roadnet Fee w/o Telematics (Quote of $79,002/yr):",
                                value=79002.12),
                   
                   sliderInput("fuel",
                               "Annual % Savings in Fuel Consumption (KC assumed to save 0.3 gal for every 1 gal saved in STL):",
                               min=0.00,
                               max=0.15,
                               value=0.10),
                   
                   sliderInput("driver",
                               "Annual % Savings in Driver Hours (All houses except STL):",
                               min=0.00,
                               max=0.15,
                               value=0.028),
                   
                   sliderInput("n_telematics_units",
                               label="Number of Telematics Units to Install ($288/unit install plus estimated monthly cost per truck):",
                               min=0,
                               max=70,
                               value=0),
                   
                   sliderInput("truck",
                               "Probability of 1 Truck Off Road by March 2017:",
                               min=0.00,
                               max=1.00,
                               value=0.7),
                   
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
      
))))
# runApp('C:/Users/pmwash/Desktop/R_files/Applications/Roadnet ROI Simulator')


# runApp('C:/Users/pmwash/Desktop/R_files/Applications/Roadnet ROI Simulator')
