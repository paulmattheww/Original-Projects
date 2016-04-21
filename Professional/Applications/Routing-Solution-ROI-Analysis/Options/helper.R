

# roadnet helper file


simulate_cloud_full = function(percent_saved_fuel, percent_saved_driver_compensation, p_truck_gone, non_recurring_inflator,
                               opportunity_equip_maint_improve = 0,
                               opportunity_analyst_resources_improve = 0,
                               opportunity_router_resources_improve = 0,
                               roadnet_telematics = 0,
                               negotiations = 72650.40, #cut out $8349 in BI tool per $9.94 per truck per month
                               n_telematics_units = 0,
                               interest_rate_input = 0.06) {
  
  roadnet_yearly = negotiations
  n_telematics_units = n_telematics_units
  
  roadnet_telematics_monthly_per_truck = 19171 / 12 / 70 # total / 70 quoted trucks / 12 months
  roadnet_telematics_monthly = round(roadnet_telematics_monthly_per_truck * n_telematics_units, 2)  # yearly / 12 monoths / 70 units quoted at 19171
  
  
  roadnet_monthly = round(roadnet_yearly / 12, 2) + roadnet_telematics_monthly # roadnet_yearly == roadnet_monthly * 12
  
  
  roadnet_consulting = 2100
  roadnet_onsite_conversion = 7150
  
  roadnet_telematics_unit_cost = n_telematics_units * 288 # from Joe P a while back
  
  non_recurring_inflator = non_recurring_inflator # IT WILL PROBABLY GO OVER BUDGET AND TIMELINE
  non_recurring = (roadnet_consulting + roadnet_onsite_conversion + roadnet_telematics_unit_cost) * non_recurring_inflator
  
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
  
  truck_insurance_yearly = 1400 + 1231 # 1000 per truck per year for insurance; 1231 for prop taxes, weighted avg bn kc stl
  truck_insurance_monthly = (truck_insurance_yearly / 12) * p_truck_gone  # from Tom
  
  maps_savings = 1211.81
  maps_savings_monthly = round(maps_savings / 12, 2)
  
  percent_saved_fuel = percent_saved_fuel #LEVER
  ly_fuel_consumption_gal = 524570
  fuel_consumption_per_truck_per_year = ly_fuel_consumption_gal / 70 #70 units
  fuel_consumption_per_truck_per_month = fuel_consumption_per_truck_per_year / 12
  
  fuel_savings_gallons = ly_fuel_consumption_gal * percent_saved_fuel
  price_per_gallon = 2.53 * 1.08 # assumes 8% inflation in gas price; 2.53 from Tom's hedginge analysis
  
  fuel_savings_yearly = fuel_savings_gallons * price_per_gallon
  fuel_savings_monthly = round(((fuel_savings_yearly / 12) * (40/70)) + (((fuel_savings_yearly / 12) * (30/70)) * 0.3), 2) # for every 1 gal stl saves kc will save .30 gal
  
  percent_saved_driver_compensation = percent_saved_driver_compensation
  ly_total_comp = 5450219#4281082
  driver_compensation_savings_yearly = ly_total_comp * percent_saved_driver_compensation
  driver_compensation_savings_monthly = round(round(driver_compensation_savings_yearly / 12, 2) * (40/70), 2) # STL won't save as much on driver comp
  
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
  roi_data[2, 'One.Time.Expenses'] = non_recurring + cell_phones_yearly 
  cost4 = roi_data$One.Time.Expenses
  
  roi_data$Savings.Fuel.Consumption = fuel_savings_monthly
  roi_data[c(1:4), c(7)] = 0 # won't see fuel savings until we go live + 1 month
  benefit1 = roi_data$Savings.Fuel.Consumption
  
  roi_data$Savings.Driver.Compensation = driver_compensation_savings_monthly
  roi_data[c(1:4), c(8)] = 0 # won't see drv comp savings until we go live + 1 month
  benefit2 = roi_data$Savings.Driver.Compensation
  
  roi_data$Savings.Truck.Lease = round(truck_lease_monthly + fuel_consumption_per_truck_per_month, 2)
  roi_data[c(1:12), 'Savings.Truck.Lease'] = 0 # Lease is not up until March 17
  benefit3 = roi_data$Savings.Truck.Lease
  
  roi_data$Savings.Truck.Insurance = truck_insurance_monthly
  roi_data[c(1:12), 'Savings.Truck.Insurance'] = 0
  benefit4 = roi_data$Savings.Truck.Insurance
  
  roi_data$Savings.Map.Purchases = maps_savings_monthly
  benefit5 = roi_data$Savings.Map.Purchases
  
  current_roadnet_yearly_cost = 8333
  current_monthly = round(current_roadnet_yearly_cost / 12, 2)
  benefit6 = current_monthly
  
  roi_data$Total.Costs = cost1 + cost2 + cost3 + cost4
  roi_data$Total.Savings = benefit1 + benefit2 + benefit3 + benefit4 + benefit5 + benefit6 +
    opportunity_equip_maint_improve + opportunity_analyst_resources_improve + opportunity_router_resources_improve
  
  roi_data = mutate(roi_data, Accumulated.Costs=cumsum(Total.Costs),
                    Accumulated.Savings=cumsum(Total.Savings))
  roi_data$Net.Savings = round(roi_data$Accumulated.Savings - roi_data$Accumulated.Costs, 2)
  
  roi_data = data.frame(roi_data)
  
  t_cost = roi_data$Total.Costs
  t_save = roi_data$Total.Savings
  n_periods = 0:(length(roi_data$Total.Costs) - 1)
  
  interest_rate_monthly = interest_rate_input / 12
  
  discounted_cost = round(t_cost / (1 + interest_rate_monthly)^(n_periods), 2)
  roi_data$Present.Value.Total.Costs = discounted_cost
  
  discounted_savings = round(t_save / (1 + interest_rate_monthly)^(n_periods), 2)
  roi_data$Present.Value.Total.Savings = discounted_savings
  
  
  roi_data = mutate(roi_data, Present.Value.Accumulated.Costs=cumsum(Present.Value.Total.Costs),
                    Present.Value.Accumulated.Savings=cumsum(Present.Value.Total.Savings))
  roi_data$Present.Value.Net.Savings = round(roi_data$Present.Value.Accumulated.Savings - roi_data$Present.Value.Accumulated.Costs, 2)
  
  roi_data[c(1), 'Roadnet.Subscription'] = 0
  
  roi_data 
}




