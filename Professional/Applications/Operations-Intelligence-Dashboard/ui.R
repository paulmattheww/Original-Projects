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
      menuItem('Production', tabName='production', icon=icon('wrench')),
      menuItem('Breakage', tabName='breakage', icon=icon('trash')),
      menuItem('Unsaleables', tabName='unsaleables', icon=icon('exclamation-triangle')),
      menuItem('Velocity', tabName='velocity', icon=icon('flag-checkered'))
    )
  ),
  
  dashboardBody(
    
    tabItems(
      
      tabItem(tabName='dashboard',
              
              fluidRow( 
                valueBoxOutput('cases_delivered'),
                valueBoxOutput('cases_delivered_ly'),
                valueBoxOutput('cases_delivered_delta'),
                
                valueBoxOutput('oddball_cases'),
                valueBoxOutput('oddball_cases_ly'),
                valueBoxOutput('oddball_cases_delta'),
                
                valueBoxOutput('cpmh'),
                valueBoxOutput('cpmh_ly'),
                valueBoxOutput('cpmh_delta'),
                
                valueBoxOutput('man_hours'),
                valueBoxOutput('man_hours_ly'),
                valueBoxOutput('man_hours_delta'),
                
                valueBoxOutput('employees_on_hand'),
                valueBoxOutput('employees_on_hand_ly'),
                valueBoxOutput('employees_on_hand_delta'),
                
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
                
              )),
      
      tabItem(tabName='breakage', 
              
              fluidRow(
                selectInput('driver_warehouse', 'Warehouse or Driver Breakage',
                            choice=c('Warehouse', 'Drivers')),
                
                wellPanel(plotOutput('cum_breakage_plot')),
                
                dataTableOutput('breakage_data')
              )
      ),
      
      tabItem(tabName='unsaleables',
              
              fluidRow(
                selectInput('unsaleables_facet', 'View Unsaleables by...',
                            choice=c('Item', 'Supplier', 'Customer')),
                
                dataTableOutput('unsaleable_data')
              )
      ),
      
      tabItem(tabName='velocity', 
              valueBoxOutput('g_line_cases'),
              valueBoxOutput('g_line_percent'),
              valueBoxOutput('g_line_unique'),
              
              valueBoxOutput('d_line_cases'),
              valueBoxOutput('d_line_percent'),
              valueBoxOutput('d_line_unique'),
              
              valueBoxOutput('c_line_cases'),
              valueBoxOutput('c_line_percent'),
              valueBoxOutput('c_line_unique'),
              
              valueBoxOutput('e_line_cases'),
              valueBoxOutput('e_line_percent'),
              valueBoxOutput('e_line_unique'),
              
              valueBoxOutput('o_line_cases'),
              valueBoxOutput('o_line_percent'),
              valueBoxOutput('o_line_unique'),
              
              valueBoxOutput('f_line_cases'),
              valueBoxOutput('f_line_percent'),
              valueBoxOutput('f_line_unique'),
              
              valueBoxOutput('w_line_cases'),
              valueBoxOutput('w_line_percent'),
              valueBoxOutput('w_line_unique'),
              
              valueBoxOutput('a_line_btls'),
              valueBoxOutput('a_line_percent'),
              valueBoxOutput('a_line_unique'),
              
              valueBoxOutput('b_line_btls'),
              valueBoxOutput('b_line_percent'),
              valueBoxOutput('b_line_unique'),
              
              fluidRow(
                dataTableOutput('velocity_summary'))
              
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
