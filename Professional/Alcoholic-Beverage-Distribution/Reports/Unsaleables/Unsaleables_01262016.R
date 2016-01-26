print('Load the necessary libraries.')
library(dplyr)
library(xlsx)
library(lubridate)
library(ggplot2)


print('Define functions necessary for analysis.')
headTail = function(x) {
  h <- head(x)
  t <- tail(x)
  print(h)
  print(t)
}
as400Date <- function(x) {
  date <- as.character(x)
  date <- substrRight(date, 6)
  date <- as.character((strptime(date, "%y%m%d")))
  date
}
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}
substrLeft <- function(x, n){
  substr(x, 1, n)
}

print('Returns & Spoilage: pwmtc1 & pwrct1 by house')
setwd("C:/Users/pmwash/Desktop/R_files/Data Input")

print('Be sure to re-run both queries. Gain access to query before replacing these file objects in memory')
timeframe = 'Jan. 1 2015 to Dec. 31 2015'
rct = read.csv('rct1.csv', header=TRUE, na.strings=NA)
mtc = read.csv('mtc1.csv', header=TRUE, na.strings=NA)
headTail(rct)
headTail(mtc)

print('Create dates & months in both files')
rct$DATE = as400Date(rct$X.RDATE)
rct$MONTH = month(rct$DATE, label=TRUE)
mtc$DATE = as400Date(mtc$X.MIVDT)
mtc$MONTH = month(mtc$DATE, label=TRUE)

print('Create cases from cases & bottles using QPC in the RTC file')
cs = rct$X.RCASE
btl = rct$X.RBOTT
qpc = rct$X.RQPC
rct$CASES.UNSALEABLE = cs + round(btl/qpc, 2)

