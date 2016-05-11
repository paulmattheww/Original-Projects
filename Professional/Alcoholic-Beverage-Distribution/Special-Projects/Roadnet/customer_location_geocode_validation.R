
print('Customer Geocode Audit')

library(ggmap)
library(ggplot2)
library(ggrepel)
library(directlabels)
library(RgoogleMaps)
library(dplyr)
library(geosphere)
library(reshape2)
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')


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


#rebuilt = rbind(one, two, three, four, five, six, six_f_up, seven, eight)
combined = rbind(one, two, three, four, five, six, six_f_up, seven, eight)

namez = c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Route', 'Latitude', 'Longitude', 'Verified.Lat', 'Verified.Lon')
combined = combined[, namez]
combined = combined %>% filter(State == 'MO')
combined$OOB = ifelse(substrRight(as.character(combined$Name), 3) == 'OOB', 'Y', 'N')
combined = combined %>% filter(OOB=='N') %>% select(one_of(namez))




#write.csv(combined, 'C:/Users/pmwash/Desktop/Roadnet Implementation/Data/combined_unverified_geocodes.csv')
#combined = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/combined_unverified_geocodes.csv', header=TRUE)
# combined$X = NULL
headTail(combined, 500)







combined$Warehouse.Route = whse_rte = paste0(combined$Company, '_', combined$Route)
countUnique(whse_rte)

combined = split(combined, combined$Warehouse.Route)
whse_rte = names(combined)

names(combined) = lapply(names(combined), as.character)

headTail(combined)




























#Missouri = get_map(location='missouri', source='google', zoom=7, maptype='roadmap', color='bw') 

#two_times = 2 * length(combined)


print('Start at 178 tomorrow')
for(i in 180:length(combined)) {
  file_name_i = paste0(names(combined[i]))
  
  df_i = combined[[i]]
  df_i = na.omit(df_i)
  
  df_i = df_i %>% filter(Latitude > 36 | Latitude < 50)
  df_i = df_i %>% filter(Longitude > -97 | Longitude > -92)
  df_i = df_i %>% filter(Verified.Lat > 36 | Verified.Lat < 50)
  df_i = df_i %>% filter(Verified.Lon > -97 | Verified.Lon > -92)
  #df_i[,c('Latitude', 'Longitude', 'Verified.Lat', 'Verified.Lon')] = as.numeric(round(df_i[,c('Latitude', 'Longitude', 'Verified.Lat', 'Verified.Lon')], 6))
  
  base_map = get_map(location=c(lon=mean(df_i$Longitude, na.rm=T), lat=mean(df_i$Latitude, na.rm=T)), 
                     zoom='auto', source='osm')
  g_base_map = get_map(location=c(lon=mean(df_i$Verified.Lon, na.rm=T), lat=mean(df_i$Verified.Lat, na.rm=T)), 
                       zoom='auto', source='osm')
  
  map_df_i = ggmap(base_map, extent='panel', 
                   base_layer=ggplot(data=df_i, aes(x=Longitude, y=Latitude)))
  g_map_df_i = ggmap(g_base_map, extent='panel', 
                     base_layer=ggplot(data=df_i, aes(x=Verified.Lon, y=Verified.Lat)))
  
  
  # Generate and print map for geocodes we already had in AS400
  png(file=paste0('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Maps/', file_name_i, '_as400_existing_geocodes.png'), 
      width=1680, height=1028)
  
  map_existing_df_i = map_df_i + 
    geom_point(aes(x=Longitude, y=Latitude), colour='black', size=2) +
    labs(title=paste0('Warehouse_Route: ', file_name_i, ' - AS400 Existing Geocodes - Please Verify w/ Driver for Accuracy'), 
         x='Longitude', y='Latitude') +
    geom_label_repel(data=df_i, aes(x=Longitude, y=Latitude, label=Name), 
                     fill='white', box.padding=unit(0.4, 'lines'),
                     label.padding=unit(0.115, 'lines'), label.size=0.5,
                     segment.color='black', segment.size=0.05, alpha=0.7,
                     arrow=arrow(length = unit(0.01, 'npc'))) +
    theme(legend.position='none') +
    borders('county', 'missouri') 
  
  print(map_existing_df_i)
  
  dev.off()
  
  
  
  png(file=paste0('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Maps/', file_name_i, '_google_generated_geocodes.png'), 
      width=1680, height=1028)
  
  map_google_df_i = g_map_df_i + 
    geom_point(aes(x=Verified.Lon, y=Verified.Lat), colour='black', size=2) +
    labs(title=paste0('Warehouse_Route: ', file_name_i, ' - Google Address Generated Geocodes - Compare Quality of Geocode to Existing'), 
         x='Longitude', y='Latitude') +
    geom_label_repel(data=df_i, aes(x=Verified.Lon, y=Verified.Lat, label=Name), 
                     fill='white', box.padding=unit(0.4, 'lines'),
                     label.padding=unit(0.115, 'lines'), label.size=0.5,
                     segment.color='black', segment.size=0.05, alpha=0.7,
                     arrow=arrow(length = unit(0.01, 'npc'))) +
    theme(legend.position='none') +
    borders('county', 'missouri') 
  
  print(map_google_df_i)
  
  dev.off()
}













