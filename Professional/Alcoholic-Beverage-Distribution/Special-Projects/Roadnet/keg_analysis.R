# Keg Route Analysis
library(dplyr)
library(ggmap)
library(scales)

keg_routes = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/Customers_KegRoutes.csv', header=TRUE)
head(keg_routes)

ytd_keg_sales = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/pw_custytd.csv', header=TRUE)
head(ytd_keg_sales)


kegs = merge(keg_routes, ytd_keg_sales, by='CustomerID', all.y=TRUE); head(kegs)
kegs$KegRteHouse = paste0(kegs$Warehouse, '_', kegs$KegRte)



kegs = kegs %>% filter(YTDKegSales > 0); head(kegs); tail(kegs)
keg_route_only = kegs %>% filter(KegRte != 0, is.na(KegRte) == FALSE,
                                 KegRteHouse %in% c('2_68', '2_67', '2_69', '2_66', '3_366', '1_75'))

keg_route_only = keg_route_only %>% filter(State == 'MO')
# keg_route_only = keg_route_only %>% filter(CustomerTYpe != 'Internal')

stl_keg_routes = keg_route_only %>% filter(Warehouse == 2)
kc_keg_routes = keg_route_only %>% filter(Warehouse == 1)
col_keg_routes = keg_route_only %>% filter(Warehouse == 3)


STL = get_map('Saint Louis, MO USA',
              maptype = 'roadmap',
              zoom = 10)
KC = get_map('Kansas City, MO USA',
             maptype = 'roadmap',
             zoom = 9)
COL = get_map('Columbia, MO USA',
              maptype = 'roadmap',
              zoom = 9)

xx = col_keg_routes$Customer
itapgeo = geocode('308 S 9th St, Columbia, MO 65201 USA')
itaplon = itapgeo[1, 1]
itaplat = itapgeo[1, 2]
col_keg_routes$Latitude = ifelse(xx == 'INTERNATIONAL TAP & BOTTLE HS', itaplat, col_keg_routes$Latitude)
col_keg_routes$Longitude = ifelse(xx == 'INTERNATIONAL TAP & BOTTLE HS', itaplon, col_keg_routes$Longitude)




# googleVis attempt
library(googleVis)

create_interactive_map = function(keg_data, house)  {
  keg_data$LatLon = paste0(keg_data$Latitude, ":", keg_data$Longitude)
  keg_data$HoverText = paste0('<p>Customer ID:', keg_data$CustomerID, '<br>',
                              'Customer:  ', keg_data$Customer, '<br>',
                              'Keg Route:  ', keg_data$KegRte, '<br>', 
                              'YTD Keg Sales:  $', keg_data$YTDKegSales, '<br>',
                              'YTD Keg Transactions:  ', keg_data$YTDKegTransactions, '<br>',
                              'Customer Type:  ', keg_data$CustomerType, '<br>',
                              'Delivery Days:  ', keg_data$DeliveryDays, '<br>',
                              'Avg Service Time (Min):  ', round(keg_data$ServiceTimePredicted, 1), '<br>',
                              'Avg Invoice Lines Per Day:  ', keg_data$AvgInvoiceLinesPerDay, '<br>',
                              'On-Premise:  ', keg_data$OnPremise,
                              '</p>')
  
  
  keg_map = gvisMap(keg_data,
                    "LatLon", 
                    "HoverText",
                    options=list(region="US",
                                 showTip=TRUE,
                                 showLine=TRUE,
                                 enableScrollWheel=TRUE,
                                 mapType='normal', 
                                 useMapTypeControl=T,
                                 height=800,
                                 width=1400#,
                                 # gvis.editor='Edit me!'
                                 ))
  
  plot(keg_map)
  cat(keg_map$html$chart, 
      file=paste0('N:/2016 MB Projects/Roadnet/Keg Route Analysis/', house, '_keg_routes_interactive_map.html'))
  
}


create_interactive_map(keg_data = stl_keg_routes, house = 'stl')
create_interactive_map(keg_data = kc_keg_routes, house = 'kc')
create_interactive_map(keg_data = col_keg_routes, house = 'col')


