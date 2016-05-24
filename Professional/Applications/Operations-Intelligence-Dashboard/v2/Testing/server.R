
# runApp('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Testing', launch.browser = TRUE)
# source('N:/Operations Intelligence/Monthly Reports/Applications/Code/OpsDashboard/libs.R')
# server.R

print('TESTING VERSION NATIVE TO PAUL COMPUTER')

library(shinydashboard)
library(xlsx)
library(scales)
library(ggplot2)
library(ggthemes)
library(gridExtra)
library(reshape2)
library(dplyr)
library(RODBC)
library(lubridate)
library(tidyr)
library(stringr)
library(shiny)
#library(Rcpp)
#library(ggvis)


substrRight = function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}
substrLeft = function(x, n){
  substr(x, 1, n)
}


###### NEW STUFF BELOW

reporting_db = 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Reporting Database.accdb'

odbc_connection = odbcConnectAccess2007(reporting_db)

# x = sqlQuery(odbc_connection, "SELECT * FROM TS_Production WHERE Date BETWEEN #06/01/2015# AND #03/31/2016#")
# head(x)
# t_returns = sqlFetch(odbc_connection, "T_Returns")
# t_breakage = sqlFetch(odbc_connection, "T_Breakage")
# t_offday = sqlFetch(odbc_connection, "T_Off-Day Deliveries")

# sqlTables(odbc_connection)



#odbcCloseAll()





