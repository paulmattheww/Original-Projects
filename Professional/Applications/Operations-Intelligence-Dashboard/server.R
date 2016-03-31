# server.R
library(shiny)
library(shinydashboard)
library(xlsx)
library(scales)
library(ggplot2)
library(ggthemes)


stl_production_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/stl_production_dashboard_summary.csv', header=TRUE)
kc_production_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/kc_production_dashboard_summary.csv', header=TRUE)

stl_production_data = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/stl_production_data_master.csv', header=TRUE)
kc_production_data = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/kc_production_data_master.csv', header=TRUE)

stl_breakage_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/stl_breakage_dashboard_summary_feb16.csv', header=TRUE)
kc_breakage_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/kc_breakage_dashboard_summary_feb16.csv', header=TRUE)

stl_breakage_driver = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/stl_breakage_driver_items_feb16.csv', header=TRUE)
kc_breakage_driver = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/kc_breakage_driver_items_feb16.csv', header=TRUE)

stl_breakage_warehouse = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/stl_breakage_warehouse_items_feb16.csv', header=TRUE)
kc_breakage_warehouse = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/kc_breakage_warehouse_items_feb16.csv', header=TRUE)

stl_breakage_master = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/stl_breakage_master_dataset_feb16.csv', header=TRUE)
kc_breakage_master = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/kc_breakage_master_dataset_feb16.csv', header=TRUE)

unsaleables_items = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/unsaleables_items.csv', header=TRUE)
unsaleables_suppliers = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/unsaleables_suppliers.csv', header=TRUE)
unsaleables_customers = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/unsaleables_customers.csv', header=TRUE)

