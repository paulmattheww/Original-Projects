# server.R
# TESTING VERSION
# runApp('C:/Users/pmwash/Desktop/R_files/Applications/Roadnet ROI Simulator/TESTING')

library(shiny)
library(ggplot2)
library(gridExtra)
library(ggthemes)
library(dplyr)
library(scales)

# read in simulator functions
source('C:/Users/pmwash/Desktop/R_files/Applications/Roadnet ROI Simulator/TESTING/helper.R')


shinyServer(
  function(input, output) {
   
    roi_data = reactive({
      if(input$product_selection == 'C-RDM'){
        r = simulate_cloud_full(percent_saved_fuel=input$fuel, percent_saved_driver_compensation=input$driver, p_truck_gone=input$truck, non_recurring_inflator=input$inflator,
                          opportunity_equip_maint_improve = input$safety, opportunity_analyst_resources_improve = input$analyst, opportunity_router_resources_improve = input$router,
                          roadnet_telematics = 19171, negotiations=72650.4, n_telematics_units=input$n_telematics_units,
                          interest_rate_input = input$interest) 
      }
      if(input$product_selection == 'C-R'){
        r = simulate_cloud_stripped(percent_saved_fuel=input$fuel, percent_saved_driver_compensation=input$driver, p_truck_gone=input$truck, non_recurring_inflator=input$inflator,
                                opportunity_equip_maint_improve = input$safety, opportunity_analyst_resources_improve = input$analyst, opportunity_router_resources_improve = input$router,
                                roadnet_telematics = 19171, negotiations=42848.4, n_telematics_units=input$n_telematics_units,
                                interest_rate_input = input$interest) 
      }
      if(input$product_selection == 'OP-RDM'){
        r = simulate_op_full(percent_saved_fuel=input$fuel, percent_saved_driver_compensation=input$driver, p_truck_gone=input$truck, non_recurring_inflator=input$inflator,
                                opportunity_equip_maint_improve = input$safety, opportunity_analyst_resources_improve = input$analyst, opportunity_router_resources_improve = input$router,
                                roadnet_telematics = 19171, negotiations=68896, n_telematics_units=input$n_telematics_units,
                                interest_rate_input = input$interest) 
      }
      if(input$product_selection == 'OP-R'){
        r = simulate_op_stripped(percent_saved_fuel=input$fuel, percent_saved_driver_compensation=input$driver, p_truck_gone=input$truck, non_recurring_inflator=input$inflator,
                                opportunity_equip_maint_improve = input$safety, opportunity_analyst_resources_improve = input$analyst, opportunity_router_resources_improve = input$router,
                                roadnet_telematics = 19171, negotiations=38598, n_telematics_units=input$n_telematics_units,
                                interest_rate_input = input$interest) 
      }
        
      return(r)
    })
    
   #  roi_data = reactiveValuesToList(roi_data)
    
    output$plot1 <- renderPlot({
      g = ggplot(data=roi_data(), aes(x=Month, y=Present.Value.Accumulated.Costs))
      g + geom_point(aes(group=Year)) + 
        geom_line(aes(group=Year), colour='red', size=1.5, alpha=0.7) +
        geom_point(data=roi_data(), aes(x=Month, y=Present.Value.Accumulated.Savings, group=Year)) +
        geom_line(data=roi_data(), aes(x=Month, y=Present.Value.Accumulated.Savings, group=Year), colour='lightgreen', size=2, alpha=0.7) +
        facet_wrap(~Year, nrow=1) + 
        theme(legend.position='none', axis.text.x=element_text(angle=90, hjust=1.5)) +
        scale_y_continuous(labels=dollar) +
        ggtitle(expression(atop('Present Value Accumulated Costs vs. Present Value Accumulated Savings of Roadnet', 
                                atop(italic('Manipulate Assumptions Using Sliders'))))) +
        labs(y='2016 Dollars')
    })
    
    output$data = renderDataTable({
      roi_data()
    })
    
    output$net_savings_year_3 = reactive({
      net = round(as.numeric(tail(roi_data()[, 'Net.Savings'], 1)))
      net = scales::dollar(net)
    })
    
    output$discounted_net_savings_year_3 = reactive({
      net = round(as.numeric(tail(roi_data()[, 'Present.Value.Net.Savings'], 1)))
      net = scales::dollar(net)
    })
    
    output$downloadData = downloadHandler(
      filename = function() { paste('roadnet_', as.character(round(input$product_selection)), 
                                   '_fuel_', as.character(round(input$fuel*100)), 
                                   '_driver_', as.character(round(input$driver*100)), 
                                   '_telematics_', as.character(round(input$telematics)), '.csv', sep='')
        },
      content = function(file) {
        write.csv(roi_data(), file, row.names=FALSE)
      }
    )
    
    output$months_to_roi = reactive({
      counter = ifelse(roi_data()[, 'Net.Savings'] < 0, 1, 0)
      ifelse(sum(counter)==45, 'ROI will not be realized before 2020; potentially not at all.', sum(counter))
    })
    
    output$miles_saved_per_truck = reactive({
      
      percent_saved_fuel = input$fuel #LEVER
      
      ly_fuel_consumption_gal = 524570
      price_per_gallon = 2.53 * 1.08
      miles_per_gallon = 6.5
      
      fuel_savings_gallons = ly_fuel_consumption_gal * percent_saved_fuel
      fuel_savings_miles = fuel_savings_gallons * miles_per_gallon
      fuel_savings_miles_per_truck = fuel_savings_miles / 70
      fuel_savings_miles_per_truck_per_day = round((fuel_savings_miles_per_truck / 207) * ((40 / 70) * 1.3), 1) #discounted because KC won't see a 100% reduction, 0.3 for every 1 stl
      
      fuel_savings_miles_per_truck_per_day
      
    })
    
    output$delivery_hours_saved = reactive({
      
      percent_saved_driver_compensation = input$driver
      ly_total_comp = 5450219#4281082
      hourly_wage = 20
      
      driver_compensation_savings_yearly = ly_total_comp * percent_saved_driver_compensation
      
      hours_saved_per_year = round(driver_compensation_savings_yearly / hourly_wage, 2)
      hours_saved_per_day = hours_saved_per_year / 207
      hours_saved_per_day_per_employee = round(hours_saved_per_day / 70, 2)
      
      minutes_saved_per_employee_per_day = round((hours_saved_per_day_per_employee * 60) * (40/70), 1)
      
      minutes_saved_per_employee_per_day
    })
    
    
    output$yearly_cost = reactive({
      x = ifelse(input$product_selection=='C-RDM', 72650,
             ifelse(input$product_selection=='C-R', 42848,
                    ifelse(input$product_selection=='OP-RDM', 68896, 38598)))
      x = scales::dollar(x)
      x
    })
    
    
    
})
    
