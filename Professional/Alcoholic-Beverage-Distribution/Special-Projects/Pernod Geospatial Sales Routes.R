## Ad Hoc ask
## Dan Monks, Craig Housman, Nick Fahs
## Geospatial view of accounts & teams

library(dplyr)
library(googleVis)
library(plotGoogleMaps)
library(reshape2)
# library(leaflet)
# library(rMaps)

IN = function(f_name) { read.csv(paste0('N:/Operations Intelligence/Operations Research/Geospatial Analyses/Sales Routes/', f_name), header=TRUE) }

pernod = IN('STL Pernod Sales 2016.csv')
locs = IN('STL Locations.csv')

head(pernod)
head(locs)

combined = merge(pernod, locs, by.x='Customer.ID', by.y='ID', all.x=TRUE)
combined = combined %>% arrange(desc(Dollars))
combined$Is.Nicks.Team = combined$Sales.Division == 'VICTORY'
combined$LatLong = paste0(combined$Latitude, ':', combined$Longitude)

combined = combined %>% filter(!is.na(Longitude), Premise.Type=='Off-Premise')
ht(combined)

## Widen out the dataframe for later
mapping_data = dcast(combined, Customer.ID + Customer + Delivery.Days + LatLong + Latitude + Longitude + Sales.Division + Salesperson ~ Is.Nicks.Team, value.var='Dollars')
colnames(mapping_data)[names(mapping_data) %in% c('FALSE','TRUE')] = c('Not.Victory','Victory')

mapping_data$Pop.Up = paste0('<p>Customer ID:   ', mapping_data$Customer.ID, '<br>',
                         'Customer:  ', mapping_data$Customer, '<br>',
                         'Delivery.Days:  ', mapping_data$Delivery.Days, '<br>',
                         'Victory Sales ($):  ', mapping_data$Victory, '<br>',
                         'Non-Victory Sales ($):  ', mapping_data$Not.Victory, '<br>',
                         'Division:  ', mapping_data$Sales.Division, '<br>',
                         'Salesperson:   ', mapping_data$Salesperson, '<br>',
                         '</p>')

mapping_data$Sales.Division.OnevAll = ifelse(mapping_data$Sales.Division == 'VICTORY','VICTORY','ALL OTHER TEAMS')
head(mapping_data)




## GoogleVis
MAP = gvisMap(data=mapping_data, locationvar='LatLong', tipvar='Pop.Up',
            options=list(
              showTip=TRUE,
              enableScrollWheel=TRUE,
              mapType='normal', 
              useMapTypeControl=T,
              height=800,
              width=1400
            ))
plot(MAP)
#cat(MAP$html$chart, 
    #file='N:/Operations Intelligence/Operations Research/Geospatial Analyses/Sales Routes/STL Sales Routes.html')




library(ggmap)
library(plotly)
map = get_map(location=c(mean(mapping_data$Longitude, na.rm=T), mean(mapping_data$Latitude, na.rm=T)),
              source='google', zoom=7, maptype='roadmap')


OUT = function(df, f_name) { write.csv(df, paste0('N:/Operations Intelligence/Operations Research/Geospatial Analyses/Sales Routes/', f_name), row.names=FALSE) }
ht(mapping_data)
#OUT(mapping_data, 'Pernod Geospatial Data.csv')

ggmap(map) + 
  geom_point(data=mapping_data, 
             aes(x=Longitude, y=Latitude, colour=Sales.Division.OnevAll, group=Sales.Division))









# ggmap for size
MAP = get_map(location=keg_data[,c('Longitude', 'Latitude')],
              source='google',
              maptype='roadmap')

keg_map_stl = ggmap(MAP) +
  geom_point(data = keg_data, 
             alpha = 0.5,
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








































## trying PlotGoogleMaps
library(plotGoogleMaps)
c = combined
coordinates(c) = ~Latitude+Longitude
bubbleGoogleMaps(c, zcol='Sales.Division')

head(c)


data(meuse)
coordinates(meuse) = ~x+y
head(meuse)



### FOR LATER
# G <- gvisGeoChart(Exports, "Country", "Profit", 
#                   options=list(width=300, height=300))
# T <- gvisTable(Exports, 
#                options=list(width=220, height=300))
# 
# GT <- gvisMerge(G,T, horizontal=TRUE) 
# plot(GT)










## Leaflet
# library(htmltools)
# base_map = leaflet(ggmap::geocode('St Louis Missouri USA')) 
# base_map %>% addTiles() %>%
#   addMarkers(data=combined, ~Longitude, ~Latitude, 
#              popup=~Pop.Up) 
# combined = combined %>% filter(!is.na(Longitude))



#GoogleVis try fail
# googleVis attempt
# library(googleVis)
# 
# create_interactive_map = function(combined)  {
#   #combined$LatLong = paste0(combined$Latitude, ":", combined$Longitude)
#   
#   
#   MAP = gvisMap(combined,
#                     "LatLon", 
#                     "Pop.Up",
#                     options=list(#region="US",
#                                  showTip=TRUE,
#                                  enableScrollWheel=TRUE,
#                                  mapType='normal', 
#                                  useMapTypeControl=T,
#                                  height=800,
#                                  width=1400
#                     ))
#   
#   plot(MAP)
#   cat(MAP$html$chart, 
#       file='N:/Operations Intelligence/Operations Research/Geospatial Analyses/Sales Routes/STL Sales Routes.html')
#   
# }
# 
# 
# create_interactive_map(combined)
# 












