print('This is the Beer Report for Jill et al')

print('The goal of this report is to see what we have thrown away and what has come back from market, by supplier')



setwd("C:/Users/pmwash/Desktop/R_Files/Data Input")
unsale <- read.csv('unsaleables_beer_dec2015.csv', header=TRUE)
names(unsale) <- c('Product.Id', 'Description', 'Size', 'Case', 'Bottle', 'Laid.In', 'Ext.Cost',
                   'Trans.Code', 'Trans', 'Company', 'Trans.Date', 'QPC', 'Alt.QPC', 'Suppx', 
                   'Cases', 'Month', 'Class', 'Supplier')


print('SAINT LOUIS')
library(dplyr)
beerStl <- filter(unsale, Class=='BEER' & Company==2)

print('GATHER SUPPLIER DATA')
supplierStlCase <- aggregate(Cases ~ Supplier, data=beerStl, FUN=sum)
supplierStlCase <- arrange(supplierStlCase, desc(Cases))

supplierStlCost <- aggregate(Ext.Cost ~ Supplier, data=beerStl, FUN=sum)
supplierStlCost <- arrange(supplierStlCost, Ext.Cost)

supplierStlCount <- aggregate(Ext.Cost ~ Supplier, data=beerStl, FUN=length)
names(supplierStlCount) <- c('Supplier', 'No.Incidents')
suppliersStlCount <- arrange(supplierStlCount, desc(No.Incidents))

supplierStl <- merge(supplierStlCase, supplierStlCost, by='Supplier')
supplierStl <- merge(supplierStl, supplierStlCount, by='Supplier')
supplierStl <- arrange(supplierStl, desc(Cases))
supplierStl$Cases.Per.Incident <- round(supplierStl$Cases / supplierStl$No.Incidents)



print('GATHER ITEM DATA')
itemStlCase <- aggregate(Cases ~ Description + Product.Id, data=beerStl, FUN=sum)
itemStlCase <- arrange(itemStlCase, desc(Cases))

itemStlCost <- aggregate(Ext.Cost ~ Description + Product.Id, data=beerStl, FUN=sum)
itemStlCost <- arrange(itemStlCost, Ext.Cost)

itemStlCount <- aggregate(Ext.Cost ~ Description + Product.Id, data=beerStl, FUN=length)
names(itemStlCount) <- c('Description', 'Product.Id', 'No.Incidents')
itemsStlCount <- arrange(itemStlCount, desc(No.Incidents))

itemStl <- merge(itemStlCase, itemStlCost, by=c('Description', 'Product.Id'))
itemStl <- merge(itemStl, itemStlCount, by=c('Description', 'Product.Id'))
itemStl <- arrange(itemStl, desc(Cases))
itemStl$Cases.Per.Incident <- round(itemStl$Cases / itemStl$No.Incidents)







print('KANSAS CITY')
library(dplyr)
beerkc <- filter(unsale, Class=='BEER' & Company==1)

print('GATHER SUPPLIER DATA')
supplierkcCase <- aggregate(Cases ~ Supplier, data=beerkc, FUN=sum)
supplierkcCase <- arrange(supplierkcCase, desc(Cases))

supplierkcCost <- aggregate(Ext.Cost ~ Supplier, data=beerkc, FUN=sum)
supplierkcCost <- arrange(supplierkcCost, Ext.Cost)

supplierkcCount <- aggregate(Ext.Cost ~ Supplier, data=beerkc, FUN=length)
names(supplierkcCount) <- c('Supplier', 'No.Incidents')
supplierskcCount <- arrange(supplierkcCount, desc(No.Incidents))

supplierkc <- merge(supplierkcCase, supplierkcCost, by='Supplier')
supplierkc <- merge(supplierkc, supplierkcCount, by='Supplier')
supplierkc <- arrange(supplierkc, desc(Cases))
supplierkc$Cases.Per.Incident <- round(supplierkc$Cases / supplierkc$No.Incidents)