simulate_cloud_stripped = function(percent_saved_fuel, percent_saved_driver_compensation, p_truck_gone, non_recurring_inflator,
                                   opportunity_equip_maint_improve = 0,
                                   opportunity_analyst_resources_improve = 0,
                                   opportunity_router_resources_improve = 0,
                                   roadnet_telematics = 0,
                                   negotiations = 42848.4,
                                   n_telematics_units = 0,
                                   interest_rate_input = 0.06) {
  
  roadnet_yearly = negotiations
  n_telematics_units = n_telematics_units
  
  roadnet_telematics_monthly_per_truck = 19171 / 12 / 70 # total / 70 quoted trucks / 12 months
  roadnet_telematics_monthly = round(roadnet_telematics_monthly_per_truck * n_telematics_units, 2)  # yearly / 12 monoths / 70 units quoted at 19171
  
  
  roadnet_monthly = round(roadnet_yearly / 12, 2) + roadnet_telematics_monthly # roadnet_yearly == roadnet_monthly * 12
  
  
  roadnet_consulting = 2100
  roadnet_onsite_conversion = 7150
  
  roadnet_telematics_unit_cost = n_telematics_units * 288 # from Joe P a while back
  
  
  non_recurring_inflator = non_recurring_inflator # IT WILL PROBABLY GO OVER BUDGET AND TIMELINE
  non_recurring = (roadnet_consulting + roadnet_onsite_conversion + roadnet_telematics_unit_cost) * non_recurring_inflator
  
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
  
  truck_insurance_yearly = 1400 + 1231 # 1000 per truck per year for insurance; 1231 for prop taxes, weighted avg bn kc stl
  truck_insurance_monthly = (truck_insurance_yearly / 12) * p_truck_gone  # from Tom
  
  maps_savings = 1211.81
  maps_savings_monthly = round(maps_savings / 12, 2)
  
  percent_saved_fuel = percent_saved_fuel #LEVER
  ly_fuel_consumption_gal = 524570
  fuel_consumption_per_truck_per_year = ly_fuel_consumption_gal / 70 #70 units
  fuel_consumption_per_truck_per_month = fuel_consumption_per_truck_per_year / 12
  
  fuel_savings_gallons = ly_fuel_consumption_gal * percent_saved_fuel
  price_per_gallon = 2.53 * 1.08 # assumes 8% inflation in gas price; 2.53 from Tom's hedginge analysis
  
  fuel_savings_yearly = fuel_savings_gallons * price_per_gallon
  fuel_savings_monthly = round((round(fuel_savings_yearly / 12, 2)) * ((40/70) * 1.3), 2) # for every 1 gal stl saves kc will save .30 gal
  
  percent_saved_driver_compensation = percent_saved_driver_compensation
  ly_total_comp = 5450219#4281082
  driver_compensation_savings_yearly = ly_total_comp * percent_saved_driver_compensation
  driver_compensation_savings_monthly = round(round(driver_compensation_savings_yearly / 12, 2) * (40/70), 2) # STL won't save as much on driver comp
  
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
  
  roi_data$Cell.Data.Plan = 0 # not included cell_data_plan
  cost2 = roi_data$Cell.Data.Plan
  
  roi_data$Cell.Insurance = 0 # not included cell_ins_monthly
  cost3 = roi_data$Cell.Insurance
  
  roi_data$One.Time.Expenses = 0
  roi_data[2, 'One.Time.Expenses'] = non_recurring # not included + cell_phones_yearly 
  cost4 = roi_data$One.Time.Expenses
  
  roi_data$Savings.Fuel.Consumption = fuel_savings_monthly
  roi_data[c(1:4), c(7)] = 0 # won't see fuel savings until we go live + 1 month
  benefit1 = roi_data$Savings.Fuel.Consumption
  
  roi_data$Savings.Driver.Compensation = driver_compensation_savings_monthly
  roi_data[c(1:4), c(8)] = 0 # won't see drv comp savings until we go live + 1 month
  benefit2 = roi_data$Savings.Driver.Compensation
  
  roi_data$Savings.Truck.Lease = round(truck_lease_monthly + fuel_consumption_per_truck_per_month, 2)
  roi_data[c(1:12), 'Savings.Truck.Lease'] = 0 # Lease is not up until March 17
  benefit3 = roi_data$Savings.Truck.Lease
  
  roi_data$Savings.Truck.Insurance = truck_insurance_monthly
  roi_data[c(1:12), 'Savings.Truck.Insurance'] = 0
  benefit4 = roi_data$Savings.Truck.Insurance
  
  roi_data$Savings.Map.Purchases = maps_savings_monthly
  benefit5 = roi_data$Savings.Map.Purchases
  
  current_roadnet_yearly_cost = 8333
  current_monthly = round(current_roadnet_yearly_cost / 12, 2)
  benefit6 = current_monthly
  
  roi_data$Total.Costs = cost1 + cost2 + cost3 + cost4
  roi_data$Total.Savings = benefit1 + benefit2 + benefit3 + benefit4 + benefit5 + benefit6 +
    opportunity_equip_maint_improve + opportunity_analyst_resources_improve + opportunity_router_resources_improve
  
  roi_data = mutate(roi_data, Accumulated.Costs=cumsum(Total.Costs),
                    Accumulated.Savings=cumsum(Total.Savings))
  roi_data$Net.Savings = round(roi_data$Accumulated.Savings - roi_data$Accumulated.Costs, 2)
  
  roi_data = data.frame(roi_data)
  
  t_cost = roi_data$Total.Costs
  t_save = roi_data$Total.Savings
  n_periods = 0:(length(roi_data$Total.Costs) - 1)
  
  interest_rate_monthly = interest_rate_input / 12
  
  discounted_cost = round(t_cost / (1 + interest_rate_monthly)^(n_periods), 2)
  roi_data$Present.Value.Total.Costs = discounted_cost
  
  discounted_savings = round(t_save / (1 + interest_rate_monthly)^(n_periods), 2)
  roi_data$Present.Value.Total.Savings = discounted_savings
  
  
  roi_data = mutate(roi_data, Present.Value.Accumulated.Costs=cumsum(Present.Value.Total.Costs),
                    Present.Value.Accumulated.Savings=cumsum(Present.Value.Total.Savings))
  roi_data$Present.Value.Net.Savings = round(roi_data$Present.Value.Accumulated.Savings - roi_data$Present.Value.Accumulated.Costs, 2)
  
  roi_data[c(1), 'Roadnet.Subscription'] = 0
  
  roi_data 
}





