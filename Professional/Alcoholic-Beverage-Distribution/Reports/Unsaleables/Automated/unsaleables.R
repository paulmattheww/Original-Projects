print('Load the necessary libraries.')
library(dplyr)
library(xlsx)
library(lubridate)
library(ggplot2)


print('Define functions necessary for analysis.')
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')
#cat('C:\Users\pmwash\Desktop\R_files\Data Input\Input Files for Reports\Unsaleables')


print('Returns & Spoilage: pwunsale & pwrct1 by house')

print('Be sure to re-run both queries. Gain access to query before replacing these file objects in memory')
timeFrame = 'Jan. 1 2015 to Dec. 31 2015'
rct = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/Input Files for Reports/Unsaleables/pwrct1.csv', header=TRUE, na.strings=NA)
mtc = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/Input Files for Reports/Unsaleables/pwunsale.csv', header=TRUE, na.strings=NA) # pwreturns new     #replaces mtc1 same query
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


later1 = paste0('MTC sum of CASES.RETURNED = ', sum(mtc$CASES, na.rm=T))
later2 = paste0('RCT sum of EXT.COST (unsaleables) = ', sum(round(rct$EXT.COST, 2), na.rm=T))
later3 = paste0('RCT sum of CASES.UNSALEABLE = ', sum(rct$CASES.UNSALEABLE, na.rm=T))

later1; later2; later3

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



print('CHECKPOINT 1 - Sanity check: The numbers should not match yet')
head(cases_unsale_returns, 20)
x = sum(cases_unsale_returns$CASES.RETURNED, na.rm=T)
y = sum(cases_unsale_returns$CASES.UNSALEABLE, na.rm=T)
paste('Do these match the originals?', 
      'Returned & Total Unsaleable:  ', 
      x,'       ', y)
later1; later2; later3


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
later1; later2; later3


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
later1; later2; later3






print('Manipulate data now that it is safely in one place')
accumulator$COST.RETURNED =  accumulator$COST.RETURNED*(-1)
accumulator$COST.UNSALEABLE = accumulator$COST.UNSALEABLE*(-1)
accumulator$CASES.UNSALEABLE = accumulator$CASES.UNSALEABLE*(-1)
accumulator$CASES.RETURNED = accumulator$CASES.RETURNED*(-1)
accumulator$AVG.CASES.UNSALEABLE = accumulator$AVG.CASES.UNSALEABLE*(-1)

headTail(accumulator) #ensure all are positive

accumulator$COST.DUMPED = accumulator$COST.UNSALEABLE - ifelse(is.na(accumulator$COST.RETURNED), 
                                                               0, accumulator$COST.RETURNED)
# x_check = accumulator$COST.UNSALEABLE - accumulator$COST.RETURNED
# sum(x_check, na.rm=T)
# sum(accumulator$COST.DUMPED)

accumulator$CASES.DUMPED = accumulator$CASES.UNSALEABLE - ifelse(is.na(accumulator$CASES.RETURNED),
                                                                 0, accumulator$CASES.RETURNED)
# x_check = accumulator$CASES.UNSALEABLE - accumulator$CASES.RETURNED
# sum(x_check, na.rm=T)
# sum(accumulator$CASES.DUMPED)


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
later1; later2; later3








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
later1; later2; later3






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
later1





# print('Break out time series for Jill/Mitch')
# monthly_returns = aggregate(CASES ~ MONTH + X.MINP., data=mtc, FUN=function(x) round(sum(x), 2))
# names(monthly_returns) = c('MONTH', 'ITEM.NO', 'CASES.RETURNED')
# monthly_returns$CASES.RETURNED = monthly_returns$CASES.RETURNED*(-1)
# 
# gather_columns = aggregate(CASES.UNSALEABLE ~ MONTH + PSUPPL + X.SSUNM + X.RPRD. + X.RDESC + CLASS, data=rct, FUN=length)
# names(gather_columns) = c('MONTH', 'SUPPLIER', 'SUPPLIER.NO', 'ITEM.NO', 'DESCRIPTION', 'CLASS', 'NUMBER.INCIDENTS')
# 
# print('Merge 1')
# monthly_accumulator = merge(gather_columns, monthly_returns, by=c('ITEM.NO', 'MONTH'), all.y=TRUE)
# names(monthly_accumulator) = c('ITEM.NO', 'MONTH', 'SUPPLIER.NO', 'SUPPLIER', 
#                               'DESCRIPTION', 'CLASS', 'NUMBER.INCIDENTS', 'CASES.RETURNED')
# 
# 
# 
# monthly_unsaleable = aggregate(CASES.UNSALEABLE ~ MONTH + X.RPRD., data=rct, FUN=function(x) round(sum(x), 2))
# names(monthly_unsaleable) = c('MONTH', 'ITEM.NO', 'CASES.UNSALEABLE')
# 
# monthly_unsaleable$CASES.UNSALEABLE = monthly_unsaleable$CASES.UNSALEABLE*(-1)
# monthly_accumulator$CASES.UNSALEABLE = -1 * monthly_accumulator$CASES.UNSALEABLE
# monthly_accumulator$CASES.DUMPED = -1 * monthly_accumulator$CASES.DUMPED
# 
# headTail(monthly_unsaleable)
# headTail(monthly_accumulator)
# 
# print('Merge 2')
# monthly_accumulator = merge(monthly_accumulator, monthly_unsaleable, by=c('ITEM.NO', 'MONTH'), all=TRUE)
# monthly_accumulator$CASES.DUMPED = monthly_accumulator$CASES.UNSALEABLE - 
#   ifelse(is.na(monthly_accumulator$CASES.RETURNED), 0, monthly_accumulator$CASES.RETURNED)
# 
# monthly_accumulator = monthly_accumulator %>% arrange(MONTH, CASES.UNSALEABLE)
# 
# headTail(monthly_accumulator, 50)


