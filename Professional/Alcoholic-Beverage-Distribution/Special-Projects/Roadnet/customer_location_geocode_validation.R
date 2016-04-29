
print('Customer Geocode Audit')

library(ggmap)
library(ggplot2)
library(ggrepel)
library(directlabels)
library(RgoogleMaps)

cus = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/customer_geocodes.csv', header=TRUE)
headTail(cus)


first_2500 = cus[c(1:2500), ]

first_2500_addresses = paste0(first_2500$Address, ' ', first_2500$City, ' ', first_2500$State, ' ', first_2500$Zip, ' USA')
# lat_lon = geocode(first_2500_addresses)


first_2500 = cbind(first_2500, lat_lon)
rearrange = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'lat', 'lon')
first_2500 = first_2500[, rearrange]
first_2500 = first_2500[c(1:2496), ] # a few did not get called
col_names = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'Verified.Lat', 'Verified.Lon')
names(first_2500) = col_names
headTail(first_2500, 20)
write.csv(first_2500, 'C:/Users/pmwash/Desktop/Roadnet Implementation/Data/first_geocodes.csv')


second = cus[c(2496:4000), ]

second_addresses = paste0(second$Address, ' ', second$City, ' ', second$State, ' ', second$Zip, ' USA')

# lat_lon = geocode(second_addresses)

second_batch = cbind(second, lat_lon)
rearrange = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'lat', 'lon')
second_batch = second_batch[, rearrange]
col_names = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'Verified.Lat', 'Verified.Lon')
names(second_batch) = col_names
head(second_batch, 20); tail(second_batch, 20)
write.csv(second_batch, 'C:/Users/pmwash/Desktop/Roadnet Implementation/Data/second_geocodes.csv')







third = cus[c(4001:4985), ]

third_addresses = paste0(third$Address, ' ', third$City, ' ', third$State, ' ', third$Zip, ' USA')

# lat_lon = geocode(third_addresses)
lat_lon = lat_lon[c(1:985) ,]

third_batch = cbind(third, lat_lon)
rearrange = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'lat', 'lon')
third_batch = third_batch[, rearrange]
col_names = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'Verified.Lat', 'Verified.Lon')
names(third_batch) = col_names
head(third_batch, 20); tail(third_batch, 20)
write.csv(third_batch, 'C:/Users/pmwash/Desktop/Roadnet Implementation/Data/third_geocodes.csv')






fourth = cus[c(4986:7000), ]

fourth_addresses = paste0(fourth$Address, ' ', fourth$City, ' ', fourth$State, ' ', fourth$Zip, ' USA')

# lat_lon = geocode(fourth_addresses)
## only if necessary ... lat_lon = lat_lon[c(1:985) ,]

fourth_batch = cbind(fourth, lat_lon)
rearrange = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'lat', 'lon')
fourth_batch = fourth_batch[, rearrange]
col_names = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'Verified.Lat', 'Verified.Lon')
names(fourth_batch) = col_names
head(fourth_batch, 20); tail(fourth_batch, 20)
write.csv(fourth_batch, 'C:/Users/pmwash/Desktop/Roadnet Implementation/Data/fourth_geocodes.csv')






fifth = cus[c(7001:9000), ]

fifth_addresses = paste0(fifth$Address, ' ', fifth$City, ' ', fifth$State, ' ', fifth$Zip, ' USA')

# lat_lon = geocode(fifth_addresses)
## only if necessary ... lat_lon = lat_lon[c(1:985) ,]

fifth_batch = cbind(fifth, lat_lon)
rearrange = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'lat', 'lon')
fifth_batch = fifth_batch[, rearrange]
col_names = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'Verified.Lat', 'Verified.Lon')
names(fifth_batch) = col_names
head(fifth_batch, 20); tail(fifth_batch, 20)
write.csv(fifth_batch, 'C:/Users/pmwash/Desktop/Roadnet Implementation/Data/fifth_geocodes.csv')










