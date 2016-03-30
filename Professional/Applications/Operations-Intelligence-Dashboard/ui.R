library(shiny)
library(shinydashboard)


dashboardPage(
  dashboardHeader(title='Operations Dashboard'),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem('Dashboard', tabName='dashboard', icon=icon('dashboard')),
      menuItem('Plots', tabName='plots', icon=icon('bar-chart-o')),
      menuItem('Production', tabName='production', icon=icon('th')),
      menuItem('Breakage', tabName='breakage', icon=icon('th')),
      menuItem('Unsaleables', tabName='unsaleables', icon=icon('th')),
      menuItem('Velocity', tabName='velocity', icon=icon('th'))
    )
  ),
  
  dashboardBody(
    # boxes need be in row or column
    tabItems(
      # first tab content
      tabItem(tabName='dashboard',
              fluidRow(
                box(title='Operations Intelligence Dashboard', solidHeader=TRUE, status='primary', collapsable=TRUE)
              )
      ),
      
      tabItem(tabName='production', 
              fluidRow(
                box('Test2')
              )
      )
    )
  )
)







































# runApp('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard')