print('Put in Class codes.')
class = rct$X.RCLA.
rct$CLASS = ifelse(class==10, 'Liquor & Spirits', 
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


cs = rct$X.RCASE
fob = rct$X.RFOB
qpc = rct$X.RQPC
btl = rct$X.RBOTT
rct$EXT.COST = (cs * fob) + (fob/qpc*btl) #### BUG FIXED

print('Cases for MTC; divide bottles (Q sold) by QPC')
qpc = mtc$X.MQPC 
qty = mtc$X.MQTYS
mtc$CASES = round(qty / qpc, 2)

print('Check names.')
headTail(mtc);headTail(rct)


print('###################')
print('Start report below')
print('###################')

print('Gather data by supplier and item, also returning class and supplier number;
      RCT will be total unsaleables; aggregate by supplier')
supplierItem = aggregate(CASES.UNSALEABLE ~ PSUPPL + X.SSUNM + X.RPRD. + X.RDESC + CLASS, data=rct, FUN=sum)#total unsaleables
names(supplierItem) = c('SUPPLIER', 'SUPPLIER.NO', 'ITEM.NO', 'DESCRIPTION', 'CLASS', 'CASES.UNSALEABLE') 

############ 
print("check koochenvagner for cases unsaleable")
koochen = filter(supplierItem, SUPPLIER==309)
sum(koochen$CASES.UNSALEABLE)#matches Kathie's
rm(koochen)
############

print('MTC will be total returns; aggregate by product number')
itemReturns = aggregate(CASES ~ X.MINP., data=mtc, FUN=sum)
names(itemReturns) = c('ITEM.NO', 'CASES.RETURNED')

print('Aggregate X.MCOS. by item number from MTC to obtain cost returned')
supplierItemCost = aggregate(X.MCOS. ~ X.MINP., data=mtc, FUN=sum)
names(supplierItemCost) = c('ITEM.NO', 'COST.RETURNED')#verify

supplierItemUnsaleableCost = aggregate(EXT.COST ~ PSUPPL + X.SSUNM + X.RPRD. + X.RDESC + CLASS, data=rct, FUN=sum)
names(supplierItemUnsaleableCost) = c('SUPPLIER', 'SUPPLIER.NO', 'ITEM.NO', 'DESCRIPTION', 'CLASS', 'COST.UNSALEABLE')
supplierItemUnsaleableCost = supplierItemUnsaleableCost %>% arrange(COST.UNSALEABLE)
############ 
print("check koochenvagner for ext cost")
koochen = filter(supplierItemUnsaleableCost, SUPPLIER==309)
sum(koochen$COST.UNSALEABLE)#matches Kathie's
rm(koochen)
############ 


print('Merge the two above files to get unsaleable by supplier and item;
      This is where we subtract returns (MTC) from total unsaleables (RCT)')
supplierItem = merge(supplierItem, itemReturns, by='ITEM.NO', all=TRUE)
returned = supplierItem$CASES.RETURNED
supplierItem$CASES.RETURNED = ifelse(is.na(returned), 0, returned)
############ 
print("check koochenvagner for ext cost")
koochen = filter(supplierItem, SUPPLIER==309)
head(koochen)
sum(koochen$CASES.UNSALEABLE)#matches Kathie's
sum(koochen$CASES.RETURNED)#matches Kathie's
rm(koochen)
############ 
supplierItem = merge(supplierItem, supplierItemCost, by='ITEM.NO', all=TRUE)
############ 
print("check koochenvagner for ext cost")
check = merge(supplierItem, supplierItemCost, by='ITEM.NO', all=TRUE)
koochen = filter(check, SUPPLIER==309)
sum(koochen$CASES.UNSALEABLE)#matches Kathie's
sum(koochen$CASES.RETURNED)
rm(koochen)
############ 
supplierItem = merge(supplierItem, supplierItemUnsaleableCost, by=c('SUPPLIER', 'SUPPLIER.NO', 'ITEM.NO', 'DESCRIPTION', 'CLASS'), all=TRUE)
costReturned = supplierItem$COST.RETURNED
supplierItem$COST.RETURNED = ifelse(is.na(costReturned), 0, costReturned)
############ 
print("check koochenvagner for ext cost")
check = merge(supplierItem, supplierItemUnsaleableCost, by=c('SUPPLIER', 'SUPPLIER.NO', 'ITEM.NO', 'DESCRIPTION', 'CLASS'), all=TRUE)
koochen = filter(check, SUPPLIER==309)
sum(koochen$CASES.UNSALEABLE)#matches Kathie's
sum(koochen$CASES.RETURNED)
rm(koochen)
############ 
names(supplierItem) = c('SUPPLIER.NO', 'SUPPLIER', 'ITEM.NO', 'DESCRIPTION',
                        'CLASS', 'CASES.UNSALEABLE', 'CASES.RETURNED', 'COST.RETURNED',
                        'COST.UNSALEABLE')
supplierItem = supplierItem %>% arrange(COST.UNSALEABLE)
head(supplierItem, 100)
############ 
print("check koochenvagner for ext cost")
koochen = filter(supplierItem, SUPPLIER.NO==309)
sum(koochen$COST.UNSALEABLE)#matches Kathie's
sum(koochen$CASES.UNSALEABLE)#matches Kathie's
sum(koochen$COST.RETURNED)
sum(koochen$CASES.RETURNED)
rm(koochen)
############
supplierItem$COST.RETURNED =  supplierItem$COST.RETURNED*(-1)
supplierItem$COST.UNSALEABLE = supplierItem$COST.UNSALEABLE*(-1)
supplierItem$CASES.UNSALEABLE = supplierItem$CASES.UNSALEABLE*(-1)
supplierItem$CASES.RETURNED = supplierItem$CASES.RETURNED*(-1)
headTail(supplierItem)

supplierItem$COST.DUMPED = supplierItem$COST.UNSALEABLE - supplierItem$COST.RETURNED
supplierItem$CASES.DUMPED = supplierItem$CASES.UNSALEABLE - supplierItem$CASES.RETURNED
supplierItem = supplierItem %>% arrange(desc(COST.UNSALEABLE))
supplierItem = supplierItem[,c('ITEM.NO', 'DESCRIPTION', 'SUPPLIER.NO', 'SUPPLIER', 'CLASS',
                               'CASES.UNSALEABLE', 'CASES.RETURNED', 'CASES.DUMPED',
                               'COST.UNSALEABLE', 'COST.RETURNED', 'COST.DUMPED')]
headTail(supplierItem)

#########
schlafly = filter(supplierItem, SUPPLIER.NO==218)
sum(schlafly$COST.UNSALEABLE)
sum(schlafly$CASES.UNSALEABLE)

koochen = filter(supplierItem, SUPPLIER.NO==309)
sum(koochen$COST.UNSALEABLE)
sum(koochen$CASES.UNSALEABLE)
############

print('Gather by supplier only;
      Independently gather dumped, returned and unsaleable & validate with previous data')
dumped = aggregate(CASES.DUMPED ~ SUPPLIER + SUPPLIER.NO, data=supplierItem, FUN=sum)
dumpedCost = aggregate(COST.DUMPED ~ SUPPLIER + SUPPLIER.NO, data=supplierItem, FUN=sum)
returned = aggregate(CASES.RETURNED ~ SUPPLIER + SUPPLIER.NO, data=supplierItem, FUN=sum)
returnedCost = aggregate(COST.RETURNED ~ SUPPLIER + SUPPLIER.NO, data=supplierItem, FUN=sum)
unsaleable = aggregate(CASES.UNSALEABLE ~ SUPPLIER + SUPPLIER.NO, data=supplierItem, FUN=sum)
unsaleableCost = aggregate(COST.UNSALEABLE ~ SUPPLIER + SUPPLIER.NO, data=supplierItem, FUN=sum)


print('Merge together dumped, returned & unsaleable by supplier & supplier number')
suppliers = merge(dumped, returned, by=c('SUPPLIER', 'SUPPLIER.NO'))
suppliers = merge(suppliers, unsaleable, by=c('SUPPLIER', 'SUPPLIER.NO'))
suppliers = merge(suppliers, dumpedCost, by=c('SUPPLIER', 'SUPPLIER.NO'))
suppliers = merge(suppliers, returnedCost, by=c('SUPPLIER', 'SUPPLIER.NO'))
suppliers = merge(suppliers, unsaleableCost, by=c('SUPPLIER', 'SUPPLIER.NO'))

suppliers = arrange(suppliers, desc(COST.UNSALEABLE))
headTail(suppliers)
##########


print('Gather case returns by customer number (X.MCUS)
      Read in customer names (value) and customer ID (key) 
      Merge to give them names')
customers = aggregate(CASES ~ X.MCUS., data=mtc, FUN=sum)
names(customers) = c('CUSTOMER.NO', 'CASES.RETURNED')

print('If need be, update active customer dive')
setwd("C:/Users/pmwash/Desktop/R_files/Data Input")
cust = read.csv('active_customers_dive.csv', header=TRUE)
names(cust) = c('CUSTOMER', 'CUSTOMER.NO')
customers = merge(cust, customers, by='CUSTOMER.NO', all.y=TRUE)
customers$CASES.RETURNED = customers$CASES.RETURNED*(-1)
customers = arrange(customers, desc(CASES.RETURNED))
head(customers, 100)


print('Generate time series of returns from MTC file')
monthReturns = aggregate(CASES ~ MONTH + X.MINP., data=mtc, FUN=sum)
names(monthReturns) = c('MONTH', 'ITEM.NO', 'CASES.RETURNED')
monthReturns$CASES.RETURNED = monthReturns$CASES.RETURNED*(-1)
headTail(monthReturns)

monthUnsaleable = aggregate(CASES.UNSALEABLE ~ MONTH + PSUPPL + X.SSUNM + X.RPRD. + X.RDESC + CLASS, data=rct, FUN=sum)
names(monthUnsaleable) = c('MONTH', 'SUPPLIER', 'SUPPLIER.NO', 'ITEM.NO', 'DESCRIPTION', 'CLASS', 'CASES.UNSALEABLE')
monthUnsaleable$CASES.UNSALEABLE = monthUnsaleable$CASES.UNSALEABLE*(-1)
headTail(monthUnsaleable)

monthly = merge(monthUnsaleable, monthReturns, by=c('ITEM.NO', 'MONTH'))
monthly$CASES.DUMPED = monthly$CASES.UNSALEABLE - monthly$CASES.RETURNED
monthly = arrange(monthly, desc(CASES.UNSALEABLE))
monthly = arrange(monthly, MONTH)
headTail(monthly)



print('#############')
print('Print results')
print('#############')



print('Write items and suppliers to Excel document; make sure to delete old ones first
      The formatting macro is on GitHub')
setwd("C:/Users/pmwash/Desktop/R_files/Data Output")
write.xlsx(supplierItem, file='returned_dumped_2015.xlsx', sheet='Item Summary')
write.xlsx(suppliers, file='returned_dumped_2015.xlsx', sheet='Supplier Summary', append=TRUE)
write.xlsx(customers, file='returned_dumped_2015.xlsx', sheet='Customer Returns Summary', append=TRUE)
write.xlsx(monthly, file='returned_dumped_2015.xlsx', sheet='Time Series', append=TRUE)



print('##############')
print('START GRAPHICS')
print('##############')




print('Create a plot of time series for worst 10 suppliers for unsaleables')
top10SupplierUnsaleables = head(suppliers, 10)$SUPPLIER
top10SupplierUnsaleables
top10Month = monthly[monthly$SUPPLIER.NO %in% c('ST. LOUIS BREWING 803933/803934',
                                            'THE WINE GROUP           802301',
                                            'FOUNDERS BREWING COMPANY 805204',
                                            'KOOCHENVAGNER\'S BREWING  803091',
                                            'OSKAR BLUES BREWERY      800054',
                                            'LEFT HAND BREWING COMPNY 805220',
                                            'ROGUE ALES AND SPIRITS   805244',
                                            'TWO BROTHERS BREWING CO  800038',
                                            'CONSTELLATION BRANDS     800606',
                                            'GREAT DIVIDE BREWING     802821'),]
top10Month$SUPPLIER.NO = factor(top10Month$SUPPLIER.NO, levels=c('ST. LOUIS BREWING 803933/803934',
                                                                 'THE WINE GROUP           802301',
                                                                 'FOUNDERS BREWING COMPANY 805204',
                                                                 'KOOCHENVAGNER\'S BREWING  803091',
                                                                 'OSKAR BLUES BREWERY      800054',
                                                                 'LEFT HAND BREWING COMPNY 805220',
                                                                 'ROGUE ALES AND SPIRITS   805244',
                                                                 'TWO BROTHERS BREWING CO  800038',
                                                                 'CONSTELLATION BRANDS     800606',
                                                                 'GREAT DIVIDE BREWING     802821'))

g = ggplot(data=top10Month, aes(x=MONTH, y=abs(CASES.UNSALEABLE)))
g + geom_bar(stat='sum', aes(group=MONTH, fill=SUPPLIER.NO)) +
  theme(legend.position='none') + facet_wrap(~SUPPLIER.NO, ncol=2, scales="free_y") +
  labs(title='Total Cases Unsaleable, Top 10 Suppliers In Order', x='Month', y='Total Cases Unsaleable')
























print('First gather customer/monthly data. Create a plot of time series for Customers.')
head(customers, 10)
custMonth = aggregate(CASES ~ X.MCUS. + MONTH, data=mtc, FUN=sum)
names(custMonth) = c('CUSTOMER.NO', 'MONTH', 'CASES.RETURNED')
custMonth = custMonth %>% filter(CUSTOMER.NO==11944 | CUSTOMER.NO==100487 |
                                   CUSTOMER.NO==11368 | CUSTOMER.NO==7456 |
                                   CUSTOMER.NO==1801 | CUSTOMER.NO==3009142 |
                                   CUSTOMER.NO==3009706 | CUSTOMER.NO==10382 |
                                   CUSTOMER.NO==12047 | CUSTOMER.NO==8571)#MAKE SURE THEY MATCH

setwd("C:/Users/pmwash/Desktop/R_files/Data Input")
cust = read.csv('active_customers_dive.csv', header=TRUE)
names(cust) = c('CUSTOMER', 'CUSTOMER.NO')
custMonth = merge(cust, custMonth, by='CUSTOMER.NO', all.y=TRUE)
custMonth = arrange(custMonth, MONTH, CASES.RETURNED)
head(custMonth)
custMonth$CUSTOMER = factor(custMonth$CUSTOMER, 
                            levels=c('FRIAR TUCK BEVERAGE O FALLON (11944)',
                                     'LUKAS LIQUOR SUPERSTORE (1004877)',
                                     ' FRIAR TUCK BEVERAGE CRESTWOOD (11368)',
                                     'LUKAS LIQUOR SUPERSTORE (7456)',
                                     'TOTAL WINE #1801 TWN & CNTRY (1801)',
                                     'CRAFT BEER CELLAR COLUMBIA (3009142)',
                                     'DIERBERGS #25 LAKEVIEW POINTE (3009706)',
                                     'RANDALLS WINE & SPIRITS (10382)',
                                     'MOLLYS 808 GEYER           OOB (12047)',
                                     'SHOP N SAVE #1834 HARVESTER (8571)'))



  headTail(custMonth)
  g = ggplot(data=custMonth, aes(x=MONTH, y=abs(CASES.RETURNED)))
  g + geom_bar(stat='sum', aes(group=MONTH, fill=CUSTOMER)) +
    theme(legend.position='none') + 
    facet_wrap(~CUSTOMER, ncol=2, scales='free') +
    labs(title='Total Returns, Top 10 Customers for Returns In Order', x='Month', y='Total Cases Unsaleable')

##
print('Look at case unsaleables.')
g = ggplot(data=mtc, aes(x=MONTH, y=abs(CASES)))
g + geom_jitter(aes(group=MONTH))


#################################################################################################

