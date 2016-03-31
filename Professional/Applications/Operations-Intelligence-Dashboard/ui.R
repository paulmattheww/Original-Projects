library(shiny)
library(shinydashboard)


dashboardPage(skin='red',
  dashboardHeader(title='Operations VP/Director Dashboard',
                  titleWidth = 350),
  
  dashboardSidebar(width=250,
    sidebarMenu(
      selectInput('house', 'Choose House',
                  choice=c('Saint Louis', 'Kansas City')),
      menuItem('Dashboard', tabName='dashboard', icon=icon('dashboard')),
      menuItem('Plots', tabName='plots', icon=icon('bar-chart-o')),
      menuItem('Production', tabName='production', icon=icon('th')),
      menuItem('Breakage', tabName='breakage', icon=icon('th')),
      menuItem('Unsaleables', tabName='unsaleables', icon=icon('th')),
      menuItem('Velocity', tabName='velocity', icon=icon('th'))
    )
  ),
  
  dashboardBody(
    
    tabItems(
      
      tabItem(tabName='dashboard',
              
              fluidRow( 
                valueBoxOutput('cases_delivered'),
                valueBoxOutput('cases_delivered_ly'),
                valueBoxOutput('cases_delivered_delta'),
                
                valueBoxOutput('cpmh'),
                valueBoxOutput('cpmh_ly'),
                valueBoxOutput('cpmh_delta'),
                
                valueBoxOutput('man_hours'),
                valueBoxOutput('man_hours_ly'),
                valueBoxOutput('man_hours_delta'),
                
                valueBoxOutput('errors'),
                valueBoxOutput('errors_ly'),
                valueBoxOutput('errors_delta'),
                
                valueBoxOutput('total_breakage'),
                valueBoxOutput('total_breakage_ly'),
                valueBoxOutput('total_breakage_delta'),
                
                valueBoxOutput('driver_breakage'),
                valueBoxOutput('driver_breakage_ly'),
                valueBoxOutput('driver_breakage_delta')
                
              )
      ),
      
      tabItem(tabName='plots',
              
              fluidRow(
                plotOutput('cum_breakage_plot')
              )),
      
      tabItem(tabName='breakage', 
              
              fluidRow(
                selectInput('driver_warehouse', 'Warehouse or Driver Breakage',
                            choice=c('Warehouse', 'Drivers')),
                
                dataTableOutput('breakage_data')
              )
      ),
      
      tabItem(tabName='production', 
              fluidRow(
                box(title='Test2', solidHeader=TRUE, status='primary', collapsable=TRUE, background='black')
              )
      )
    )
  )
)







































# runApp('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard')
