
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')
library(RODBC)
library(plotly)

# query is pw_offday
# below is ETL process for off day deliveries

off_day_etl = function(deliveries, weeklookup) {
  library(lubridate)
  library(dplyr)
  library(stringr)
  source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')
  
  d = deliveries
  w = weeklookup
  
  names(d) = c('Date', 'Invoice', 'Customer', 'Call', 'Priority', 
               'Warehouse', 'Cases', 'Dollars', 'Ship', 'Salesperson', 
               'Ship.Week.Plan', 'Merchandising', 'On.Premise', 
               'Customer.Setup')
  
  date = d$Date = as400Date(d$Date)
  w$Date = as.character(strptime(weeklookup$Date, format="%m/%d/%Y"))
  
  d = merge(d, w, by='Date', all_x=TRUE)
  
  weekday = d$Weekday = wday(date, label=TRUE, abbr=TRUE)
  week_plan = d$Ship.Week.Plan
  week_shipped = d$Ship.Week
  month = month(date)
  setup_month = str_pad(as.character(d$Customer.Setup), 4, pad='0')
  setup_month = month(as.numeric(substrLeft(setup_month, 2)))
  year = year(date)
  s = substrRight(as.character(d$Customer.Setup), 2)
  this_century = as.numeric(s) < 20
  setup_year = ifelse(this_century == TRUE, 
                      as.numeric(as.character(paste0("20", s))), 
                      as.numeric(as.character(paste0("19", s))))
  days = as.character(d$Ship)
  days = d$Ship = str_pad(days, 7, pad='0')
  
  
  mon =  ifelse(substrLeft(substrRight(days, 7), 1) == 1, 'M', '_')
  tue = ifelse(substrLeft(substrRight(days, 6), 1) == 1, 'T', '_')
  wed =  ifelse(substrLeft(substrRight(days, 5), 1) == 1, 'W', '_')
  thu =  ifelse(substrLeft(substrRight(days, 4), 1) == 1, 'R', '_')
  fri = ifelse(substrLeft(substrRight(days, 3), 1) == 1, 'F', '_')
  sat = ifelse(substrLeft(substrRight(days, 2), 1) == 1, 'S', '_')
  sun = ifelse(substrRight(days, 1) == 1, 'S', '_')
  
  d$Delivery.Days = deldays = paste0(mon, tue, wed, thu, fri, sat, sun)
  d$Customer.Setup = paste0(str_pad(as.character(setup_month), 2, pad=0), '-', as.character(setup_year))
  
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
  
  d$Off.Day = off
  
  
  off_day_d = d %>% filter(Off.Day == 'Y')
  rm(d)
  #headTail(off_day_d, 100)
  week_plan = off_day_d$Ship.Week.Plan
  whse = off_day_d$Warehouse
  call = off_day_d$Call
  
  off_day_d$Warehouse = ifelse(whse==1, 'KC', 
                               ifelse(whse==2, 'STL', 
                                      ifelse(whse==3, 'COL', 
                                             ifelse(whse==4, 'CAPE', 
                                                    ifelse(whse==5, 'SPFD', '')))))
  
  off_day_d$Call = ifelse(call==1, 'Customer Call', 
                          ifelse(call==2, 'ROE/EDI',
                                 ifelse(call==3, 'Salesperson Call',
                                        ifelse(call==4, 'Telesales', 'Not Specified'))))
  
  ship_flag = off_day_d$Ship
  n_ship_days = sapply(strsplit(ship_flag, split=''), function(x) sum(as.numeric(x)))
  
  off_day_d$Tier = ifelse(week_plan=='A' | week_plan=='B', 'Tier 4', 
                          ifelse(n_ship_days==1 & (week_plan!='A' | week_plan!='B'), 'Tier 3',
                                 ifelse(n_ship_days==2, 'Tier 2',
                                        ifelse(n_ship_days>=3, 'Tier 1', 'Tier 4'))))
  
  off_day_d$Year = year(off_day_d$Date)
  
  new = off_day_d$Customer.Setup
  now_m = month(off_day_d$Month)
  now_y = off_day_d$Year
  
  setup_monthx = str_pad(as.character(off_day_d$Customer.Setup), 4, pad='0')
  setup_monthx = month(as.numeric(substrLeft(setup_monthx, 2)))
  sx = substrRight(as.character(off_day_d$Customer.Setup), 2)
  this_centuryx = as.numeric(sx) < 20
  setup_yearx = ifelse(this_centuryx == TRUE, 
                       as.numeric(as.character(paste0("20", sx))), 
                       as.numeric(as.character(paste0("19", sx))))
  
  
  off_day_d$New.Customer = ifelse(setup_monthx == now_m & setup_yearx == now_y, 'YES', 'NO')
  
  da_colz = c('Date', 'Invoice', 'Call', 'Salesperson', 'Customer', 
              'New.Customer', 'On.Premise', 'Tier', 'Cases', 'Dollars', 
              'Priority', 'Warehouse', 'Weekday',
              'Delivery.Days', 'Month', 'DOTM', 'Year', 'Week',
              'Ship.Week', 'Ship.Week.Plan', 'Merchandising')
  off_day_d = off_day_d[, da_colz]
  
  names(off_day_d) = c('Date', 'Invoice', 'Call', 'Salesperson', 'Customer', 
                       'NewCustomer', 'OnPremise', 'Tier', 'Cases', 'Dollars', 
                       'Priority', 'Warehouse', 'Weekday',
                       'DeliveryDays', 'Month', 'DOTM', 'Year', 'Week',
                       'ShipWeek', 'ShipWeekPlan', 'Merchandising')
  
  
  off_day_d

}




