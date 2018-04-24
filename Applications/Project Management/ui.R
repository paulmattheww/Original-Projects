library(shiny)
library(shinydashboard)
library(plotly)


#runApp('C:/Users/pmwash/Desktop/Project Management Tool/Project_Mgmt_Homebase')

dashboardPage(skin='black',
              dashboardHeader(title='Roadnet Phase II',
                              titleWidth = 250),
              
              dashboardSidebar(width=250,
                               sidebarMenu(
                                 # selectInput('project', 'Choose Project',
                                 #             choice=c('Saint Louis', 'Kansas City')),
                                 menuItem('High-Level Timeline', tabName='gantt_tab', icon=icon('binoculars')),
                                 menuItem('Detailed Timeline', tabName='timeline_tab', icon=icon('calendar')),
                                 menuItem('Risk Assessment', tabName='risk_tab', icon=icon('warning')),
                                 menuItem('Key Decisions', tabName='decision_tab', icon=icon('code-fork')),
                                 menuItem('Task Details', tabName='task_details_tab', icon=icon('tasks')),
                                 menuItem('Project Objectives', tabName='objectives_tab', icon=icon('bullseye')),
                                 menuItem('Mission Statement', tabName='mission_statement_tab', icon=icon('star-half-full')))
              ),
              
              dashboardBody(
                tabItems(
                  tabItem(tabName='gantt_tab',
                          wellPanel(fluidRow(plotOutput('GANTT_PLOT')))),
                  
                  tabItem(tabName='timeline_tab',
                          wellPanel(fluidRow(htmlOutput('TIMELINE_PLOT')))),
                    
                  tabItem(tabName='risk_tab',
                          fluidRow(
                            box(title='Risk Matrix', solidHeader=TRUE, status='primary', 
                                       plotlyOutput('RISK_PLOT', width='100%', height='600px')),
                            box(title='Risks Enumerated', solidHeader=TRUE, status='primary', 
                                       tableOutput('RISK_TABLE')))),
                  
                  tabItem(tabName='decision_tab',
                          fluidRow(
                            box(title='Decisions', solidHeader=TRUE, status='primary', 
                                wellPanel(fluidRow(tableOutput('DECISION_TABLE'))))))#,
                  
                  # tabItem(tabName='task_details_tab',
                  #         fluidRow(
                  #           box(title='Details', solidHeader=TRUE, status='primary', 
                  #               wellPanel(fluidRow(tableOutput('TASK_TABLE'))))))
                )
              )
)
