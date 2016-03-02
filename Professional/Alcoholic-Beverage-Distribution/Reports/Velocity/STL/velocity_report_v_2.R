
print('Velocity Report STL')


print('Load necessary libraries')
library(dplyr)
library(xlsx)
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')


print('(1) AS400 - run for COMP = 2 & 3 for STL and 1 & 5 for KC')
print('(2) Open Compleo from Citrix; format and extract the text file; save as ASCII UTF 8 to desktop Compleo folder')
print('(3) Check column D, find "CASE", and then copy from the first occurrence down to new file')
print('(4) Input files are velocity_disc_cases.csv and velocity_disc_bottles.csv; sort and check them; ensure numeric format for D & E cols')




print('Declare production days and time period; put time period on output file name')
productionDays = 17
rawBtlTtl = 9822.94
rawCsTtl = 220898
timeFrame = '1/1/16 - 1/31/16 for Companies 2 & 3'

print('Read in Velocity report from AS400, accessed through Compleo and pre-formatted in Excel:
      Make sure rows below data have all been deleted, and headers (above col names) are nixed')
btls = read.csv('C:/Users/pmwash/Desktop/R_Files/Data Input/velocity_disc_bottles.csv', header=TRUE, na.strings=NA)
names(btls) = c('ITEM.NUMBER', 'DESCRIPTION', 'BTL.SALES', 'PICK.FREQUENCY', 'CASE.LOCATION',
                 'BTL.LOCATION', 'BULK.LOCATION', 'BTLS.ON.HAND')
cases = read.csv('C:/Users/pmwash/Desktop/R_Files/Data Input/velocity_disc_cases.csv', header=TRUE, na.strings=NA)
names(cases) = c('ITEM.NUMBER', 'DESCRIPTION', 'CASE.SALES', 'PICK.FREQUENCY', 'CASE.LOCATION',
                 'BTL.LOCATION', 'BULK.LOCATION', 'BTLS.ON.HAND')
headTail(btls)
headTail(cases)

#######
print('AVOID BUGS: Check sums from raw input data')
btlTot = sum(btls$BTL.SALES, na.rm=T)
csTot = sum(cases$CASE.SALES, na.rm=T)
paste('Bottle total after reading in data is ', btlTot, 
      ' when before it was ', rawBtlTtl,
      'Case total after reading in data is ', csTot,
      ' when before it was ', rawCsTtl)
paste(' Bottles OK?: ', btlTot == rawBtlTtl) 
paste(' Cases OK?: ', csTot == rawCsTtl)
#######

print('Classify lines')
csLine = substrLeft(cases$CASE.LOCATION, 1)
cases$CASE.LINE = ifelse(csLine == 'C', 'C-LINE', 
                        ifelse(csLine == 'D', 'D-LINE', 
                               ifelse(csLine == 'E', 'E-LINE', 
                                      ifelse(csLine == 'F', 'F-LINE',
                                             ifelse(csLine == 'G', 'G-LINE', 
                                                    ifelse(csLine == 'K', 'KEG ROOM',
                                                           ifelse(csLine == 'W', 'WINE ROOM',
                                                                  ifelse(csLine == 'A', 'A-RACK', 
                                                                         ifelse(csLine == 'B', 'B-RACK',
                                                                                ifelse(csLine=='R'|csLine=='M'|csLine=='Z'|csLine=='Y'|csLine=='T'|csLine=='J'|csLine=='L'|csLine=='S'|csLine=='H', 'ODDBALL', 'ODDBALL'))))))))))
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


print('Separate out cases that came from the keg room (which are oddballs) from kegs from keg room')
LINE = cases$CASE.LINE
ISKEG = cases$IS.KEG
cases$CASE.LINE = ifelse(LINE == 'KEG ROOM' & ISKEG == 'NO', 'ODDBALL', LINE)
cases = cases %>% arrange(desc(CASE.SALES), ITEM.NUMBER)
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



print('Separate out the lines for printing')
paste('There were', productionDays, 'production days in this analysis for the time period between', timeFrame)

oddball = cases %>% filter(CASE.LINE=='ODDBALL' & IS.KEG=='NO') %>% arrange(desc(CASE.SALES), ITEM.NUMBER)
c.line = cases %>% filter(CASE.LINE=='C-LINE') %>% arrange(desc(CASE.SALES), ITEM.NUMBER)
d.line = cases %>% filter(CASE.LINE=='D-LINE') %>% arrange(desc(CASE.SALES), ITEM.NUMBER)
e.line = cases %>% filter(CASE.LINE=='E-LINE') %>% arrange(desc(CASE.SALES), ITEM.NUMBER)
f.line = cases %>% filter(CASE.LINE=='F-LINE') %>% arrange(desc(CASE.SALES), ITEM.NUMBER)
g.line = cases %>% filter(CASE.LINE=='G-LINE') %>% arrange(desc(CASE.SALES), ITEM.NUMBER)
wine.room = cases %>% filter(CASE.LINE=='WINE ROOM') %>% arrange(desc(CASE.SALES), ITEM.NUMBER)
a.btl.line = btls %>% filter(BTL.LINE=='A-RACK') %>% arrange(desc(BTL.SALES), ITEM.NUMBER)
b.btl.line = btls %>% filter(BTL.LINE=='B-RACK') %>% arrange(desc(BTL.SALES), ITEM.NUMBER)
oddballBtls = btls %>% filter(BTL.LINE=='ODDBALL') %>% arrange(desc(BTL.SALES), ITEM.NUMBER)
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
# # #########
# print('Remove positives and add them up')
# b = ifelse(btls$BTL.LINE=='ODDBALL' & btls$BTL.SALES>0, as.numeric(btls$BTL.SALES),0)
# sum(b,na.rm=T)
# # #########
names(btlSales) = c('CASE.LINE', 'BTL.SALES')
lineSummary = merge(lineSummary, btlSales, by='CASE.LINE', all=TRUE)
lineSummary$PERCENT.TTL.BTLS = round(lineSummary$BTL.SALES / sum(lineSummary$BTL.SALES, na.rm=TRUE), 2)

lineSummary = lineSummary[,c('CASE.LINE', 'CASE.SALES', 'PERCENT.TTL.CASES', 
                             'BTL.SALES', 'PERCENT.TTL.BTLS', 'NUMBER.UNIQUE.ITEMS')]
lineSummary = arrange(lineSummary, -CASE.SALES)
lineSummary

##########
print('AVOID BUGS: Check that totals match input files')
finalCs = sum(lineSummary$CASE.SALES, na.rm=T)
finalBtl = sum(lineSummary$BTL.SALES, na.rm=T)
paste('Cases OK?: ', finalCs == rawCsTtl, 'Final Cases = ', finalCs)
paste('Bottles OK?: ', finalBtl == rawBtlTtl, 'Final Bottles = ', finalBtl)
##########

print('Print results to a file for distribution. Make sure file name is equal to the file output name before running moveRenameFile()')
setwd("C:/Users/pmwash/Desktop/R_Files/Data Output")
library(xlsx)
file_name = 'velocity_stl_02012016-02292016.xlsx'
write.xlsx(lineSummary, file=file_name, sheetName='Line Summary')
write.xlsx(a.btl.line, file=file_name, sheetName='A Rack', append=TRUE)
write.xlsx(b.btl.line, file=file_name, sheetName='B Rack', append=TRUE)
write.xlsx(oddballBtls, append=TRUE, file=file_name, sheetName='Oddball Bottles')
write.xlsx(c.line, append=TRUE, file=file_name, sheetName='C Line')
write.xlsx(d.line, append=TRUE, file=file_name, sheetName='D Line')
write.xlsx(e.line, append=TRUE, file=file_name, sheetName='E Line')
write.xlsx(f.line, append=TRUE, file=file_name, sheetName='F Line')
write.xlsx(g.line, append=TRUE, file=file_name, sheetName='G Line')
write.xlsx(keg.room, append=TRUE, file=file_name, sheetName='Keg Room')
write.xlsx(wine.room, append=TRUE, file=file_name, sheetName='Wine Room')
write.xlsx(oddball, append=TRUE, file=file_name, sheetName='Oddball Cases')

print('STOP and run the VBA code to format the report for distribution. Make sure file output name matches the final branch of the file paths below')


from = paste0("C:/Users/pmwash/Desktop/R_Files/Data Output/", file_name, sep='')
to = paste0("//majorbrands.com/STLcommon/Operations Intelligence/Monthly Reports/Velocity/", file_name, sep='')
moveRenameFile(from, to)


