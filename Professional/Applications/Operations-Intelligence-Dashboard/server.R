# server.R
library(shiny)
library(shinydashboard)
library(xlsx)
library(scales)


primary_dataset = 1

stl_production_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/stl_production_dashboard_summary.csv', header=TRUE)
kc_production_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/kc_production_dashboard_summary.csv', header=TRUE)


shinyServer(
  function(input, output) {
    
    house = reactive({
      ifelse(input$house == 'Saint Louis', 'STL', 'KC')
    })
    
    reactive_dataset = reactive({
      file_name = 'na'
    })
    
    output$cases_delivered = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((stl_production_summary[1, 2])), 
               scales::comma((kc_production_summary[1, 2]))), 
        'Cases Produced', icon=icon('credit-card')
      )
    })
    
    output$cpmh = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((round(stl_production_summary[5, 2], 2))), 
               scales::comma((round(kc_production_summary[5, 2], 2)))), 
        'Cases / Man Hour', icon=icon('list')
      )
    })
    
    output$man_hours = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((stl_production_summary[7, 2])), 
               scales::comma((round(kc_production_summary[7, 2], 2)))), 
        'Man Hours', icon=icon('list')
      )
    })
    
    output$ot_hours = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((stl_production_summary[5, 2])), 
               scales::comma((round(kc_production_summary[5, 2], 2)))), 
        'Overtime Hours', icon=icon('list')
      )
    })
    
    output$total_breakage = renderValueBox({
      valueBox(
        25 * 2, 'Total Breakage ($)', icon=icon('list')
      )
    })
    
    output$ytd_breakage = renderValueBox({
      valueBox(
        25 * 2, 'YTD Breakage ($)', icon=icon('list')
      )
    })
    
  })

