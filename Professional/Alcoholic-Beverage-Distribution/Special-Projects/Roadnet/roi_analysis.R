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
library(reshape2)
library(gdistance)
library(scales)
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
stl_history$YEAR = substrRight(as.character(stl_history$DATE), 4)
stl_history$YEAR.MONTH = paste0(stl_history$YEAR, sep='-', stl_history$MONTH)
stl_history$YEAR = NULL
stl_history$DATE = NULL
stl_history$MONTH = NULL
stl_history$YEAR.MONTH = factor(stl_history$YEAR.MONTH, 
                                levels=unique(stl_history$YEAR.MONTH))
headTail(stl_history)
stl_melt = melt(stl_history, c('YEAR.MONTH'))

png(file='C:/Users/pmwash/Desktop/Roadnet Implementation/ROI Analysis/Images/STL_Trucks_Time_Series.png', width=956, height=738)
g = ggplot(data=stl_melt, aes(x=factor(YEAR.MONTH), y=value))
g + geom_boxplot(aes(group=YEAR.MONTH, fill=variable), alpha=0.5) + 
  facet_wrap(~variable, scales='free_y') + 
  geom_smooth(aes(group=variable), colour='black', alpha=0.5) +
  labs(title='STL Trucks & Stops', x='Year & Month', y='Value') +
  theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1))
dev.off()


kc_history = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/kc_production_archive.csv')
kc_history = kc_history[, c('DATE', 'MONTH', 'TRUCKS.KC.TOTAL', 'TRUCKS.SPRINGFIELD',  
                            'STOPS.KC.TOTAL', 'STOPS.SPRINGFIELD')]
kc_history$YEAR = substrRight(as.character(kc_history$DATE), 4)
kc_history$YEAR.MONTH = paste0(kc_history$YEAR, sep='-', kc_history$MONTH)
kc_history$YEAR = NULL
kc_history$DATE = NULL
kc_history$MONTH = NULL
kc_history$YEAR.MONTH = factor(kc_history$YEAR.MONTH, 
                                levels=unique(kc_history$YEAR.MONTH))
headTail(kc_history)
stl_melt = melt(kc_history, c('YEAR.MONTH'))

png(file='C:/Users/pmwash/Desktop/Roadnet Implementation/ROI Analysis/Images/KC_Trucks_Time_Series.png', width=956, height=738)
g = ggplot(data=stl_melt, aes(x=factor(YEAR.MONTH), y=value))
g + geom_boxplot(aes(group=YEAR.MONTH, fill=variable), alpha=0.5) + 
  facet_wrap(~variable, scales='free_y') + 
  geom_smooth(aes(group=variable), colour='black', alpha=0.5) +
  labs(title='KC Trucks & Stops', x='Year & Month', y='Value') +
  theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1))
dev.off()




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


routes = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/ROI Analysis/trucks_routes_analysis.csv') #from vba production rpt

format_route_data = function(routes) {
  routes = routes[, c('Driver', 'Stops', 'RTE', 'Truck.', 
                      'LOC', 'TTL.Cs.splt',  
                      'Ttl.Mi', 'Date', 'Index', 'House')]
  names(routes) = c('Driver', 'Stops', 'Route', 'Truck', 
                    'Location', 'Cases',  
                    'Miles', 'Date', 'Index', 'House')
  routes$Date = as.character(strptime(str_extract(routes$Date, '[0-9]+-[0-9]+'), format='%m-%d'))
  routes = routes %>% arrange(Date)
  routes$Truck = factor(as.character(routes$Truck))
  routes
}  

clean_routes = format_route_data(routes)
# duplicated(clean_routes)




clean_routes = clean_routes[, c('Date', 'Route', 'Stops', 'Truck', 'Location', 
                                        'Cases', 'Miles')]
customers_routes = unique(clean_routes)
clean_routes$Capacity.Utilization = round(clean_routes$Cases / 550, 4)
clean_routes = arrange(clean_routes, -Stops)


clean_routes = filter(clean_routes, Cases > 75 & Stops > 1 & Cases < 625 & Stops < 100)

filter(clean_routes, Stops < 10)

headTail(clean_routes, 500)
# View(clean_routes)

g = ggplot(data=clean_routes, aes(x=Capacity.Utilization))
g + geom_histogram(binwidth=0.025, aes(fill=factor(Route)), 
                   size=0.1) +
  scale_x_continuous(label=percent)

g = ggplot(data=clean_routes, aes(x=Capacity.Utilization))
g + geom_density(aes(fill=factor(Truck), group=Truck), alpha=0.5) +
  scale_x_continuous(label=comma) +
  scale_y_continuous(label=percent)

