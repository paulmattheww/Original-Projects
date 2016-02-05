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