simulate_op_full = function(percent_saved_fuel, percent_saved_driver_compensation, p_truck_gone, non_recurring_inflator,
                            opportunity_equip_maint_improve = 0,
                            opportunity_analyst_resources_improve = 0,
                            opportunity_router_resources_improve = 0,
                            roadnet_telematics = 0,
                            negotiations = 68896, # includes maps of 1344 
                            n_telematics_units = 0,
                            interest_rate_input = 0.06) {
  
  roadnet_yearly = negotiations
  n_telematics_units = n_telematics_units
  
  roadnet_telematics_monthly_per_truck = 19171 / 12 / 70 # total / 70 quoted trucks / 12 months
  roadnet_telematics_monthly = round(roadnet_telematics_monthly_per_truck * n_telematics_units, 2)  # yearly / 12 monoths / 70 units quoted at 19171
  
  roadnet_monthly = round(roadnet_yearly / 12, 2) + roadnet_telematics_monthly # roadnet_yearly == roadnet_monthly * 12
  
  roadnet_consulting = 10350 # mobilecast implement
  roadnet_onsite_conversion = 23325 # standard implement
  
  roadnet_telematics_unit_cost = n_telematics_units * 288 # from Joe P a while back
  
  non_recurring_inflator = non_recurring_inflator # IT WILL PROBABLY GO OVER BUDGET AND TIMELINE
  non_recurring = (roadnet_consulting + roadnet_onsite_conversion + roadnet_telematics_unit_cost) * non_recurring_inflator
  
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
  
  truck_insurance_yearly = 1400 + 1231 # 1000 per truck per year for insurance; 1231 for prop taxes, weighted avg bn kc stl
  truck_insurance_monthly = (truck_insurance_yearly / 12) * p_truck_gone  # from Tom
  
  maps_savings = 1211.81
  maps_savings_monthly = round(maps_savings / 12, 2)
  
  percent_saved_fuel = percent_saved_fuel #LEVER
  ly_fuel_consumption_gal = 524570
  fuel_consumption_per_truck_per_year = ly_fuel_consumption_gal / 70 #70 units
  fuel_consumption_per_truck_per_month = fuel_consumption_per_truck_per_year / 12
  
  fuel_savings_gallons = ly_fuel_consumption_gal * percent_saved_fuel
  price_per_gallon = 2.53 * 1.08 # assumes 8% inflation in gas price; 2.53 from Tom's hedginge analysis
  
  fuel_savings_yearly = fuel_savings_gallons * price_per_gallon
  fuel_savings_monthly = round(((fuel_savings_yearly / 12) * (40/70)) + (((fuel_savings_yearly / 12) * (30/70)) * 0.3), 2) # for every 1 gal stl saves kc will save .30 gal
  
  percent_saved_driver_compensation = percent_saved_driver_compensation
  ly_total_comp = 5450219#4281082
  driver_compensation_savings_yearly = ly_total_comp * percent_saved_driver_compensation
  driver_compensation_savings_monthly = round(round(driver_compensation_savings_yearly / 12, 2) * (40/70), 2) # STL won't save as much on driver comp
  
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
  roi_data[2, 'One.Time.Expenses'] = non_recurring + cell_phones_yearly 
  cost4 = roi_data$One.Time.Expenses
  
  roi_data$Savings.Fuel.Consumption = fuel_savings_monthly
  roi_data[c(1:4), c(7)] = 0 # won't see fuel savings until we go live + 1 month
  benefit1 = roi_data$Savings.Fuel.Consumption
  
  roi_data$Savings.Driver.Compensation = driver_compensation_savings_monthly
  roi_data[c(1:4), c(8)] = 0 # won't see drv comp savings until we go live + 1 month
  benefit2 = roi_data$Savings.Driver.Compensation
  
  roi_data$Savings.Truck.Lease = round(truck_lease_monthly + fuel_consumption_per_truck_per_month, 2)
  roi_data[c(1:12), 'Savings.Truck.Lease'] = 0 # Lease is not up until March 17
  benefit3 = roi_data$Savings.Truck.Lease
  
  roi_data$Savings.Truck.Insurance = truck_insurance_monthly
  roi_data[c(1:12), 'Savings.Truck.Insurance'] = 0
  benefit4 = roi_data$Savings.Truck.Insurance
  
  roi_data$Savings.Map.Purchases = maps_savings_monthly
  benefit5 = roi_data$Savings.Map.Purchases
  
  current_roadnet_yearly_cost = 8333
  current_monthly = round(current_roadnet_yearly_cost / 12, 2)
  benefit6 = current_monthly
  
  roi_data$Total.Costs = cost1 + cost2 + cost3 + cost4
  roi_data$Total.Savings = benefit1 + benefit2 + benefit3 + benefit4 + benefit5 + benefit6 +
    opportunity_equip_maint_improve + opportunity_analyst_resources_improve + opportunity_router_resources_improve
  
  roi_data = mutate(roi_data, Accumulated.Costs=cumsum(Total.Costs),
                    Accumulated.Savings=cumsum(Total.Savings))
  roi_data$Net.Savings = round(roi_data$Accumulated.Savings - roi_data$Accumulated.Costs, 2)
  
  roi_data = data.frame(roi_data)
  
  t_cost = roi_data$Total.Costs
  t_save = roi_data$Total.Savings
  n_periods = 0:(length(roi_data$Total.Costs) - 1)
  
  interest_rate_monthly = interest_rate_input / 12
  
  discounted_cost = round(t_cost / (1 + interest_rate_monthly)^(n_periods), 2)
  roi_data$Present.Value.Total.Costs = discounted_cost
  
  discounted_savings = round(t_save / (1 + interest_rate_monthly)^(n_periods), 2)
  roi_data$Present.Value.Total.Savings = discounted_savings
  
  
  roi_data = mutate(roi_data, Present.Value.Accumulated.Costs=cumsum(Present.Value.Total.Costs),
                    Present.Value.Accumulated.Savings=cumsum(Present.Value.Total.Savings))
  roi_data$Present.Value.Net.Savings = round(roi_data$Present.Value.Accumulated.Savings - roi_data$Present.Value.Accumulated.Costs, 2)
  
  roi_data[c(1), 'Roadnet.Subscription'] = 0
  
  roi_data 
}





