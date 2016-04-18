library(dplyr)
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')




print('prepare unsaleables for upload to warehouse')

# pw_returns

etl_returns = function(returns) {
  library(lubridate) 
  
  names(returns) = c('Date', 'Product', 'Customer', 'Supplier', 'Cases', 'Cost', 'Warehouse')
  
  #returns$Cases = -1 * returns$Cases
  returns$Cost = -1 * returns$Cost
  returns$Date = as400Date(returns$Date)
  returns$Month = month(returns$Date, label=TRUE, abbr=FALSE)
  returns$Year = year(returns$Date)
  
  w = returns$Warehouse
  returns$Warehouse = ifelse(w==1, 'KC', 
                             ifelse(w==2, 'STL', 
                                    ifelse(w==3, 'COL', 
                                           ifelse(w==4, 'CAPE', 'SPFD'))))
  
  returns
}

returns = read.csv('N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/returns.csv', header=TRUE)

returns = etl_returns(returns)
headTail(returns)

write.csv(returns, 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/Output/returns_upload.csv')
















# pw_unsell

etl_unsaleables = function(rct) {
  library(lubridate)
  source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')
  
  names(rct) = c('Date', 'ProductID', 'Cases', 'Cost', 'Size', 'SupplierID', 'Class', 'Warehouse')
  
  rct$Date = as400Date(rct$Date)
  rct$Month = month(rct$Date, label=TRUE, abbr=FALSE)
  rct$Year = year(rct$Date)
  
  rct$Warehouse = ifelse(rct$Warehouse == 2, 'STL', 'KC')
  
  class = rct$Class
  rct$Class = ifelse(class==10, 'Liquor & Spirits', 
                     ifelse(class==25, 'Liquor & Spirits',
                            ifelse(class==50, 'Wine', 
                                   ifelse(class==51, 'Wine', 
                                          ifelse(class==53, 'Wine', 
                                                 ifelse(class==55, 'Wine', 
                                                        ifelse(class==58, 'Beer & Cider', 
                                                               ifelse(class==59, 'Beer & Cider', 
                                                                      ifelse(class==70, 'Wine', 
                                                                             ifelse(class==80, 'Beer & Cider', 
                                                                                    ifelse(class==84, 'Beer & Cider', 
                                                                                           ifelse(class==85, 'Beer & Cider', 
                                                                                                  ifelse(class==86, 'Beer & Cider', 
                                                                                                         ifelse(class==87, 'Beer & Cider',
                                                                                                                ifelse(class==88, 'Beer & Cider', 
                                                                                                                       ifelse(class>=90, 'Non-Alcoholic', 'XXXXXXXXXXXXX'))))))))))))))))
  
  
  rct
  
}

rct = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/Data Warehousing/pw_unsell.csv', header=TRUE, na.strings=NA)

unsaleables = etl_unsaleables(rct)
headTail(unsaleables)

write.csv(unsaleables, 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/Output/unsaleables_upload.csv')



















etl_breakage = function(brk) {
  library(lubridate)
  
  names(brk) = c('Date', 'Product ID', 'Cases', 'Cost', 'Type', 'Warehouse')
  
  r = brk$Type
  w = brk$Warehouse
  
  brk$Type = ifelse(r == 3 & w == 2, 'Warehouse STL', 
                    ifelse(r == 3 & w == 1, 'Warehouse KC', 
                           ifelse(r == 4 & w == 2, 'Driver STL',
                                  ifelse(r == 4 & w == 1, 'Driver KC', 
                                         ifelse(r == 5 & w == 1, 'Driver SPFD', 
                                                ifelse(r == 5 & w == 2, 'Driver COL',
                                                       ifelse(r == 3 & w == 5, 'Warehouse SPFD', 
                                                              ifelse(r == 3 & w == 3, 'Warehouse COL', 
                                                                     ifelse(is.na(w) & r == 3, 'Warehouse UNSPECIFIED',
                                                                            ifelse(is.na(w) & r == 4, 'Driver UNSPECIFIED',
                                                                                   ifelse(is.na(w) & r == 5, 'Driver MMO', 'UNSPECIFIED')))))))))))
                    
  brk$Warehouse = ifelse(w == 2, 'STL', 
                         ifelse(w == 1, 'KC', 
                                ifelse(w == 3, 'COL', 
                                       ifelse(w == 5, 'SPFD', 
                                              ifelse(w == 4, 'CAPE',
                                                     ifelse(is.na(w), 'NOT IDENTIFIED', 'NOT IDENTIFIED'))))))   
  
  brk$Date = as400Date(brk$Date)
  
  brk$Cost = round(-1 * brk$Cost, 2)
  brk$Cases = round(-1 * brk$Cases, 2)
  
  brk$Year = year(brk$Date)
  brk$Month = month(brk$Date, label=TRUE, abbr=FALSE)
  
  brk              
   
}  


brk = read.csv('N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/breakage.csv', header=TRUE)

breakage = etl_breakage(brk)
headTail(breakage)

write.csv(breakage, 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/Output/breakage_upload.csv')





















etl_customers = function(customers) {
  library(stringr)
  days = as.character(customers$Ship.Days)
  days = str_pad(days, 7, pad='0')
  customers$Ship.Days = days
  
  customers$SUNDAY.PLAN = sun = ifelse(substrRight(days, 1) == 1, "Y", "N")
  customers$SATURDAY.PLAN = sat = ifelse(substrLeft(substrRight(days, 2), 1) == 1, "Y", "N")
  customers$FRIDAY.PLAN = fri = ifelse(substrLeft(substrRight(days, 3), 1) == 1, "Y", "N")
  customers$THURSDAY.PLAN= thurs =  ifelse(substrLeft(substrRight(days, 4), 1) == 1, "Y", "N")
  customers$WEDNESDAY.PLAN = wed =  ifelse(substrLeft(substrRight(days, 5), 1) == 1, "Y", "N")
  customers$TUESDAY.PLAN = tue = ifelse(substrLeft(substrRight(days, 6), 1) == 1, "Y", "N")
  customers$MONDAY.PLAN = mon =  ifelse(substrLeft(substrRight(days, 7), 1) == 1, "Y", "N")
  
  customers
}


customers = read.csv('C:/Users/pmwash/Desktop/Disposable Docs/Customers_edit.csv', header=TRUE)


cust = etl_customers(customers)
headTail(cust)

write.csv(cust, 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/Output/customer_upload.csv')


























# query is pw_offday

off_day_etl = function(deliveries) {
  library(lubridate)
  library(dplyr)
  
  names(deliveries) = c('Date', 'Invoice', 'Customer', 'Call', 'Priority', 'Warehouse', 'Cases', 'Dollars', 'Ship', 'Salesperson', 'Ad.Member')
  
  date = deliveries$Date = as400Date(deliveries$Date)
  weekday = deliveries$Weekday = wday(date, label=TRUE, abbr=TRUE)
  
  library(stringr)
  days = as.character(deliveries$Ship)
  deliveries$Ship = days = str_pad(days, 7, pad='0')
  
  deliveries$Mon = mon =  ifelse(substrLeft(substrRight(days, 7), 1) == 1, "Y", "N")
  deliveries$Tue = tue = ifelse(substrLeft(substrRight(days, 6), 1) == 1, "Y", "N")
  deliveries$Wed = wed =  ifelse(substrLeft(substrRight(days, 5), 1) == 1, "Y", "N")
  deliveries$Thu = thu =  ifelse(substrLeft(substrRight(days, 4), 1) == 1, "Y", "N")
  deliveries$Fri = fri = ifelse(substrLeft(substrRight(days, 3), 1) == 1, "Y", "N")
  deliveries$Sat = sat = ifelse(substrLeft(substrRight(days, 2), 1) == 1, "Y", "N")
  deliveries$Sun = sun = ifelse(substrRight(days, 1) == 1, "Y", "N")
  
  deliveries$Off.Day = ifelse(mon=='Y' & weekday=='Mon', 'N',
                              ifelse(tue=='Y' & weekday=='Tues', 'N',
                                     ifelse(wed=='Y' & weekday=='Wed', 'N',
                                            ifelse(thu=='Y' & weekday=='Thurs', 'N',
                                                   ifelse(fri=='Y' & weekday=='Fri', 'N',
                                                          ifelse(sat=='Y' & weekday=='Sat', 'N',
                                                                 ifelse(sun=='Y' & weekday=='Sun', 'N', 'Y')))))))
  
  off_day_deliveries = deliveries %>% filter(Off.Day == 'Y')
  
  whse = off_day_deliveries$Warehouse
  call = off_day_deliveries$Call
  ad_mem = as.character(off_day_deliveries$Ad.Member)
  
  off_day_deliveries$Warehouse = ifelse(whse==1, 'KC', 
                                        ifelse(whse==2, 'STL', 
                                               ifelse(whse==3, 'COL', 
                                                      ifelse(whse==4, 'CAPE', 
                                                             ifelse(whse==5, 'SPFD', '')))))
  
  off_day_deliveries$Call = ifelse(call==1, 'Customer Call', 
                                   ifelse(call==2, 'ROE/EDI',
                                          ifelse(call==3, 'Salesperson Call',
                                                 ifelse(call==4, 'Telesales', 'Not Specified'))))
  
  ship_flag = off_day_deliveries$Ship
  n_ship_days = sapply(strsplit(ship_flag, split=''), function(x) sum(as.numeric(x)))
  
  off_day_deliveries$Tier = ifelse(ad_mem=='A' | ad_mem=='B', 'Tier 4', 
                                   ifelse(n_ship_days==1 & (ad_mem!='A' | ad_mem!='B'), 'Tier 3',
                                          ifelse(n_ship_days==2, 'Tier 2',
                                                 ifelse(n_ship_days>=3, 'Tier 1', 'Tier 4'))))
  
  off_day_deliveries = off_day_deliveries[, c('Date', 'Customer', 'Tier', 'Cases', 'Dollars', 'Salesperson', 'Priority', 'Warehouse', 'Invoice')]
  off_day_deliveries$Month = month(off_day_deliveries$Date)
  off_day_deliveries$Year = year(off_day_deliveries$Date)
  
  off_day_deliveries
  
}



deliveries = read.csv("C:/Users/pmwash/Desktop/Disposable Docs/deliveries.csv", header=TRUE)


off_days = off_day_etl(deliveries)
headTail(off_days, 50)



write.csv(off_days, 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/Output/deliveries_upload.csv')


# Sub format_off_day()
# Dim ws As Worksheet
# 
# For Each ws In ActiveWorkbook.Worksheets
# ws.Columns("A:ZZ").Font.Size = 9
# ws.Columns("A:ZZ").AutoFit
# ws.Activate
# Range("A1").Activate
# Selection.AutoFilter
# ActiveWindow.DisplayGridlines = False
# ws.Columns("A:ZZ").AutoFit
# ws.Rows("1:999999").RowHeight = 11.5
# Application.ErrorCheckingOptions.BackgroundChecking = False
# ws.Cells.Replace "#N/A", "", xlWhole
# Next ws
# 
# End Sub




