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
countUnique <- function(x) {
  length(unique(x))
}


print('Returns & Spoilage: pwmtc1 & pwrct1 by house')
setwd("C:/Users/pmwash/Desktop/R_files/Data Input")

print('Be sure to re-run both queries. Gain access to query before replacing these file objects in memory')
timeFrame = 'Jan. 1 2015 to Dec. 31 2015'
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


# ############
# print('Investigate duplicates in raw files')
# length(mtc$X.MIVND)
# x = ifelse(duplicated(mtc[,c(1:6)])==TRUE, 1, 0)
# sum(x) #all clear
# ############


print('###################')
print('Start report below')
print('###################')

print('Gather data by supplier and item, also returning class and supplier number;
      RCT will be total unsaleables; aggregate by supplier')





###########DEBUG TOTALS BEGIN
print('Strategy: purposefully introduce duplicates only to filter out later; Aggregate by item number')
avg_cases_unsale = aggregate(CASES.UNSALEABLE ~ X.RPRD., data=rct, FUN=function(x) round(mean(x),2))
names(avg_cases_unsale) = c('ITEM.NO', 'AVG.CASES.UNSALEABLE')

tot_cases_unsale = aggregate(CASES.UNSALEABLE ~ X.RPRD., data=rct, FUN=function(x) round(sum(x),2))
names(tot_cases_unsale) = c('ITEM.NO', 'CASES.UNSALEABLE')

print('Merge 1: Use all.y=TRUE to preserve sums with minimal cost to means')
cases_unsale = merge(avg_cases_unsale, tot_cases_unsale, by='ITEM.NO', all=TRUE) #all.y=TRUE


get_other_columns = aggregate(CASES.UNSALEABLE ~ PSUPPL + X.SSUNM + X.RPRD. + X.RDESC + CLASS, data=rct, FUN=length)
names(get_other_columns) = c('SUPPLIER.NO', 'SUPPLIER', 'ITEM.NO', 'DESCRIPTION', 'CLASS', 'NUMBER.INCIDENTS')

print('Merge 2')
cases_unsale = merge(get_other_columns, cases_unsale, by='ITEM.NO', all=TRUE) #all.y=TRUE
cases_unsale = cases_unsale %>% arrange(ITEM.NO)


print('MTC will be total returns; aggregate by product number')
item_returns = aggregate(CASES ~ X.MINP., data=mtc, FUN=sum)
names(item_returns) = c('ITEM.NO', 'CASES.RETURNED')

print('Merge 3')
cases_unsale_returns = merge(cases_unsale, item_returns, by='ITEM.NO', all=TRUE)



print('Sanity check: The numbers should not match yet')
head(cases_unsale_returns, 20)
x = sum(cases_unsale_returns$CASES.RETURNED, na.rm=T)
y = sum(cases_unsale_returns$CASES.UNSALEABLE, na.rm=T)
paste('Do these match the originals?', 
      'Returned & Total Unsaleable:  ', 
      x,'       ', y)



cost_returns = aggregate(X.MCOS. ~ X.MINP., data=mtc, FUN=sum)
names(cost_returns) = c('ITEM.NO', 'COST.RETURNED')

print('Merge 4')
accumulator = merge(cases_unsale_returns, cost_returns, by='ITEM.NO', all=TRUE)
duplicated(accumulator$ITEM.NO)
accumulator = accumulator[!duplicated(accumulator$ITEM.NO),]



print('Sanity check: Do the numbers match the originals after removing duplicates?')
head(accumulator, 20)
x = sum(accumulator$CASES.RETURNED, na.rm=T)
y = sum(accumulator$CASES.UNSALEABLE, na.rm=T)
paste('Do these match the originals?', 
      'Returned & Total Unsaleable:           ', 
      x,'       ', y)



cost_unsale = aggregate(EXT.COST ~ X.RPRD., data=rct, FUN=function(x) round(sum(x), 2))
names(cost_unsale) = c('ITEM.NO', 'COST.UNSALEABLE')
cost_unsale = cost_unsale %>% arrange(COST.UNSALEABLE)

print('Merge 5')
accumulator = merge(accumulator, cost_unsale, by='ITEM.NO', all=TRUE)



print('Sanity check: Do the numbers match the originals after removing duplicates?')
head(accumulator, 20)
x = sum(accumulator$CASES.RETURNED, na.rm=T)
y = sum(accumulator$CASES.UNSALEABLE, na.rm=T)
paste('Do these match the originals?', 
      'Returned & Total Unsaleable:           ', 
      x,'       ', y)







print('Manipulate data now that it is safely in one place')
accumulator$COST.RETURNED =  accumulator$COST.RETURNED*(-1)
accumulator$COST.UNSALEABLE = accumulator$COST.UNSALEABLE*(-1)
accumulator$CASES.UNSALEABLE = accumulator$CASES.UNSALEABLE*(-1)
accumulator$CASES.RETURNED = accumulator$CASES.RETURNED*(-1)
accumulator$AVG.CASES.UNSALEABLE = accumulator$AVG.CASES.UNSALEABLE*(-1)

headTail(accumulator) #ensure all are positive

accumulator$COST.DUMPED = accumulator$COST.UNSALEABLE - accumulator$COST.RETURNED
accumulator$CASES.DUMPED = accumulator$CASES.UNSALEABLE - accumulator$CASES.RETURNED
accumulator = accumulator %>% arrange(desc(COST.UNSALEABLE))
accumulator = accumulator[,c('ITEM.NO', 'DESCRIPTION', 'CLASS', 'SUPPLIER.NO', 'SUPPLIER',
                             'CASES.UNSALEABLE', 'CASES.RETURNED', 'CASES.DUMPED',
                             'COST.UNSALEABLE', 'COST.RETURNED', 'COST.DUMPED',
                             'AVG.CASES.UNSALEABLE', 'NUMBER.INCIDENTS')]

headTail(accumulator)
one = sum(accumulator$CASES.RETURNED,na.rm=T)
two = sum(accumulator$COST.RETURNED,na.rm=T)
three = sum(accumulator$CASES.UNSALEABLE,na.rm=T)
four = sum(accumulator$COST.UNSALEABLE,na.rm=T)
paste('Cases returned:       ', one, 
      '                   ',
      'Cost returned:        ', two,
      '                   ',
      'Cases unsaleable:     ', three,
      '                   ',
      'Cost unsaleable:      ', four)









print('Segregate by Supplier')
supplier_dump = aggregate(CASES.DUMPED ~ SUPPLIER + SUPPLIER.NO, data=accumulator, FUN=function(x) round(sum(x),2))
supplier_dump_cost = aggregate(COST.DUMPED ~ SUPPLIER + SUPPLIER.NO, data=accumulator, FUN=function(x) round(sum(x),2))
supplier_return = aggregate(CASES.RETURNED ~ SUPPLIER + SUPPLIER.NO, data=accumulator, FUN=function(x) round(sum(x),2))
supplier_return_cost = aggregate(COST.RETURNED ~ SUPPLIER + SUPPLIER.NO, data=accumulator, FUN=function(x) round(sum(x),2))
supplier_unsale = aggregate(CASES.UNSALEABLE ~ SUPPLIER + SUPPLIER.NO, data=accumulator, FUN=function(x) round(sum(x),2))
supplier_unsale_cost = aggregate(COST.UNSALEABLE ~ SUPPLIER + SUPPLIER.NO, data=accumulator, FUN=function(x) round(sum(x),2))


print('Merge by Supplier; preserve records with all=TRUE argument on Merge')
supplier_accumulator = merge(supplier_dump, supplier_dump_cost, by=c('SUPPLIER', 'SUPPLIER.NO'), all=TRUE)
supplier_accumulator = merge(supplier_accumulator, supplier_return, by=c('SUPPLIER', 'SUPPLIER.NO'), all=TRUE)
supplier_accumulator = merge(supplier_accumulator, supplier_return_cost, by=c('SUPPLIER', 'SUPPLIER.NO'), all=TRUE)
supplier_accumulator = merge(supplier_accumulator, supplier_unsale, by=c('SUPPLIER', 'SUPPLIER.NO'), all=TRUE)
supplier_accumulator = merge(supplier_accumulator, supplier_unsale_cost, by=c('SUPPLIER', 'SUPPLIER.NO'), all=TRUE)

supplier_accumulator = arrange(supplier_accumulator, desc(COST.UNSALEABLE))



print('Check totals still match')
headTail(supplier_accumulator)
one = sum(supplier_accumulator$CASES.RETURNED,na.rm=T)
two = sum(supplier_accumulator$COST.RETURNED,na.rm=T)
three = sum(supplier_accumulator$CASES.UNSALEABLE,na.rm=T)
four = sum(supplier_accumulator$COST.UNSALEABLE,na.rm=T)
paste('Cases returned:       ', one, 
      '                   ',
      'Cost returned:        ', two,
      '                   ',
      'Cases unsaleable:     ', three,
      '                   ',
      'Cost unsaleable:      ', four)







print('Customer names come from Diver; aggregate returns by customer')
cust = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/active_customers_dive.csv', header=TRUE)
names(cust) = c('CUSTOMER', 'CUSTOMER.NO')

print('Aggregate cases and costs returned by customer')
customers = aggregate(CASES ~ X.MCUS., data=mtc, FUN=sum)
names(customers) = c('CUSTOMER.NO', 'CASES.RETURNED')

costCust = aggregate(X.MCOS. ~ X.MCUS., data=mtc, FUN=sum)
names(costCust) = c('CUSTOMER.NO', 'COST.RETURNED')

print('Merge 1: Merge customer names from Diver with customer return data; use all.y=TRUE to get all data for returns')
customers = merge(cust, customers, by='CUSTOMER.NO', all.y=TRUE)

print('Merge 2: Add cost returned')
customers = merge(customers, costCust, by='CUSTOMER.NO', all=TRUE)

print('Maniuplate data')
customers$CASES.RETURNED = customers$CASES.RETURNED*(-1)
customers$COST.RETURNED = customers$COST.RETURNED*(-1)

customers = arrange(customers, desc(COST.RETURNED))



print('Sanity check')
headTail(customers)
one = sum(customers$CASES.RETURNED)
two = sum(customers$COST.RETURNED)
paste('Cases returned:       ', one, 
      '                   ',
      'Cost returned:        ', two)






print('Break out time series for Jill/Mitch')
monthly_returns = aggregate(CASES ~ MONTH + X.MINP., data=mtc, FUN=function(x) round(sum(x), 2))
names(monthly_returns) = c('MONTH', 'ITEM.NO', 'CASES.RETURNED')
monthly_returns$CASES.RETURNED = monthly_returns$CASES.RETURNED*(-1)

gather_columns = aggregate(CASES.UNSALEABLE ~ MONTH + PSUPPL + X.SSUNM + X.RPRD. + X.RDESC + CLASS, data=rct, FUN=length)
names(gather_columns) = c('MONTH', 'SUPPLIER', 'SUPPLIER.NO', 'ITEM.NO', 'DESCRIPTION', 'CLASS', 'NUMBER.INCIDENTS')

print('Merge 1')
monthly_accumulator = merge(gather_columns, monthly_returns, by=c('ITEM.NO', 'MONTH'), all.y=TRUE)
names(monthly_accumulator) = c('ITEM.NO', 'MONTH', 'SUPPLIER.NO', 'SUPPLIER', 
                              'DESCRIPTION', 'CLASS', 'NUMBER.INCIDENTS', 'CASES.RETURNED')



monthly_unsaleable = aggregate(CASES.UNSALEABLE ~ MONTH + X.RPRD., data=rct, FUN=function(x) round(sum(x), 2))
names(monthly_unsaleable) = c('MONTH', 'ITEM.NO', 'CASES.UNSALEABLE')
monthly_unsaleable$CASES.UNSALEABLE = monthly_unsaleable$CASES.UNSALEABLE*(-1)
headTail(monthly_unsaleable)

print('Merge 2')
monthly_accumulator = merge(monthly_accumulator, monthly_unsaleable, by=c('ITEM.NO', 'MONTH'), all=TRUE)
monthly_accumulator$CASES.DUMPED = monthly_accumulator$CASES.UNSALEABLE - monthly_accumulator$CASES.RETURNED




print('Sanity check')
headTail(monthly_accumulator)
one = sum(monthly_accumulator$CASES.RETURNED, na.rm=T)
two = sum(monthly_accumulator$CASES.UNSALEABLE, na.rm=T)
paste('Cases returned:       ', one, 
      '                   ',
      'Cost unsaleable:        ', two)










print('#############')
print('Print results')
print('#############')









print('Write items and suppliers to Excel document; make sure to delete old ones first
      The formatting macro is on GitHub')
setwd("C:/Users/pmwash/Desktop/R_files/Data Output")
file_name = 'returned_dumped_2015_all_Missouri.xlsx'
write.xlsx(accumulator, file=file_name, sheet='Item Summary')
write.xlsx(supplier_accumulator, file=file_name, sheet='Supplier Summary', append=TRUE)
write.xlsx(customers, file=file_name, sheet='Customer Returns Summary', append=TRUE)
write.xlsx(monthly_accumulator, file=file_name, sheet='Time Series', append=TRUE)



print('STOP and run the VBA code to format the report for distribution. Make sure file output name matches the final branch of the file paths below')


print('Below is for KC moving files')
from = paste0("C:/Users/pmwash/Desktop/R_Files/Data Output/", file_name, sep='')
to = paste0('M:/Operations Intelligence/Monthly Reports/Unsaleables/', file_name, sep='')
moveRenameFile(from, to)


print('Below is for STL moving files')
from = paste0("C:/Users/pmwash/Desktop/R_Files/Data Output/", file_name, sep='')
to = paste0("//majorbrands.com/STLcommon/Operations Intelligence/Monthly Reports/Unsaleables/", file_name, sep='')
moveRenameFile(from, to)

















# 
# print('Drop cases unsaleable and merge back in; it is the only one still off')
# accumulator = accumulator[,-c(8)]
# check = merge(accumulator, cases_unsale, by='ITEM.NO', all.x=TRUE)

# supplierItem = supplierItem[!duplicated(supplierItem$ITEM.NO, supplierItem$SUPPLIER.NO),]
# 
# print('Aggregate X.MCOS. by item number from MTC to obtain cost returned')
# supplierItemCost = aggregate(X.MCOS. ~ X.MINP., data=mtc, FUN=sum)
# names(supplierItemCost) = c('ITEM.NO', 'COST.RETURNED')
# 

##########
# possibly delete or bring back
# supplierItem = aggregate(CASES.UNSALEABLE ~ PSUPPL + X.SSUNM + X.RPRD. + X.RDESC + CLASS, data=rct, FUN=length)#total unsaleables
# names(supplierItem) = c('SUPPLIER', 'SUPPLIER.NO', 'ITEM.NO', 'DESCRIPTION', 'CLASS', 'CASES.UNSALEABLE')
# supplierItem = supplierItem %>% arrange(ITEM.NO)

# ############ 
# print("check koochenvagner for cases unsaleable")
# koochen = filter(supplierItem, SUPPLIER==309)
# sum(koochen$CASES.UNSALEABLE)#matches Kathie's
# rm(koochen)
# ############
##############
# print('MTC will be total returns; aggregate by product number')
# itemReturns = aggregate(CASES ~ X.MINP., data=mtc, FUN=sum)
# names(itemReturns) = c('ITEM.NO', 'CASES.RETURNED')
# 
# print('Aggregate X.MCOS. by item number from MTC to obtain cost returned')
# supplierItemCost = aggregate(X.MCOS. ~ X.MINP., data=mtc, FUN=sum)
# names(supplierItemCost) = c('ITEM.NO', 'COST.RETURNED')#verify

# supplierItemUnsaleableCost = aggregate(EXT.COST ~ PSUPPL + X.SSUNM + X.RPRD. + X.RDESC + CLASS, data=rct, FUN=sum)
# names(supplierItemUnsaleableCost) = c('SUPPLIER', 'SUPPLIER.NO', 'ITEM.NO', 'DESCRIPTION', 'CLASS', 'COST.UNSALEABLE')
# supplierItemUnsaleableCost = supplierItemUnsaleableCost %>% arrange(COST.UNSALEABLE)
# 
# # ############ 
# # print("check koochenvagner for ext cost")
# # koochen = filter(supplierItemUnsaleableCost, SUPPLIER==309)
# # sum(koochen$COST.UNSALEABLE)#matches Kathie's
# # rm(koochen)
# print('check sum of returned')
# before = sum(itemReturns$CASES.RETURNED, na.rm=T) #matches expected
# before2 = sum(mtc$CASES, na.rm=T)
# before3 = sum(supplierItem$CASES.UNSALEABLE)
# # ############ 
# 
# print('Merge the two above files to get unsaleable by supplier and item;
#       This is where we subtract returns (MTC) from total unsaleables (RCT)')
# supplierItem = merge(supplierItem, itemReturns, by='ITEM.NO', all=TRUE)
# 
# duplicated(supplierItem$ITEM.NO)
# 
# 
# supplierItem = supplierItem[!duplicated(supplierItem$ITEM.NO, supplierItem$SUPPLIER.NO),]
# after = sum(supplierItem$CASES.RETURNED, na.rm=T)
# paste('Passes first test for total cases returned: ', before == after)
# paste('Passes second test: ', after == before2)
# 
# ###########
# print('Debug find out why after the merge CASES.RETURNED goes up')
# after = sum(supplierItem$CASES.RETURNED, na.rm=T)
# paste0('Before there were ', before, ' and from mtc1 it was ', before2, ' cases returned now there are ', after)
# after = after*-1
# before = before *-1
# after-before
# check = supplierItem %>% filter(abs(CASES.RETURNED) < 400 & abs(CASES.RETURNED) > 100) %>% arrange(CASES.RETURNED)
# check
# rm(check, before, after, before2)
# itemsOnly = arrange(itemReturns, CASES.RETURNED)
# itemsOnly = itemsOnly$CASES.RETURNED
# itemsSupp = arrange(supplierItem, CASES.RETURNED)
# itemsSupp = itemsSupp$CASES.RETURNED
# itemsSupp == itemsOnly
# 
# check = merge(itemReturns, supplierItem, by='ITEM.NO')
# headTail(check)
# sum(check$CASES.RETURNED.y)
# sum(check$CASES.RETURNED.x)
# 
# check = merge(supplierItem, itemReturns, by='ITEM.NO', all.y=TRUE)
# sum(check$CASES.RETURNED, na.rm=T)
# headTail(check)
# ####BUG FIXED with respect to returns; now it is decrementing total cases unsaleable 
# print('DUPLICATES MADE IT INTO THE DATASET BECAUSE DESCRIPTIONS WERE DIFFERENT BETWEEN EQUAL ITEM NUMBERS')
# duplicated_items = supplierItem[duplicated(supplierItem$ITEM.NO),]
# sum(supplierItem$CASES.RETURNED, na.rm=T)
# sum(duplicated_items$CASES.RETURNED, na.rm=T)
# duplicated_items = arrange(duplicated_items, ITEM.NO)
# head(duplicated_items, 20)
# ###########
# 
# 
# supplierItem$CASES.RETURNED = ifelse(is.na(returned), 0, returned)
# 
# # ############ 
# # print("check koochenvagner for ext cost")
# # koochen = filter(supplierItem, SUPPLIER==309)
# # head(koochen)
# # sum(koochen$CASES.UNSALEABLE)#matches Kathie's
# # sum(koochen$CASES.RETURNED)#matches Kathie's
# # rm(koochen)
# # ############ 
# 
# supplierItem = merge(supplierItem, supplierItemCost, by='ITEM.NO', all=TRUE)
# 
# # ############ 
# # print("check koochenvagner for ext cost")
# # check = merge(supplierItem, supplierItemCost, by='ITEM.NO', all=TRUE)
# # koochen = filter(check, SUPPLIER==309)
# # sum(koochen$CASES.UNSALEABLE)#matches Kathie's
# # sum(koochen$CASES.RETURNED)
# # rm(koochen)
# # ############ 
# 
# supplierItem = merge(supplierItem, supplierItemUnsaleableCost, by=c('SUPPLIER', 'SUPPLIER.NO', 'ITEM.NO', 'DESCRIPTION', 'CLASS'), all=TRUE)
# costReturned = supplierItem$COST.RETURNED
# supplierItem$COST.RETURNED = ifelse(is.na(costReturned), 0, costReturned)
# 
# # ############ 
# # print("check koochenvagner for ext cost")
# # check = merge(supplierItem, supplierItemUnsaleableCost, by=c('SUPPLIER', 'SUPPLIER.NO', 'ITEM.NO', 'DESCRIPTION', 'CLASS'), all=TRUE)
# # koochen = filter(check, SUPPLIER==309)
# # sum(koochen$CASES.UNSALEABLE)#matches Kathie's
# # sum(koochen$CASES.RETURNED)
# # rm(koochen)
# # ############ 
# 
# names(supplierItem) = c('SUPPLIER.NO', 'SUPPLIER', 'ITEM.NO', 'DESCRIPTION',
#                         'CLASS', 'CASES.UNSALEABLE', 'CASES.RETURNED', 'COST.RETURNED',
#                         'COST.UNSALEABLE')
# supplierItem = supplierItem %>% arrange(COST.UNSALEABLE)
# head(supplierItem, 100)
# ############ 
# print("check koochenvagner for ext cost")
# koochen = filter(supplierItem, SUPPLIER.NO==309)
# sum(koochen$COST.UNSALEABLE)#matches Kathie's
# sum(koochen$CASES.UNSALEABLE)#matches Kathie's
# sum(koochen$COST.RETURNED)
# sum(koochen$CASES.RETURNED)
# rm(koochen)
# ############
# # supplierItem$COST.RETURNED =  supplierItem$COST.RETURNED*(-1)
# # supplierItem$COST.UNSALEABLE = supplierItem$COST.UNSALEABLE*(-1)
# # supplierItem$CASES.UNSALEABLE = supplierItem$CASES.UNSALEABLE*(-1)
# # supplierItem$CASES.RETURNED = supplierItem$CASES.RETURNED*(-1)
# # headTail(supplierItem)
# # 
# # supplierItem$COST.DUMPED = supplierItem$COST.UNSALEABLE - supplierItem$COST.RETURNED
# # supplierItem$CASES.DUMPED = supplierItem$CASES.UNSALEABLE - supplierItem$CASES.RETURNED
# # supplierItem = supplierItem %>% arrange(desc(COST.UNSALEABLE))
# # supplierItem = supplierItem[,c('ITEM.NO', 'DESCRIPTION', 'SUPPLIER.NO', 'SUPPLIER', 'CLASS',
# #                                'CASES.UNSALEABLE', 'CASES.RETURNED', 'CASES.DUMPED',
# #                                'COST.UNSALEABLE', 'COST.RETURNED', 'COST.DUMPED')]
# 
# # ######### 
# # print('Check for duplicates in supplierItem table')
# # original = (sum(mtc$CASES))*-1
# # before = sum(supplierItem$CASES.RETURNED)
# # check = supplierItem[!duplicated(supplierItem[,c(1:11)]),]
# # after = sum(check$CASES.RETURNED, na.rm=T)
# # paste('Originally supplierItem had', before, 'cases returned. After the duplicate removal there was', after, 
# #       'cases returned. Move forward =', before == after)
# # paste('Originally there were', original, 'cases returned from the pwmtc1 query (raw)')
# # #########
# 
# # #########
# # schlafly = filter(supplierItem, SUPPLIER.NO==218)
# # sum(schlafly$COST.UNSALEABLE)
# # sum(schlafly$CASES.UNSALEABLE)
# # 
# # koochen = filter(supplierItem, SUPPLIER.NO==309)
# # sum(koochen$COST.UNSALEABLE)
# # sum(koochen$CASES.UNSALEABLE)
# # ############

# print('Gather by supplier only;
#       Independently gather dumped, returned and unsaleable & validate with previous data')
# dumped = aggregate(CASES.DUMPED ~ SUPPLIER + SUPPLIER.NO, data=supplierItem, FUN=sum)
# dumpedCost = aggregate(COST.DUMPED ~ SUPPLIER + SUPPLIER.NO, data=supplierItem, FUN=sum)
# returned = aggregate(CASES.RETURNED ~ SUPPLIER + SUPPLIER.NO, data=supplierItem, FUN=sum)
# returnedCost = aggregate(COST.RETURNED ~ SUPPLIER + SUPPLIER.NO, data=supplierItem, FUN=sum)
# unsaleable = aggregate(CASES.UNSALEABLE ~ SUPPLIER + SUPPLIER.NO, data=supplierItem, FUN=sum)
# unsaleableCost = aggregate(COST.UNSALEABLE ~ SUPPLIER + SUPPLIER.NO, data=supplierItem, FUN=sum)
# 
# 
# print('Merge together dumped, returned & unsaleable by supplier & supplier number')
# suppliers = merge(dumped, returned, by=c('SUPPLIER', 'SUPPLIER.NO'))
# suppliers = merge(suppliers, unsaleable, by=c('SUPPLIER', 'SUPPLIER.NO'))
# suppliers = merge(suppliers, dumpedCost, by=c('SUPPLIER', 'SUPPLIER.NO'))
# suppliers = merge(suppliers, returnedCost, by=c('SUPPLIER', 'SUPPLIER.NO'))
# suppliers = merge(suppliers, unsaleableCost, by=c('SUPPLIER', 'SUPPLIER.NO'))
# 
# suppliers = arrange(suppliers, desc(COST.UNSALEABLE))
# headTail(suppliers)
# print('Check totals still match')
# sum(suppliers$CASES.RETURNED)
# 
# 
# print('Gather case returns by customer number (X.MCUS)
#       Read in customer names (value) and customer ID (key) 
#       Merge to give them names')
# customers = aggregate(CASES ~ X.MCUS., data=mtc, FUN=sum)
# names(customers) = c('CUSTOMER.NO', 'CASES.RETURNED')
# 
# print('If need be, update active customer dive')
# setwd("C:/Users/pmwash/Desktop/R_files/Data Input")
# cust = read.csv('active_customers_dive.csv', header=TRUE)
# names(cust) = c('CUSTOMER', 'CUSTOMER.NO')
# customers = merge(cust, customers, by='CUSTOMER.NO', all.y=TRUE)
# customers$CASES.RETURNED = customers$CASES.RETURNED*(-1)
# customers = arrange(customers, desc(CASES.RETURNED))
# head(customers, 20)
# sum(customers$CASES.RETURNED)
# 
# print('Check that count of unique ecustomeres is the same')
# custFile = unique(cust$CUSTOMER.NO)
# custMtc = unique(mtc$X.MCUS.)
# intersection = countUnique(intersect(custFile, custMtc))
# custFile = countUnique(cust$CUSTOMER.NO)
# custMtc = countUnique(mtc$X.MCUS.)
# paste('Out of', custFile, 'unique customers represented in the customer file', intersection, 
#       'customers were in both files, MTC1 and the customer file for the time period', timeFrame, 
#       '. Should you update the customer file?')
# 
# print('Generate time series of returns from MTC file')
# monthReturns = aggregate(CASES ~ MONTH + X.MINP., data=mtc, FUN=sum)
# names(monthReturns) = c('MONTH', 'ITEM.NO', 'CASES.RETURNED')
# monthReturns$CASES.RETURNED = monthReturns$CASES.RETURNED*(-1)
# headTail(monthReturns)
# 
# monthUnsaleable = aggregate(CASES.UNSALEABLE ~ MONTH + PSUPPL + X.SSUNM + X.RPRD. + X.RDESC + CLASS, data=rct, FUN=sum)
# names(monthUnsaleable) = c('MONTH', 'SUPPLIER', 'SUPPLIER.NO', 'ITEM.NO', 'DESCRIPTION', 'CLASS', 'CASES.UNSALEABLE')
# monthUnsaleable$CASES.UNSALEABLE = monthUnsaleable$CASES.UNSALEABLE*(-1)
# headTail(monthUnsaleable)
# 
# monthly = merge(monthUnsaleable, monthReturns, by=c('ITEM.NO', 'MONTH'))
# monthly$CASES.DUMPED = monthly$CASES.UNSALEABLE - monthly$CASES.RETURNED
# monthly = arrange(monthly, desc(CASES.UNSALEABLE))
# monthly = arrange(monthly, MONTH)
# headTail(monthly)
# 
# 
# ##########################
# print('#############')
# print('Print results')
# print('#############')
# 
# 
# 
# print('Write items and suppliers to Excel document; make sure to delete old ones first
#       The formatting macro is on GitHub')
# setwd("C:/Users/pmwash/Desktop/R_files/Data Output")
# file_name = 'returned_dumped_2015_all_Missouri.xlsx'
# write.xlsx(supplierItem, file=file_name, sheet='Item Summary')
# write.xlsx(suppliers, file=file_name, sheet='Supplier Summary', append=TRUE)
# write.xlsx(customers, file=file_name, sheet='Customer Returns Summary', append=TRUE)
# write.xlsx(monthly, file=file_name, sheet='Time Series', append=TRUE)
# 
# 
# 
# print('STOP and run the VBA code to format the report for distribution. Make sure file output name matches the final branch of the file paths below')
# 
# 
# print('Below is for KC moving files')
# from = paste0("C:/Users/pmwash/Desktop/R_Files/Data Output/", file_name, sep='')
# to = paste0('M:/Operations Intelligence/Monthly Reports/Unsaleables/', file_name, sep='')
# moveRenameFile(from, to)
# 
# 
# print('Below is for STL moving files')
# from = paste0("C:/Users/pmwash/Desktop/R_Files/Data Output/", file_name, sep='')
# to = paste0("//majorbrands.com/STLcommon/Operations Intelligence/Monthly Reports/Unsaleables/", file_name, sep='')
# moveRenameFile(from, to)















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