sixth = cus[c(9001:9691), ]

sixth_addresses = paste0(sixth$Address, ' ', sixth$City, ' ', sixth$State, ' ', sixth$Zip, ' USA')

# lat_lon = geocode(sixth_addresses)
## only if necessary ... lat_lon = lat_lon[c(1:985) ,]

sixth_batch = cbind(sixth, lat_lon)
rearrange = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'lat', 'lon')
sixth_batch = sixth_batch[, rearrange]
col_names = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'Verified.Lat', 'Verified.Lon')
names(sixth_batch) = col_names
head(sixth_batch, 20); tail(sixth_batch, 20)
write.csv(sixth_batch, 'C:/Users/pmwash/Desktop/Roadnet Implementation/Data/sixth_geocodes.csv')
















seventh = cus[c(11001:13000), ]

seventh_addresses = paste0(seventh$Address, ' ', seventh$City, ' ', seventh$State, ' ', seventh$Zip, ' USA')

# lat_lon = geocode(seventh_addresses)
## only if necessary ... lat_lon = lat_lon[c(1:985) ,]

seventh_batch = cbind(seventh, lat_lon)
rearrange = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'lat', 'lon')
seventh_batch = seventh_batch[, rearrange]
col_names = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'Verified.Lat', 'Verified.Lon')
names(seventh_batch) = col_names
head(seventh_batch, 20); tail(seventh_batch, 20)
write.csv(seventh_batch, 'C:/Users/pmwash/Desktop/Roadnet Implementation/Data/seventh_geocodes.csv')












eighth = cus[c(13001:14633), ]

eighth_addresses = paste0(eighth$Address, ' ', eighth$City, ' ', eighth$State, ' ', eighth$Zip, ' USA')

# lat_lon = geocode(eighth_addresses)
## only if necessary ... lat_lon = lat_lon[c(1:985) ,]

eighth_batch = cbind(eighth, lat_lon)
rearrange = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'lat', 'lon')
eighth_batch = eighth_batch[, rearrange]
col_names = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'Verified.Lat', 'Verified.Lon')
names(eighth_batch) = col_names
head(eighth_batch, 20); tail(eighth_batch, 20)
write.csv(eighth_batch, 'C:/Users/pmwash/Desktop/Roadnet Implementation/Data/eighth_geocodes.csv')



# 1632 = 14633 - 13001















sixth_screwup = cus[c(9692:11000), ]

sixth_screwup_addresses = paste0(sixth_screwup$Address, ' ', sixth_screwup$City, ' ', sixth_screwup$State, ' ', sixth_screwup$Zip, ' USA')

# lat_lon = geocode(sixth_screwup_addresses)
## only if necessary ... lat_lon = lat_lon[c(1:985) ,]

sixth_screwup_batch = cbind(sixth_screwup, lat_lon)
rearrange = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'lat', 'lon')
sixth_screwup_batch = sixth_screwup_batch[, rearrange]
col_names = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Zip2', 'Latitude', 'Longitude', 'Route', 'Verified.Lat', 'Verified.Lon')
names(sixth_screwup_batch) = col_names
head(sixth_screwup_batch, 20); tail(sixth_screwup_batch, 20)
write.csv(sixth_screwup_batch, 'C:/Users/pmwash/Desktop/Roadnet Implementation/Data/sixth_screwup_geocodes.csv')




# 1308 = 11000 - 9692
# 1308 + 1632







one = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/first_geocodes.csv', header=TRUE)
two = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/second_geocodes.csv', header=TRUE)
three = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/third_geocodes.csv', header=TRUE)
four = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/fourth_geocodes.csv', header=TRUE)
five = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/fifth_geocodes.csv', header=TRUE)
six = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/sixth_geocodes.csv', header=TRUE)
six_f_up = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/sixth_screwup_geocodes.csv', header=TRUE)
seven = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/seventh_geocodes.csv', header=TRUE)
eight = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/eighth_geocodes.csv', header=TRUE)


