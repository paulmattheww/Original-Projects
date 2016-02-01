print('Velocity Report KC - In Process')




print('Velocity Report')

print('Load necessary libraries')
library(dplyr)
library(XLConnect)

print('Create functions for later use')
substrRight = function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}
substrLeft = function(x, n){
  substr(x, 1, n)
}
as400Date = function(x) {
  date = as.character(x)
  date = substrRight(date, 6)
  date = as.character((strptime(date, "%y%m%d")))
  date
}
countUnique = function(x) {
  length(unique(x))
}
moveRenameFile = function(from, to) {
  destination = dirname(to)
  if (!isTRUE(file.info(destination)$isdir)) dir.create(destination, recursive=TRUE)
  file.rename(from = from,  to = to)
}


print('Declare production days and time period')
productionDays = 18
timeFrame = '1/1/16 - 1/31/16'


print('Read in pwvelocity query from AS400 for timeframe specific to the report')
setwd("C:/Users/pmwash/Desktop/R_Files/Data Input")
shipments = read.csv('pwvelocity.csv', header=TRUE) # query containing transactions 
names(shipments) = c('ITEM.NUMBER', 'CASES.SOLD', 'QTY.SOLD', 'INVOICE.DATE', 'INVOICE.NO',
                     'QPC', 'CLASS', 'SIZE', 'LINE.ITEM.NO', 'TRNS.CODE')
shipments$INVOICE.DATE = as400Date(shipments$INVOICE.DATE)
shipments$TRNS.CODE = as.character(shipments$TRNS.CODE)
shipments = arrange(shipments, ITEM.NUMBER)
shipments = select(shipments, c(ITEM.NUMBER, CASES.SOLD, SIZE))
headTail(shipments)
itemVolumeForLater = aggregate(CASES.SOLD~ITEM.NUMBER, data=shipments, FUN=sum)


print('Read in location data from AS400 for the exact day this report is run')
locations = read.csv('pwkclocs.csv', header=TRUE)
names(locations) = c('ITEM.NUMBER', 'SIZE', 'DESCRIPTION', 'CASE.LOC', 'BTL.LOC', 
                     'BULK.LOC', 'CASES.ON.HAND', 'QPC', 'UPC')
locations = arrange(locations, desc(CASES.ON.HAND))
locations = select(locations, c(ITEM.NUMBER, DESCRIPTION, SIZE, CASE.LOC, BTL.LOC, BULK.LOC, CASES.ON.HAND))
names(locations) = c('ITEM.NUMBER', 'DESCRIPTION', 'SIZE', 'CASE.LOC', 'BTL.LOC', 'BULK.LOC', 'CASES.ON.HAND')
headTail(locations)



print('Merge (greedily) todays inventory with locs with shipments data')
shipmentsLocationsKC = merge(itemVolumeForLater, locations, by="ITEM.NUMBER", all=TRUE)
shipmentsLocationsKC = shipmentsLocationsKC %>% arrange(desc(CASES.SOLD), desc(CASES.ON.HAND), ITEM.NUMBER)
shipmentsLocationsKC = select(shipmentsLocationsKC, c(ITEM.NUMBER, DESCRIPTION, SIZE,
                                                  CASES.SOLD, CASE.LOC, BTL.LOC, BULK.LOC, CASES.ON.HAND))
shipmentsLocationsKC$ITEM.NUMBER = factor(shipmentsLocationsKC$ITEM.NUMBER)
headTail(shipmentsLocationsKC)




