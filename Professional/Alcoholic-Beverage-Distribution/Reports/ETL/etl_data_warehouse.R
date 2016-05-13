library(dplyr)
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')




print('prepare unsaleables for upload to warehouse')

# pw_returns

etl_returns = function(returns) {
  library(lubridate) 
  
  names(returns) = c('Date', 'Product', 'Customer', 'Supplier', 'Cases', 'Cost', 'Warehouse')
  
  returns$Cases = round(-1 * returns$Cases, 2)
  returns$Cost = round(-1 * returns$Cost, 2)
  
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

returns = read.csv('N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/pw_returns.csv', header=TRUE)

returns = etl_returns(returns)
headTail(returns)

write.csv(returns, 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/Output/returns_upload.csv')
















# pw_unsell

etl_unsaleables = function(rct) {
  library(lubridate)
  source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')
  
  names(rct) = c('Date', 'Product', 'Cases', 'Cost', 'Supplier', 'Class', 'Warehouse')
  
  rct$Date = as400Date(rct$Date)
  rct$Month = month(rct$Date, label=TRUE, abbr=FALSE)
  rct$Year = year(rct$Date)
  
  rct$Cases = round(-1 * rct$Cases, 2)
  rct$Cost = round(-1 * rct$Cost, 2)
  
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
  
  
  rct = arrange(rct, Date)
  
}

rct = read.csv('N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/pw_unsell.csv', header=TRUE, na.strings=NA)
headTail(rct)

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
                                                                                   ifelse(is.na(w) & r == 5, 'Driver MMO',
                                                                                          ifelse(r == 7, 'Supplier','UNSPECIFIED'))))))))))))
                    
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


brk = read.csv('N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/pw_breaks.csv', header=TRUE)

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

off_day_etl = function(deliveries, weeklookup) {
  library(lubridate)
  library(dplyr)
  library(stringr)
  
  names(deliveries) = c('Date', 'Invoice', 'Customer', 'Call', 'Priority', 
                        'Warehouse', 'Cases', 'Dollars', 'Ship', 'Salesperson', 
                        'Ad.Member', 'Merchandising', 'Ship.Week', 'On.Premise', 
                        'Customer.Setup')
  
  date = deliveries$Date = as400Date(deliveries$Date)
  weekday = deliveries$Weekday = wday(date, label=TRUE, abbr=TRUE)
  week = deliveries$Ship.Week
  month = month(date)
  setup_month = str_pad(as.character(deliveries$Customer.Setup), 4, pad='0')
  setup_month = month(as.numeric(substrLeft(setup_month, 2)))
  year = year(date)
  s = substrRight(as.character(deliveries$Customer.Setup), 2)
  this_century = as.numeric(s) < 20
  setup_year = ifelse(this_century == TRUE, 
         as.numeric(as.character(paste0("20", s))), 
         as.numeric(as.character(paste0("19", s))))
    
  days = as.character(deliveries$Ship)
  days = deliveries$Ship = str_pad(days, 7, pad='0')
  
  deliveries = merge(deliveries, weeklookup, by='Date', all_x=TRUE)
  
  mon =  ifelse(substrLeft(substrRight(days, 7), 1) == 1, 'M', '_')
  tue = ifelse(substrLeft(substrRight(days, 6), 1) == 1, 'T', '_')
  wed =  ifelse(substrLeft(substrRight(days, 5), 1) == 1, 'W', '_')
  thu =  ifelse(substrLeft(substrRight(days, 4), 1) == 1, 'R', '_')
  fri = ifelse(substrLeft(substrRight(days, 3), 1) == 1, 'F', '_')
  sat = ifelse(substrLeft(substrRight(days, 2), 1) == 1, 'S', '_')
  sun = ifelse(substrRight(days, 1) == 1, 'S', '_')
  
  deliveries$Delivery.Days = deldays = paste0(mon, tue, wed, thu, fri, sat, sun)
  
  deliveries$Weekday = weekday = wday(deliveries$Invoice.Date, label=TRUE)
  
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
  off_day_deliveries$Month = month(off_day_deliveries$Date, label=TRUE, abbr=FALSE)
  off_day_deliveries$Year = year(off_day_deliveries$Date)
  
  off_day_deliveries
  
}



deliveries = read.csv("N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/pw_offday.csv", header=TRUE)
weeklookup = read.csv("N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/pw_offday_weeklookup.csv", header=TRUE)

headTail(deliveries)
headTail(weeklookup)

off_days = off_day_etl(deliveries, weeklookup)
headTail(off_days, 50)



