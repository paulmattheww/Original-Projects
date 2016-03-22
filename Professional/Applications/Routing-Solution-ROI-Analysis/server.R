# server.R
library(shiny)
library(ggplot2)
library(gridExtra)
library(ggthemes)
library(dplyr)
library(scales)


simulate_data = function(percent_saved_fuel, percent_saved_driver_compensation, p_truck_gone, non_recurring_inflator,
                         opportunity_equip_maint_improve = 0,
                         opportunity_analyst_resources_improve = 0,
                         opportunity_router_resources_improve = 0,
                         roadnet_telematics = 0) {

  roadnet_yearly = 79002.12
  roadnet_telematics_monthly =  round(roadnet_telematics / 12, 2) # 19173 if using, 0 else
  roadnet_monthly = 6583.51 + roadnet_telematics_monthly # roadnet_yearly == roadnet_monthly * 12
  roadnet_consulting = 2100
  roadnet_onsite_conversion = 7150
  roadnet_insights = 5700
  
  non_recurring_inflator = non_recurring_inflator # IT WILL PROBABLY GO OVER BUDGET AND TIMELINE
  non_recurring = (roadnet_consulting + roadnet_onsite_conversion + roadnet_insights) * non_recurring_inflator
  
  n_drivers = 70
  cell_ins_yearly = 25 * n_drivers  # $25 per user per year
  cell_ins_monthly = round(cell_ins_yearly / 12, 2)
  upgrade_cost_per_phone = 50       # price changed, iPhone is $.99
  cell_phones_yearly = (upgrade_cost_per_phone * n_drivers) * 1.0423# mo sales tax 4.23 for city
  cell_phones_monthly = round(cell_phones_yearly / 12, 2)
  # n_accounts = 1 # from 4 to 5 accounts of 100 useres per account; 1 new account will be added
  cell_data_plan_monthly = 1125 + (35 * n_drivers) # 35 per user per month
  cell_data_plan_yearly = cell_data_plan_monthly * 12
  
  p_truck_gone = p_truck_gone # probability of ACTUALLY getting truck off road
  
  truck_lease_monthly = 963 * p_truck_gone# first lease up is L6355 in KC it is yearly renewed
  
  truck_insurance_yearly = 1000 + 1231 # 1000 per truck per year for insurance; 1231 for prop taxes, weighted avg bn kc stl
  truck_insurance_monthly = (truck_insurance_yearly / 12) * p_truck_gone  # from Tom
  
  maps_savings = 1063
  maps_savings_monthly = round(maps_savings / 12, 2)
  
  percent_saved_fuel = percent_saved_fuel #LEVER
  ly_fuel_consumption_gal = 524570
  fuel_savings_gallons = ly_fuel_consumption_gal * percent_saved_fuel
  price_per_gallon = 2.53 * 1.08 # assumes 8% inflation in gas price; 2.53 from Tom's hedginge analysis
  
  fuel_savings_yearly = fuel_savings_gallons * price_per_gallon
  fuel_savings_monthly = round(fuel_savings_yearly / 12, 2)
  
  percent_saved_driver_compensation = percent_saved_driver_compensation
  ly_total_comp = 4281082
  driver_compensation_savings_yearly = ly_total_comp * percent_saved_driver_compensation
  driver_compensation_savings_monthly = round(driver_compensation_savings_yearly / 12, 2)
  
  opportunity_equip_maint_improve = opportunity_equip_maint_improve
  opportunity_analyst_resources_improve = opportunity_analyst_resources_improve
  opportunity_router_resources_improve = opportunity_router_resources_improve
  
  
  Month = c('Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep',
            'Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar',
            'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep',
            'Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar',
            'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep',
            'Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar',
            'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep',
            'Oct', 'Nov', 'Dec')
  Year = c('2016', '2016', '2016', '2016', '2016', '2016',
           '2016', '2016', '2016', '2017', '2017', '2017',
           '2017', '2017', '2017', '2017', '2017', '2017',
           '2017', '2017', '2017', '2018', '2018', '2018',
           '2018', '2018', '2018', '2018', '2018', '2018',
           '2018', '2018', '2018', '2019', '2019', '2019',
           '2019', '2019', '2019', '2019', '2019', '2019',
           '2019', '2019', '2019')
  
  roi_data = data.frame(cbind(Month, Year))
  roi_data$Month = factor(roi_data$Month, levels=c('Jan', 'Feb', 'Mar',
                                                   'Apr', 'May', 'Jun', 
                                                   'Jul', 'Aug', 'Sep',
                                                   'Oct', 'Nov', 'Dec'))
  roi_data$Roadnet.Subscription = roadnet_monthly
  cost1 = roi_data$Roadnet.Subscription
  roi_data$Cell.Data.Plan = cell_data_plan_monthly
  cost2 = roi_data$Cell.Data.Plan
  roi_data$Cell.Insurance = cell_ins_monthly
  cost3 = roi_data$Cell.Insurance
  roi_data$One.Time.Expenses = 0
  roi_data[1, 'One.Time.Expenses'] = non_recurring + cell_phones_yearly 
  cost4 = roi_data$One.Time.Expenses
  
  roi_data$Savings.Fuel.Consumption = fuel_savings_monthly
  benefit1 = roi_data$Savings.Fuel.Consumption
  roi_data$Savings.Driver.Compensation = driver_compensation_savings_monthly
  benefit2 = roi_data$Savings.Driver.Compensation
  roi_data$Savings.Truck.Lease = truck_lease_monthly 
  roi_data[c(1:12), 'Savings.Truck.Lease'] = 0 # Lease is not up until March 17
  benefit3 = roi_data$Savings.Truck.Lease
  
  roi_data$Savings.Truck.Insurance = truck_insurance_monthly
  roi_data[c(1:12), 'Savings.Truck.Insurance'] = 0
  benefit4 = roi_data$Savings.Truck.Insurance
  
  roi_data$Savings.Map.Purchases = maps_savings_monthly
  benefit5 = roi_data$Savings.Map.Purchases
  
  roi_data$Total.Costs = cost1 + cost2 + cost3 + cost4
  roi_data$Total.Savings = benefit1 + benefit2 + benefit3 + benefit4 + benefit5 + 
    opportunity_equip_maint_improve + opportunity_analyst_resources_improve + opportunity_router_resources_improve
  
  roi_data = mutate(roi_data, Accumulated.Costs=cumsum(Total.Costs),
                    Accumulated.Savings=cumsum(Total.Savings))
  roi_data = data.frame(roi_data)
  
  roi_data 
}