headTail(one)
headTail(two)
headTail(three)
headTail(four)
headTail(five)
headTail(six)
headTail(six_f_up)
headTail(seven)
headTail(eight)



combined = rbind(one, two, three, four, five, six, six_f_up, seven, eight)

namez = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Route', 'Latitude', 'Longitude', 'Verified.Lat', 'Verified.Lon')
combined = combined[, namez]
combined = combined %>% filter(State == 'MO')
combined$OOB = ifelse(substrRight(as.character(combined$Name), 3) == 'OOB', 'Y', 'N')
combined = combined %>% filter(OOB=='N') %>% select(one_of(namez))




headTail(combined)
#write.csv(combined, 'C:/Users/pmwash/Desktop/Roadnet Implementation/Data/combined_unverified_geocodes.csv')
#combined = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/combined_unverified_geocodes.csv', header=TRUE)


# 
# google_lat = combined$Verified.Lat
# google_lon = combined$Verified.Lon
# original_lat = combined$Latitude
# original_lon = combined$Longitude
# 


# 
# file_name = 'test'
# png(file=paste0('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Maps/', file_name), width=1011, height=764)
# 
# Missouri = get_map(location='missouri', source='google', zoom=7, maptype='roadmap', color='bw') 
# mo_base_map = ggmap(Missouri, extent='panel', 
#                     base_layer=ggplot(data=combined, 
#                                       aes(x=Avg.Longitude, y=Avg.Latitude)))
# mo_base_map + geom_point(aes(x=Avg.Longitude, y=Avg.Latitude, group=Route, colour=factor(Route), size=Avg.Cases)) + 
#   theme(legend.position='right') +
#   borders('county', 'missouri') + geom_density_2d(aes(colour=Avg.Cases), alpha=0.5) + 
#   labs(title='NOVEMBER/DECEMBER: Geographic Centers of Routes w/ Capacity Utilization < 45% & Stops < 18')
# 
# dev.off()



combined$Warehouse.Route = whse_rte = paste0(combined$Company, '_', combined$Route)
countUnique(whse_rte)

combined = split(combined, combined$Warehouse.Route)
whse_rte = names(combined)

names(combined) = lapply(names(combined), as.character)






Missouri = get_map(location='missouri', source='google', zoom=7, maptype='roadmap', color='bw') 

for(i in 1:length(combined)) {
  file_name_i = paste0(names(combined[i]))
  df_i = combined[[i]]
  location_labels_df_i = df_i$Name
  
  center_of_route = c(mean(df_i$Latitude, na.rm=T), mean(df_i$Longitude, na.rm=T))

  base_map = get_map(location=c(lon=mean(df_i$Longitude, na.rm=T), lat=mean(df_i$Latitude, na.rm=T)), 
                          zoom='auto', maptype='roadmap', color='bw') 
  
  map_df_i = ggmap(base_map, extent='panel', 
                           base_layer=ggplot(data=df_i, 
                                             aes(x=Longitude, y=Latitude)))
  
  png(file=paste0('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Maps/existing_geocodes_', file_name_i, '.png'), width=1680, height=1028)
  
  map_existing_df_i = map_df_i + 
    geom_point(aes(x=Longitude, y=Latitude), colour='black', size=2) +
    labs(title=paste0('Warehouse/Route: ', file_name_i, ' - Existing Geocodes - Please Verify w/ Driver for Accuracy'), 
         x='Longitude', y='Latitude') +
    geom_label_repel(data=df_i, aes(x=Longitude, y=Latitude, label=Name), 
                     fill='white', box.padding=unit(0.4, 'lines'),
                     label.padding=unit(0.115, 'lines'), label.size=0.2,
                     segment.color='black', segment.size=0.05, alpha=0.3,
                     arrow=arrow(length = unit(0.01, 'npc'))) +
    theme(legend.position='none') +
    borders('county', 'missouri') 
  
  map_existing_df_i
  
  dev.off()
}