#locations = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/combined_unverified_geocodes.csv', header=TRUE)

headTail(locations)
#unique(locations$Company)

print('Gather the most "off" ones so team will not have to through so many maps')
options(scipen=999)
locations$Latitude = round(as.numeric(locations$Latitude), 6)

unverified = locations %>% filter(is.na(Latitude) | is.na(Longitude) |
                                       is.na(Verified.Lat) | is.na(Verified.Lon))
headTail(unverified)


addresses = paste0(unverified$Address, ' ', unverified$City, ' ', unverified$State, ' ', unverified$Zip, ' USA')

# lat_lon = geocode(addresses)
lat_lon = lat_lon[, c(2, 1)]


now_verified = cbind(unverified[, c(1:10)], lat_lon)
names(now_verified) = names(unverified)

now_verified = now_verified[, c('Customer', 'Verified.Lat', 'Verified.Lon')]

cust = now_verified$Customer
lat = now_verified$Verified.Lat
lon = now_verified$Verified.Lon

missing_locations = locations
missing_locations = missing_locations %>% filter(Customer %in% cust) %>%
  select(one_of(c('Company', 'Customer', 'Name', 'Address', 'City', 'State', 'Zip', 'Route', 'Latitude', 'Longitude')))

not_missing_anymore = merge(missing_locations, now_verified, by='Customer', all=TRUE)




never_missing = locations %>% filter(!Customer %in% cust)
headTail(never_missing)


all_locations = rbind(never_missing, not_missing_anymore)

unique(all_locations$Company)

all_locations$Warehouse.Route = whse_rte = paste0(all_locations$Company, '_', all_locations$Route)


print('SEND DATA TO PYTHON FOR HAVERSINE FORMULA')
###########
### DO NOT DO AGAIN ### #write.csv(all_locations, file('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/verified_locations_all.csv', encoding="UTF-8"))
###########
print('READ DATA BACK IN FROM PYTHON PROCESSING ROUTINE')

#all_locations = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/verified_locations_all.csv', header=TRUE)
all_locations = all_locations[,-c(1)]
headTail(all_locations, 50)


# check = filter(all_locations, Customer==614)
# base_map = get_map(location=c(lon=check$Longitude, lat=check$Latitude), 
#                    zoom='auto', source='google', maptype='road')
# 
# 
# customer_map = ggmap(base_map, extent='panel', 
#                  base_layer=ggplot(data=check, aes(x=Longitude, y=Latitude))) 
# 
# customer_map = customer_map + 
#   geom_point(aes(x=Longitude, y=Latitude), colour='blue', size=4) +
#   geom_point(aes(x=Verified.Lon, y=Verified.Lat), colour='red', size=4) +
#   labs(title=paste0('CHECK COORDINATES'), 
#        x='Longitude', y='Latitude') +
#   geom_label_repel(data=check, aes(x=Longitude, y=Latitude, label=Name), 
#                    fill='white', box.padding=unit(0.4, 'lines'),
#                    label.padding=unit(0.115, 'lines'), label.size=0.5,
#                    segment.color='black', segment.size=0.05, alpha=0.7,
#                    arrow=arrow(length = unit(0.01, 'npc'))) +
#   geom_label_repel(data=check, aes(x=Verified.Lon, y=Verified.Lat, label=Name), 
#                    fill='white', box.padding=unit(0.4, 'lines'),
#                    label.padding=unit(0.115, 'lines'), label.size=0.5,
#                    segment.color='black', segment.size=0.05, alpha=0.7,
#                    arrow=arrow(length = unit(0.01, 'npc'))) +
#   theme(legend.position='none') +
#   borders('county', 'missouri') 
# 
# print(customer_map)
# 
#   





