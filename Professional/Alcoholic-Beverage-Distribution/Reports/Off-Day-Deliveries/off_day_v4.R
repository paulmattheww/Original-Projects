
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')
library(RODBC)
library(plotly)
library(dplyr)
library(lubridate)
library(stringr)
library(XLConnect)

# query is pw_offday


clean_pw_offday = function(deliveries, weeklookup) {
  #################################################################################
  ## CLEAN UP QUERY PW_OFFDAY AND DO NOT FILTER OUT ON DAYS YET
  #################################################################################
  
  d = deliveries
  w = weeklookup
  
  names(d) = c('Date', 'Division', 'Invoice', 'CustomerID', 'Call', 'Priority', 
               'Warehouse', 'Cases', 'Dollars', 'Ship', 'Salesperson', 
               'ShipWeekPlan', 'Merchandising', 'OnPremise', 
               'CustomerSetup', 'CustomerType', 'Customer')
  
  typ = d$CustomerType
  d$CustomerType = ifelse(typ == 'A', 'Bar/Tavern', 
                          ifelse(typ == 'C', 'Country Club', 
                                 ifelse(typ=='E', 'Transportation/Airline',
                                        ifelse(typ=='G', 'Gambling', 
                                               ifelse(typ=='J', 'Hotel/Motel',
                                                      ifelse(typ=='L', 'Restaurant', 
                                                             ifelse(typ=='M', 'Military', 
                                                                    ifelse(typ=='N', 'Fine Dining',
                                                                           ifelse(typ=='O', 'Internal', 
                                                                                  ifelse(typ=='P', 'Country/Western',
                                                                                         ifelse(typ=='S', 'Package Store', 
                                                                                                ifelse(typ=='T', 'Supermarket/Grocery',
                                                                                                       ifelse(typ=='V', 'Drug Store',
                                                                                                              ifelse(typ=='Y', 'Convenience Store', 
                                                                                                                     ifelse(typ=='Z', 'Catering',
                                                                                                                            ifelse(typ=='3', 'Night Club', 
                                                                                                                                   ifelse(typ=='5', 'Adult Entertainment', 
                                                                                                                                          ifelse(typ=='6', 'Sports Bar', 
                                                                                                                                                 ifelse(typ=='I', 'Church', 
                                                                                                                                                        ifelse(typ=='F', 'Membership Club', 
                                                                                                                                                               ifelse(typ=='B', 'Mass Merchandiser', 
                                                                                                                                                                      ifelse(typ=='H', 'Fraternal Organization', 
                                                                                                                                                                             ifelse(typ=='7', 'Sports Venue', 'OTHER')))))))))))))))))))))))
  
  
  date = d$Date = as400Date(d$Date)
  w$Date = as.character(strptime(weeklookup$Date, format="%m/%d/%Y"))
  
  d = merge(d, w, by='Date', all_x=TRUE)
  
  weekday = d$Weekday = wday(date, label=TRUE, abbr=TRUE)
  week_plan = d$ShipWeekPlan
  week_shipped = d$ShipWeek
  month = month(date)
  setup_month = str_pad(as.character(d$CustomerSetup), 4, pad='0')
  setup_month = month(as.numeric(substrLeft(setup_month, 2)))
  year = year(date)
  s = substrRight(as.character(d$CustomerSetup), 2)
  this_century = as.numeric(s) < 20
  setup_year = ifelse(this_century == TRUE, 
                      as.numeric(as.character(paste0("20", s))), 
                      as.numeric(as.character(paste0("19", s))))
  days = as.character(d$Ship)
  days = d$Ship = str_pad(days, 7, pad='0')
  
  
  d$Mon = mon =  ifelse(substrLeft(substrRight(days, 7), 1) == 1, 'M', '_')
  d$Tue = tue = ifelse(substrLeft(substrRight(days, 6), 1) == 1, 'T', '_')
  d$Wed = wed =  ifelse(substrLeft(substrRight(days, 5), 1) == 1, 'W', '_')
  d$Thu = thu =  ifelse(substrLeft(substrRight(days, 4), 1) == 1, 'R', '_')
  d$Fri = fri = ifelse(substrLeft(substrRight(days, 3), 1) == 1, 'F', '_')
  d$Sat = sat = ifelse(substrLeft(substrRight(days, 2), 1) == 1, 'S', '_')
  d$Sun = sun = ifelse(substrRight(days, 1) == 1, 'S', '_')
  
  d$DeliveryDays = deldays = paste0(mon, tue, wed, thu, fri, sat, sun)
  d$CustomerSetup = paste0(str_pad(as.character(setup_month), 2, pad=0), '-', as.character(setup_year))
  
  if (week_plan != '') {
    if (week_plan != week_shipped) {
      off = 'Y'
    } else if (week_plan == week_shipped) {
      off = ifelse(mon=='M' & weekday=='Mon', 'N', 
                   ifelse(tue=='T' & weekday=='Tues', 'N',
                          ifelse(wed=='W' & weekday=='Wed', 'N', 
                                 ifelse(thu=='R' & weekday=='Thurs', 'N',
                                        ifelse(fri=='F' & weekday=='Fri', 'N', 
                                               ifelse(sat=='S' & weekday=='Sat', 'N', 
                                                      ifelse(sun=='S' & weekday=='Sun', 'N', 'Y')))))))
    } 
  } else if (week_plan == '') {
    off = ifelse(mon=='M' & weekday=='Mon', 'N', 
                 ifelse(tue=='T' & weekday=='Tues', 'N',
                        ifelse(wed=='W' & weekday=='Wed', 'N', 
                               ifelse(thu=='R' & weekday=='Thurs', 'N',
                                      ifelse(fri=='F' & weekday=='Fri', 'N', 
                                             ifelse(sat=='S' & weekday=='Sat', 'N', 
                                                    ifelse(sun=='S' & weekday=='Sun', 'N', 'Y')))))))
  } else {
    off = 'N'
  }
  
  d$OffDay = off
  
  d = d[, c('Date', 'Warehouse', 'CustomerID', 'Customer', 'CustomerType', 'Invoice', 'Dollars', 'Cases', 
            'Priority', 'Call', 'Salesperson', 'Ship', 'ShipWeekPlan', 'Merchandising', 'OnPremise', 'CustomerSetup', 
            'Week', 'ShipWeek', 'DOTM', 'Month', 'Weekday', 'OffDay', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun')]
  
  
  week_plan = d$ShipWeekPlan
  whse = d$Warehouse
  call = d$Call
  
  d$Warehouse = ifelse(whse==1, 'KC', 
                       ifelse(whse==2, 'STL', 
                              ifelse(whse==3, 'COL', 
                                     ifelse(whse==4, 'CAPE', 
                                            ifelse(whse==5, 'SPFD', '')))))
  
  d$Call = ifelse(call==1, 'Customer Call', 
                  ifelse(call==2, 'ROE/EDI',
                         ifelse(call==3, 'Salesperson Call',
                                ifelse(call==4, 'Telesales', 'Not Specified'))))
  
  ship_flag = d$Ship
  n_ship_days = sapply(strsplit(ship_flag, split=''), function(x) sum(as.numeric(x)))
  
  d$Tier = ifelse(week_plan=='A' | week_plan=='B', 'Tier 4', 
                  ifelse(n_ship_days==1 & (week_plan!='A' | week_plan!='B'), 'Tier 3',
                         ifelse(n_ship_days==2, 'Tier 2',
                                ifelse(n_ship_days>=3, 'Tier 1', 'Tier 4'))))
  
  d$Year = year(d$Date)
  
  new = d$CustomerSetup
  now_m = month(d$Month)
  now_y = d$Year
  
  setup_monthx = str_pad(as.character(d$CustomerSetup), 4, pad='0')
  setup_monthx = month(as.numeric(substrLeft(setup_monthx, 2)))
  sx = substrRight(as.character(d$CustomerSetup), 2)
  this_centuryx = as.numeric(sx) < 20
  setup_yearx = ifelse(this_centuryx == TRUE, 
                       as.numeric(as.character(paste0("20", sx))), 
                       as.numeric(as.character(paste0("19", sx))))
  
  
  d$NewCustomer = ifelse(setup_monthx == now_m & setup_yearx == now_y, 'Y', 'N')
  
  d$DeliveryDays = paste0(mon, tue, wed, thu, fri, sat, sun)
  
  print(d)
  
}




# 
pw_offday = d = read.csv("C:/Users/pmwash/Desktop/R_files/Data Input/Input Files for Reports/Off-Day Deliveries/pw_offday.csv", header=TRUE)
weeklookup = w = read.csv("N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/pw_offday_weeklookup.csv", header=TRUE)
# 

clean_data = clean_pw_offday(pw_offday, weeklookup)



create_tier_summary = function(clean_data) {
  #################################################################################
  ## Mark ADDITIONAL DELIVERY DAYS
  #################################################################################
  d = clean_data
  
  on_cust = aggregate(OffDay ~ CustomerID + Week + Date, data=d, FUN=function(OffDay) unique(ifelse(OffDay == 'N', 1, 0)))
  names(on_cust) = c('CustomerID', 'Week', 'Date', 'OnDayDeliveries')#; head(on_cust)
  off_cust = aggregate(OffDay ~ CustomerID + Week + Date, data=d, FUN=function(OffDay) unique(ifelse(OffDay == 'Y', 1, 0)))
  names(off_cust) = c('CustomerID', 'Week', 'Date', 'OffDayDeliveries')#; head(off_cust)
  new_cust = aggregate(NewCustomer ~ CustomerID + Week + Date, data=d, FUN=function(NewCustomer) unique(ifelse(NewCustomer == 'Y', 1, 0)))
  names(new_cust) = c('CustomerID', 'Week', 'Date', 'NewCustomerDeliveries')#; head(off_cust)
  
  
  customer_daily = merge(off_cust, on_cust, by=c('CustomerID', 'Week', 'Date'))
  customer_daily = merge(customer_daily, new_cust, by=c('CustomerID', 'Week', 'Date'))
  customer_daily = customer_daily %>% arrange(CustomerID, Date)#; headTail(customer_daily, 50)
  
  on_cust_wk = aggregate(OnDayDeliveries ~ CustomerID + Week, data=customer_daily, FUN=sum)#; headTail(on_cust_wk)
  off_cust_wk = aggregate(OffDayDeliveries ~ CustomerID + Week, data=customer_daily, FUN=sum)#; headTail(off_cust_wk)
  new_cust_wk = aggregate(NewCustomerDeliveries ~ CustomerID + Week, data=customer_daily, FUN=sum)#; headTail(new_cust_wk)
  cases_wk = aggregate(Cases ~ CustomerID + Week, data=d, FUN=sum)
  dollars_wk = aggregate(Dollars ~ CustomerID + Week, data=d, FUN=sum)
  
  customer_summary = merge(off_cust_wk, on_cust_wk, by=c('CustomerID', 'Week'))#; headTail(customer_summary)
  customer_summary = merge(customer_summary, new_cust_wk, by=c('CustomerID', 'Week'))#; headTail(customer_summary)
  customer_summary$AdditionalDeliveries = ifelse(customer_summary$OffDayDeliveries > 0 & customer_summary$OnDayDeliveries >= 1, customer_summary$OffDayDeliveries, 0)
  customer_summary = merge(customer_summary, cases_wk, by=c('CustomerID', 'Week'))#; headTail(customer_summary)
  customer_summary = merge(customer_summary, dollars_wk, by=c('CustomerID', 'Week'))#; headTail(customer_summary)
  
  
  ## MERGE IN RELEVANT CUSTOMER DETAILS
  customer_attributes = unique(d[, c('CustomerID', 'Customer', 'CustomerType', 
                                     'Warehouse', 'ShipWeekPlan', 
                                     'Merchandising', 'OnPremise', 'CustomerSetup', 'Tier',
                                     'DeliveryDays', 'Ship')])
  customer_attributes$Ship = sapply(strsplit(as.character(customer_attributes$Ship), split=''), function(x) sum(as.numeric(x)))
  names(customer_attributes) = c('CustomerID', 'Customer', 'CustomerType', 
                                 'Warehouse', 'ShipWeekPlan', 
                                 'Merchandising', 'OnPremise', 'CustomerSetup', 'Tier',
                                 'DeliveryDays', 'NumberScheduledShipDays')#; headTail(customer_attributes)
  
  customer_summary = merge(customer_summary, customer_attributes, by='CustomerID')
  customer_summary = customer_summary %>% arrange(CustomerID, Week)
  customer_summary = customer_summary[, c('Tier', 'CustomerID', 'Customer', 'CustomerType', 'Warehouse', 
                                          'ShipWeekPlan', 'Merchandising', 'OnPremise',
                                          'CustomerSetup', 'Week', 'DeliveryDays', 
                                          'NumberScheduledShipDays', 'OnDayDeliveries', 
                                          'OffDayDeliveries', 'AdditionalDeliveries', 
                                          'NewCustomerDeliveries', 'Cases', 'Dollars')]#; headTail(customer_summary, 10)
  customer_summary = customer_summary %>% arrange(CustomerID, Week)
  customer_summary$Tier = ifelse(customer_summary$NewCustomerDeliveries > 0, 'New Customer', customer_summary$Tier)
  customer_summary$TotalDeliveries = customer_summary$OnDayDeliveries + customer_summary$OffDayDeliveries + customer_summary$NewCustomerDeliveries#; headTail(customer_summary, 20)
  
  
  tier_cust = aggregate(Customer ~ Tier, data=customer_summary, FUN=countUnique)
  tier_deliv = aggregate(TotalDeliveries ~ Tier, data=customer_summary, FUN=sum)
  tier_off = aggregate(OffDayDeliveries ~ Tier, data=customer_summary, FUN=sum)
  tier_addl = aggregate(AdditionalDeliveries ~ Tier, data=customer_summary, FUN=sum)
  tier_avgcs = aggregate(Cases ~ Tier, data=customer_summary, FUN=function(x) round(mean(x), 2))
  tier_avgdollars = aggregate(Dollars ~ Tier, data=customer_summary, FUN=function(x) round(mean(x), 2))
  
  tier_summary = merge(tier_cust, tier_deliv, by='Tier')
  tier_summary = merge(tier_summary, tier_off, by='Tier')
  tier_summary = merge(tier_summary, tier_addl, by='Tier')
  tier_summary = merge(tier_summary, tier_avgcs, by='Tier')
  tier_summary = merge(tier_summary, tier_avgdollars, by='Tier')
  
  names(tier_summary) = c('Tier', 'UniqueCustomerCount', 'TotalDeliveries', 
                          'OffDayDeliveries', 'AdditionalDeliveries', 'AvgCases', 'AvgDollars')
  
  print(tier_summary)
}



tier_summary = create_tier_summary(clean_data)











create_tier_warehouse_summary = function(clean_data) {
  #################################################################################
  ## Mark ADDITIONAL DELIVERY DAYS
  #################################################################################
  d = clean_data
  
  on_cust = aggregate(OffDay ~ Warehouse + CustomerID + Week + Date, data=d, FUN=function(OffDay) unique(ifelse(OffDay == 'N', 1, 0)))
  names(on_cust) = c('Warehouse', 'CustomerID', 'Week', 'Date', 'OnDayDeliveries')#; head(on_cust)
  off_cust = aggregate(OffDay ~ Warehouse + CustomerID + Week + Date, data=d, FUN=function(OffDay) unique(ifelse(OffDay == 'Y', 1, 0)))
  names(off_cust) = c('Warehouse', 'CustomerID', 'Week', 'Date', 'OffDayDeliveries')#; head(off_cust)
  new_cust = aggregate(NewCustomer ~ Warehouse + CustomerID + Week + Date, data=d, FUN=function(NewCustomer) unique(ifelse(NewCustomer == 'Y', 1, 0)))
  names(new_cust) = c('Warehouse', 'CustomerID', 'Week', 'Date', 'NewCustomerDeliveries')#; head(off_cust)
  
  
  customer_daily = merge(off_cust, on_cust, by=c('Warehouse', 'CustomerID', 'Week', 'Date'))
  customer_daily = merge(customer_daily, new_cust, by=c('Warehouse', 'CustomerID', 'Week', 'Date'))
  customer_daily = customer_daily %>% arrange(Warehouse, CustomerID, Date)#; headTail(customer_daily, 50)
  
  on_cust_wk = aggregate(OnDayDeliveries ~ Warehouse + CustomerID + Week, data=customer_daily, FUN=sum)#; headTail(on_cust_wk)
  off_cust_wk = aggregate(OffDayDeliveries ~ Warehouse + CustomerID + Week, data=customer_daily, FUN=sum)#; headTail(off_cust_wk)
  new_cust_wk = aggregate(NewCustomerDeliveries ~ Warehouse + CustomerID + Week, data=customer_daily, FUN=sum)#; headTail(new_cust_wk)
  cases_wk = aggregate(Cases ~ Warehouse + CustomerID + Week, data=d, FUN=sum)
  dollars_wk = aggregate(Dollars ~ Warehouse + CustomerID + Week, data=d, FUN=sum)
  
  customer_summary = merge(off_cust_wk, on_cust_wk, by=c('Warehouse', 'CustomerID', 'Week'))#; headTail(customer_summary)
  customer_summary = merge(customer_summary, new_cust_wk, by=c('Warehouse', 'CustomerID', 'Week'))#; headTail(customer_summary)
  customer_summary$AdditionalDeliveries = ifelse(customer_summary$OffDayDeliveries > 0 & customer_summary$OnDayDeliveries >= 1, customer_summary$OffDayDeliveries, 0)
  customer_summary = merge(customer_summary, cases_wk, by=c('Warehouse', 'CustomerID', 'Week'))#; headTail(customer_summary)
  customer_summary = merge(customer_summary, dollars_wk, by=c('Warehouse', 'CustomerID', 'Week'))#; headTail(customer_summary)
  
  
  ## MERGE IN RELEVANT CUSTOMER DETAILS
  customer_attributes = unique(d[, c('CustomerID', 'Customer', 'CustomerType', 
                                     'Warehouse', 'ShipWeekPlan', 
                                     'Merchandising', 'OnPremise', 'CustomerSetup', 'Tier',
                                     'DeliveryDays', 'Ship')])
  customer_attributes$Ship = sapply(strsplit(as.character(customer_attributes$Ship), split=''), function(x) sum(as.numeric(x)))
  names(customer_attributes) = c('CustomerID', 'Customer', 'CustomerType', 
                                 'Warehouse', 'ShipWeekPlan', 
                                 'Merchandising', 'OnPremise', 'CustomerSetup', 'Tier',
                                 'DeliveryDays', 'NumberScheduledShipDays')#; headTail(customer_attributes)
  
  customer_summary = merge(customer_summary, customer_attributes, by=c('Warehouse', 'CustomerID'))
  customer_summary = customer_summary %>% arrange(Warehouse, CustomerID, Week)
  customer_summary = customer_summary[, c('Tier', 'CustomerID', 'Customer', 'CustomerType', 'Warehouse', 
                                          'ShipWeekPlan', 'Merchandising', 'OnPremise',
                                          'CustomerSetup', 'Week', 'DeliveryDays', 
                                          'NumberScheduledShipDays', 'OnDayDeliveries', 
                                          'OffDayDeliveries', 'AdditionalDeliveries', 
                                          'NewCustomerDeliveries', 'Cases', 'Dollars')]#; headTail(customer_summary, 10)
  customer_summary = customer_summary %>% arrange(Warehouse, CustomerID, Week)
  customer_summary$Tier = ifelse(customer_summary$NewCustomerDeliveries > 0, 'New Customer', customer_summary$Tier)
  customer_summary$TotalDeliveries = customer_summary$OnDayDeliveries + customer_summary$OffDayDeliveries + customer_summary$NewCustomerDeliveries#; headTail(customer_summary, 20)
  
  
  tier_cust = aggregate(Customer ~ Warehouse + Tier, data=customer_summary, FUN=countUnique)
  tier_deliv = aggregate(TotalDeliveries ~ Warehouse + Tier, data=customer_summary, FUN=sum)
  tier_off = aggregate(OffDayDeliveries ~ Warehouse + Tier, data=customer_summary, FUN=sum)
  tier_addl = aggregate(AdditionalDeliveries ~ Warehouse + Tier, data=customer_summary, FUN=sum)
  tier_avgcs = aggregate(Cases ~ Warehouse + Tier, data=customer_summary, FUN=function(x) round(mean(x), 2))
  tier_avgdollars = aggregate(Dollars ~ Warehouse + Tier, data=customer_summary, FUN=function(x) round(mean(x), 2))
  
  tier_warehouse_summary = merge(tier_cust, tier_deliv, by=c('Warehouse', 'Tier'))
  tier_warehouse_summary = merge(tier_warehouse_summary, tier_off, by=c('Warehouse', 'Tier'))
  tier_warehouse_summary = merge(tier_warehouse_summary, tier_addl, by=c('Warehouse', 'Tier'))
  tier_warehouse_summary = merge(tier_warehouse_summary, tier_avgcs, by=c('Warehouse', 'Tier'))
  tier_warehouse_summary = merge(tier_warehouse_summary, tier_avgdollars, by=c('Warehouse', 'Tier'))
  
  names(tier_warehouse_summary) = c('Warehouse', 'Tier', 'UniqueCustomerCount', 'TotalDeliveries', 
                          'OffDayDeliveries', 'AdditionalDeliveries', 'AvgCases', 'AvgDollars')
  
  print(tier_warehouse_summary)
}





tier_warehouse_summary = create_tier_warehouse_summary(clean_data)








options(java.parameters = "-Xmx1024m")
library(XLConnect)



wb = loadWorkbook(file='C:/Users/pmwash/Desktop/R_files/Data Output/off_day_deliveries_july_2016.xlsx', create=TRUE)
writeWorksheetToFile('C:/Users/pmwash/Desktop/R_files/Data Output/off_day_deliveries_july_2016.xlsx', data=tier_summary, sheet='Tier Summary')
writeWorksheetToFile('C:/Users/pmwash/Desktop/R_files/Data Output/off_day_deliveries_july_2016.xlsx', data=tier_warehouse_summary, sheet='Warehouse Summary')
writeWorksheetToFile('C:/Users/pmwash/Desktop/R_files/Data Output/off_day_deliveries_july_2016.xlsx', data=customer_summary, sheet='Clean Data') #configure function for this


write.csv(customer_summary, 'C:/Users/pmwash/Desktop/R_files/Data Output/off_day_deliveries_july_2016.csv', row.names=F)


saveWorkbook(wb)


