deliveries = read.csv("N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/pw_offday.csv", header=TRUE)
weeklookup = read.csv("N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/pw_offday_weeklookup.csv", header=TRUE)

headTail(deliveries)
headTail(weeklookup)

off_days = off_day_etl(deliveries, weeklookup)
headTail(off_days)

# Write results to CSV and upload them to the reporting database

write.csv(off_days, 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/Output/deliveries_upload.csv', row.names=F)














# Extract data back out plus the lookup table feor salespersons

reporting_db = 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Reporting Database.accdb'
staging_db = 'N:/Operations Intelligence/Data/Staging/Staging-Database.accdb'


reporting_odbc = odbcConnectAccess2007(reporting_db)
staging_odbc = odbcConnectAccess2007(staging_db)



pre_processed = sqlQuery(reporting_odbc, "SELECT * 
                         FROM `T_Off-Day Deliveries` 
                         WHERE Date BETWEEN #06/01/2016# AND #06/30/2016#"); pre_processed$ID = NULL
headTail(pre_processed)

customers = sqlQuery(staging_odbc, "SELECT [CCUST#], [CCUSTN] 
                    FROM `WSFILE002_CUS2`")
names(customers) = c('CustomerID', 'CustomerName'); headTail(customers)

slsprsns = sqlQuery(staging_odbc, "SELECT [SPNUM#], [SPNAME] 
                    FROM `WSFILE002_SLP1`")
names(slsprsns) = c('SalespersonID', 'SalespersonName'); headTail(slsprsns)




del_dayz = 19


integrated_data = merge(pre_processed, customers, by.x='Customer', by.y='CustomerID', all.x=TRUE); head(integrated_data)
integrated_data = merge(integrated_data, slsprsns, by.x='Salesperson', by.y='SalespersonID', all.x=TRUE); head(integrated_data)

headTail(integrated_data, 50); unique(integrated_data$SalespersonName)


count_slsprsn = aggregate(Invoice ~ Salesperson, data=integrated_data, FUN=function(x) countUnique(x)) # + NewCustomer + Priority
count_slsprsn = count_slsprsn %>% arrange(desc(Invoice))

sum_slsprsn = aggregate(Dollars ~ Salesperson, data=integrated_data, FUN=function(x) round(sum(x)))
sum_slsprsn = sum_slsprsn %>% arrange(desc(Dollars))

slsprsn_summary = merge(count_slsprsn, sum_slsprsn, by='Salesperson'); headTail(slsprsn_summary)
slsprsn_summary = merge(slsprsns, slsprsn_summary, by.x='SalespersonID', by.y='Salesperson', all.y=TRUE); headTail(slsprsn_summary)


teams_managers = sqlQuery(reporting_odbc, "SELECT *
                    FROM `Salespersons`")
teams_managers$Salesperson = NULL
names(teams_managers) = c('SalespersonID', 'DistrictManager', 'Division', 'Company'); headTail(teams_managers)



odbcCloseAll()


slsprsn_summary = merge(slsprsn_summary, teams_managers[, c('SalespersonID', 'Division', 'DistrictManager')], by.x='SalespersonID', by.y='SalespersonID', all.x=TRUE); head(slsprsn_summary)
names(slsprsn_summary) = c('Salesperson.ID', 'Salesperson', 'Number.Off.Day.Invoices', 'Dollars', 'Sales.Division', 'Sales.District.Manager')
slsprsn_summary = slsprsn_summary %>% arrange(desc(Number.Off.Day.Invoices))

headTail(slsprsn_summary, 20)





# produce pivot table for html document. save as to correct location
# file:///N:/Operations%20Intelligence/Monthly%20Reports/Off%20Day%20Deliveries/HTML
library(rpivotTable)
i = integrated_data
head(i)


names(i) = c('SalespersonID', 'CustomerID', 'Date', 'Invoice', 'CallCode', 
             'NewCustomer', 'OnPremise', 'Tier', 'Cases', 'Dollars', 'Priority',
             'Warehouse', 'Weekday', 'DeliveryDays', 'Month', 'DOTM', 'yr', 
             'Week', 'spwk', 'wkplan', 'Merchandising', 'Customer', 'Salesperson')
i = merge(i, teams_managers[, c('SalespersonID', 'DistrictManager', 'Division')], by='SalespersonID', all.x=TRUE); headTail(i)


colz_keep = c('Date', 'SalespersonID', 'Salesperson', 
          'DistrictManager', 'Division', 
          'Invoice', 'CallCode', 
          'Customer', 'Tier', 'Cases', 'Dollars', 
          'Priority', 'NewCustomer', 'OnPremise',
          'Merchandising', 'Warehouse', 
          'Weekday', 'DeliveryDays')
#colz_keep %in% names(i)
i = i[, colz_keep]

head(i)


rpivotTable(i,
            aggregatorName='Count Unique Values',
            vals='Invoice',
            row=c('Warehouse', 'Division', 'Salesperson'),
            #sorters='function() .sort()',
            # {Array.sort()}',
            width="100%", 
            height="1400px",
            rendererName='Treemap',
            menuLimit = 20000,
            sorters = "
function(attr) {
            var sortAs = $.pivotUtilities.sortAs;
            if (attr == \"Weekday\") { return sortAs([\"Mon\", \"Tues\", \"Wed\", \"Thurs\", \"Fri\", \"Sat\", \"Sun\"]) } 
            if (attr == \"Tier\") { return sortAs([\"Tier 1\", \"Tier 2\", \"Tier 3\", \"Tier 4\"]); }
            }"
            )











# customers and salespersons
library(dplyr)
headTail(i)


count_slsprsn_cust = aggregate(Invoice ~ Salesperson + Customer + DeliveryDays + Weekday + Date + DistrictManager + Division, 
                               data=i, FUN=function(x) countUnique(x)) # + NewCustomer + Priority
count_slsprsn_cust = count_slsprsn_cust %>% arrange(desc(Invoice)); head(count_slsprsn_cust)

sum_slsprsn_cust = aggregate(Dollars ~ Salesperson + Customer + DeliveryDays + Weekday + Date + DistrictManager + Division, 
                             data=i, FUN=function(x) round(sum(x)))
sum_slsprsn_cust = sum_slsprsn_cust %>% arrange(desc(Dollars)); head(sum_slsprsn_cust)

slsprsn_customer_summary = merge(count_slsprsn_cust, sum_slsprsn_cust, by=c('Customer', 'Salesperson', 'DeliveryDays', 'Weekday', 
                                                                            'Date', 'DistrictManager', 'Division')); head(slsprsn_customer_summary)


names(slsprsn_customer_summary) = c('Customer', 'Salesperson', 'Delivery.Days', 
                                    'Weekday', 'Date', 'Sales.District.Manager', 
                                    'Sales.Division', 'Number.Off.Day.Invoices', 'Dollars')
slsprsn_customer_summary = slsprsn_customer_summary %>% arrange(Customer, Salesperson, Date)  %>%
  select(one_of(c('Date', 'Customer', 'Salesperson', 'Sales.District.Manager', 
                  'Sales.Division', 'Delivery.Days', 'Weekday', 'Number.Off.Day.Invoices', 'Dollars')))

slsprsn_customer_summary$Date = as.character(strptime(slsprsn_customer_summary$Date, '%Y-%m-%d'))
headTail(slsprsn_customer_summary, 30)


library(DT)
x = length(slsprsn_customer_summary$Date)
DT:::DT2BSClass(c('compact', 'cell-border'))
datatable(slsprsn_customer_summary, 
          filter = 'top',
          rownames = FALSE,
          options = 
            list(pageLength = x))

# add in this tag after <body> tag <font face="Calibri" size="2">
# change reference link inside summary html


i = i %>% arrange(Date, Customer, Salesperson)
slsprsn_customer_summary = slsprsn_customer_summary %>% arrange(Date, Customer, Salesperson)



# write to excel for others
library(xlsx)
#write.xlsx(slsprsn_customer_summary, file='C:/Users/pmwash/Desktop/R_files/Data Output/off_day_deliveries.xlsx', sheetName='Customer-Salesperson-Date')



i = read.csv(file='C:/Users/pmwash/Desktop/R_files/Data Output/off_day_deliveries_jun.csv')
headTail(i)

library(ggplot2)
library(plotly)
library(ggvis)
library(rCharts)
library(reshape2)
library(dplyr)


salespeeps = aggregate(Invoice ~ Salesperson + Division + DistrictManager, data=i, FUN=countUnique)
salespeeps = salespeeps %>% arrange(desc(Invoice)); head(salespeeps, 50)
salespeeps$Salesperson = factor(salespeeps$Salesperson, levels=salespeeps$Salesperson)




by_house = nPlot(Invoice ~ Division,
                 data=salespeeps,
                 group='Salesperson',
                 color='Salesperson',
                 type='multiBarChart'
                 # height=1200  #'column', #multiBarChart #lineWithFocusChart #multiChart
)
by_house$addFilters('Division') #'Sales.Division', 'Salesperson'
by_house$set(dom='off_day_plot1', 
             legendPosition='none',
             title='June 2016 Off Day Deliveries')
by_house$params$height = 1500
by_house$params$width = 800
by_house$params$facet = 'Warehouse'
# by_house$show("iframesrc", cdn = TRUE)

by_house






by_house = hPlot(Invoice ~ Salesperson,
                 data=salespeeps,
                 group='Warehouse',
                 colour='Salesperson',
                 type='column',  #'multiBarChart',
                 title='June 2016 Off Day Deliveries by Sales Division & Salesperson')
by_house$xAxis(title='Division',
               type='category')
# by_house$chart(height = 1000,
#                zoomType = "xy")
by_house$yAxis(title=list(text='Off Day Deliveries'),
               tickInterval=10)
by_house$chart(stacked=TRUE)
by_house$params$height = 1000
by_house$params$width = 1000



by_house









salespeeps_byday = aggregate(Invoice ~ Date + + Weekday + Warehouse, data=i, FUN=countUnique)
salespeeps_byday$Date = as.POSIXct(as.Date(salespeeps_byday$Date, '%m/%d/%Y'))
salespeeps_byday = salespeeps_byday %>% arrange(Date)
salespeeps_byday$Date = as.Date(salespeeps_byday$Date, '%Y-%m-%d')
# salespeeps_byday$Date = as.character(salespeeps_byday$Date)
str(salespeeps_byday)


head(salespeeps_byday, 50)




byday = nPlot(
  Invoice ~ Date,
  group = 'Warehouse',
  data = salespeeps_byday,
  type = 'lineWithFocusChart', #lineWithFocusChart #lineChart
  height = 700,
  width = 800
)
byday$xAxis(tickFormat = "#!function(d) {return d3.time.format.utc('%a %b %d')(new Date(d * 86400000 ))}!#")
byday$x2Axis(tickFormat = "#!function(d) {return d3.time.format.utc('%a %b %d')(new Date(d * 86400000))}!#")
# byday$chart(useInteractiveGuideline = TRUE)
byday$set(title = "June Off Day Deliveries")
byday$yAxis(axisLabel = 'Number Off Day Deliveries')
byday$templates$script = "http://timelyportfolio.github.io/rCharts_nvd3_templates/chartWithTitle_styled.html"

byday











