# 
# print('Sanity check')
# headTail(monthly_accumulator)
# one = sum(monthly_accumulator$CASES.RETURNED, na.rm=T)
# two = sum(monthly_accumulator$CASES.UNSALEABLE, na.rm=T)
# paste('Cases returned:       ', one, 
#       '                   ',
#       'Cost unsaleable:        ', two)
# 
# later1; later2; later3
# 



directors = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/supplier_director_lookup_table_as_of_02102016.csv')
directors = directors[, c(2:3)]
names(directors) = c('SUPPLIER.NO', 'DIRECTOR')


# a = accumulator
# accumulator = merge(a, directors, by='SUPPLIER.NO')
# sum(accumulator$CASES.UNSALEABLE)
# aggregate(COST.UNSALEABLE~DIRECTOR, data=accumulator, FUN=sum)

accumulator = merge(accumulator, directors, by='SUPPLIER.NO', all_x=TRUE)
 
# dir_check = accumulator %>% filter(DIRECTOR=='STL SITES, JILL') %>%
#   select(one_of('ITEM.NO', 'DESCRIPTION', 'SUPPLIER', 'COST.UNSALEABLE', 'COST.RETURNED', 'COST.DUMPED'))


supplier_accumulator = merge(supplier_accumulator, directors, by='SUPPLIER.NO', all_x=TRUE)

# 
# monthly_accumulator = merge(monthly_accumulator, directors, by='SUPPLIER.NO', all_x=TRUE)
# headTail(monthly_accumulator, 50)
# 




print('#############')
print('Print results')
print('#############')



accumulator = arrange(accumulator, desc(COST.UNSALEABLE))
supplier_accumulator = arrange(supplier_accumulator, desc(COST.UNSALEABLE))
customers = arrange(customers, desc(COST.RETURNED))


#head(customers)