g = ggplot(data=clean_routes, aes(x=factor(Route), y=Capacity.Utilization))
g + geom_bin2d()




route_utilisation = aggregate(Capacity.Utilization ~ Route, data=clean_routes, FUN=function(x) round(mean(x), 4))
route_utilisation = route_utilisation %>% arrange(-Capacity.Utilization)
route_utilisation$Route = factor(route_utilisation$Route, levels=route_utilisation$Route)
route_utilisation = route_utilisation %>% filter(Route != 2 & Route != 3 & Route != 4 &
                                                   Route != 5 & Route != 6 & Route != 8 &
                                                   Route != 13 & Route != 15 & Route != 16 &
                                                   Route != 25 & Route != 25 & Route != 52 &
                                                   Route != 55 & Route != 57 & Route != 58 &
                                                   Route != 59 & Route != 64 & Route != 790)


png(file='C:/Users/pmwash/Desktop/Roadnet Implementation/ROI Analysis/Images/Routes_Capacity_Utilization.png', width=1403, height=707)
avg_utilisation = mean(clean_routes$Capacity.Utilization, na.rm=TRUE)
g = ggplot(data=route_utilisation, aes(x=factor(Route), y=Capacity.Utilization))
g + geom_bar(stat='identity', fill='turquoise3', alpha=0.6) +
  theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1)) +
  scale_y_continuous(label=percent) +
  geom_hline(yintercept=avg_utilisation) + 
  labs(title='Capacity Utilization by Route', x='Route', y='Capacity Utilization')
dev.off()


truck_utilisation = aggregate(Capacity.Utilization ~ Truck, data=clean_routes, FUN=function(x) round(mean(x), 4))
truck_utilisation_sd = aggregate(Capacity.Utilization ~ Truck, data=clean_routes, FUN=function(x) round(sd(x), 4))
truck_utilisation = merge(truck_utilisation, truck_utilisation_sd, by='Truck')
names(truck_utilisation) = c('Truck', 'Avg.Capacity.Utilization', 'St.Dev.Capacity.Utilization')
truck_utilisation = truck_utilisation %>% arrange(-Avg.Capacity.Utilization) %>% 
  filter(St.Dev.Capacity.Utilization > 0.015 & as.numeric(as.character(truck_utilisation$Truck)) != 'NA')
truck_utilisation$Truck = factor(truck_utilisation$Truck, levels=truck_utilisation$Truck)

  
png(file='C:/Users/pmwash/Desktop/Roadnet Implementation/ROI Analysis/Images/Trucks_Capacity_Utilization.png', width=1403, height=707)
avg_utilisation = mean(truck_utilisation$Avg.Capacity.Utilization, na.rm=TRUE)
g = ggplot(data=truck_utilisation, aes(x=factor(Truck), y=Avg.Capacity.Utilization))
g + geom_bar(stat='identity', fill='chartreuse3', alpha=0.6) +
  theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1)) +
  scale_y_continuous(label=percent) +
  geom_hline(yintercept=avg_utilisation) + 
  labs(title='Avg Capacity Utilization by Truck', x='Truck', y='Capacity Utilization')
dev.off()


truck_lookup = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/ROI Analysis/truck_lookup.csv', header=TRUE)
truck_lookup = truck_lookup[,c(2:3)]
truck_lookup$Truck = factor(as.character(truck_lookup$Truck))





cust_rte_trck = merge(clean_routes, truck_lookup, by='Truck', all=TRUE)
# duplicated(cust_rte_trck)
arrange(cust_rte_trck, Truck, Date)
cust_rte_trck = unique(cust_rte_trck)
# duplicated(cust_rte_trck)








trucks_market_summary = aggregate(Cases ~ Truck + Date, data=cust_rte_trck, FUN=max)


compiled_trucks_daily = merge(trucks_market_summary, truck_lookup, by='Truck', all=TRUE)
compiled_trucks_daily$Percent.Capacity = round(compiled_trucks_daily$Cases / compiled_trucks_daily$Case.Capacity, 4)
headTail(compiled_trucks_daily)


compiled_trucks = aggregate(Percent.Capacity ~ Truck, data=compiled_trucks_daily, FUN=function(x) round(mean(x), 4))
compiled_trucks = compiled_trucks %>% arrange(-Percent.Capacity)


###





customers = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/ROI Analysis/Customers Geo Codes.csv')

merge_customers_routes = function(clean_routes, customers) {
  r = clean_routes
  c = customers
  
  merged = merge(r, c, by='Route', all_x=TRUE)
}

