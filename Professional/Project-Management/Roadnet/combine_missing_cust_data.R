

# zip together information
  # fields needed that exist: {kegroute, monroute, tueroute, wedroute, thuroute, friroute, satroute, sunroute, cod, weight, onpremise, }
  # fields needed that do not exist: {iskeg, nearstadium, deliverytier, outofstock/ourfault, opentime, closetime, servicetime, avg_n_invoicesprioritize}
    # must build keg base routes



library(RODBC)

#Prepare the roadnet data for merging
roadnet_db = 'N:/Operations Intelligence/Data/Operations Database.accdb'
roadnet_odbc = odbcConnectAccess2007(roadnet_db)
customers = sqlQuery(roadnet_odbc, "SELECT * FROM CUSTOMERS")
close(roadnet_odbc)

lat_g = customers$Latitude
lon_g = customers$Longitude

lat_x = customers$XLatitudeX
lon_x = customers$XLongitudeX

customers$Latitude = ifelse(is.na(lat_g) == TRUE, lat_x, lat_g)
customers$Longitude = ifelse(is.na(lon_g) == TRUE, lon_x, lon_g)

customers$XLatitudeX = customers$XLongitudeX = NULL
customers$LocationType = customers$OnPremise = customers$AccountType = customers$Phone = customers$EquipmentType = customers$ServiceTimeType = customers$Zone = customers$Priority = customers$UDF1 = customers$UDF2 = customers$UDF3 = customers$Contact = NULL

customers$OpenTime = format(strptime('00:01', "%H:%M"), "%H:%M")
customers$CloseTime = format(strptime('23:59', "%H:%M"), "%H:%M")

head(customers); tail(customers)





#Get fields from AS400 that are missing in above dataset
as400_db = 'N:/Operations Intelligence/Data/Staging/Staging-Database.accdb'
as400_odbc = odbcConnectAccess2007(as400_db)

cus1 = sqlQuery(as400_odbc, "SELECT [CCUST#], [CONPRM], [CMONRT], [CTUERT], [CWEDRT], [CTHRRT], 
                [CFRIRT], [CSATRT], [CSUNRT], [CROUT2], [CSTOP2], [CPHON#], [CADMBR], [CSHSRT], 
                [CCPAMT], [CCOD$], [CSHIPI] FROM WSFILE002_CUS2")
close(as400_odbc)

names(cus1) = c('CustomerID', 'OnPremise', 'MonRte', 'TueRte', 'WedRte', 'ThuRte', 'FriRte', 'SatRte', 'SunRte',
                'KegRte', 'KegStop', 'Phone', 'ShipWeekAB', 'EnableShipSequenceYN', 'CODAmt', 'COD$', 'ShipInstructions')
head(cus1); tail(cus1)







#Merge the two by CustomerID to input into db
merged_customers = merge(customers, cus1, by='CustomerID', all.x=TRUE)

merged_customers$ShipInstructions = as.character(merged_customers$ShipInstructions)

merged_customers$StartWindow = format(merged_customers$StartWindow, "%H:%M")
merged_customers$StartWindow2 = format(merged_customers$StartWindow2, "%H:%M")
merged_customers$EndWindow = format(merged_customers$EndWindow, "%H:%M")
merged_customers$EndWindow2 = format(merged_customers$EndWindow2, "%H:%M")
merged_customers$WindowCollectionStart = format(merged_customers$WindowCollectionStart, "%H:%M")
merged_customers$WindowCollectionEnd = format(merged_customers$WindowCollectionEnd, "%H:%M")


head(merged_customers); tail(merged_customers)




#Save to temporary Roadnet db
roadnet_db = 'N:/Operations Intelligence/Data/Operations Database.accdb'
roadnet_odbc = odbcConnectAccess2007(roadnet_db)


sqlSave(roadnet_odbc, 
        merged_customers, 
        append = FALSE,
        rownames = FALSE,
        tablename = 'New_Customers',
        verbose = FALSE,
        safer = TRUE,
        fast = TRUE)


close(roadnet_odbc)
#write.csv(merged_customers, 'C:/Users/pmwash/Desktop/R_files/Data Output/backup_merged_customers_roadnet_06212016.csv', row.names=FALSE)




































































# cst = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Integrating Data/customer_export_access_06212016_for_combining.csv', 
#                 header=TRUE)
# head(cst); tail(cst)