simulate_op_stripped = function(percent_saved_fuel, percent_saved_driver_compensation, p_truck_gone, non_recurring_inflator,
                                   opportunity_equip_maint_improve = 0,
                                   opportunity_analyst_resources_improve = 0,
                                   opportunity_router_resources_improve = 0,
                                   roadnet_telematics = 0,
                                   negotiations = 38598, # includes maps of 1344
                                   n_telematics_units = 0,
                                   interest_rate_input = 0.06) {
  
  roadnet_yearly = negotiations
  n_telematics_units = n_telematics_units
  
  roadnet_telematics_monthly_per_truck = 19171 / 12 / 70 # total / 70 quoted trucks / 12 months
  roadnet_telematics_monthly = round(roadnet_telematics_monthly_per_truck * n_telematics_units, 2)  # yearly / 12 monoths / 70 units quoted at 19171
  
  
  roadnet_monthly = round(roadnet_yearly / 12, 2) + roadnet_telematics_monthly # roadnet_yearly == roadnet_monthly * 12
  
  
  roadnet_consulting = 0
  roadnet_onsite_conversion = 14400 # roadnet implementation charge
  
  roadnet_telematics_unit_cost = n_telematics_units * 288 # from Joe P a while back
  
  
  non_recurring_inflator = non_recurring_inflator # IT WILL PROBABLY GO OVER BUDGET AND TIMELINE
  non_recurring = (roadnet_consulting + roadnet_onsite_conversion + roadnet_telematics_unit_cost) * non_recurring_inflator
  
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
  
  truck_insurance_yearly = 1400 + 1231 # 1000 per truck per year for insurance; 1231 for prop taxes, weighted avg bn kc stl
  truck_insurance_monthly = (truck_insurance_yearly / 12) * p_truck_gone  # from Tom
  
  maps_savings = 1211.81
  maps_savings_monthly = round(maps_savings / 12, 2)
  
  percent_saved_fuel = percent_saved_fuel #LEVER
  ly_fuel_consumption_gal = 524570
  fuel_consumption_per_truck_per_year = ly_fuel_consumption_gal / 70 #70 units
  fuel_consumption_per_truck_per_month = fuel_consumption_per_truck_per_year / 12
  
  fuel_savings_gallons = ly_fuel_consumption_gal * percent_saved_fuel
  price_per_gallon = 2.53 * 1.08 # assumes 8% inflation in gas price; 2.53 from Tom's hedginge analysis
  
  fuel_savings_yearly = fuel_savings_gallons * price_per_gallon
  fuel_savings_monthly = round((round(fuel_savings_yearly / 12, 2)) * ((40/70) * 1.3), 2) # for every 1 gal stl saves kc will save .30 gal
  
  percent_saved_driver_compensation = percent_saved_driver_compensation
  ly_total_comp = 5450219#4281082
  driver_compensation_savings_yearly = ly_total_comp * percent_saved_driver_compensation
  driver_compensation_savings_monthly = round(round(driver_compensation_savings_yearly / 12, 2) * (40/70), 2) # STL won't save as much on driver comp
  
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
  
  roi_data$Cell.Data.Plan = 0 # not included cell_data_plan
  cost2 = roi_data$Cell.Data.Plan
  
  roi_data$Cell.Insurance = 0 # not included cell_ins_monthly
  cost3 = roi_data$Cell.Insurance
  
  roi_data$One.Time.Expenses = 0
  roi_data[2, 'One.Time.Expenses'] = non_recurring # not included + cell_phones_yearly 
  cost4 = roi_data$One.Time.Expenses
  
  roi_data$Savings.Fuel.Consumption = fuel_savings_monthly
  roi_data[c(1:4), c(7)] = 0 # won't see fuel savings until we go live + 1 month
  benefit1 = roi_data$Savings.Fuel.Consumption
  
  roi_data$Savings.Driver.Compensation = driver_compensation_savings_monthly
  roi_data[c(1:4), c(8)] = 0 # won't see drv comp savings until we go live + 1 month
  benefit2 = roi_data$Savings.Driver.Compensation
  
  roi_data$Savings.Truck.Lease = round(truck_lease_monthly + fuel_consumption_per_truck_per_month, 2)
  roi_data[c(1:12), 'Savings.Truck.Lease'] = 0 # Lease is not up until March 17
  benefit3 = roi_data$Savings.Truck.Lease
  
  roi_data$Savings.Truck.Insurance = truck_insurance_monthly
  roi_data[c(1:12), 'Savings.Truck.Insurance'] = 0
  benefit4 = roi_data$Savings.Truck.Insurance
  
  roi_data$Savings.Map.Purchases = maps_savings_monthly
  benefit5 = roi_data$Savings.Map.Purchases
  
  current_roadnet_yearly_cost = 8333
  current_monthly = round(current_roadnet_yearly_cost / 12, 2)
  benefit6 = current_monthly
  
  roi_data$Total.Costs = cost1 + cost2 + cost3 + cost4
  roi_data$Total.Savings = benefit1 + benefit2 + benefit3 + benefit4 + benefit5 + benefit6 +
    opportunity_equip_maint_improve + opportunity_analyst_resources_improve + opportunity_router_resources_improve
  
  roi_data = mutate(roi_data, Accumulated.Costs=cumsum(Total.Costs),
                    Accumulated.Savings=cumsum(Total.Savings))
  roi_data$Net.Savings = round(roi_data$Accumulated.Savings - roi_data$Accumulated.Costs, 2)
  
  roi_data = data.frame(roi_data)
  
  t_cost = roi_data$Total.Costs
  t_save = roi_data$Total.Savings
  n_periods = 0:(length(roi_data$Total.Costs) - 1)
  
  interest_rate_monthly = interest_rate_input / 12
  
  discounted_cost = round(t_cost / (1 + interest_rate_monthly)^(n_periods), 2)
  roi_data$Present.Value.Total.Costs = discounted_cost
  
  discounted_savings = round(t_save / (1 + interest_rate_monthly)^(n_periods), 2)
  roi_data$Present.Value.Total.Savings = discounted_savings
  
  
  roi_data = mutate(roi_data, Present.Value.Accumulated.Costs=cumsum(Present.Value.Total.Costs),
                    Present.Value.Accumulated.Savings=cumsum(Present.Value.Total.Savings))
  roi_data$Present.Value.Net.Savings = round(roi_data$Present.Value.Accumulated.Savings - roi_data$Present.Value.Accumulated.Costs, 2)
  
  roi_data[c(1), 'Roadnet.Subscription'] = 0
  
  roi_data 
}

