write.csv(off_days, 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/Output/deliveries_upload.csv')



























etl_po_lines = function(po) {
  library(lubridate)
  library(dplyr)
  
  names(po) = c('PO', 'Line', 'Date', 'Product', 'Supplier', 'Ordered', 'Received', 'Cost', 'Warehouse')
  
  po$Date = as400Date(po$Date)
  po$Month = month(po$Date, label=TRUE, abbr=FALSE)
  po$Year = year(po$Date)
  
  whse = po$Warehouse
  po$Warehouse = ifelse(whse==1, 'KC', 
                        ifelse(whse==2, 'STL', 
                               ifelse(whse==3, 'COL', 
                                      ifelse(whse==4, 'CAPE', 
                                             ifelse(whse==5, 'SPFD', '')))))
  
  po = arrange(po, Date)
  
  po
}


po = read.csv('N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/po_lines.csv', header=TRUE); head(po)

po_lines = etl_po_lines(po)
headTail(po_lines, 50)



write.csv(po_lines, 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/Output/po_lines_upload.csv')














etl_transfers = function(transfers) {
  library(lubridate)
  
  t = transfers
  
  names(t) = c('Date', 'Priority', 'Product', 'Cost', 'Cases', 'Warehouse', 'Supplier', 'Customer')
  
  whse = t$Warehouse
  
  t$Date = dat = as400Date(t$Date)
  t$Month = month(dat, label=TRUE, abbr=FALSE)
  t$Year = year(dat)
  
  t$Warehouse = ifelse(whse==1, 'KC', 
                        ifelse(whse==2, 'STL', 
                               ifelse(whse==3, 'COL', 
                                      ifelse(whse==4, 'CAPE', 
                                             ifelse(whse==5, 'SPFD', '')))))
  
  t
}

transfers = read.csv('N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/pw_trnsfer.csv', header=TRUE); head(transfers)

transfers = etl_transfers(transfers)
headTail(transfers, 50)



write.csv(transfers, 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/Output/transfers_upload.csv')


























etl_empty_keg_transfers = function(empty_keg_transfers) {
  library(lubridate)
  
  t = empty_keg_transfers
  
  names(t) = c('Date', 'Product', 'Class', 'Cost', 'Kegs', 'Warehouse', 'Customer')
  
  whse = t$Warehouse
  cls = t$Class
  
  t$Date = dat = as400Date(t$Date)
  t$Month = month(dat, label=TRUE, abbr=FALSE)
  t$Year = year(dat)
  
  t$Warehouse = ifelse(whse==1, 'KC', 
                       ifelse(whse==2, 'STL', 
                              ifelse(whse==3, 'COL', 
                                     ifelse(whse==4, 'CAPE', 
                                            ifelse(whse==5, 'SPFD', '')))))
  
  t$Class = ifelse(cls == 53, 'Keg Wine',
                   ifelse(cls == 59, 'Keg Cider', 
                          ifelse(cls == 85, 'Keg Beer', 
                                 ifelse(cls == 86, 'Keg Beer', 
                                        ifelse(cls == 87, 'Keg Beer Non-Deposit', 
                                               ifelse(cls == 88, 'Keg Beer High Alcohol', 'Not Specified'))))))
  
  t
}

empty_keg_transfers = read.csv('N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/empty_keg_transfers.csv', header=TRUE); head(empty_keg_transfers)

empty_keg_transfers = etl_empty_keg_transfers(empty_keg_transfers)
headTail(empty_keg_transfers, 50)



write.csv(empty_keg_transfers, 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/Output/empty_keg_transfers_upload.csv')








































#pwoos is backup for pwoostock

etl_out_of_stock = function(out_of_stock) {
  library(lubridate)
  
  t = out_of_stock
  
  names(t) = c('Date', 'Product', 'Warehouse', 'Cost', 'Cases', 'Back.Orders.Cases', 
               'YTD.Sales.Cases', 'Cases.On.Order', 'Cases.On.Hand', 'Cases.Reserved')
  
  t$Cost = round(t$Cost, 2)
  
  whse = t$Warehouse
  
  t$Date = dat = as400Date(t$Date)
  t$Month = month(dat, label=TRUE, abbr=FALSE)
  t$Year = year(dat)
  
  t = arrange(t, Product, Date)
  
  t$Warehouse = ifelse(whse==1, 'KC', 
                       ifelse(whse==2, 'STL', 
                              ifelse(whse==3, 'COL', 
                                     ifelse(whse==4, 'CAPE', 
                                            ifelse(whse==5, 'SPFD', '')))))
  
  headTail(t, 50)
  t %>% filter(Cases.Reserved > 0) %>% arrange(desc(Product))
  t %>% filter(Back.Orders.Cases > 0) %>% arrange(desc(Back.Orders.Cases), desc(Product))
  
  t
}

out_of_stock = read.csv('N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/out_of_stock.csv', header=TRUE); head(out_of_stock)

out_of_stock = etl_out_of_stock(out_of_stock)
headTail(out_of_stock, 50)



write.csv(out_of_stock, 'N:/Operations Intelligence/Monthly Reports/Data/Reporting/Transfer Files/Output/out_of_stock_upload.csv')


















# pw_custpups



# pw_slstakes

















