check_addresses = all_locations %>% filter(Check.Address=='Y')
headTail(check_addresses)

#write.csv(all_locations, file('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/verified_locations_all_BACKUP.csv', encoding="UTF-8"))

headTail(all_locations, 50)

a_lat = all_locations$Latitude
g_lat = all_locations$Verified.Lat
a_lon = all_locations$Longitude
g_lon = all_locations$Verified.Lon
decision = all_locations$G.or.A
  
  
all_locations$Latitude.Final = ifelse(decision == 'G', g_lat, a_lat)
all_locations$Longitude.Final = ifelse(decision == 'G', g_lon, a_lon)

headTail(all_locations)
##write.csv(all_locations, file('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/verified_locations_all_BACKUP.csv', encoding="UTF-8"))

# 
# 
# for_bob_check = all_locations %>% filter(Check.Address == 'Y' | Latitude.Final < 36 | Longitude.Final > -89) %>% arrange(Latitude.Final)
# for_bob_check = for_bob_check[, c(1:8, 13:19)]
# headTail(for_bob_check)
# #for_bob_check$Latitude.Final
# #write.csv(for_bob_check, file('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/iffy_locations_for_bob_to_review.csv', encoding="UTF-8"))







print("TIME TO SATISFICE AND ACCEPT GEOCODES WE HAVE")

for_zip = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/locations_for_new_geocodes.csv', header=TRUE)
for_zip$Warehouse.Route = paste0(for_zip$Warehouse, '_', for_zip$Route)
headTail(for_zip)

satisfice = all_locations[, c('Customer', 'Latitude.Final', 'Longitude.Final', 'Warehouse.Route', 'Check.Address')]
names(satisfice) = c('Customer.ID', 'Latitude.Final', 'Longitude.Final', 'Warehouse.Route', 'Check.Address')
satisfice$Warehouse.Route.Customer = paste0(satisfice$Warehouse.Route, '_', satisfice$Customer)
satisfice = satisfice[, c('Customer.ID', 'Latitude.Final', 'Longitude.Final', 'Check.Address', 'Warehouse.Route.Customer')]
headTail(satisfice)

final_geocodes = merge(for_zip, satisfice, by='Customer.ID', all=TRUE)
library(stringr)
final_geocodes$Ship.Flag = as.character(str_pad(final_geocodes$Ship.Flag, 7, pad='0'))
headTail(final_geocodes, 10)

##
print('PERFORM CHECK BEFORE SENDING TO CSV')
x = countUnique(for_zip$Customer.ID)
y = length(for_zip$Customer.ID)
x == y #confirms are unique





#write.csv(final_geocodes, file('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/final_customer_coordinates.csv', encoding="UTF-8"))










split_verified = split(all_locations, all_locations$Warehouse.Route)


headTail(split_verified, 20)


























































tail(combined, 10)


# testing 

i = 181

file_name_i = paste0(names(combined[i]))

df_i = combined[[i]]
df_i = na.omit(df_i)

df_i = df_i %>% filter(Latitude > 36 | Latitude < 50)
df_i = df_i %>% filter(Longitude > -97 | Longitude > -92)

df_i = df_i %>% filter(Verified.Lat > 36 | Verified.Lat < 50)
df_i = df_i %>% filter(Verified.Lon > -97 | Verified.Lon > -92)

#df_i[,c('Latitude', 'Longitude', 'Verified.Lat', 'Verified.Lon')] = as.numeric(round(df_i[,c('Latitude', 'Longitude', 'Verified.Lat', 'Verified.Lon')], 6))