print('GATHER ITEM DATA')
itemkcCase <- aggregate(Cases ~ Description + Product.Id, data=beerkc, FUN=sum)
itemkcCase <- arrange(itemkcCase, desc(Cases))

itemkcCost <- aggregate(Ext.Cost ~ Description + Product.Id, data=beerkc, FUN=sum)
itemkcCost <- arrange(itemkcCost, Ext.Cost)

itemkcCount <- aggregate(Ext.Cost ~ Description + Product.Id, data=beerkc, FUN=length)
names(itemkcCount) <- c('Description', 'Product.Id', 'No.Incidents')
itemskcCount <- arrange(itemkcCount, desc(No.Incidents))

itemkc <- merge(itemkcCase, itemkcCost, by=c('Description', 'Product.Id'))
itemkc <- merge(itemkc, itemkcCount, by=c('Description', 'Product.Id'))
itemkc <- arrange(itemkc, desc(Cases))
itemkc$Cases.Per.Incident <- round(itemkc$Cases / itemkc$No.Incidents)



setwd("C:/Users/pmwash/Desktop/R_Files/Data Output")
library(xlsx)
write.xlsx(supplierStl, 'unsaleable_beer_exploration.xlsx', sheet='STL by Supplier')
write.xlsx(supplierkc, 'unsaleable_beer_exploration.xlsx', sheet='KC by Supplier', append=TRUE)
write.xlsx(itemStl, 'unsaleable_beer_exploration.xlsx', sheet='STL by Item', append=TRUE)
write.xlsx(itemkc, 'unsaleable_beer_exploration.xlsx', sheet='KC by Item', append=TRUE)









substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}
substrLeft <- function(x, n){
  substr(x, 1, n)
}






setwd("C:/Users/pmwash/Desktop/R_Files/Data Input")
lots <- read.csv("LotTracking.csv",header=TRUE, na.strings="NA")
lots$Date.Lot.Received <- strptime(lots$Date.Lot.Received, format='%m/%d/%Y')
library(dplyr)
today <- Sys.Date() #december 16 was date dive was run, must be same as this variable
lots$Expiration.Date <- today + as.numeric(lots$Remaining.Shelf.Life)
lots$Expiration.Date <- strptime(lots$Expiration.Date, format='%Y-%m-%d')
expDate <- lots$Expiration.Date
recDate <- lots$Date.Lot.Received
lots$Received.Til.Expiration <- as.Date(expDate) - as.Date(recDate)
lots <- lots[,c('Product', 'Lot.ID', 'Expiration.Date', 'Shelf.Life', 'Remaining.Shelf.Life',
                'Days.to.Deplete.by.Lot', 'Lot.Type', 'Date.Lot.Received', 'Original.Lot.Qty',
                'Remaining.Lot.Qty', 'Remaining.Lot.Value','Case.Cost.KC', 'Case.Cost.STL',
                'Product.ID', 'Received.Til.Expiration', 'Supplier', 'Warehouse')]
lots$Supplier. <- substrLeft(lots$Supplier, 15)
lots$Received.Til.Expiration <- as.numeric(lots$Received.Til.Expiration)
lots$Expiration.Date <- as.character(lots$Expiration.Date)
lots$Date.Lot.Received <- as.character(lots$Date.Lot.Received)
lots <- filter(lots, as.numeric(lots$Received.Til.Expiration) > 0 & as.numeric(lots$Received.Til.Expiration) < 350)
today <- as.POSIXct(today, '%Y-%m-%d')
expDate <- lots$Expiration.Date
recDate <- lots$Date.Lot.Received
exp <- expDate < today
lots$Expired <- ifelse(exp==TRUE, 'Expired', 'In Date')



bySupplier <- aggregate(Original.Lot.Qty ~ Supplier, data=lots, FUN=sum)
bySupplier <- arrange(bySupplier, desc(Original.Lot.Qty))

lotsBad <- filter(lots, Expired == 'Expired')
bySupplierExpired <- aggregate(Original.Lot.Qty ~ Supplier, data=lotsBad, FUN=sum)
bySupplierExpired <- arrange(bySupplierExpired, desc(Original.Lot.Qty))