customers_routes = merge_customers_routes(clean_routes, customers)












print('Analyze statewide routes more closely')
routes_avg = aggregate(Cases ~ Route + House, data=customers_routes, FUN=function(x) round(mean(x), 2))
routes_avg = routes_avg %>% arrange(-Cases)
names(routes_avg) = c('Route', 'House', 'Avg.Cases')

routes_max = aggregate(Cases ~ Route + House, data=customers_routes, FUN=max)
routes_max = routes_max %>% arrange(-Cases)
names(routes_max) = c('Route', 'House', 'Max.Cases')

routes_min = aggregate(Cases ~ Route + House, data=customers_routes, FUN=min)
routes_min = routes_min %>% arrange(-Cases)
names(routes_min) = c('Route', 'House', 'Min.Cases')

routes_sd = aggregate(Cases ~ Route + House, data=customers_routes, FUN=function(x) round(sd(x), 2))
routes_sd = routes_sd %>% arrange(-Cases)
names(routes_sd) = c('Route', 'House', 'Std.Dev.Cases')

routes_count = aggregate(Cases ~ Route + House, data=customers_routes, FUN=countUnique)
routes_count = routes_count %>% arrange(-Cases)
names(routes_count) = c('Route', 'House', 'Route.Days')

production_days = countUnique(customers_routes$Date)

avg_latitude = aggregate(Latitude ~ Route + House, data=customers_routes, FUN=function(x) round(mean(x), 8))
names(avg_latitude) = c('Route', 'House', 'Avg.Latitude')

avg_longitude = aggregate(Longitude ~ Route + House, data=customers_routes, FUN=function(x) round(mean(x), 8))
names(avg_longitude) = c('Route', 'House', 'Avg.Longitude')

max_longitude = aggregate(Longitude ~ Route + House, data=customers_routes, FUN=max)
names(max_longitude) = c('Route', 'House', 'Max.Longitude')

min_longitude = aggregate(Longitude ~ Route + House, data=customers_routes, FUN=min)
names(min_longitude) = c('Route', 'House', 'Min.Longitude')

max_latitude = aggregate(Latitude ~ Route + House, data=customers_routes, FUN=max)
names(max_latitude) = c('Route', 'House', 'Max.Latitude')

min_latitude = aggregate(Longitude ~ Route + House, data=customers_routes, FUN=min)
names(min_latitude) = c('Route', 'House', 'Min.Latitude')



rtes = merge(routes_avg, routes_max, by=c('Route', 'House'))
rtes = merge(rtes, routes_min, by=c('Route', 'House'))
rtes = merge(rtes, routes_sd, by=c('Route', 'House'))
rtes = merge(rtes, routes_count, by=c('Route', 'House'))
rtes = merge(rtes, avg_latitude, by=c('Route', 'House'))
rtes = merge(rtes, avg_longitude, by=c('Route', 'House'))
rtes = merge(rtes, max_latitude, by=c('Route', 'House'))
rtes = merge(rtes, min_latitude, by=c('Route', 'House'))
rtes = merge(rtes, max_longitude, by=c('Route', 'House'))
rtes = merge(rtes, min_longitude, by=c('Route', 'House'))


rtes = filter(rtes, Std.Dev.Cases > 0)
rtes = rtes %>% arrange(House, -Avg.Cases)
rtes$Production.Days = production_days



max_lat = rtes$Max.Latitude
min_lat = rtes$Min.Latitude
max_lon = rtes$Max.Longitude
min_lon = rtes$Min.Longitude

rtes_lat = rtes[, c('Route', 'House', 'Min.Latitude', 'Max.Latitude')]
rtes_lat_melt = melt(rtes_lat, c('Route', 'House'))
rtes_lat_melt = rtes_lat_melt[, c(1:2, 4)]
  
rtes_lon = rtes[, c('Route', 'House', 'Min.Longitude', 'Max.Longitude')]
rtes_lon_melt = melt(rtes_lon, c('Route', 'House'))
rtes_lon_melt = rtes_lon_melt[, c(1:2, 4)]

lon_lat = merge(rtes_lon_melt, rtes_lat_melt, by=c('Route', 'House'))
names(lon_lat) = c('Route', 'House', 'Longitude', 'Latitude')




Missouri = get_map(location='missouri', source='stamen', zoom=7, maptype='toner', color='bw') 
mo_base_map = ggmap(Missouri, extent='panel', 
                    base_layer=ggplot(data=lon_lat, 
                                      aes(x=Longitude, y=Latitude)))