stl_velocity_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/stl_velocity_summary_feb16.csv', header=TRUE)
kc_velocity_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/kc_velocity_summary_feb16.csv', header=TRUE)


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
    
    output$employees_on_hand = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((round(stl_production_summary[8, 2]))), 
               scales::comma((round(kc_production_summary[8, 2])))), 
        'Avg Employees On Hand', icon=icon('user')
      )
    })
    
    output$employees_on_hand_ly = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((round(stl_production_summary[8, 3]))), 
               scales::comma((round(kc_production_summary[8, 3])))), 
        'Avg Employees On Hand LY', icon=icon('user')
      )
    })
    
    output$employees_on_hand_delta = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::percent((round(stl_production_summary[8, 4], 4))), 
               scales::percent((round(kc_production_summary[8, 4], 4)))), 
        'Year-Over-Year Change', icon=icon('user')
      )
    })
    
    output$oddball_cases = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((round(stl_production_summary[13, 2]))), 
               scales::comma((round(kc_production_summary[13, 2])))), 
        'Oddball Cases', icon=icon('random')
      )
    })
    
    output$oddball_cases_ly = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::comma((round(stl_production_summary[13, 3]))), 
               scales::comma((round(kc_production_summary[13, 3])))), 
        'Oddball Cases LY', icon=icon('random')
      )
    })
    
    output$oddball_cases_delta = renderValueBox({
      valueBox(
        ifelse(input$house=='Saint Louis', 
               scales::percent((round(stl_production_summary[13, 4], 4))), 
               scales::percent((round(kc_production_summary[13, 4], 4)))), 
        'Year-Over-Year Change', icon=icon('random')
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
      y_axis = reactive({
        if(input$driver_warehouse == 'Warehouse') {
          y_axis = breaks()$YTD.Warehouse.Cost
        }
        if(input$driver_warehouse == 'Drivers') {
          y_axis = breaks()$YTD.Driver.Cost
        }
        y_axis
      })
      
      p = ggplot(breaks(), aes(factor(Month), y=y_axis()))
      p =  p + geom_point(aes(group=factor(Type))) + 
        geom_line(aes(x=factor(Month), y=y_axis(), colour=factor(Type),
                      group=factor(Type)), size=2, alpha=0.5) +
        theme(legend.position='bottom', axis.text.x=element_text(angle=90, hjust=1)) + 
        labs(title=break_plot_title(),
             x="Month", y="Dollars") +
        facet_wrap(~Year, nrow=1) +
        scale_y_continuous(labels=dollar)
      print(p)
    })
    
    
    
    
    production = reactive({
      if(input$house=='Saint Louis') { 
        production = stl_production_data
      } 
      if(input$house=='Kansas City') {
        production = kc_production_data
      }
      production
    })
 
    
    output$cum_ot_hours = renderPlot({
      p = ggplot(production(), aes(factor(YEAR.MONTH)))
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
    
    
    
    
    # for unsaleables tab
    
    output$unsaleable_data = renderDataTable({
      if(input$unsaleables_facet=='Item') { 
        data = unsaleables_items
      } 
      if(input$unsaleables_facet=='Supplier') {
        data = unsaleables_suppliers
      }
      if(input$unsaleables_facet=='Customer') {
        data = unsaleables_customers
      }
      data
    })
    
    
    
    # for velocity tab
    
    output$g_line_cases = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'G-LINE', 2]))),  
        'G-Line Cases', icon=icon('cubes'))
    })
    output$g_line_percent = renderValueBox({
      valueBox(
        scales::percent((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'G-LINE', 3], 4))),  
        'Percent Total Cases', icon=icon('pie-chart'))
    })
    output$g_line_unique = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'G-LINE', 6]))),  
        'Unique Items', icon=icon('barcode'))
    })
    
    output$d_line_cases = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'D-LINE', 2]))),  
        'D-Line Cases', icon=icon('cubes'))
    })
    output$d_line_percent = renderValueBox({
      valueBox(
        scales::percent((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'D-LINE', 3], 4))),  
        'Percent Total Cases', icon=icon('pie-chart'))
    })
    output$d_line_unique = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'D-LINE', 6]))),  
        'Unique Items', icon=icon('barcode'))
    })
    
    output$c_line_cases = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'C-LINE', 2]))),  
        'C-Line Cases', icon=icon('cubes'))
    })
    output$c_line_percent = renderValueBox({
      valueBox(
        scales::percent((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'C-LINE', 3], 4))),  
        'Percent Total Cases', icon=icon('pie-chart'))
    })
    output$c_line_unique = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'C-LINE', 6]))),  
        'Unique Items', icon=icon('barcode'))
    })
    
    output$e_line_cases = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'E-LINE', 2]))),  
        'E-Line Cases', icon=icon('cubes'))
    })
    output$e_line_percent = renderValueBox({
      valueBox(
        scales::percent((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'E-LINE', 3], 4))),  
        'Percent Total Cases', icon=icon('pie-chart'))
    })
    output$e_line_unique = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'E-LINE', 6]))),  
        'Unique Items', icon=icon('barcode'))
    })
    
    output$o_line_cases = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'ODDBALL', 2]))),  
        'Oddball Cases', icon=icon('cubes'))
    })
    output$o_line_percent = renderValueBox({
      valueBox(
        scales::percent((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'ODDBALL', 3], 4))),  
        'Percent Total Cases', icon=icon('pie-chart'))
    })
    output$o_line_unique = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'ODDBALL', 6]))),  
        'Unique Items', icon=icon('barcode'))
    })
    
    output$f_line_cases = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'F-LINE', 2]))),  
        'F-Line Cases', icon=icon('cubes'))
    })
    output$f_line_percent = renderValueBox({
      valueBox(
        scales::percent((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'F-LINE', 3], 4))),  
        'Percent Total Cases', icon=icon('pie-chart'))
    })
    output$f_line_unique = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'F-LINE', 6]))),  
        'Unique Items', icon=icon('barcode'))
    })
    
    output$w_line_cases = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'WINE ROOM', 2]))),  
        'F-Line Cases', icon=icon('cubes'))
    })
    output$w_line_percent = renderValueBox({
      valueBox(
        scales::percent((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'WINE ROOM', 3], 4))),  
        'Percent Total Cases', icon=icon('pie-chart'))
    })
    output$w_line_unique = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'WINE ROOM', 6]))),  
        'Unique Items', icon=icon('barcode'))
    })
    
    output$a_line_btls = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'A-RACK', 4]))),  
        'A Rack Bottles', icon=icon('cubes'))
    })
    output$a_line_percent = renderValueBox({
      valueBox(
        scales::percent((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'A-RACK', 5], 4))),  
        'Percent Total Bottles', icon=icon('pie-chart'))
    })
    output$a_line_unique = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'A-RACK', 6]))),  
        'Unique Items', icon=icon('barcode'))
    })
    
    output$b_line_btls = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'B-RACK', 4]))),  
        'B Rack Bottles', icon=icon('cubes'))
    })
    output$b_line_percent = renderValueBox({
      valueBox(
        scales::percent((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'B-RACK', 5], 4))),  
        'Percent Total Bottles', icon=icon('pie-chart'))
    })
    output$b_line_unique = renderValueBox({
      valueBox(
        scales::comma((round(stl_velocity_summary[stl_velocity_summary$CASE.LINE %in% 'B-RACK', 6]))),  
        'Unique Items', icon=icon('barcode'))
    })
    
    
    
    
    output$velocity_summary = renderDataTable({
      if(input$house=='Saint Louis') {
        data = stl_velocity_summary
      }
      if(input$house=='Kansas City') {
        data = kc_velocity_summary
      }
      data
    })
    
    
    
    
    
    
})