bySupplierPurchase <- aggregate(Original.Lot.Qty ~ Supplier, data=lots, function(x) round(mean(x)))

bySupplierNumber <- aggregate(Original.Lot.Qty ~ Supplier, data=lots, FUN=length)

suppliers <- merge(bySupplier, bySupplierExpired, by='Supplier')
#suppliers$Percent.Expired.365 <- round(suppliers$Original.Lot.Qty.y / suppliers$Original.Lot.Qty.x, 3)
suppliers <- merge(suppliers, bySupplierPurchase, by='Supplier')
suppliers <- merge(suppliers, bySupplierNumber, by='Supplier')
names(suppliers) <- c('Supplier', 'Original.Qty', 'Expired.Cases.In.House', 
                      'Avg.Purchase.Size.Cases', 'No.of.Purchases')
suppliers <- arrange(suppliers, desc(Expired.Cases.In.House))

beerSales <- read.csv('jan_dec_beerSales_2015.csv', header=TRUE) # 2015 beer sales through 12/17
supplierSales <- aggregate(Std.Cases ~ Supplier, data=beerSales, function(x) round(sum(x)))
names(supplierSales) <- c('Supplier', 'Std.Case.Sales.YTD')

suppliers <- merge(suppliers, supplierSales, by='Supplier')
suppliers <- arrange(suppliers, desc(Expired.Cases.In.House))

supplierDollars <- aggregate(Dollars ~ Supplier, data=beerSales, function(x) round(sum(x)))
names(supplierDollars) <- c('Supplier', 'Dollar.Sales.YTD')

suppliers <- merge(suppliers, supplierDollars, by='Supplier')
suppliers <- arrange(suppliers, desc(Expired.Cases.In.House))

setwd("C:/Users/pmwash/Desktop/R_Files/Data Input")
unsale <- read.csv('unsaleables_beer_dec2015.csv', header=TRUE)
names(unsale) <- c('Product.ID', 'Description', 'Size', 'Case', 'Bottle', 'Laid.In', 'Ext.Cost',
                   'Trans.Code', 'Trans', 'Company', 'Trans.Date', 'QPC', 'Alt.QPC', 'Suppx', 
                   'Cases', 'Month', 'Class', 'Supplier..')
unsale <- filter(unsale, Class=='BEER')
unsale <- unsale[,c('Product.ID', 'Description', 'Ext.Cost', 
                    'Cases', 'Supplier..')]
names(unsale) <- c('Product.ID', 'Description', 'Ext.Cost.Unsaleable', 
                   'Cases.Unsaleable.YTD', 'Supplier..')
unsale <- merge(lots, unsale, by='Product.ID')
unsale <- unsale[,c(1:22)]
supplierUnsale <- aggregate(Cases.Unsaleable.YTD ~ Supplier, data=unsale, FUN=sum)

suppliers <- merge(suppliers, supplierUnsale, by='Supplier')
suppliers$Case.Unsaleable.Percent.Cases.Sold <- round(suppliers$Cases.Unsaleable.YTD / suppliers$Std.Case.Sales.YTD, 3)
suppliers <- arrange(suppliers, desc(Case.Unsaleable.Percent.Cases.Sold))









library(xlsx)
setwd("C:/Users/pmwash/Desktop/R_Files/Data Output")
write.xlsx(suppliers)




library(ggplot2)
g <- ggplot(data=lots, aes(x=as.numeric(Received.Til.Expiration), group=Supplier., weight=Original.Lot.Qty))
g + geom_histogram(binwidth=15, aes(group=Supplier., fill=Supplier.)) + facet_wrap(~Supplier., scales='free') +
  labs(title='Distribution of Days til Expiration of Lots Received, Weighted by Original Lot Qty',
       x='Days til Expiration of Lot Received', y='Count') +
  geom_rug(aes(group=Supplier., weight=Original.Lot.Qty)) + theme(legend.position='none')





head(lots, 100)





