mo_base_map + geom_point(aes(x=Longitude, y=Latitude, group=Route, colour=factor(Route))) +
  geom_path(aes(xmin=Longitude, xmax=Longitude, 
                  ymin=Latitude, ymax=Latitude, 
                  group=Route, colour=factor(Route))) + 
  theme(legend.position='none') +
  borders('county', 'missouri') +
  geom_polygon(aes(x=Longitude, y=Latitude, colour=factor(Route)))
  

#+ 
 # stat_density2d(data=rtes, aes(x=Avg.Longitude, y=Avg.Latitude, fill=Avg.Cases), geom='polygon', alpha=0.05, colour='black')








#avg lat avg lon <-


png('C:/Users/pmwash/Desktop/Roadnet Implementation/ROI Analysis/Images/KansasCity_Route_Centers.png', width=850, height=689)
Missouri = get_map(location='kansas city, missouri', maptype='roadmap', source='google', zoom=9, color='bw') 
mo_base_map = ggmap(Missouri, extent='panel', 
                    base_layer=ggplot(data=rtes, 
                                      aes(x=Avg.Longitude, y=Avg.Latitude)))
mo_base_map + geom_point(data=rtes, aes(x=long, y=lat, group=Route, colour=factor(Route), size=Avg.Cases)) + theme(legend.position='none') +
  borders('county', 'missouri') + 
  stat_density2d(data=rtes, aes(x=Avg.Longitude, y=Avg.Latitude, fill=Avg.Cases), geom='polygon', alpha=0.05, colour='black')
dev.off()






trucks_avg = aggregate(Cases ~ Truck, data=customers_routes, FUN=function(x) round(mean(x), 2))
trucks_std = aggregate(Cases ~ Truck, data=customers_routes, FUN=function(x) round(sd(x), 2))
trucks = merge(trucks_avg, trucks_std, by='Truck')
names(trucks) = c('Truck', 'Avg.Cases', 'St.Dev.Cases')
trucks = trucks %>% arrange(c(Truck))
trucks = filter(trucks, St.Dev.Cases > 0)




# print('Melt data and aggregate avgs by Route')
# head(customers_routes)
# melt_cust_rte = melt(customers_routes, id=c('Date', 'Route'))
# melt_cust_rte$value = as.numeric(as.character(melt_cust_rte$value))
# agg_check = dcast(melt_cust_rte, Date + Route ~ variable, mean)
# headTail(agg_check)
# 
# aggregate(Cases ~ )









# lat = customers_routes$Latitude
# long = customers_routes$Longitude
# cust = customers_routes$Customer
# cases = customers_routes$Cases
# 
# Missouri = get_map(location='missouri', maptype='roadmap', source='google', zoom=7)
# mo_base_map = ggmap(Missouri, extent='panel', 
#                     base_layer=ggplot(data=customers_routes, 
#                                       aes(x=Longitude, y=Latitude)))
# 
# mo_base_map + geom_point()




lat_long = customers_routes[, c('Latitude', 'Longitude', 'Route', 'House')]
lat_long = unique(lat_long)
lat = lat_long$Latitude
long = lat_long$Longitude

png('C:/Users/pmwash/Desktop/Roadnet Implementation/ROI Analysis/Images/Statewide_Routes.png', width=1184, height=835)
Missouri = get_map(location='missouri', maptype='roadmap', source='google', zoom=7, color='bw') 
mo_base_map = ggmap(Missouri, extent='panel', 
                    base_layer=ggplot(data=lat_long, 
                                      aes(x=Longitude, y=Latitude, colour=factor(Route))))
mo_base_map + geom_point(aes(group=Route, colour=factor(Route))) + theme(legend.position='none') +
  borders('state', 'missouri') + borders('county', 'missouri') + 
  stat_density2d(data=customers_routes, aes(x=Longitude, y=Latitude, fill=Cases), geom='polygon', alpha=0.1)
dev.off()



stl_side = filter(customers_routes, Latitude > 35 & Latitude < 40 & Longitude < 90.5)
Stl = get_map(location='st louis, missouri', maptype='roadmap', source='google', zoom=11) 
mo_base_map = ggmap(Stl, extent='panel', 
                    base_layer=ggplot(data=stl_side, 
                                      aes(x=Longitude, y=Latitude, colour=factor(Route))))
mo_base_map + geom_point(aes(group=Route, colour=factor(Route))) + theme(legend.position='none') +
  borders('state', 'missouri') + borders('county', 'missouri')





unique(routes$Route)
headTail(routes)





















