library(shiny)
library(shinydashboard)


dashboardPage(skin='red',
  dashboardHeader(title='Operations Dashboard',
                  titleWidth = 350),
  
  dashboardSidebar(width=300,
    sidebarMenu(
      selectInput('house', 'Warehouse',
                  choice=c('Saint Louis', 'Kansas City')),
      dateRangeInput('dates', label = 'Date Range', 
                     start='2015-03-01', end='2015-03-31',
                     min='2015-01-01', max=as.character(strptime(Sys.Date(), format='%Y-%m-%d'))),
      menuItem('Dashboard', tabName='dashboard', icon=icon('dashboard')),
      menuItem('Breakage', tabName='breakage', icon=icon('trash')),
      menuItem('Unsaleables', tabName='unsaleables', icon=icon('exclamation-triangle'),
               menuSubItem('Top 15 Items/Suppliers', tabName='top_15_plot'),
               menuSubItem('Detailed Data', tabName='unsaleable_detail')),
      menuItem('Velocity', tabName='velocity', icon=icon('flag-checkered'),
               menuSubItem('Saint Louis', tabName='STL'),
               menuSubItem('Kansas City', tabName='KC'),
               menuSubItem('Summary', tabName='velocity_summary')),
      menuItem('Plots', tabName='plots', icon=icon('bar-chart-o')),
      menuItem('Production', tabName='production', icon=icon('wrench')),
      menuItem('Route Execution', tabName='routes', icon=icon('wrench')),
      menuItem('Trucks & Equipment', tabName='trucks', icon=icon('wrench')),
      menuItem('Transfers', tabName='transfers', icon=icon('wrench')),
      menuItem('Off-Day Deliveries', tabName='off_day', icon=icon('wrench')),
      menuItem('Returns', tabName='returns', icon=icon('wrench')),
      menuItem('Man Hours', tabName='man_hours', icon=icon('wrench')),
      menuItem('Inventory Receipts', tabName='receipts', icon=icon('wrench')),
      menuItem('Empty Keg Transfers', tabName='empty_kegs', icon=icon('wrench')),
      menuItem('Inventory Adjustments', tabName='adjustments', icon=icon('wrench')),
      menuItem('Out of Stock', tabName='oos', icon=icon('wrench'))
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
              
              
              selectInput('driver_warehouse', 'Warehouse or Driver Breakage',
                          choice=c('Warehouse', 'Drivers')),
              
              wellPanel(plotOutput('cum_breakage_plot')),
              
              dataTableOutput('breakage_data')
              
      ),
      
      tabItem(tabName='top_15_plot',
              
              fluidRow(
                selectInput('unsaleables_variable', 'View Dumps, Returns or Total',
                            choice=c('Total Unsaleables by Case', 'Total Unsaleables by Dollar',
                                     'Dumps by Case', 'Dumps by Dollar', 
                                     'Returns by Case', 'Returns by Dollar' )),
                
                plotOutput('unsaleable_plot')
                
              )
      ),
      
      tabItem(tabName='unsaleable_detail',
              selectInput('unsaleables_facet', 'View Unsaleables by...',
                          choice=c('Item', 'Supplier')), #'Customer' out
              
              dataTableOutput('unsaleable_data')),
      
      tabItem(tabName='STL', 
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
              valueBoxOutput('b_line_unique')
              
              
              
      ),
      
      tabItem(tabName='KC', 
              valueBoxOutput('c_100'),
              valueBoxOutput('c_100_percent'),
              valueBoxOutput('c_100_unique'),
              
              valueBoxOutput('c_200'),
              valueBoxOutput('c_200_percent'),
              valueBoxOutput('c_200_unique'),
              
              valueBoxOutput('c_300'),
              valueBoxOutput('c_300_percent'),
              valueBoxOutput('c_300_unique'),
              
              valueBoxOutput('c_400'),
              valueBoxOutput('c_400_percent'),
              valueBoxOutput('c_400_unique'),
              
              valueBoxOutput('odd'),
              valueBoxOutput('odd_percent'),
              valueBoxOutput('odd_unique'),
              
              valueBoxOutput('wine'),
              valueBoxOutput('wine_percent'),
              valueBoxOutput('wine_unique')#,
              
#               valueBoxOutput('a_rack'),
#               valueBoxOutput('a_rack_percent'),
#               valueBoxOutput('a_rack_unique'),
#               
#               valueBoxOutput('b_rack'),
#               valueBoxOutput('b_rack_percent'),
#               valueBoxOutput('b_rack_unique')
      ),
      
      
      tabItem(tabName='velocity_summary',
              dataTableOutput('velocity_summary'))#,
    
#       tabItem(tabName='production', 
#               plotOutput('cases_by_line')
      # )
    )
  )
)







































# runApp('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard')
