library(shiny)
library(shinydashboard)


dashboardPage(skin='red',
  dashboardHeader(title='Operations Intelligence Dashboard',
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
                
                valueBoxOutput('cpmh'),
                
                valueBoxOutput('total_breakage'),
                
                valueBoxOutput('ytd_breakage')
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
