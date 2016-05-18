# server.R

print('THIS IS THE TESTING VERSION')

# runApp('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Testing')

library(shiny)
library(shinydashboard)
library(xlsx)
library(scales)
library(ggplot2)
library(ggthemes)
library(gridExtra)
library(reshape2)
library(dplyr)
library(RODBC)
library(DT)
library(lubridate)

substrRight = function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}
substrLeft = function(x, n){
  substr(x, 1, n)
}


###### NEW STUFF BELOW

reporting_db = 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Reporting Database.accdb'

odbc_connection = odbcConnectAccess2007(reporting_db)

#x = sqlQuery(odbc_connection, "SELECT * FROM T_Breakage WHERE Warehouse = 'STL' AND Date BETWEEN #06/01/2015# AND #03/31/2016#")
# head(x)
# t_returns = sqlFetch(odbc_connection, "T_Returns")
# t_breakage = sqlFetch(odbc_connection, "T_Breakage")
# t_offday = sqlFetch(odbc_connection, "T_Off-Day Deliveries")

# sqlTables(odbc_connection)



#odbcCloseAll()


######




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
# unsaleables_items = unsaleables_items %>% arrange(-CASES.UNSALEABLE)

unsaleables_suppliers = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/unsaleables_suppliers.csv', header=TRUE)
# unsaleables_suppliers = unsaleables_suppliers %>% arrange(-CASES.UNSALEABLE)

# unsaleables_customers = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/unsaleables_customers.csv', header=TRUE)
# unsaleables_customers = unsaleables_customers %>% arrange(-CASES.RETURNED)

top_15_unsaleable_supplier = head(unsaleables_suppliers, 15)
top_15_unsaleable_supplier$SUPPLIER = factor(top_15_unsaleable_supplier$SUPPLIER, levels=top_15_unsaleable_supplier$SUPPLIER)

top_15_unsaleable_items = head(unsaleables_items, 15)
top_15_unsaleable_items$DESCRIPTION = factor(top_15_unsaleable_items$DESCRIPTION, levels=top_15_unsaleable_items$DESCRIPTION)

# top_15_unsaleable_customers = head(unsaleables_customers, 15)
# top_15_unsaleable_customers$CUSTOMER = factor(top_15_unsaleable_customers$SUPPLIER, levels=top_15_unsaleable_customers$CUSTOMER)

stl_velocity_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/stl_velocity_summary_feb16.csv', header=TRUE)
kc_velocity_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Applications/Operations Intelligence Dashboard/Data/kc_velocity_summary_feb16.csv', header=TRUE)





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
    
    
    
    ############################################################################

    
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
    
    
    
    ######## TESTING DB BELOW
    
   
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
        'Warehouse Breakage LY', icon=icon('trash-o')
      )
    })
    
    output$driver_breakage = renderValueBox({
      x = t_breakage()
      x = x %>% filter(grepl('Driver', Type))
      valueBox(
        scales::dollar((round(sum(x[, 'Cost'], na.rm=TRUE)))), 
        'Driver Breakage', icon=icon('trash-o')
      )
    })
    
    output$driver_breakage_ly = renderValueBox({
      x = t_breakage_ly()
      x = x %>% filter(grepl('Driver', Type))
      valueBox(
        scales::dollar((round(sum(x[, 'Cost'], na.rm=TRUE)))), 
        'Driver Breakage LY', icon=icon('trash-o')
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
    
    
    ## ________________breakage plots________________ ##
    
    output$plot_breakage_summary = renderPlot({
      x = brk_for_graphs()
      x = x %>% filter(Cost>0)
      x = x %>% filter(Type != 'UNSPECIFIED')
      x$Month = factor(x$Month, levels=unique(x$Month))
      
      p = ggplot(x, aes(Month, y=Cost, fill=factor(Type)))
      p =  p + geom_bar(stat='identity', 
                        size=0.5, alpha=0.5) +
        scale_fill_discrete(name="Breakage\nType") +
        theme(legend.position='bottom', 
              axis.text.x=element_text(angle=90, hjust=1)) + 
        labs(title='Breakage Summary',
             x="Month", y="Dollars") +
        facet_wrap(~Type, nrow=2) +
        scale_y_continuous(labels=dollar)
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
    
    ########
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
    
    
    output$unsaleable_summary_data = renderDataTable({
      z = t_unsaleables() # add (type, director, class) (month, year, date)
      
      if(input$unsaleables_facet=='Product') {
        data = melt(z, id='Product', measure.var=c('Cases', 'Cost'))
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
      data
    })




    
    
    
    
    
    
    ################################################################################
    
    
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