# ggmap for size
create_density_map = function(city, keg_data, title, house)  {
  MAP = get_map(location=keg_data[,c('Longitude', 'Latitude')],
                source='google',
                maptype='roadmap')
  
  keg_map_stl = ggmap(MAP) +
    geom_point(data = keg_data, 
                 aes(x = Longitude, 
                     y = Latitude, 
                     group = factor(KegRte),
                     colour = factor(KegRte),
                     size = YTDKegTransactions/10
                     ),
                 alpha = 0.7) +
    # facet_wrap(~OnPremise) +
    scale_fill_gradient(low='green', high='red') +
    geom_density2d(data = keg_data, 
                 aes(x = Longitude, 
                     y = Latitude)) +
    stat_density2d(data = keg_data, 
                   aes(x = Longitude,
                       y = Latitude,
                       fill = ..level.., 
                       alpha = ..level..)) +
    labs(x = 'Longitude', y = 'Latitude', title = title,
         subtitle = 'On and Off Premise') +
    scale_fill_gradient(low = "green", high = "red") +
    scale_alpha(range = c(0.00, 0.25), guide = FALSE)
  
  keg_map_stl
}


create_density_map(city='st louis', keg_data=stl_keg_routes, title='STL Keg Route Density', house='stl')







# look at routes by day
unique(keg_route_only$KegRte)
head(keg_route_only)
keg_route_only$Customer = factor(keg_route_only$Customer) 
keg_route_only$KegRte = factor(keg_route_only$KegRte)
keg_route_only$Warehouse = factor(keg_route_only$Warehouse)


total_kegs_by_route = aggregate(YTDKegTransactions ~ KegRte + Warehouse, data=keg_route_only, FUN=sum)
total_kegs_by_route = total_kegs_by_route %>% arrange(desc(YTDKegTransactions)) 
total_kegs_by_route$KegRte = factor(total_kegs_by_route$KegRte, levels=total_kegs_by_route$KegRte)
total_kegs_by_route

# gvisTreeMap(data = keg_route_only, idvar = 'Customer',
#             parentvar = 'Route',
#             sizevar = 'YTDKegTransactions')


source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')
library(lubridate)
library(zoo)
library(plotly)

keg_routes_day = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/pw_kegwday.csv', header=TRUE)
keg_routes_day$Date = dat = as400Date(keg_routes_day$Date)
keg_routes_day$Date = as.Date(keg_routes_day$Date, '%Y-%m-%d')
keg_routes_day$Weekday = wday(dat, TRUE, FALSE)
keg_routes_day$Route = factor(keg_routes_day$Route, levels=total_kegs_by_route$KegRte)
keg_routes_day = keg_routes_day %>% filter(is.na(Route) == FALSE)

#moving avg
keg_routes_day = data.frame(keg_routes_day %>% 
  group_by(Route) %>%
  mutate(TenDayAvgKegs = rollmean(KegCount, 10, na.pad=TRUE, align='right'),
         ThirtyDayAvgKegs = rollmean(KegCount, 30, na.pad=TRUE, align='right')))
  
g = ggplot(data=keg_routes_day, aes(x=Date, y=KegCount, group=Route))
keg_routes_ts_plot = 
  g + geom_point(aes(colour=Route, size=KegCount/10), alpha=0.5) + 
  geom_line(data=keg_routes_day, size=2.5, alpha=0.7, colour='black',
            aes(x=Date, y=TenDayAvgKegs, group=Route)) +
  geom_line(data=keg_routes_day, size=1.5, alpha=0.7, colour='blue',
            aes(x=Date, y=ThirtyDayAvgKegs, group=Route)) +
  facet_wrap(~Route) +
  ggtitle('Statewide Daily Keg Route Volume<br>
          10 & 30 Day Moving Averages Included') +
  labs(x='Date', y='Number of Kegs') +
  theme(legend.position='none', 
        plot.title = element_text(lineheight=1.5, face="bold"),
        axis.text.x = element_text(angle = 90, hjust = 1))
ggplotly(keg_routes_ts_plot)




unique(keg_routes_day$Weekday)
sat_sun_keg_deliveries = keg_routes_day %>% filter(Weekday == 'Saturday' | Weekday == 'Sunday')
head(keg_routes_day, 50)

