print('Check this part with Bob K
      Step 1 filters out bulk locs (not starting with a letter)
      Step 2 would take out A and B lines, but waiting to hear back from Bob')

print('Below deletes bulk locs but don not need it for KC')
#############
#forDelete = grepl("(\\d)", line) # delete digits and A & B from line identifier 
#shipmentsLocationsKC = shipmentsLocationsKC[!forDelete,]
#shipmentsLocationsKC = filter(shipmentsLocationsKC, shipmentsLocationsKC$LINE.IDENTIFIER != "A")
#shipmentsLocationsKC = filter(shipmentsLocationsKC, shipmentsLocationsKC$LINE.IDENTIFIER != "B")
#############


print('Separate out case lines')
csLine = substrLeft(shipmentsLocationsKC$CASE.LOC, 2)
btlLine = substrLeft(shipmentsLocationsKC$BTL.LOC, 1)
shipmentsLocationsKC$CASE.LINE = ifelse(csLine == 'C1', 'C-100', 
                                     ifelse(csLine == 'C2', 'C-200', 
                                            ifelse(csLine == 'C3', 'C-300', 
                                                   ifelse(csLine == 'C4', 'C-400',
                                                          ifelse(substrLeft(csLine,1) == 'W' | substrLeft(csLine,1) == '5', 'WINE ROOM', 'ODDBALL')))))
                                                             
shipmentsLocationsKC$BTL.LINE = ifelse(btlLine == 'A', 'A-LINE',
                                     ifelse(btlLine == 'B', 'B-LINE', 
                                            ifelse(btlLine == '5' | btlLine == 'W', 'WINE ROOM', 'ODDBALL')))

DESC = shipmentsLocationsKC$SIZE
k1 = "\\<1/6BL\\>" 
k2 = "\\<1/2BL\\>"
k3 = "\\<1/4BL\\>"
k4 = "\\<20L\\>"
k5 = "\\<10.8G\\>"
k6 = "\\<15.5G\\>"
k7 = "\\<15L\\>"
k8 = "\\<2.6G\\>"
k9 = "\\<19L\\>"
k10 = "\\<3.3G\\>"
k11 = "\\<4.9G\\>"
k12 = "\\<5.16G\\>"
k13 = "\\<5.2G\\>"
k14 = "\\<5.4G\\>"
k15 = "\\<19.5L\\>"
k16 = "\\<50L\\>"
k17 = "\\<30L\\>"
k18 = "\\<5G\\>"
k19 = "\\<25L\\>"

shipmentsLocationsKC$IS.KEG = ifelse(grepl(k1, DESC) == TRUE, 'YES', 
                                   ifelse(grepl(k2, DESC) == TRUE, 'YES', 
                                          ifelse(grepl(k3, DESC) == TRUE, 'YES', 
                                                 ifelse(grepl(k4, DESC) == TRUE, 'YES', 
                                                        ifelse(grepl(k5, DESC) == TRUE, 'YES', 
                                                               ifelse(grepl(k6, DESC) == TRUE, 'YES', 
                                                                      ifelse(grepl(k7, DESC) == TRUE, 'YES', 
                                                                             ifelse(grepl(k8, DESC) == TRUE, 'YES', 
                                                                                    ifelse(grepl(k9, DESC) == TRUE, 'YES', 
                                                                                           ifelse(grepl(k10, DESC) == TRUE, 'YES', 
                                                                                                  ifelse(grepl(k11, DESC) == TRUE, 'YES', 
                                                                                                         ifelse(grepl(k12, DESC) == TRUE, 'YES', 
                                                                                                                ifelse(grepl(k13, DESC) == TRUE, 'YES', 
                                                                                                                       ifelse(grepl(k14, DESC) == TRUE, 'YES', 
                                                                                                                              ifelse(grepl(k15, DESC) == TRUE, 'YES', 
                                                                                                                                     ifelse(grepl(k16, DESC) == TRUE, 'YES',
                                                                                                                                            ifelse(grepl(k17, DESC) == TRUE, 'YES', 
                                                                                                                                                   ifelse(grepl(k18, DESC) == TRUE, 'YES', 
                                                                                                                                                          ifelse(grepl(k19, DESC) == TRUE, 'YES', 'NO')))))))))))))))))))

# kegsOnlyCheck = filter(shipmentsLocationsKC, IS.KEG=='YES')
# headTail(kegsOnlyCheck)
# rm(kegsOnlyCheck)

print('Separate out cases that came from the keg room (which are oddballs) from kegs from keg room')
LINE = shipmentsLocationsKC$CASE.LINE
ISKEG = shipmentsLocationsKC$IS.KEG
shipmentsLocationsKC$CASE.LINE = ifelse(LINE == 'KEG ROOM' & ISKEG == 'NO', 'ODDBALL', LINE)
shipmentsLocationsKC = shipmentsLocationsKC %>% arrange(desc(CASES.SOLD), desc(CASES.ON.HAND), ITEM.NUMBER)

print('New variable for avg case movement per night; MAKE SURE PRODUCTION DAYS IS CORRECT and added up from daily report folders')
paste('It is assumed there were', productionDays, 'production days for the time period between', timeFrame)
shipmentsLocationsKC$CASES.SOLD.PER.NIGHT = round(shipmentsLocationsKC$CASES.SOLD / productionDays, 1)

print('Remove duplicates')
before = nrow(shipmentsLocationsKC)
shipmentsLocationsKC = shipmentsLocationsKC[!duplicated(shipmentsLocationsKC), ]
after = nrow(shipmentsLocationsKC)
paste('Before ther were', before, ' rows ... After there were ', after, ' rows')
head(shipmentsLocationsKC,50)

# ################
# print('Check to ensure that the order is the same for products')
# caseMovementByProduct = aggregate(CASES.SOLD ~ ITEM.NUMBER, data=shipments, FUN=sum)
# caseMovementByProduct = arrange(caseMovementByProduct, -CASES.SOLD)
# head(caseMovementByProduct, 20)
# head(shipmentsLocationsKC, 50) 
# ################


print('Separate out the lines for printing')
paste('There were', productionDays, 'production days in this analysis for the time period between', timeFrame)
CSLINE = shipmentsLocationsKC$CASE.LINE
BTLLINE = shipmentsLocationsKC$BTL.LINE

print('Filter lines out from totals')
oddball = shipmentsLocationsKC %>% filter(CSLINE=='ODDBALL') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
c100.line = shipmentsLocationsKC %>% filter(CSLINE=='C-100') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
c200.line = shipmentsLocationsKC %>% filter(CSLINE=='C-200') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
c300.line = shipmentsLocationsKC %>% filter(CSLINE=='C-300') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
c400.line = shipmentsLocationsKC %>% filter(CSLINE=='C-400') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
wine.room = shipmentsLocationsKC %>% filter(CSLINE=='WINE ROOM' | CSLINE=='WINE ROOM') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
a.btl.line = shipmentsLocationsKC %>% filter(BTLLINE=='A-LINE') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
b.btl.line = shipmentsLocationsKC %>% filter(BTLLINE=='B-LINE') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
itemsWithInventoryButNoSales = shipmentsLocationsKC %>% filter(is.na(CASES.SOLD)) %>% arrange(desc(CASES.ON.HAND), ITEM.NUMBER)
noInventoryPositiveSales = shipmentsLocationsKC %>% filter(is.na(CASES.ON.HAND) & CASES.SOLD>0) %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)