print('Write items and suppliers to Excel document; make sure to delete old ones first
      The formatting macro is on GitHub')
library(lubridate)
mon = month(Sys.Date(), TRUE, FALSE)
yr = year(Sys.Date())
day = day(Sys.Date())

#setwd("C:/Users/pmwash/Desktop/R_files/Data Output")
file_name = paste0(mon, '_', day, '_', yr, '_unsaleables_returns_dumps.xlsx')
file_path = paste0('N:/Operations Intelligence/Monthly Reports/Unsaleables/Data/', file_name)

write.xlsx(accumulator, file=file_path, sheet='Item Summary')
write.xlsx(supplier_accumulator, file=file_path, sheet='Supplier Summary', append=TRUE)
# write.xlsx(customers, file=file_path, sheet='Customer Returns Summary', append=TRUE)
# write.xlsx(directors, file=file_path, sheet='Director Lookup Table', append=TRUE)
# write.xlsx(monthly_accumulator, file=file_path, sheet='Time Series', append=TRUE)
print('MTD UNSALEABLE REPORT COMPLETE -- RUNNING VBA CODE')

# KC
# 
# setwd("C:/Users/pmwash/Desktop/R_files/Data Output")
# file_path_2 = paste0('kc_', file_path)
# write.xlsx(accumulator, file=file_path_2, sheet='Item Summary')
# write.xlsx(supplier_accumulator, file=file_path_2, sheet='Supplier Summary', append=TRUE)
# write.xlsx(customers, file=file_path_2, sheet='Customer Returns Summary', append=TRUE)
# # write.xlsx(directors, file=file_path, sheet='Director Lookup Table', append=TRUE)
# # write.xlsx(monthly_accumulator, file=file_path, sheet='Time Series', append=TRUE)



#print('STOP and run the VBA code to format the report for distribution. Make sure file output name matches the final branch of the file paths below')
#source("C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R")



# 
# 
# 
# print('Below is for STL moving files')
# from = paste0("C:/Users/pmwash/Desktop/R_Files/Data Output/", file_name, sep='')
# to = paste0("//majorbrands.com/STLcommon/Operations Intelligence/Monthly Reports/Unsaleables/", file_name, sep='')
# moveRenameFile(from, to)
# 
# 
# print('Save as... *_kcversion.xlsx')
# 
# 
# print('Below is for KC moving files')
# from = paste0("C:/Users/pmwash/Desktop/R_Files/Data Output/", file_name_2, sep='')
# to = paste0('M:/Operations Intelligence/Monthly Reports/Unsaleables/', file_name_2, sep='')
# moveRenameFile(from, to)
# 
# 
# 







# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# print('##############')
# print('START GRAPHICS')
# print('##############')
# 
# 
# 
# 
# print('Create a plot of time series for worst 10 suppliers for unsaleables')
# top10SupplierUnsaleables = head(suppliers, 10)$SUPPLIER
# top10SupplierUnsaleables
# top10Month = monthly[monthly$SUPPLIER.NO %in% c('ST. LOUIS BREWING 803933/803934',
#                                             'THE WINE GROUP           802301',
#                                             'FOUNDERS BREWING COMPANY 805204',
#                                             'KOOCHENVAGNER\'S BREWING  803091',
#                                             'OSKAR BLUES BREWERY      800054',
#                                             'LEFT HAND BREWING COMPNY 805220',
#                                             'ROGUE ALES AND SPIRITS   805244',
#                                             'TWO BROTHERS BREWING CO  800038',
#                                             'CONSTELLATION BRANDS     800606',
#                                             'GREAT DIVIDE BREWING     802821'),]
# top10Month$SUPPLIER.NO = factor(top10Month$SUPPLIER.NO, levels=c('ST. LOUIS BREWING 803933/803934',
#                                                                  'THE WINE GROUP           802301',
#                                                                  'FOUNDERS BREWING COMPANY 805204',
#                                                                  'KOOCHENVAGNER\'S BREWING  803091',
#                                                                  'OSKAR BLUES BREWERY      800054',
#                                                                  'LEFT HAND BREWING COMPNY 805220',
#                                                                  'ROGUE ALES AND SPIRITS   805244',
#                                                                  'TWO BROTHERS BREWING CO  800038',
#                                                                  'CONSTELLATION BRANDS     800606',
#                                                                  'GREAT DIVIDE BREWING     802821'))
# 
# g = ggplot(data=top10Month, aes(x=MONTH, y=abs(CASES.UNSALEABLE)))
# g + geom_bar(stat='sum', aes(group=MONTH, fill=SUPPLIER.NO)) +
#   theme(legend.position='none') + facet_wrap(~SUPPLIER.NO, ncol=2, scales="free_y") +
#   labs(title='Total Cases Unsaleable, Top 10 Suppliers In Order', x='Month', y='Total Cases Unsaleable')
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# print('First gather customer/monthly data. Create a plot of time series for Customers.')
# head(customers, 10)
# custMonth = aggregate(CASES ~ X.MCUS. + MONTH, data=mtc, FUN=sum)
# names(custMonth) = c('CUSTOMER.NO', 'MONTH', 'CASES.RETURNED')
# custMonth = custMonth %>% filter(CUSTOMER.NO==11944 | CUSTOMER.NO==100487 |
#                                    CUSTOMER.NO==11368 | CUSTOMER.NO==7456 |
#                                    CUSTOMER.NO==1801 | CUSTOMER.NO==3009142 |
#                                    CUSTOMER.NO==3009706 | CUSTOMER.NO==10382 |
#                                    CUSTOMER.NO==12047 | CUSTOMER.NO==8571)#MAKE SURE THEY MATCH
# 
# setwd("C:/Users/pmwash/Desktop/R_files/Data Input")
# cust = read.csv('active_customers_dive.csv', header=TRUE)
# names(cust) = c('CUSTOMER', 'CUSTOMER.NO')
# custMonth = merge(cust, custMonth, by='CUSTOMER.NO', all.y=TRUE)
# custMonth = arrange(custMonth, MONTH, CASES.RETURNED)
# head(custMonth)
# custMonth$CUSTOMER = factor(custMonth$CUSTOMER, 
#                             levels=c('FRIAR TUCK BEVERAGE O FALLON (11944)',
#                                      'LUKAS LIQUOR SUPERSTORE (1004877)',
#                                      ' FRIAR TUCK BEVERAGE CRESTWOOD (11368)',
#                                      'LUKAS LIQUOR SUPERSTORE (7456)',
#                                      'TOTAL WINE #1801 TWN & CNTRY (1801)',
#                                      'CRAFT BEER CELLAR COLUMBIA (3009142)',
#                                      'DIERBERGS #25 LAKEVIEW POINTE (3009706)',
#                                      'RANDALLS WINE & SPIRITS (10382)',
#                                      'MOLLYS 808 GEYER           OOB (12047)',
#                                      'SHOP N SAVE #1834 HARVESTER (8571)'))
# 
# 
# 
#   headTail(custMonth)
#   g = ggplot(data=custMonth, aes(x=MONTH, y=abs(CASES.RETURNED)))
#   g + geom_bar(stat='sum', aes(group=MONTH, fill=CUSTOMER)) +
#     theme(legend.position='none') + 
#     facet_wrap(~CUSTOMER, ncol=2, scales='free') +
#     labs(title='Total Returns, Top 10 Customers for Returns In Order', x='Month', y='Total Cases Unsaleable')
# 
# ##
# print('Look at case unsaleables.')
# g = ggplot(data=mtc, aes(x=MONTH, y=abs(CASES)))
# g + geom_jitter(aes(group=MONTH))
# 
# 
# #################################################################################################
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