shinyServer(
  function(input, output) {
   
    roi_data = reactive({
      r = simulate_data(percent_saved_fuel=input$fuel, percent_saved_driver_compensation=input$driver, p_truck_gone=input$truck, non_recurring_inflator=input$inflator,
                             opportunity_equip_maint_improve = input$maintenance, opportunity_analyst_resources_improve = input$analyst, opportunity_router_resources_improve = input$router,
                             roadnet_telematics = input$telematics) #19173 per year, will 
      return(r)
    })
    
   #  roi_data = reactiveValuesToList(roi_data)
    
    output$plot1 <- renderPlot({
      g = ggplot(data=roi_data(), aes(x=Month, y=Accumulated.Costs))
      g + geom_point(aes(group=Year)) + 
        geom_line(aes(group=Year), colour='red', size=1.5, alpha=0.7) +
        geom_point(data=roi_data(), aes(x=Month, y=Accumulated.Savings, group=Year)) +
        geom_line(data=roi_data(), aes(x=Month, y=Accumulated.Savings, group=Year), colour='lightgreen', size=2, alpha=0.7) +
        facet_wrap(~Year, nrow=1) + 
        theme(legend.position='none', axis.text.x=element_text(angle=90, hjust=1.5)) +
        scale_y_continuous(labels=dollar) +
        ggtitle(expression(atop('Accumulated Costs vs. Accumulated Savings of Roadnet', 
                                atop(italic('Manipulate Assumptions Using Sliders'))))) +
        labs(y='Dollars')
    })
    
})
    