print('Aggregate a summary page for report')
caseMovementByLine = aggregate(CASES.SOLD ~ CASE.LINE, data=shipmentsLocationsKC, FUN=sum) 
caseInventoryByLine = aggregate(CASES.ON.HAND ~ CASE.LINE, data=shipmentsLocationsKC, FUN=sum)
caseMovementByLine = merge(caseMovementByLine, caseInventoryByLine, by='CASE.LINE')
caseMovementByLine = arrange(caseMovementByLine, -CASES.SOLD)
cases = caseMovementByLine$CASES.SOLD
total = sum(caseMovementByLine$CASES.SOLD)
caseMovementByLine$PERCENT.SALES = round(cases / total, 3)
cases = caseMovementByLine$CASES.ON.HAND
total = sum(caseMovementByLine$CASES.ON.HAND)
caseMovementByLine$PERCENT.INVENTORY = round(cases / total, 3)
caseMovementByLine

itemsPerLine = aggregate(DESCRIPTION ~ CASE.LINE, data=shipmentsLocationsKC, FUN=countUnique)
names(itemsPerLine) = c('CASE.LINE', 'NUMBER.UNIQUE.ITEMS')

lineSummary = merge(caseMovementByLine, itemsPerLine, by='CASE.LINE')
lineSummary = arrange(lineSummary, -CASES.SOLD)
#casesPerDay = lineSummary$CASES.PER.DAY = round(lineSummary$CASES.SOLD / productionDays)
lineSummary




casesByLocationTtl = aggregate(CASES.SOLD ~ CASE.LOC, data=shipmentsLocationsKC, FUN=sum)
casesByLocationTtl = arrange(casesByLocationAvg, -CASES.SOLD)
head(casesByLocationTtl, 50) 



print('Print results to a file for distribution')
setwd("C:/Users/pmwash/Desktop/R_Files/Data Output")
write.xlsx(lineSummary, file='Velocity_KC.xlsx', sheetName='Line Summary')
write.xlsx(c100.line, file='Velocity_KC.xlsx', sheetName='C100', append=TRUE)
write.xlsx(c200.line, file='Velocity_KC.xlsx', sheetName='C200', append=TRUE)
write.xlsx(c300.line, file='Velocity_KC.xlsx', sheetName='C300', append=TRUE)
write.xlsx(c400.line, file='Velocity_KC.xlsx', sheetName='C400', append=TRUE)
write.xlsx(a.btl.line, file='Velocity_KC.xlsx', sheetName='A Line', append=TRUE)
write.xlsx(b.btl.line, file='Velocity_KC.xlsx', sheetName='B Line', append=TRUE)
write.xlsx(wine.room, file='Velocity_KC.xlsx', sheetName='Wine Room', append=TRUE)
write.xlsx(oddball, file='Velocity_KC.xlsx', sheetName='Oddball', append=TRUE)
#write.xlsx(itemsWithInventoryButNoSales, append=TRUE, file='Velocity_KC.xlsx', sheetName='Items in Inventory wo Sales')
#write.xlsx(noInventoryPositiveSales, append=TRUE, file='Velocity_KC.xlsx', sheetName='Positive Sales No Locations')

print('Now open the output file and run the format_velocity() VBA code on it so it looks good')

