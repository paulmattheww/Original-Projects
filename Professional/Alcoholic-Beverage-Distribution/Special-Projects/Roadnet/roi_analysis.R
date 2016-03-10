cat('Use trucksfull AS400 query to get route and stop number and number of cases
    \n
    Filter out TRCD so just B and E remain (invoices & transfers)')

cat('Read in necessary external tools')
library(dplyr)
library(lubridate)
library(reshape2)
library(ggplot2)
library(stringr)
library(ggmap)
library(maps)
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')


# mtc = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/trucksfull.csv')
# 
# clean_mtc_data = function(mtc) {
#   names(mtc) = c('ROUTE.NO', 'STOP.NO', 'DRIVER.NO', 'WAREHOUSE', 'PRODUCT.NO', 'QPC',
#                  'QTY.SOLD', 'TRANSACTION.CODE', 'INVOICE.DATE', 'QTY.CODE')
#   mtc = mtc %>% filter(TRANSACTION.CODE == 'B' | TRANSACTION.CODE == 'E')
#   
#   qpc = mtc$QPC 
#   qty = mtc$QTY.SOLD
#   mtc$CASES = round(qty / qpc, 2)
#   
#   mtc$INVOICE.DATE = as400Date(mtc$INVOICE.DATE)
#   
#   mtc
# }


# mtc_clean = clean_mtc_data(mtc)



stl_history = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/stl_production_archive.csv')
stl_history = stl_history[, c('DATE', 'MONTH', 'TRUCKS.TOTAL', 'TRUCKS.PACKAGE', 'TRUCKS.KEG', 
                              'STOPS.STL', 'STOPS.CAPE', 'STOPS.COLUMBIA')]
headTail(stl_history)
stl_melt = melt(stl_history, c('DATE', 'MONTH'))

g = ggplot(data=stl_melt, aes(x=DATE, y=value))
g + geom_point(aes(group=variable)) + 
  facet_wrap(~variable, scales='free_y') + 
  geom_smooth(aes(group=variable)) +
  labs(title='STL Trucks & Stops')



kc_history = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/kc_production_archive.csv')
kc_history = kc_history[, c('DATE', 'MONTH', 'TRUCKS.KC.TOTAL', 'TRUCKS.SPRINGFIELD',  
                            'STOPS.KC.TOTAL', 'STOPS.SPRINGFIELD')]

headTail(kc_history)
kc_melt = melt(kc_history, c('DATE', 'MONTH'))

g = ggplot(data=kc_melt, aes(x=DATE, y=value))
g + geom_point(aes(group=variable)) + 
  facet_wrap(~variable, scales='free_y') + 
  geom_smooth(aes(group=variable)) +
  labs(title='KC Trucks & Stops')




cat('Information from SMEs
    \n
    Joe Luna 
      * High cases / low stops
      * No more than 37 stops (check with Joe)
    ')
kc_18_ft_capacity = 580
kc_53_ft_capacity = 1500
kc_48_ft_capacity = 1200





cat('Roadnet ROI Analysis: Drivers Only \n
    COSTS \n
    Routing & Dispatching Cost Savings \n
    Cell Phones 
      -S5 Phones 
      -Annual Plan 
      -Data Plan 
      -Insurance/Replacements \n
    \n
    SAVINGS \n
    Routing Time
    Driver Compensation 
    Fuel Usage 
    New KC Roadnet License')









cat('Roadnet ROI Analysis: With Telematics \n
    COSTS \n
    Routing & Dispatching Cost Savings \n
    Telematics
    Cell Phones 
      -S5 Phones 
      -Annual Plan 
      -Data Plan 
      -Insurance/Replacements \n
    \n
    SAVINGS \n
    Routing Time
    Driver Compensation 
    Fuel Usage 
    New KC Roadnet License
    Decrease in Insurance Claims*')





















cat('KC SPFD COL have 1 truck each that is not 18 ft
    \n
    Rick/Tony the MoBev units, Joe plaza unit, KC has only trailer statewide
    \n
    SPFD Truck # 133000 is 18ft')



kc_18_ft_capacity = 580
kc_53_ft_capacity = 1500
kc_48_ft_capacity = 1200

stl_18_ft_capacity = 600
stl_keg_18_ft_capacity = 90 #barrels

spfd_cases_per_bin = #from Rick



cat('Adapt VBA code to get production tab of Daily Report
    Two months worth of data should suffice')



routes = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/ROI Analysis/trucks_routes_analysis.csv')

format_route_data = function(routes) {
  routes = routes[, c('Driver', 'Stops', 'RTE', 'Truck.', 
                      'LOC', 'TTL.Cs.splt',  
                      'Ttl.Mi', 'Date', 'Index', 'House')]
  names(routes) = c('Driver', 'Stops', 'Route', 'Truck', 
                    'Location', 'Cases',  
                    'Miles', 'Date', 'Index', 'House')
  routes$Date = as.character(strptime(str_extract(routes$Date, '[0-9]+-[0-9]+'), format='%m-%d'))
  routes = routes %>% arrange(Date)
  routes
}  
 
clean_routes = format_route_data(routes)



customers = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/ROI Analysis/Customers Geo Codes.csv')

merge_customers_routes = function(clean_routes, customers) {
  r = clean_routes
  c = customers
  
  merged = merge(r, c, by='Route', all_x=TRUE)
}

customers_routes = merge_customers_routes(clean_routes, customers)


long_long
lat = customers_routes$Latitude
long = customers_routes$Longitude
cust = customers_routes$Customer
cases = customers_routes$Cases

Missouri = get_map(location='missouri', maptype='roadmap', source='google', zoom=7)
mo_base_map = ggmap(Missouri, extent='panel', 
                    base_layer=ggplot(data=customers_routes, 
                                      aes(x=unique(Longitude), y=unique(Latitude))))



unique(routes$Route)
headTail(routes)





















