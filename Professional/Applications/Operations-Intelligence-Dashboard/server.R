# server.R
library(shiny)
library(shinydashboard)
library(xlsx)
library(scales)
library(ggplot2)
library(ggthemes)


primary_dataset = 1

stl_production_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/stl_production_dashboard_summary.csv', header=TRUE)
kc_production_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/kc_production_dashboard_summary.csv', header=TRUE)

stl_breakage_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/stl_breakage_dashboard_summary_feb16.csv', header=TRUE)
kc_breakage_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/kc_breakage_dashboard_summary_feb16.csv', header=TRUE)

stl_breakage_driver = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/stl_breakage_driver_items_feb16.csv', header=TRUE)
kc_breakage_driver = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/kc_breakage_driver_items_feb16.csv', header=TRUE)

stl_breakage_warehouse = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/stl_breakage_warehouse_items_feb16.csv', header=TRUE)
kc_breakage_warehouse = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/kc_breakage_warehouse_items_feb16.csv', header=TRUE)

stl_breakage_master = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/stl_breakage_master_dataset_feb16.csv', header=TRUE)
kc_breakage_master = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/kc_breakage_master_dataset_feb16.csv', header=TRUE)


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
        'Cases Shipped', icon=icon('truck')
      )
    })
    
    output$cases_delivered_ly = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((stl_production_summary[1, 3])), 
               scales::comma((kc_production_summary[1, 3]))), 
        'Cases Shipped LY', icon=icon('truck')
      )
    })
    
    output$cases_delivered_delta = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::percent((round(stl_production_summary[1, 4], 4))), 
               scales::percent((round(kc_production_summary[1, 4], 4)))), 
        'Year-Over-Year Change', icon=icon('truck')
      )
    })
    
    output$cpmh = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((round(stl_production_summary[5, 2], 2))), 
               scales::comma((round(kc_production_summary[5, 2], 2)))), 
        'Cases / Man Hour', icon=icon('gears')
      )
    })
    
    output$cpmh_ly = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((round(stl_production_summary[5, 3], 2))), 
               scales::comma((round(kc_production_summary[5, 3], 2)))), 
        'Cases / Man Hour LY', icon=icon('gears')
      )
    })
    
    output$cpmh_delta = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::percent((round(stl_production_summary[5, 4], 4))), 
               scales::percent((round(kc_production_summary[5, 4], 4)))), 
        'Year-Over-Year Change', icon=icon('gears')
      )
    })
    
    output$errors = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((stl_production_summary[9, 2])), 
               scales::comma((round(kc_production_summary[9, 2], 2)))), 
        'Errors', icon=icon('frown-o')
      )
    })
    
    output$errors_ly = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((stl_production_summary[9, 3])), 
               scales::comma((round(kc_production_summary[9, 3], 2)))), 
        'Errors LY', icon=icon('frown-o')
      )
    })
    
    output$errors_delta = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::percent((round(stl_production_summary[9, 4], 4))), 
               scales::percent((round(kc_production_summary[9, 4], 4)))), 
        'Year-Over-Year Change', icon=icon('frown-o')
      )
    })
    
    output$man_hours = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((round(stl_production_summary[7, 2]))), 
               scales::comma((round(kc_production_summary[7, 2])))), 
        'Man Hours', icon=icon('users')
      )
    })
    
    output$man_hours_ly = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((round(stl_production_summary[7, 3]))), 
               scales::comma((round(kc_production_summary[7, 3])))), 
        'Man Hours LY', icon=icon('users')
      )
    })
    
    output$man_hours_delta = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::percent((round(stl_production_summary[7, 4], 4))), 
               scales::percent((round(kc_production_summary[7, 4], 4)))), 
        'Year-Over-Year Change', icon=icon('users')
      )
    })
    
    output$total_breakage = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::dollar((round(stl_breakage_summary[7, 2]))), 
               scales::dollar((round(kc_breakage_summary[7, 2])))), 
        'YTD Warehouse Breakage', icon=icon('trash-o')
      )
    })
    
    output$total_breakage_ly = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::dollar((round(stl_breakage_summary[7, 5]))), 
               scales::dollar((round(kc_breakage_summary[7, 5])))), 
        'YTD Warehouse Breakage LY', icon=icon('trash-o')
      )
    })
    
    output$total_breakage_delta = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::percent((round(stl_breakage_summary[7, 8], 4))), 
               scales::percent((round(kc_breakage_summary[7, 8], 4)))), 
        'Year-Over-Year Change', icon=icon('trash-o')
      )
    })
    
    output$driver_breakage = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::dollar((round(stl_breakage_summary[8, 2]))), 
               scales::dollar((round(kc_breakage_summary[8, 2])))), 
        'YTD Driver Breakage', icon=icon('trash-o')
      )
    })
    
    output$driver_breakage_ly = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::dollar((round(stl_breakage_summary[8, 5]))), 
               scales::dollar((round(kc_breakage_summary[8, 5])))), 
        'YTD Driver Breakage LY', icon=icon('trash-o')
      )
    })
    
    output$driver_breakage_delta = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::percent((round(stl_breakage_summary[8, 8], 4))), 
               scales::percent((round(kc_breakage_summary[8, 8], 4)))), 
        'Year-Over-Year Change', icon=icon('trash-o')
      )
    })
    
    
    
    # for plot tab
    
    breaks = reactive({
      if(input$house=='Saint Louis') { 
        breaks = stl_breakage_master
        } 
      if(input$house=='Kansas City') {
        breaks = kc_breakage_master
      }
      
      breaks$Month = factor(breaks$Month, levels=c('January','February','March','April','May','June','July',
                                                   'August','September','October','November','December'))
      breaks$Type = factor(breaks$Type, levels=c('Liquor (1)', 'Wine (2)', 'Beer (3)', 'Non-Alc (4)'))
      breaks
    })
    
    break_plot_title = reactive({
      if(input$house=='Saint Louis' & input$driver_warehouse=='Warehouse'){
        title = 'YTD Breakage, STL Warehouse'
      }
      if(input$house=='Saint Louis' & input$driver_warehouse=='Drivers'){
        title = 'YTD Breakage, STL Drivers'
      }
      if(input$house=='Kansas City' & input$driver_warehouse=='Warehouse'){
        title = 'YTD Breakage, KC Warehouse'
      }
      if(input$house=='Kansas City' & input$driver_warehouse=='Drivers'){
        title = 'YTD Breakage, KC Drivers'
      }
      title
    })
    
    output$cum_breakage_plot = renderPlot({
      
      p = ggplot(breaks(), aes(factor(Month), y=YTD.Warehouse.Cost))
      p =  p + geom_point(aes(group=factor(Type))) + 
        geom_line(aes(x=factor(Month), y=YTD.Warehouse.Cost, colour=factor(Type),
                      group=factor(Type))) +
        theme(legend.position='bottom', axis.text.x=element_text(angle=90, hjust=1)) + 
        labs(title=break_plot_title(),
             x="Month", y="Dollars") +
        facet_wrap(~Year, nrow=1) +
        scale_y_continuous(labels=dollar)
      print(p)
    })
    
    
    
    
    
    
    # for breakage report tab
   
    output$breakage_data = renderDataTable({
      if(input$house=='Saint Louis' & input$driver_warehouse=='Warehouse') {
        data = stl_breakage_warehouse
      }
      if(input$house=='Saint Louis' & input$driver_warehouse=='Drivers') {
        data = stl_breakage_driver
      }
      if(input$house=='Kansas City' & input$driver_warehouse=='Warehouse') {
        data = kc_breakage_warehouse
      } 
      if(input$house=='Kansas City' & input$driver_warehouse=='Drivers') {
        data = kc_breakage_driver
      }
      data
    })
    
    
    
    
    
  })