shinyServer(
  function(input, output) {
    
    ## ________________get dates for same period last year________________ ##
    start_date_ly = reactive({
      x = as.Date(input$dates[1], "%m/%d/%Y")
      year(x) = 2015 #year(Sys.Date()) - 1
      x = format(x, "%m/%d/%Y")
    })
    
    end_date_ly = reactive({
      x = as.Date(input$dates[2], "%m/%d/%Y")
      year(x) = 2015 #year(Sys.Date()) - 1
      x = format(x, "%m/%d/%Y")
    })
    
    
    
    ## ________________production________________ ##
    
    ## ________________query for production________________ ##
    query_production = reactive({
      q = paste0("SELECT *FROM TS_Production WHERE Date BETWEEN #",
                 format(input$dates[1], "%m/%d/%Y"), "# AND #",
                 format(input$dates[2], "%m/%d/%Y"), "#")
      q
    })
    
    query_production_ly = reactive({
      q = paste0("SELECT *FROM TS_Production WHERE Date BETWEEN #",
                 start_date_ly(), "# AND #", end_date_ly(), "#")
      q
    })
    
    ## ________________get production data________________ ##
    t_production = reactive({
      t = sqlQuery(odbc_connection, query=query_production())
      
      t
    })
    
    t_production_ly = reactive({
      t = sqlQuery(odbc_connection, query=query_production_ly())
      
      t
    })
    
    ## ________________get summary of production________________ ##
    
    cs_ship = reactive({
      x = t_production()
      val = ifelse(input$house == 'Saint Louis', 
                   round(sum(x$STLCASESTOTAL, na.rm=TRUE)),
                   round(sum(x$KCCASESTOTAL, na.rm=TRUE)))
      val
    })
    
    cs_ship_ly = reactive({
      x = t_production_ly()
      val = ifelse(input$house == 'Saint Louis', 
                   round(sum(x$STLCASESTOTAL, na.rm=TRUE)),
                   round(sum(x$KCCASESTOTAL, na.rm=TRUE)))
      val
    })
    
    output$cases_delivered = renderValueBox({
      valueBox(
        scales::comma((cs_ship())), 'Cases Shipped', icon=icon('truck')
      )
    })
    
    output$cases_delivered_ly = renderValueBox({
      valueBox(
        scales::comma((cs_ship_ly())), 'Cases Shipped LY', icon=icon('truck')
      )
    })
    
    output$cases_delivered_delta = renderValueBox({
      x = round((cs_ship() - cs_ship_ly()) / cs_ship_ly(), 4)
      x = scales::percent((x))
      valueBox(
        x, 'Year-Over-Year Change', icon=icon('truck')
      )
    })
    
    
    
    ## ________________cpmh________________ ##
    cpmh = reactive({
      x = t_production()
      val = ifelse(input$house == 'Saint Louis', 
                   round(mean(x$STLCPMHOTADJUSTED, na.rm=TRUE), 2),
                   round(mean(x$KCCPMHOTADJUSTED, na.rm=TRUE), 2))
      val
    })
    
    cpmh_ly = reactive({
      x = t_production_ly()
      val = ifelse(input$house == 'Saint Louis', 
                   round(mean(x$STLCPMHOTADJUSTED, na.rm=TRUE), 2),
                   round(mean(x$KCCPMHOTADJUSTED, na.rm=TRUE), 2))
      val
    })
    
    output$cpmh = renderValueBox({
      valueBox(
        scales::comma((cpmh())), 'CPMH OT Adjusted', icon=icon('gears')
      )
    })
    
    output$cpmh_ly = renderValueBox({
      valueBox(
        scales::comma((cpmh_ly())), 'CPMH OT Adjusted LY', icon=icon('gears')
      )
    })
    
    output$cpmh_delta = renderValueBox({
      x = round((cpmh() - cpmh_ly()) / cpmh_ly(), 4)
      x = scales::percent((x))
      valueBox(
        x, 'Year-Over-Year Change', icon=icon('gears')
      )
    })
    
    
    
    
    ## ________________man hours________________ ##
    man_hours = reactive({
      x = t_production()
      val = ifelse(input$house == 'Saint Louis', 
                   round(sum(x$STLTOTALHOURS, na.rm=TRUE)),
                   round(sum(x$KCHOURSTOTAL, na.rm=TRUE)))
      val
    })
    
    man_hours_ly = reactive({
      x = t_production_ly()
      val = ifelse(input$house == 'Saint Louis', 
                   round(sum(x$STLTOTALHOURS, na.rm=TRUE)),
                   round(sum(x$KCHOURSTOTAL, na.rm=TRUE)))
      val
    })
    
    
    output$man_hours = renderValueBox({
      valueBox(
        scales::comma((man_hours())), 'Man Hours', icon=icon('user')
      )
    })
    
    output$man_hours_ly = renderValueBox({
      valueBox(
        scales::comma((man_hours_ly())), 'Man Hours LY', icon=icon('user')
      )
    })
    
    output$man_hours_delta = renderValueBox({
      x = round((man_hours() - man_hours_ly()) / man_hours_ly(), 4)
      x = scales::percent((x))
      valueBox(
        x, 'Year-Over-Year Change', icon=icon('user')
      )
    })
    
    
    
    ## ________________avg employees on hand________________ ##
    avg_emps = reactive({
      x = t_production()
      val = ifelse(input$house == 'Saint Louis', 
                   round(mean(x$STLTOTALEMPSTEMPS, na.rm=TRUE), 1),
                   round(mean(x$KCEMPSTEMPSONHAND, na.rm=TRUE), 1))
      val
    })
    
    avg_emps_ly = reactive({
      x = t_production_ly()
      val = ifelse(input$house == 'Saint Louis', 
                   round(mean(x$STLTOTALEMPSTEMPS, na.rm=TRUE), 1),
                   round(mean(x$KCEMPSTEMPSONHAND, na.rm=TRUE), 1))
      val
    })
    
    output$employees_on_hand = renderValueBox({
      valueBox(
        scales::comma((avg_emps())), 'Avg Employees On Hand', icon=icon('users')
      )
    })
    
    output$employees_on_hand_ly = renderValueBox({
      valueBox(
        scales::comma((avg_emps_ly())), 'Avg Employees On Hand LY', icon=icon('users')
      )
    })
    
    output$employees_on_hand_delta = renderValueBox({
      x = round((avg_emps() - avg_emps_ly()) / avg_emps_ly(), 4)
      x = scales::percent((x))
      valueBox(
        x, 'Year-Over-Year Change', icon=icon('users')
      )
    })
    
    
    ## ________________raw errors________________ ##
    tot_err = reactive({
      x = t_production()
      val = ifelse(input$house == 'Saint Louis', 
                   round(sum(x$STLRAWCASEERRORS, na.rm=TRUE) + sum(x$STLRAWBOTTLEERRORS, na.rm=TRUE), 1),
                   round(sum(x$KCTOTALRAWCASEERRORS, na.rm=TRUE) + sum(x$KCTOTALRAWBOTTLEERRORS, na.rm=TRUE), 1))
      val
    })
    
    tot_err_ly = reactive({
      x = t_production_ly()
      val = ifelse(input$house == 'Saint Louis', 
                   round(sum(x$STLRAWCASEERRORS, na.rm=TRUE) + sum(x$STLRAWBOTTLEERRORS, na.rm=TRUE), 1),
                   round(sum(x$KCTOTALRAWCASEERRORS, na.rm=TRUE) + sum(x$KCTOTALRAWBOTTLEERRORS, na.rm=TRUE), 1))
      val
    })
    
    output$errors = renderValueBox({
      valueBox(
        scales::comma((tot_err())),'Raw Errors', icon=icon('frown-o')
      )
    })
    
    output$errors_ly = renderValueBox({
      valueBox(
        scales::comma((tot_err_ly())),'Raw Errors LY', icon=icon('frown-o')
      )
    })
    
    output$errors_delta = renderValueBox({
      x = round((tot_err() - tot_err_ly()) / tot_err_ly(), 4)
      x = scales::percent((x))
      valueBox(
        x, 'Year-Over-Year Change', icon=icon('frown-o')
      )
    })
    
    
    
    
    
    ## ________________oddballs________________ ##
    tot_odd = reactive({
      x = t_production()
      val = ifelse(input$house == 'Saint Louis', 
                   round(sum(x$STLTOTALODDBALL, na.rm=TRUE), 1),
                   round(sum(x$KCRODDBALL, na.rm=TRUE), 1))
      val
    })
    
    tot_odd_ly = reactive({
      x = t_production_ly()
      val = ifelse(input$house == 'Saint Louis', 
                   round(sum(x$STLTOTALODDBALL, na.rm=TRUE), 1),
                   round(sum(x$KCODDBALLBOTTLES, na.rm=TRUE), 1))
      val
    })
    output$oddball_cases = renderValueBox({
      valueBox(
        scales::comma((tot_odd())), 'Oddball Cases', icon=icon('random')
      )
    })
    
    output$oddball_cases_ly = renderValueBox({
      valueBox(
        scales::comma((tot_odd_ly())), 'Oddball Cases', icon=icon('random')
      )
    })
    
    output$oddball_cases_delta = renderValueBox({
      x = round((tot_odd() - tot_odd_ly()) / tot_odd_ly(), 4)
      x = scales::percent((x))
      valueBox(
        x, 'Year-Over-Year Change', icon=icon('random')
      )
    })
    
    

    ## ________________ ot hours summary ________________ ##
    tot_ot_hours = reactive({
      x = t_production()
      val = ifelse(input$house == 'Saint Louis', 
                   round(sum(x$STLOTHOURS, na.rm=TRUE), 1),
                   round(sum(x$KCOTHOURS, na.rm=TRUE), 1))
      val
    })
    
    tot_ot_hours_ly = reactive({
      x = t_production_ly()
      val = ifelse(input$house == 'Saint Louis', 
                   round(sum(x$STLOTHOURS, na.rm=TRUE), 1),
                   round(sum(x$KCOTHOURS, na.rm=TRUE), 1))
      val
    })
    output$ot_hours = renderValueBox({
      valueBox(
        scales::comma((tot_ot_hours())), 'OT Hours', icon=icon('flag')
      )
    })
    
    output$ot_hours_ly = renderValueBox({
      valueBox(
        scales::comma((tot_ot_hours_ly())), 'OT Hours LY', icon=icon('flag')
      )
    })
    
    output$ot_hours_delta = renderValueBox({
      x = round((tot_ot_hours() - tot_ot_hours_ly()) / tot_ot_hours_ly(), 4)
      x = scales::percent((x))
      valueBox(
        x, 'Year-Over-Year Change', icon=icon('flag')
      )
    })
    
    
    
    
    ## ________________ trucks ________________ ##
    avg_trucks = reactive({
      x = t_production()
      val = ifelse(input$house == 'Saint Louis', 
                   round(mean(x$STLTRUCKSTOTAL, na.rm=TRUE), 1),
                   round(mean(x$KCTRUCKSKCTOTAL, na.rm=TRUE), 1))
      val
    })
    
    avg_trucks_ly = reactive({
      x = t_production_ly()
      val = ifelse(input$house == 'Saint Louis', 
                   round(mean(x$STLTRUCKSTOTAL, na.rm=TRUE), 1),
                   round(mean(x$KCTRUCKSKCTOTAL, na.rm=TRUE), 1))
      val
    })
    output$trucks = renderValueBox({
      valueBox(
        scales::comma((avg_trucks())), 'Avg Trucks', icon=icon('road')
      )
    })
    
    output$trucks_ly = renderValueBox({
      valueBox(
        scales::comma((avg_trucks_ly())), 'Avg Trucks LY', icon=icon('road')
      )
    })
    
    output$trucks_delta = renderValueBox({
      x = round((avg_trucks() - avg_trucks_ly()) / avg_trucks_ly(), 4)
      x = scales::percent((x))
      valueBox(
        x, 'Year-Over-Year Change', icon=icon('road')
      )
    })
    
    
    
    
    
    ## ________________ stops ________________ ##
    avg_stops = reactive({
      x = t_production()
      val = ifelse(input$house == 'Saint Louis', 
                   round(mean(x$STLSTOPSTOTAL, na.rm=TRUE), 1),
                   round(mean(x$KCSTOPSKCTOTAL, na.rm=TRUE), 1))
      val
    })
    
    avg_stops_ly = reactive({
      x = t_production_ly()
      val = ifelse(input$house == 'Saint Louis', 
                   round(mean(x$STLSTOPSTOTAL, na.rm=TRUE), 1),
                   round(mean(x$KCSTOPSKCTOTAL, na.rm=TRUE), 1))
      val
    })
    output$stops = renderValueBox({
      valueBox(
        scales::comma((avg_stops())), 'Avg Stops', icon=icon('share-alt')
      )
    })
    
    output$stops_ly = renderValueBox({
      valueBox(
        scales::comma((avg_stops_ly())), 'Avg Stops LY', icon=icon('share-alt')
      )
    })
    
    output$stops_delta = renderValueBox({
      x = round((avg_stops() - avg_stops_ly()) / avg_stops_ly(), 4)
      x = scales::percent((x))
      valueBox(
        x, 'Year-Over-Year Change', icon=icon('share-alt')
      )
    })
    
    
    
    
    
    
    
    ## ________________ loading_hours ________________ ##
    avg_loading_hours = reactive({
      x = t_production()
      val = ifelse(input$house == 'Saint Louis', 
                   round(mean(x$STLLOADINGHOURS, na.rm=TRUE), 1),
                   round(mean(x$KCLOADINGHOURS, na.rm=TRUE), 1))
      val
    })
    
    avg_loading_hours_ly = reactive({
      x = t_production_ly()
      val = ifelse(input$house == 'Saint Louis', 
                   round(mean(x$STLLOADINGHOURS, na.rm=TRUE), 1),
                   round(mean(x$KCLOADINGHOURS, na.rm=TRUE), 1))
      val
    })
    output$loading_hours = renderValueBox({
      valueBox(
        scales::comma((avg_loading_hours())), 'Avg Loading Hours', icon=icon('hourglass-end')
      )
    })
    
    output$loading_hours_ly = renderValueBox({
      valueBox(
        scales::comma((avg_loading_hours_ly())), 'Avg Loading Hours LY', icon=icon('hourglass-end')
      )
    })
    
    output$loading_hours_delta = renderValueBox({
      x = round((avg_loading_hours() - avg_loading_hours_ly()) / avg_loading_hours_ly(), 4)
      x = scales::percent((x))
      valueBox(
        x, 'Year-Over-Year Change', icon=icon('hourglass-end')
      )
    })
    
    
    
    #x$STLLOADINGHOURS
    #x$STLRESTOCKHOURS
    # TRUCKS OTHOURS MILES 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ## ________________ case line plot ________________ ##
    output$case_line_plot = renderPlot(width = 1100, height = 800, {
      p = t_production()
      p$YEARMONTH = paste0(p$YEAR, '-', p$MONTH)
      p$YEARMONTH = factor(p$YEARMONTH, levels=unique(p$YEARMONTH))
      
      x = p[, c('DATE', 'YEARMONTH', 'STLCCASES', 'STLDCASES', 'STLECASES', 
                'STLFCASES', 'STLGCASES', 'STLWCASES', 'STLTOTALODDBALL')]
      names(x) = c('DATE', 'YEARMONTH', 'C-Cases', 'D-Cases', 'E-Cases', 
                   'F-Cases', 'G-Cases', 'W-Cases', 'Oddball-Cases')
      melted = melt(x, c('DATE', 'YEARMONTH'))
      
      l = ggplot(data=melted, aes(x=YEARMONTH, y=value, group=variable))
      one = l + geom_jitter(aes(group=variable), size=0.1, alpha=0.2) +
        geom_point(aes(group=variable), size=0.5, alpha=0.2) +
        facet_wrap(~variable, ncol=1, scales='free_y') +
        geom_smooth(aes(group=variable, colour=variable), se=TRUE, size=1.25, alpha=0.5, span=0.2) +
        theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1)) +
        scale_y_continuous(labels=comma) +
        labs(title='Daily Case Line Production STL', 
             x='Date', y='Cases Produced by Line')
      
      x = p[, c('DATE', 'YEARMONTH', 'STLCHOURS', 'STLDHOURS', 'STLEHOURS', 
                'STLFHOURS', 'STLGHOURS', 'STLWHOURS', 'STLTOTALODDBALLHOURS')]
      names(x) = c('DATE', 'YEARMONTH', 'C-Hours', 'D-Hours', 'E-Hours', 
                   'F-Hours', 'G-Hours', 'W-Hours', 'Oddball-Hours')
      melted = melt(x, c('DATE', 'YEARMONTH'))
      l = ggplot(data=melted, aes(x=YEARMONTH, y=value, group=variable))
      two = l + geom_jitter(aes(group=variable), size=0.1, alpha=0.2) +
        geom_point(aes(group=variable), size=0.5, alpha=0.2) +
        facet_wrap(~variable, ncol=1, scales='free_y') +
        geom_smooth(aes(group=variable, colour=variable), se=TRUE, size=1.25, alpha=0.5, span=0.2) +
        theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1)) +
        scale_y_continuous(labels=comma) +
        labs(title='Daily Case Line Hours STL', 
             x='Date', y='Production Hours')
      
      x = p[, c('DATE', 'YEARMONTH', 'KCC100CASES', 'KCC200CASES', 'KCC300400CASES', 
                'KCWCASES', 'KCRODDBALL', 'KCODDBALLBOTTLES')]
      melted = melt(x, c('DATE', 'YEARMONTH'))
      
      l = ggplot(data=melted, aes(x=YEARMONTH, y=value, group=variable))
      three = l + geom_jitter(aes(group=variable), size=0.1, alpha=0.2) +
        geom_point(aes(group=variable), size=0.5, alpha=0.2) +
        facet_wrap(~variable, ncol=1, scales='free_y') +
        geom_smooth(aes(group=variable, colour=variable), se=TRUE, size=1.25, alpha=0.5, span=0.2) +
        theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1)) +
        scale_y_continuous(labels=comma) +
        labs(title='Daily Case Line Production KC', 
             x='Date', y='Cases Produced by Line')
      
      x = p[, c('DATE', 'YEARMONTH', 'KCC100HOURS', 'KCC200HOURS', 'KCC300400HOURS', 
                'KCWHOURS', 'KCRODDBALLHOURS', 'KCODDBALLBOTTLEHOURS')]
      melted = melt(x, c('DATE', 'YEARMONTH'))
      l = ggplot(data=melted, aes(x=YEARMONTH, y=value, group=variable))
      four = l + geom_jitter(aes(group=variable), size=0.1, alpha=0.2) +
        geom_point(aes(group=variable), size=0.5, alpha=0.2) +
        facet_wrap(~variable, ncol=1, scales='free_y') +
        geom_smooth(aes(group=variable, colour=variable), se=TRUE, size=1.25, alpha=0.5, span=0.2) +
        theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1)) +
        scale_y_continuous(labels=comma) +
        labs(title='Daily Case Line Hours KC', 
             x='Date', y='Production Hours') 
      
      
      print(suppressWarnings(grid.arrange(one, two, three, four, ncol=4)))
      
    })
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    #### END PRODUCTION
    
    ## ________________get breakage queries for both years________________ ##
    query_brk = reactive({
      q = ifelse(input$house == 'Saint Louis', 
                 paste0("SELECT * 
                        FROM T_Breakage 
                        WHERE Warehouse = 'STL' AND Date BETWEEN #",
                        as.character(format(input$dates[1], "%m/%d/%Y")), 
                        "# AND #", 
                        as.character(format(input$dates[2], "%m/%d/%Y")), "#"),
                 paste0("SELECT * 
                        FROM T_Breakage 
                        WHERE Warehouse = 'KC' AND Date BETWEEN #",
                        format(input$dates[1], "%m/%d/%Y"), 
                        "# AND #", 
                        format(input$dates[2], "%m/%d/%Y"), "#"))
      q
    })
    
    query_brk_ly = reactive({
      q = ifelse(input$house == 'Saint Louis', 
                 paste0("SELECT * 
                        FROM T_Breakage 
                        WHERE Warehouse = 'STL' AND Date BETWEEN #",
                        start_date_ly(), 
                        "# AND #", 
                        end_date_ly(), "#"),
                 paste0("SELECT * 
                        FROM T_Breakage 
                        WHERE Warehouse = 'KC' AND Date BETWEEN #",
                        start_date_ly(), 
                        "# AND #", 
                        end_date_ly(), "#"))
      q
    })
    
    ## ________________get breakage data________________ ##
    t_breakage = reactive({
      t = sqlQuery(odbc_connection, query=query_brk())
      t
    }) 
    
    t_breakage_ly = reactive({
      t = sqlQuery(odbc_connection, query=query_brk_ly())
      t
    }) 
    
    brk_for_graphs = reactive({
      q = paste0("SELECT * FROM T_Breakage 
                 WHERE Date BETWEEN #",
                 as.character(format(input$dates[1], "%m/%d/%Y")), 
                 "# AND #", 
                 as.character(format(input$dates[2], "%m/%d/%Y")), "#")
      t = sqlQuery(odbc_connection, query=q)
      t
    })
    
    brk_for_graphs_ly = reactive({
      q = paste0("SELECT * FROM T_Breakage 
                 WHERE Date BETWEEN #",
                 start_date_ly(), 
                 "# AND #", 
                 end_date_ly(), "#")
      t = sqlQuery(odbc_connection, query=q)
      t
    })
    
    ## ________________get summary of breakage________________ ##
    output$total_breakage = renderValueBox({
      x = t_breakage()
      x = x %>% filter(grepl('Warehouse', Type))
      valueBox(
        scales::dollar((round(sum(x[, 'Cost'], na.rm=TRUE)))), 
        'Warehouse Breakage', icon=icon('trash-o')
      )
    })
    
    output$total_breakage_ly = renderValueBox({
      x = t_breakage_ly()
      x = x %>% filter(grepl('Warehouse', Type))
      valueBox(
        scales::dollar((round(sum(x[, 'Cost'], na.rm=TRUE)))), 
        'Warehouse Breakage LY', icon=icon('car')
      )
    })
    
    output$driver_breakage = renderValueBox({
      x = t_breakage()
      x = x %>% filter(grepl('Driver', Type))
      valueBox(
        scales::dollar((round(sum(x[, 'Cost'], na.rm=TRUE)))), 
        'Driver Breakage', icon=icon('car')
      )
    })
    
    output$driver_breakage_ly = renderValueBox({
      x = t_breakage_ly()
      x = x %>% filter(grepl('Driver', Type))
      valueBox(
        scales::dollar((round(sum(x[, 'Cost'], na.rm=TRUE)))), 
        'Driver Breakage LY', icon=icon('car')
      )
    })
    
    ## ________________render atomic level data to output________________ ##
    output$atomic_breakage = renderDataTable({
      t_breakage()
    })
    
    output$atomic_breakage_ly = renderDataTable({
      t_breakage_ly()
    })
    
    ## ________________calculate yoy change breakage________________ ##
    output$total_breakage_delta = renderValueBox({
      y = t_breakage_ly()
      y = y %>% filter(grepl('Warehouse', Type))
      
      x = t_breakage()
      x = x %>% filter(grepl('Warehouse', Type))
      
      x = round(sum(x[, 'Cost']))
      y = round(sum(y[, 'Cost']))     
      d = scales::percent(((x - y) / y))
      valueBox(
        d, 'YOY %Change', icon=icon('trash-o')
      )
    })
    
    output$driver_breakage_delta = renderValueBox({
      y = t_breakage_ly()
      y = y %>% filter(grepl('Driver', Type))
      
      x = t_breakage()
      x = x %>% filter(grepl('Driver', Type))
      
      x = round(sum(x[, 'Cost']))
      y = round(sum(y[, 'Cost']))     
      d = scales::percent(((x - y) / y))
      valueBox(
        d, 'YOY %Change', icon=icon('trash-o')
      )
    })
    
    ## ________________render items data for driver/warehouse brk________________ ##
    brk_prod = reactive({
      library(tidyr)
      x = t_breakage()
      names(x) = gsub(" ",".", names(x)) 
      
      if(input$driver_warehouse=='Warehouse'){
        x = x %>% filter(grepl('Warehouse', Type))
      } else {
        x = x %>% filter(grepl('Driver', Type))
      }
      x = x[, c('Product.ID', 'Product', 'Cases', 'Cost')]
      one = aggregate(Cost ~ Product.ID + Product, data=x, FUN=function(x) round(sum(x)))
      two = aggregate(Cases ~ Product.ID, data=x, FUN=function(x) length(unique(x)))
      three = aggregate(Cases ~ Product.ID, data=x, FUN=function(x) round(sum(x), 1))
      x = merge(one, two, by='Product.ID')
      x = merge(x, three, by='Product.ID')
      names(x) = c('Product.ID', 'Product', 'Cost', 'Instances', 'Cases')
      x = x %>% arrange(desc(Cost))
      x
    })
    
    output$breakage_by_product = renderDataTable({
      brk_prod()
    })
    
    
    ## ________________breakage plots________________ ##
    output$plot_breakage_summary = renderPlot({
      x = brk_for_graphs()
      x = x %>% filter(Cost>0)
      x = x %>% filter(Type != 'UNSPECIFIED')
      x = x %>% filter(Type != 'Supplier')
      x$Month = factor(x$Month, levels=unique(x$Month))
      
      p = ggplot(x, aes(Month, y=Cost, fill=factor(Type)))
      p =  p + geom_bar(stat='identity', 
                        size=0.5, alpha=0.5) +
        scale_fill_discrete(name="Breakage\nType") +
        theme(legend.position='bottom', 
              axis.text.x=element_text(angle=90, hjust=1)) + 
        labs(title='Breakage Summary',
             x="Month", y="Dollars") +
        facet_wrap(Type~Year, nrow=1) +
        scale_y_continuous(labels=dollar) +
        geom_jitter()
      print(p)
    })
    
    
    output$plot_breakage_product = renderPlot({
      x = brk_prod()
      x = x %>% arrange(desc(Cost))
      x$Product = factor(x$Product, unique(x$Product))
      x = head(x, 10)
      
      p = ggplot(x, aes(x=Product, y=Cost))
      d =  p + geom_bar(stat='identity', 
                        size=0.5, 
                        alpha=0.7,
                        fill='purple') +
        theme(legend.position='none', 
              axis.text.x=element_text(angle=90, hjust=1)) + 
        labs(title='Top Breakage Items by Dollar',
             x="Product", y="Dollars") +
        scale_y_continuous(labels=dollar)
      
      y = brk_prod()
      y = y %>% arrange(desc(Instances))
      y$Product = factor(y$Product, unique(y$Product))
      y = head(y, 10)
      
      g = ggplot(y, aes(x=Product, y=Instances))
      i = g + geom_bar(stat='identity', 
                       size=0.5, 
                       alpha=0.7,
                       fill='red') +
        theme(legend.position='none', 
              axis.text.x=element_text(angle=90, hjust=1)) + 
        labs(title='Top Breakage Items by Instances',
             x="Product", y="Instances") +
        scale_y_continuous(labels=comma)
      
      z = brk_prod()
      z = z %>% arrange(desc(Cases))
      z$Product = factor(z$Product, unique(z$Product))
      z = head(z, 10)
      
      ge = ggplot(z, aes(x=Product, y=Cases))
      c = ge + geom_bar(stat='identity', 
                        size=0.5, 
                        alpha=0.7,
                        fill='blue') +
        theme(legend.position='none', 
              axis.text.x=element_text(angle=90, hjust=1)) + 
        labs(title='Top Breakage Items by Cases',
             x="Product", y="Cases") +
        scale_y_continuous(labels=comma) 
      
      print(grid.arrange(d, c, i, nrow=1))
    })
    
    
    output$breakage_pivot = renderDataTable({
      all = brk_for_graphs()
      all_ly = brk_for_graphs_ly()
      
      all = all %>% filter(Type != 'UNSPECIFIED')
      all = all %>% filter(Type != 'Supplier')
      all_ly = all_ly %>% filter(Type != 'UNSPECIFIED')
      all_ly = all_ly %>% filter(Type != 'Supplier')
      
      one = aggregate(Cost ~ Type, data=all, FUN=function(x) round(sum(x)))
      two = aggregate(Cases ~ Type, data=all, FUN=function(x) round(sum(x), 1))
      all = merge(one, two, by='Type', all=TRUE)
      all = arrange(all, desc(Cost))
      names(all) = c('Type', 'TY.Cost', 'TY.Cases')
      
      one_ly = aggregate(Cost ~ Type, data=all_ly, FUN=function(x) round(sum(x)))
      two_ly = aggregate(Cases ~ Type, data=all_ly, FUN=function(x) round(sum(x), 1))
      all_ly = merge(one_ly, two_ly, by='Type', all_ly=TRUE)
      all_ly = arrange(all_ly, desc(Cost))
      names(all_ly) = c('Type', 'LY.Cost', 'LY.Cases')
      
      all = merge(all, all_ly, by='Type', all=TRUE)
      all$YOY.Change.Cost = scales::percent((round((all$TY.Cost - all$LY.Cost) / all$LY.Cost, 4)))
      all$YOY.Change.Cases = scales::percent((round((all$TY.Cases - all$LY.Cases) / all$LY.Cases, 4)))
      all$TY.Cost = scales::dollar((all$TY.Cost))
      all$LY.Cost = scales::dollar((all$LY.Cost))
      all = all[, c('Type', 'TY.Cost', 'LY.Cost', 'YOY.Change.Cost', 'TY.Cases', 'LY.Cases', 'YOY.Change.Cases')]
      all = all %>% arrange(desc(YOY.Change.Cost))
      
      all
    })
    
    
    
    # google how to close rodbc unused handle X
    
    
    
    
    
    #### below has not past testing
    
    
    
    ## ________________unsaleables________________ ##
    
    ## ________________query for unsaleables________________ ##
    query_unsale = reactive({
      q = ifelse(input$house == 'Saint Louis',
                 paste0("SELECT *
                        FROM T_Unsaleables
                        WHERE Warehouse = 'STL' AND Date BETWEEN #",
                        as.character(format(input$dates[1], "%m/%d/%Y")),
                        "# AND #",
                        as.character(format(input$dates[2], "%m/%d/%Y")), "#"),
                 paste0("SELECT *
                        FROM T_Unsaleables
                        WHERE Warehouse = 'KC' AND Date BETWEEN #",
                        format(input$dates[1], "%m/%d/%Y"),
                        "# AND #",
                        format(input$dates[2], "%m/%d/%Y"), "#"))
      q
    })
    
    query_unsale_ly = reactive({
      q = ifelse(input$house == 'Saint Louis',
                 paste0("SELECT *
                        FROM T_Unsaleables
                        WHERE Warehouse = 'STL' AND Date BETWEEN #",
                        start_date_ly(),
                        "# AND #",
                        end_date_ly(), "#"),
                 paste0("SELECT *
                        FROM T_Unsaleables
                        WHERE Warehouse = 'KC' AND Date BETWEEN #",
                        start_date_ly(),
                        "# AND #",
                        end_date_ly(), "#"))
      q
    })
    
    
    
    ## ________________get unsaleables data________________ ##
    t_unsaleables = reactive({
      t = sqlQuery(odbc_connection, query=query_unsale())
      t
    })
    
    t_unsaleables_ly = reactive({
      t = sqlQuery(odbc_connection, query=query_unsale_ly())
      t
    })
    
    ## ________________get summary of unsaleables________________ ##
    output$total_unsaleables = renderValueBox({
      valueBox(
        scales::dollar((round(sum(t_unsaleables()[, 'Cost'], na.rm=TRUE)))),
        'Unsaleables', icon=icon('trash-o')
      )
    })
    
    output$total_unsaleables_ly = renderValueBox({
      valueBox(
        scales::dollar((round(sum(t_unsaleables_ly()[, 'Cost'], na.rm=TRUE)))),
        'Unsaleables LY', icon=icon('trash-o')
      )
    })
    
    ## ________________render atomic level data to output________________ ##
    output$atomic_unsaleables = renderDataTable({
      t_unsaleables()
    })
    
    output$atomic_unsaleables_ly = renderDataTable({
      t_unsaleables_ly()
    })
    
    ## ________________calculate yoy change________________ ##
    output$total_unsaleables_delta = renderValueBox({
      x = round(sum(t_unsaleables()[, 'Cost']))
      y = round(sum(t_unsaleables_ly()[, 'Cost']))
      d = scales::percent(((x - y) / y))
      valueBox(
        d, 'YOY %Change', icon=icon('trash-o')
      )
    })
    
    
    ## ________________top unsaleables by supplier product director________________ ##
    output$top_10_plot = renderPlot({
      
      u = t_unsaleables()
      u = u[, c('Supplier', 'Cases', 'Cost')]
      u = melt(u, id='Supplier')
      u = dcast(u, Supplier ~ variable, function(x) round(sum(x)))
      names(u) = c('Supplier', 'Cases', 'Cost')
      u2 = head(u %>% arrange(desc(Cases)), 10)
      u2$Supplier = factor(u2$Supplier, levels=u2$Supplier)
      u = u %>% arrange(desc(Cost))
      u = head(u, 10)
      u$Supplier = factor(u$Supplier, levels=u$Supplier)
      
      
      g = ggplot(data=u, aes(x=factor(Supplier), y=Cost))
      one = g + geom_bar(stat='identity', fill='blue') + 
        theme(legend.position='none', 
              axis.text.x=element_text(angle=90,hjust=1)) +
        scale_y_continuous(labels=dollar) +
        labs(title='Top 10 Unsaleables by Supplier ($)',
             x = 'Supplier') + 
        coord_flip()
      
      t = ggplot(data=u2, aes(x=factor(Supplier), y=Cases))
      two = t + geom_bar(stat='identity', fill='orange') + 
        theme(legend.position='none', 
              axis.text.x=element_text(angle=90,hjust=1)) +
        scale_y_continuous(labels=comma) +
        labs(title='Top 10 Unsaleables by Supplier (Cases)',
             x = 'Supplier') + 
        coord_flip()
      
      
      
      z = t_unsaleables()
      z = z[, c('Product', 'Cases', 'Cost')]
      z = melt(z, id='Product')#, measzre.var=c('Cases', 'Cost'))
      z = dcast(z, Product ~ variable, function(x) round(sum(x)))
      names(z) = c('Product', 'Cases', 'Cost')
      z2 = head(z %>% arrange(desc(Cases)), 10)
      z2$Product = factor(z2$Product, levels=z2$Product)
      z = z %>% arrange(desc(Cost))
      z = head(z, 10)
      z$Product = factor(z$Product, levels=z$Product)
      
      
      
      p = ggplot(data=z, aes(x=factor(Product), y=Cost))
      three = p + geom_bar(stat='identity', fill='blue') + 
        theme(legend.position='none', 
              axis.text.x=element_text(angle=90,hjust=1)) +
        scale_y_continuous(labels=dollar) +
        labs(title='Top 10 Unsaleables by Product ($)',
             x = 'Product') + 
        coord_flip()
      
      s = ggplot(data=z2, aes(x=factor(Product), y=Cases))
      four = s + geom_bar(stat='identity', fill='orange') + 
        theme(legend.position='none', 
              axis.text.x=element_text(angle=90,hjust=1)) +
        scale_y_continuous(labels=comma) +
        labs(title='Top 10 Unsaleables by Product (Cases)',
             x = 'Product') + 
        coord_flip()
      
      grid.arrange(one, two, three, four, ncol=2, nrow=2)
      
    })
    
    
    ## ________________summary of unsaleables________________ ##
    output$unsaleable_summary_data = renderDataTable({
      z = t_unsaleables() # add (type, director, class) (month, year, date)
      
      if(input$unsaleables_facet=='Product') {
        data = melt(z, id=c('Product', 'Supplier'), measure.var=c('Cases', 'Cost'))
        data = dcast(data, Product ~ variable, function(x) round(sum(x)))
        names(data) = c('Product', 'Cases', 'Cost')
        data = data %>% arrange(desc(Cost))
      } else if(input$unsaleables_facet=='Supplier') {
        data = melt(z, id='Supplier', measure.var=c('Cases', 'Cost'))
        data = dcast(data, Supplier ~ variable, function(x) round(sum(x)))
        names(data) = c('Supplier', 'Cases', 'Cost')
        data = data %>% arrange(desc(Cost))
      } else {
        data = melt(z, id='Class', measure.var=c('Cases', 'Cost'))
        data = dcast(data, Class ~ variable, function(x) round(sum(x)))
        names(data) = c('Class', 'Cases', 'Cost')
        data = data %>% arrange(desc(Cost))
      }
      data = data[,c(1, 3, 2)]
      data$Cost = scales::dollar((data$Cost))
      data
    })
    
    
    
    
    
    
    
    
    
    
    ################################################################################
    
    
    # break_plot_title = reactive({
    #   if(input$house=='Saint Louis' & input$driver_warehouse=='Warehouse'){
    #     title = 'YTD Breakage, STL Warehouse'
    #   }
    #   if(input$house=='Saint Louis' & input$driver_warehouse=='Drivers'){
    #     title = 'YTD Breakage, STL Drivers'
    #   }
    #   if(input$house=='Kansas City' & input$driver_warehouse=='Warehouse'){
    #     title = 'YTD Breakage, KC Warehouse'
    #   }
    #   if(input$house=='Kansas City' & input$driver_warehouse=='Drivers'){
    #     title = 'YTD Breakage, KC Drivers'
    #   }
    #   title
    # })
    
    
    
    # y_axis2 = reactive({
    #   if(input$unsaleables_variable=='Dumps by Case') {
    #     y_axis2 = top_15_unsaleable_supplier$CASES.DUMPED
    #   }
    #   if(input$unsaleables_variable=='Dumps by Dollar') {
    #     y_axis2 = top_15_unsaleable_supplier$COST.DUMPED
    #   }
    #   if(input$unsaleables_variable=='Total Unsaleables by Case') {
    #     y_axis2 = top_15_unsaleable_supplier$CASES.UNSALEABLE
    #   }
    #   if(input$unsaleables_variable=='Total Unsaleables by Dollar') {
    #     y_axis2 = top_15_unsaleable_supplier$COST.UNSALEABLE
    #   }
    #   if(input$unsaleables_variable=='Returns by Case') {
    #     y_axis2 = top_15_unsaleable_supplier$CASES.RETURNED
    #   }
    #   if(input$unsaleables_variable=='Returns by Dollar') {
    #     y_axis2 = top_15_unsaleable_supplier$COST.RETURNED
    #   }
    #   y_axis2
    # })
    
    # y_axis3 = reactive({
    #   if(input$unsaleables_variable=='Dumps by Case') {
    #     y_axis3 = top_15_unsaleable_items$CASES.DUMPED
    #   }
    #   if(input$unsaleables_variable=='Dumps by Dollar') {
    #     y_axis3 = top_15_unsaleable_items$COST.DUMPED
    #   }
    #   if(input$unsaleables_variable=='Total Unsaleables by Case') {
    #     y_axis3 = top_15_unsaleable_items$CASES.UNSALEABLE
    #   }
    #   if(input$unsaleables_variable=='Total Unsaleables by Dollar') {
    #     y_axis3 = top_15_unsaleable_items$COST.UNSALEABLE
    #   }
    #   if(input$unsaleables_variable=='Returns by Case') {
    #     y_axis3 = top_15_unsaleable_items$CASES.RETURNED
    #   }
    #   if(input$unsaleables_variable=='Returns by Dollar') {
    #     y_axis3 = top_15_unsaleable_items$COST.RETURNED
    #   }
    #   
    #   y_axis3
    # })
    # 
    
    # 
    # output$driver_breakage = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::dollar((round(stl_breakage_summary[8, 2]))), 
    #            scales::dollar((round(kc_breakage_summary[8, 2])))), 
    #     'YTD Driver Breakage', icon=icon('trash-o')
    #   )
    # })
    # 
    # output$driver_breakage_ly = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::dollar((round(stl_breakage_summary[8, 5]))), 
    #            scales::dollar((round(kc_breakage_summary[8, 5])))), 
    #     'YTD Driver Breakage LY', icon=icon('trash-o')
    #   )
    # })
    # 
    # output$driver_breakage_delta = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::percent((round(stl_breakage_summary[8, 8], 4))), 
    #            scales::percent((round(kc_breakage_summary[8, 8], 4)))), 
    #     'Year-Over-Year Change', icon=icon('trash-o')
    #   )
    # })
    # 
    
    
    # for plot tab
    
    # breaks = reactive({
    #   if(input$house=='Saint Louis') { 
    #     breaks = stl_breakage_master
    #     } 
    #   if(input$house=='Kansas City') {
    #     breaks = kc_breakage_master
    #   }
    #   breaks$Month = factor(breaks$Month, levels=c('January','February','March','April','May','June','July',
    #                                                'August','September','October','November','December'))
    #   breaks$Type = factor(breaks$Type, levels=c('Liquor (1)', 'Wine (2)', 'Beer (3)', 'Non-Alc (4)'))
    #   breaks
    # })
    
    # break_plot_title = reactive({
    #   if(input$house=='Saint Louis' & input$driver_warehouse=='Warehouse'){
    #     title = 'YTD Breakage, STL Warehouse'
    #   }
    #   if(input$house=='Saint Louis' & input$driver_warehouse=='Drivers'){
    #     title = 'YTD Breakage, STL Drivers'
    #   }
    #   if(input$house=='Kansas City' & input$driver_warehouse=='Warehouse'){
    #     title = 'YTD Breakage, KC Warehouse'
    #   }
    #   if(input$house=='Kansas City' & input$driver_warehouse=='Drivers'){
    #     title = 'YTD Breakage, KC Drivers'
    #   }
    #   title
    # })
    # 
    # output$cum_breakage_plot = renderPlot({
    #   y_axis = reactive({
    #     if(input$driver_warehouse == 'Warehouse') {
    #       y_axis = breaks()$YTD.Warehouse.Cost
    #     }
    #     if(input$driver_warehouse == 'Drivers') {
    #       y_axis = breaks()$YTD.Driver.Cost
    #     }
    #     y_axis
    #   })
    #   
    #   p = ggplot(breaks(), aes(factor(Month), y=y_axis()))
    #   p =  p + geom_point(aes(group=factor(Type))) + 
    #     geom_line(aes(x=factor(Month), y=y_axis(), colour=factor(Type),
    #                   group=factor(Type)), size=2, alpha=0.5) +
    #     theme(legend.position='bottom', axis.text.x=element_text(angle=90, hjust=1)) + 
    #     labs(title=break_plot_title(),
    #          x="Month", y="Dollars") +
    #     facet_wrap(~Year, nrow=1) +
    #     scale_y_continuous(labels=dollar)
    #   print(p)
    # })
    # 
    
    
    ############################################################################
    
    
    # output$cases_delivered = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::comma((stl_production_summary[1, 2])), 
    #            scales::comma((kc_production_summary[1, 2]))), 
    #     'Cases Shipped', icon=icon('truck')
    #   )
    # })
    # 
    # output$cases_delivered_ly = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::comma((stl_production_summary[1, 3])), 
    #            scales::comma((kc_production_summary[1, 3]))), 
    #     'Cases Shipped LY', icon=icon('truck')
    #   )
    # })
    # 
    # output$cases_delivered_delta = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::percent((round(stl_production_summary[1, 4], 4))), 
    #            scales::percent((round(kc_production_summary[1, 4], 4)))), 
    #     'Year-Over-Year Change', icon=icon('truck')
    #   )
    # })
    # 
    # output$cpmh = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::comma((round(stl_production_summary[5, 2], 2))), 
    #            scales::comma((round(kc_production_summary[5, 2], 2)))), 
    #     'Cases / Man Hour', icon=icon('gears')
    #   )
    # })
    # 
    # output$cpmh_ly = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::comma((round(stl_production_summary[5, 3], 2))), 
    #            scales::comma((round(kc_production_summary[5, 3], 2)))), 
    #     'Cases / Man Hour LY', icon=icon('gears')
    #   )
    # })
    # 
    # output$cpmh_delta = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::percent((round(stl_production_summary[5, 4], 4))), 
    #            scales::percent((round(kc_production_summary[5, 4], 4)))), 
    #     'Year-Over-Year Change', icon=icon('gears')
    #   )
    # })
    
    # output$errors = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::comma((stl_production_summary[9, 2])), 
    #            scales::comma((round(kc_production_summary[9, 2], 2)))), 
    #     'Errors', icon=icon('frown-o')
    #   )
    # })
    # 
    # output$errors_ly = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::comma((stl_production_summary[9, 3])), 
    #            scales::comma((round(kc_production_summary[9, 3], 2)))), 
    #     'Errors LY', icon=icon('frown-o')
    #   )
    # })
    # 
    # output$errors_delta = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::percent((round(stl_production_summary[9, 4], 4))), 
    #            scales::percent((round(kc_production_summary[9, 4], 4)))), 
    #     'Year-Over-Year Change', icon=icon('frown-o')
    #   )
    # })
    
    # output$man_hours = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::comma((round(stl_production_summary[7, 2]))), 
    #            scales::comma((round(kc_production_summary[7, 2])))), 
    #     'Man Hours', icon=icon('users')
    #   )
    # })
    # 
    # output$man_hours_ly = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::comma((round(stl_production_summary[7, 3]))), 
    #            scales::comma((round(kc_production_summary[7, 3])))), 
    #     'Man Hours LY', icon=icon('users')
    #   )
    # })
    # 
    # output$man_hours_delta = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::percent((round(stl_production_summary[7, 4], 4))), 
    #            scales::percent((round(kc_production_summary[7, 4], 4)))), 
    #     'Year-Over-Year Change', icon=icon('users')
    #   )
    # })
    # 
    # output$employees_on_hand = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::comma((round(stl_production_summary[8, 2]))), 
    #            scales::comma((round(kc_production_summary[8, 2])))), 
    #     'Avg Employees On Hand', icon=icon('user')
    #   )
    # })
    # 
    # output$employees_on_hand_ly = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::comma((round(stl_production_summary[8, 3]))), 
    #            scales::comma((round(kc_production_summary[8, 3])))), 
    #     'Avg Employees On Hand LY', icon=icon('user')
    #   )
    # })
    # 
    # output$employees_on_hand_delta = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::percent((round(stl_production_summary[8, 4], 4))), 
    #            scales::percent((round(kc_production_summary[8, 4], 4)))), 
    #     'Year-Over-Year Change', icon=icon('user')
    #   )
    # })
    # 
    # output$oddball_cases = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::comma((round(stl_production_summary[13, 2]))), 
    #            scales::comma((round(kc_production_summary[13, 2])))), 
    #     'Oddball Cases', icon=icon('random')
    #   )
    # })
    # 
    # output$oddball_cases_ly = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::comma((round(stl_production_summary[13, 3]))), 
    #            scales::comma((round(kc_production_summary[13, 3])))), 
    #     'Oddball Cases LY', icon=icon('random')
    #   )
    # })
    # 
    # output$oddball_cases_delta = renderValueBox({
    #   valueBox(
    #     ifelse(input$house=='Saint Louis', 
    #            scales::percent((round(stl_production_summary[13, 4], 4))), 
    #            scales::percent((round(kc_production_summary[13, 4], 4)))), 
    #     'Year-Over-Year Change', icon=icon('random')
    #   )
    # })
    # 
    
    
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
    
    # output$breakage_data = renderDataTable({
    #   if(input$house=='Saint Louis' & input$driver_warehouse=='Warehouse') {
    #     data = stl_breakage_warehouse
    #   }
    #   if(input$house=='Saint Louis' & input$driver_warehouse=='Drivers') {
    #     data = stl_breakage_driver
    #   }
    #   if(input$house=='Kansas City' & input$driver_warehouse=='Warehouse') {
    #     data = kc_breakage_warehouse
    #   }
    #   if(input$house=='Kansas City' & input$driver_warehouse=='Drivers') {
    #     data = kc_breakage_driver
    #   }
    #   data
    # })
    
    
    
    
    # for unsaleables tab
    
    # top15_suppliers = renderDataTable({
    #   x = ifelse(1 == 1, 
    #          top_15_unsaleable_supplier, top_15_unsaleable_supplier)
    #   x
    # })
    # 
    # top15_items = renderDataTable({
    #   y = ifelse(input$unsaleables_facet=='Item', 
    #          top_15_unsaleable_items, top_15_unsaleable_items)
    #   y
    # })
    # 
    
    
    
    
    
    
    # output$unsaleable_plot = renderPlot({
    #   y_axis2 = reactive({
    #     if(input$unsaleables_variable=='Dumps by Case') {
    #       y_axis2 = top_15_unsaleable_supplier$CASES.DUMPED
    #     }
    #     if(input$unsaleables_variable=='Dumps by Dollar') {
    #       y_axis2 = top_15_unsaleable_supplier$COST.DUMPED
    #     }
    #     if(input$unsaleables_variable=='Total Unsaleables by Case') {
    #       y_axis2 = top_15_unsaleable_supplier$CASES.UNSALEABLE
    #     }
    #     if(input$unsaleables_variable=='Total Unsaleables by Dollar') {
    #       y_axis2 = top_15_unsaleable_supplier$COST.UNSALEABLE
    #     }
    #     if(input$unsaleables_variable=='Returns by Case') {
    #       y_axis2 = top_15_unsaleable_supplier$CASES.RETURNED
    #     }
    #     if(input$unsaleables_variable=='Returns by Dollar') {
    #       y_axis2 = top_15_unsaleable_supplier$COST.RETURNED
    #     }
    #     y_axis2
    #   })
    #   
    #   y_axis3 = reactive({
    #     if(input$unsaleables_variable=='Dumps by Case') {
    #       y_axis3 = top_15_unsaleable_items$CASES.DUMPED
    #     }
    #     if(input$unsaleables_variable=='Dumps by Dollar') {
    #       y_axis3 = top_15_unsaleable_items$COST.DUMPED
    #     }
    #     if(input$unsaleables_variable=='Total Unsaleables by Case') {
    #       y_axis3 = top_15_unsaleable_items$CASES.UNSALEABLE
    #     }
    #     if(input$unsaleables_variable=='Total Unsaleables by Dollar') {
    #       y_axis3 = top_15_unsaleable_items$COST.UNSALEABLE
    #     }
    #     if(input$unsaleables_variable=='Returns by Case') {
    #       y_axis3 = top_15_unsaleable_items$CASES.RETURNED
    #     }
    #     if(input$unsaleables_variable=='Returns by Dollar') {
    #       y_axis3 = top_15_unsaleable_items$COST.RETURNED
    #     }
    #     
    #     y_axis3
    #   })
    #   
    #   g = ggplot(data=top_15_unsaleable_supplier, aes(x=SUPPLIER, y=y_axis2()))
    #   x = g + geom_bar(aes(x=SUPPLIER, fill=factor(DIRECTOR)), stat='identity') + 
    #     theme(legend.position='bottom', axis.text.x=element_text(angle=90,hjust=1)) +
    #     scale_y_continuous(labels=comma) +
    #     labs(title='Top 10 Unsaleables by Supplier') + 
    #     coord_flip()
    #   
    #   p = ggplot(data=top_15_unsaleable_items, aes(x=DESCRIPTION, y=y_axis3()))
    #   y = p + geom_bar(stat='identity', aes(fill=DIRECTOR)) + 
    #     theme(legend.position='bottom', axis.text.x=element_text(angle=90,hjust=1)) +
    #     scale_y_continuous(labels=comma) +
    #     labs(title='Top 10 Unsaleables by Item') + 
    #     coord_flip()
    #   
    #   z = grid.arrange(x, y, nrow=1)
    #   
    #   print(z)
    # })
    # 
    # 
    # output$unsaleable_data = renderDataTable({
    #   if(input$unsaleables_facet=='Item') { 
    #     data = unsaleables_items
    #   } 
    #   if(input$unsaleables_facet=='Supplier') {
    #     data = unsaleables_suppliers
    #   }
    # 
    #   data
    # })
    # 
    
    
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
    
    # kc begins velocity
    
    output$c_100 = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'C-100', 2]))),  
        'C-100 Cases', icon=icon('cubes'), color='olive')
    })
    output$c_100_percent = renderValueBox({
      valueBox(
        scales::percent((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'C-100', 3], 4))),  
        'Percent Total Cases', icon=icon('pie-chart'), color='olive')
    })
    output$c_100_unique = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'C-100', 6]))),  
        'Unique Items', icon=icon('barcode'), color='olive')
    })
    
    output$c_200 = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'C-200', 2]))),  
        'C-200 Cases', icon=icon('cubes'), color='olive')
    })
    output$c_200_percent = renderValueBox({
      valueBox(
        scales::percent((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'C-200', 3], 4))),  
        'Percent Total Cases', icon=icon('pie-chart'), color='olive')
    })
    output$c_200_unique = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'C-200', 6]))),  
        'Unique Items', icon=icon('barcode'), color='olive')
    })
    
    output$c_300 = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'C-300', 2]))),  
        'C-300 Cases', icon=icon('cubes'), color='olive')
    })
    output$c_300_percent = renderValueBox({
      valueBox(
        scales::percent((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'C-300', 3], 4))),  
        'Percent Total Cases', icon=icon('pie-chart'), color='olive')
    })
    output$c_300_unique = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'C-300', 6]))),  
        'Unique Items', icon=icon('barcode'), color='olive')
    })
    
    output$c_400 = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'C-400', 2]))),  
        'C-400 Cases', icon=icon('cubes'), color='olive')
    })
    output$c_400_percent = renderValueBox({
      valueBox(
        scales::percent((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'C-400', 3], 4))),  
        'Percent Total Cases', icon=icon('pie-chart'), color='olive')
    })
    output$c_400_unique = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'C-400', 6]))),  
        'Unique Items', icon=icon('barcode'), color='olive')
    })
    
    output$odd = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'ODDBALL', 2]))),  
        'Oddball Cases', icon=icon('cubes'), color='olive')
    })
    output$odd_percent = renderValueBox({
      valueBox(
        scales::percent((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'ODDBALL', 3], 4))),  
        'Percent Total Cases', icon=icon('pie-chart'), color='olive')
    })
    output$odd_unique = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'ODDBALL', 6]))),  
        'Unique Items', icon=icon('barcode'), color='olive')
    })
    
    output$wine = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'WINE ROOM', 2]))),  
        'Wine Room Cases', icon=icon('cubes'), color='olive')
    })
    output$wine_percent = renderValueBox({
      valueBox(
        scales::percent((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'WINE ROOM', 3], 4))),  
        'Percent Total Cases', icon=icon('pie-chart'), color='olive')
    })
    output$wine_unique = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'WINE ROOM', 6]))),  
        'Unique Items', icon=icon('barcode'), color='olive')
    })
    
    output$a_rack = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'A-RACK', 4]))),  
        'A Rack Bottles', icon=icon('cubes'), color='olive')
    })
    output$a_rack_percent = renderValueBox({
      valueBox(
        scales::percent((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'A-RACK', 5], 4))),  
        'Percent Total Bottles', icon=icon('pie-chart'), color='olive')
    })
    output$a_rack_unique = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'A-RACK', 6]))),  
        'Unique Items', icon=icon('barcode'), color='olive')
    })
    
    output$b_rack = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'B-RACK']))),  
        'B Rack Bottles', icon=icon('cubes'), color='olive')
    })
    output$b_rack_percent = renderValueBox({
      valueBox(
        scales::percent((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'B-RACK', 5], 4))),  
        'Percent Total Bottles', icon=icon('pie-chart'), color='olive')
    })
    output$b_rack_unique = renderValueBox({
      valueBox(
        scales::comma((round(kc_velocity_summary[kc_velocity_summary$CASE.LINE %in% 'B-RACK', 6]))),  
        'Unique Items', icon=icon('barcode'), color='olive')
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
