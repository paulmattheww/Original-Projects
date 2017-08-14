
print('Customer Geocode Audit')

library(ggmap)
library(ggplot2)
library(RgoogleMaps)
library(dplyr)
library(reshape2)
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')


accountsToGeocode = read.csv('C:/Users/pmwash/Desktop/Disposable Docs/Caseys - Generate Lat Lon.csv', header=TRUE)

concatenateAddresses = function(name, street, city, state, zip, county, country){
  return(paste0(name,' ',street,' ',city,' ',state,' ',zip,' ',county,' ',country))
}
accountsToGeocode$FullAddress = concatenateAddresses(accountsToGeocode$NAME, accountsToGeocode$STREET, accountsToGeocode$CITY,
                                                     accountsToGeocode$STATE, accountsToGeocode$ZIP, accountsToGeocode$COUNTY, 'USA')
getLonLat = function(accountsToGeocode){
  lonLat = geocode(accountsToGeocode$FullAddress)
  accountsToGeocode$Longitude = lonLat[1]
  accountsToGeocode$Latitude = lonLat[2]
  return(accountsToGeocode)
}

accountsToGeocode = getLonLat(accountsToGeocode)

headTail(accountsToGeocode)