base_map = get_map(location=c(lon=mean(df_i$Longitude, na.rm=T), lat=mean(df_i$Latitude, na.rm=T)), 
                   zoom='auto', source='osm')
g_base_map = get_map(location=c(lon=mean(df_i$Verified.Lon, na.rm=T), lat=mean(df_i$Verified.Lat, na.rm=T)), 
                     zoom='auto', source='osm')

map_df_i = ggmap(base_map, extent='panel', 
                 base_layer=ggplot(data=df_i, aes(x=Longitude, y=Latitude)))
g_map_df_i = ggmap(g_base_map, extent='panel', 
                   base_layer=ggplot(data=df_i, aes(x=Verified.Lon, y=Verified.Lat)))


# Generate and print map for geocodes we already had in AS400
png(file=paste0('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Maps/', file_name_i, '_as400_existing_geocodes.png'), 
    width=1680, height=1028)

map_existing_df_i = map_df_i + 
  geom_point(aes(x=Longitude, y=Latitude), colour='black', size=2) +
  labs(title=paste0('Warehouse_Route: ', file_name_i, ' - AS400 Existing Geocodes - Please Verify w/ Driver for Accuracy'), 
       x='Longitude', y='Latitude') +
  geom_label_repel(data=df_i, aes(x=Longitude, y=Latitude, label=Name), 
                   fill='white', box.padding=unit(0.4, 'lines'),
                   label.padding=unit(0.115, 'lines'), label.size=0.5,
                   segment.color='black', segment.size=0.05, alpha=0.7,
                   arrow=arrow(length = unit(0.01, 'npc'))) +
  theme(legend.position='none') +
  borders('county', 'missouri') 

print(map_existing_df_i)

dev.off()



png(file=paste0('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Maps/', file_name_i, '_google_generated_geocodes.png'), 
    width=1680, height=1028)

map_google_df_i = g_map_df_i + 
  geom_point(aes(x=Verified.Lon, y=Verified.Lat), colour='black', size=2) +
  labs(title=paste0('Warehouse_Route: ', file_name_i, ' - Google Address Generated Geocodes - Compare Quality of Geocode to Existing'), 
       x='Longitude', y='Latitude') +
  geom_label_repel(data=df_i, aes(x=Verified.Lon, y=Verified.Lat, label=Name), 
                   fill='white', box.padding=unit(0.4, 'lines'),
                   label.padding=unit(0.115, 'lines'), label.size=0.5,
                   segment.color='black', segment.size=0.05, alpha=0.7,
                   arrow=arrow(length = unit(0.01, 'npc'))) +
  theme(legend.position='none') +
  borders('county', 'missouri') 

print(map_google_df_i)

dev.off()





























test = combined[[46]]
location_labels_test = test$Name

center = c(mean(test$Latitude, na.rm=T), mean(test$Longitude, na.rm=T))
zoom = 10

# Missouri_test = GetMap(center=center, zoom=zoom, maptype='roadmap')
Missouri_test = get_map(location=c(lon=mean(test$Longitude, na.rm=T), lat=mean(test$Latitude, na.rm=T)), 
                        zoom='auto', maptype='roadmap', color='bw') 

mo_base_map_test = ggmap(Missouri_test, extent='panel', 
                    base_layer=ggplot(data=test, 
                                      aes(x=Longitude, y=Latitude)))

old_and_new_test = mo_base_map_test + 
  geom_point(aes(x=Longitude, y=Latitude), colour='black', size=2) +
  labs(title=paste0('Warehouse/Route: ', file_name_i, ' - Existing Geocodes - Verify w/ Driver for Accuracy'), 
       x='Longitude', y='Latitude') +
  geom_label_repel(data=test, aes(x=Longitude, y=Latitude, label=Name), 
                   fill='white', box.padding=unit(0.4, 'lines'),
                   label.padding=unit(0.115, 'lines'), label.size=0.18,
                   segment.color='black', segment.size=0.05, alpha=0.7,
                   arrow=arrow(length = unit(0.01, 'npc'))) +
  theme(legend.position='none') +
  borders('county', 'missouri') 
  
old_and_new_test








