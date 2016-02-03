print('Velocity Report for Kansas City')

############
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
headTail = function(x) {
  h <- head(x)
  t <- tail(x)
  print(h)
  print(t)
}
############

print('Declare production days and time period; put time period on output file name')
productionDays = 18
timeFrame = '1/1/16 - 1/31/16 for Companies 1 & 5'

print('Read in Velocity report from AS400, accessed through Compleo and pre-formatted in Excel:
      Make sure rows below data have all been deleted, and headers (above col names) are nixed')
setwd("C:/Users/pmwash/Desktop/R_Files/Data Input")
btls = read.csv('bottle_velocity_kc.csv', header=TRUE)
names(btls) = c('ITEM.NUMBER', 'DESCRIPTION', 'BTL.SALES', 'PICK.FREQUENCY', 'CASE.LOCATION',
                'BTL.LOCATION', 'BULK.LOCATION', 'BTLS.ON.HAND')
btls = btls %>% arrange(-BTL.SALES)
cases = read.csv('case_velocity_kc.csv', header=TRUE)
names(cases) = c('ITEM.NUMBER', 'DESCRIPTION', 'CASE.SALES', 'PICK.FREQUENCY', 'CASE.LOCATION',
                 'BTL.LOCATION', 'BULK.LOCATION', 'BTLS.ON.HAND')
cases = cases %>% arrange(-CASE.SALES)


headTail(cases)
headTail(btls)


print('Classify lines')
csLine = substrLeft(cases$CASE.LOCATION, 2)
btlLine = substrLeft(btls$BTL.LOCATION, 1)
cases$CASE.LINE = ifelse(csLine == 'C1', 'C-100', 
                         ifelse(csLine == 'C2', 'C-200', 
                                ifelse(csLine == 'C3', 'C-300', 
                                       ifelse(csLine == 'C4', 'C-400',
                                              ifelse(substrLeft(csLine, 1) == 'W' | substrLeft(csLine,1) == '5', 'WINE ROOM', 'ODDBALL')))))
btlLine = substrLeft(btls$BTL.LOCATION, 1)
btls$BTL.LINE = ifelse(btlLine == 'A', 'A-RACK',
                       ifelse(btlLine == 'B', 'B-RACK', 'ODDBALL'))






print('Get cases & bottles per day')
cases$CASE.SALES = as.numeric(cases$CASE.SALES)
btls$BTL.SALES = as.numeric(btls$BTL.SALES)
cases$CASE.SALES.PER.DAY = round(cases$CASE.SALES / productionDays, 2)
btls$BTL.SALES.PER.DAY = round(btls$BTL.SALES / productionDays, 2)


print('Mark kegs to take out cases for the oddballs (if from keg room)')
DESC = cases$DESCRIPTION
k1 = "\\<1/6BL\\>"; k2 = "\\<1/2BL\\>"; k3 = "\\<1/4BL\\>"
k4 = "\\<20L\\>"; k5 = "\\<10.8G\\>"; k6 = "\\<15.5G\\>"; k7 = "\\<15L\\>"
k8 = "\\<2.6G\\>"; k9 = "\\<19L\\>"; k10 = "\\<3.3G\\>"
k11 = "\\<4.9G\\>"; k12 = "\\<5.16G\\>"; k13 = "\\<5.2G\\>"; k14 = "\\<5.4G\\>"
k15 = "\\<19.5L\\>"; k16 = "\\<50L\\>"; k17 = "\\<30L\\>"
k18 = "\\<5G\\>"; k19 = "\\<25L\\>"

cases$IS.KEG = ifelse(grepl(k1, DESC) == TRUE, 'YES', 
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


headTail(cases)



print('Add in Btls & Cases per Pick')
btls$BTL.SALES = as.numeric(btls$BTL.SALES)
btls$PICK.FREQUENCY = as.numeric(btls$PICK.FREQUENCY)
btls$BTLS.PER.PICK = round(btls$BTL.SALES / btls$PICK.FREQUENCY, 2)
cases$CASE.SALES = as.numeric(cases$CASE.SALES)
cases$PICK.FREQUENCY = as.numeric(cases$PICK.FREQUENCY)
cases$CASES.PER.PICK = round(cases$CASE.SALES / cases$PICK.FREQUENCY, 2)




print('Move columns for display purposes')
cases = cases[,c('ITEM.NUMBER', 'DESCRIPTION', 'CASE.SALES.PER.DAY', 'CASE.SALES', 'PICK.FREQUENCY', 
                 'CASES.PER.PICK', 'CASE.LOCATION', 'BTL.LOCATION', 'BULK.LOCATION', 'BTLS.ON.HAND', 'CASE.LINE', 'IS.KEG')]
btls = btls[,c('ITEM.NUMBER', 'DESCRIPTION', 'BTL.SALES.PER.DAY', 'BTL.SALES', 'PICK.FREQUENCY', 
               'BTLS.PER.PICK', 'CASE.LOCATION', 'BTL.LOCATION', 'BULK.LOCATION', 'BTLS.ON.HAND', 'BTL.LINE')]


print('In future, adapt this for cases on hand to be integrated into cases table')
# setwd("C:/Users/pmwash/Desktop/R_Files/Data Input")
# print('Read in location data from HighJump for the exact day this report is run')
# locations = read.csv('highjump_inventory_export.csv', header=TRUE)
# names(locations) = toupper(names(locations))
# locations$CASE.BTL.ON.HAND = round(locations$TOTAL.BOTTLES / locations$QPC, 2)
# 
# 
# locations = select(locations, c(ITEM.NUMBER, CASES, BOTTLES, CASE.BTL.ON.HAND))
# names(locations) = c('ITEM.NUMBER', 'CASES.ON.HAND', 'BTLS.ON.HAND', 'CASE.BTL.ON.HAND')
# headTail(locations)
# 

headTail(cases)
headTail(btls)





print('Filter lines out from totals')
oddball = cases %>% filter(CASE.LINE=='ODDBALL') %>% arrange(desc(CASE.SALES), ITEM.NUMBER)
c100.line = cases %>% filter(CASE.LINE=='C-100') %>% arrange(desc(CASE.SALES), ITEM.NUMBER)
c200.line = cases %>% filter(CASE.LINE=='C-200') %>% arrange(desc(CASE.SALES), ITEM.NUMBER)
c300.line = cases %>% filter(CASE.LINE=='C-300') %>% arrange(desc(CASE.SALES), ITEM.NUMBER)
c400.line = cases %>% filter(CASE.LINE=='C-400') %>% arrange(desc(CASE.SALES), ITEM.NUMBER)
wine.room = cases %>% filter(CASE.LINE=='WINE ROOM') %>% arrange(desc(CASE.SALES), ITEM.NUMBER)
a.btl.line = btls %>% filter(BTL.LINE=='A-RACK') %>% arrange(desc(BTL.SALES), ITEM.NUMBER)
b.btl.line = btls %>% filter(BTL.LINE=='B-RACK') %>% arrange(desc(BTL.SALES), ITEM.NUMBER)
keg.room = cases %>% filter(IS.KEG=='YES') %>% arrange(desc(CASE.SALES), ITEM.NUMBER)







print('Aggregate a summary page for report')
caseMovementByLine = aggregate(CASE.SALES ~ CASE.LINE, data=cases, FUN=sum) 
caseMovementByLine = arrange(caseMovementByLine, -CASE.SALES)
cs = caseMovementByLine$CASE.SALES
total = sum(caseMovementByLine$CASE.SALES)
caseMovementByLine$PERCENT.TTL.CASES = round(cs / total, 3)
caseMovementByLine
itemsPerLine = aggregate(DESCRIPTION ~ CASE.LINE, data=cases, FUN=countUnique)
names(itemsPerLine) = c('CASE.LINE', 'NUMBER.UNIQUE.ITEMS')
lineSummary = merge(caseMovementByLine, itemsPerLine, by='CASE.LINE')
btlSales = aggregate(BTL.SALES~BTL.LINE, data=btls, FUN=sum)
names(btlSales) = c('CASE.LINE', 'BTL.SALES')
lineSummary = merge(lineSummary, btlSales, by='CASE.LINE', all=TRUE)
lineSummary$PERCENT.TTL.BTLS = round(lineSummary$BTL.SALES / sum(lineSummary$BTL.SALES, na.rm=TRUE), 2)

lineSummary = lineSummary[,c('CASE.LINE', 'CASE.SALES', 'PERCENT.TTL.CASES', 
                             'BTL.SALES', 'PERCENT.TTL.BTLS', 'NUMBER.UNIQUE.ITEMS')]
lineSummary = arrange(lineSummary, -CASE.SALES)
lineSummary


print('Print results to a file for distribution. Make sure file name is equal to the file output name before running moveRenameFile()')
setwd("C:/Users/pmwash/Desktop/R_Files/Data Output")
file_name = 'velocity_kc_01012016-01312016.xlsx'
write.xlsx(lineSummary, file=file_name, sheetName='Line Summary')
write.xlsx(a.btl.line, file=file_name, sheetName='A Rack', append=TRUE)
write.xlsx(b.btl.line, file=file_name, sheetName='B Rack', append=TRUE)
write.xlsx(c100.line, append=TRUE, file=file_name, sheetName='C-100')
write.xlsx(c200.line, append=TRUE, file=file_name, sheetName='C-200')
write.xlsx(c300.line, append=TRUE, file=file_name, sheetName='C-300')
write.xlsx(c400.line, append=TRUE, file=file_name, sheetName='C-400')
write.xlsx(wine.room, append=TRUE, file=file_name, sheetName='Wine Room')
write.xlsx(oddball, append=TRUE, file=file_name, sheetName='Oddball')
write.xlsx(keg.room, append=TRUE, file=file_name, sheetName='Keg Room')


print('STOP and run the VBA code to format the report for distribution. Make sure file output name matches the final branch of the file paths below')


from = paste0("C:/Users/pmwash/Desktop/R_Files/Data Output/", file_name, sep='')
to = paste0('M:/Operations Intelligence/Monthly Reports/Velocity/', file_name, sep='')
moveRenameFile(from, to)


