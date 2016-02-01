
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
productionDays = 20
timeFrame = '12/1/15 - 12/31/15'


print('Read in pwvelocity query from AS400 for timeframe specific to the report')
setwd("C:/Users/pmwash/Desktop/R_Files/Data Input")
shipments = read.csv('pwvelocity.csv', header=TRUE) # query containing transactions 
names(shipments) = c('ITEM.NUMBER', 'CASES.SOLD', 'QTY.SOLD', 'INVOICE.DATE', 'INVOICE.NO',
                      'QPC', 'CLASS', 'SIZE', 'LINE.ITEM.NO', 'TRNS.CODE')
shipments$INVOICE.DATE = as400Date(shipments$INVOICE.DATE)
shipments$TRNS.CODE = as.character(shipments$TRNS.CODE)
shipments = arrange(shipments, ITEM.NUMBER)
shipments = select(shipments, c(ITEM.NUMBER, CASES.SOLD, CLASS))
headTail(shipments)
itemVolumeForLater = aggregate(CASES.SOLD~ITEM.NUMBER, data=shipments, FUN=sum)


print('Read in location data from HighJump for the exact day this report is run')
locations = read.csv('highjump_inventory_export.csv', header=TRUE)
names(locations) = toupper(names(locations))
locations$CASE.BTL.ON.HAND = round(locations$TOTAL.BOTTLES / locations$QPC, 2)
locations = select(locations, c(ITEM.NUMBER, DESCRIPTION, LOCATION, CASES, BOTTLES))
names(locations) = c('ITEM.NUMBER', 'DESCRIPTION', 'LOCATION', 'CASES.ON.HAND', 'BTLS.ON.HAND')
#onHandItemForLater = aggregate()
head(locations)



print('Merge (greedily) todays inventory with locs with shipments data')
shipmentsLocations = merge(itemVolumeForLater, locations, by="ITEM.NUMBER", all=TRUE)
shipmentsLocations = shipmentsLocations %>% arrange(desc(CASES.SOLD), desc(CASES.ON.HAND), ITEM.NUMBER)
head(shipmentsLocations, 50)
shipmentsLocations = select(shipmentsLocations, c(ITEM.NUMBER, DESCRIPTION, 
                                                   CASES.SOLD, LOCATION, CASES.ON.HAND, BTLS.ON.HAND))
shipmentsLocations$ITEM.NUMBER = factor(shipmentsLocations$ITEM.NUMBER)


print('Below filters out bulk locs for stl, but not necessary for KC, Check STL be sure it should happen')
##############
#print('Check this part with Bob K
#      Step 1 filters out bulk locs (not starting with a letter)
#      Step 2 would take out A and B lines, but waiting to hear back from Bob')
#line = substrLeft(shipmentsLocations$LOCATION, 1)
#forDelete = grepl("(\\d)", line) # delete digits and A & B from line identifier 
#shipmentsLocations = shipmentsLocations[!forDelete,]
#shipmentsLocations = filter(shipmentsLocations, shipmentsLocations$LINE.IDENTIFIER != "A")
#shipmentsLocations = filter(shipmentsLocations, shipmentsLocations$LINE.IDENTIFIER != "B")
###############

line = substrLeft(shipmentsLocations$LOCATION, 1)
shipmentsLocations$LINE = ifelse(line == 'C', 'C-LINE', 
         ifelse(line == 'D', 'D-LINE', 
                ifelse(line == 'E', 'E-LINE', 
                       ifelse(line == 'F', 'F-LINE',
                              ifelse(line == 'G', 'G-LINE', 
                                     ifelse(line == 'H', 'H-LINE',
                                            ifelse(line == 'K', 'KEG ROOM',
                                                   ifelse(line == 'W', 'WINE ROOM',
                                                          ifelse(line == 'A', 'A-RACK',
                                                                 ifelse(line == 'B', 'B-RACK',
                                                                        ifelse(line=='R'|line=='M'|line=='Z'|line=='Y'|line=='T'|line=='J'|line=='L'|line=='S', 'ODDBALL', 'ODDBALL')))))))))))

DESC = shipmentsLocations$DESCRIPTION
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

shipmentsLocations$IS.KEG = ifelse(grepl(k1, DESC) == TRUE, 'YES', 
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

kegsOnlyCheck = filter(shipmentsLocations, IS.KEG=='YES')
headTail(kegsOnlyCheck)

print('Separate out cases that came from the keg room (which are oddballs) from kegs from keg room')
LINE = shipmentsLocations$LINE
ISKEG = shipmentsLocations$IS.KEG
shipmentsLocations$LINE = ifelse(LINE == 'KEG ROOM' & ISKEG == 'NO', 'ODDBALL', LINE)
shipmentsLocations = shipmentsLocations %>% arrange(desc(CASES.SOLD), desc(CASES.ON.HAND), desc(BTLS.ON.HAND), ITEM.NUMBER)

print('Remove duplicates')
before = nrow(shipmentsLocations)
shipmentsLocations = shipmentsLocations[!duplicated(shipmentsLocations), ]
head(shipmentsLocations, 50)
after = nrow(shipmentsLocations)
paste('Before ther were', before, ' rows ... After there were ', after, ' rows')

################  
print("checkNonKegsFromKegRoom = shipmentsLocations %>% filter(IS.KEG=='NO' & LINE=='ODDBALL') %>% arrange(LOCATION)")
checkNonKegsFromKegRoom$startswith = substrLeft(checkNonKegsFromKegRoom$LOCATION, 1)
checkNonKegFromKegRoom = filter(checkNonKegsFromKegRoom, startswith=='K')
headTail(checkNonKegFromKegRoom)
################

  
################
print('Check to ensure that the order is the same for products')
caseMovementByProduct = aggregate(CASES.SOLD ~ ITEM.NUMBER, data=shipments, FUN=sum)
caseMovementByProduct = arrange(caseMovementByProduct, -CASES.SOLD)
head(caseMovementByProduct, 20)
head(shipmentsLocations, 50) 
################


print('Separate out the lines for printing')
paste('There were', productionDays, 'production days in this analysis for the time period between', timeFrame)
oddball = shipmentsLocations %>% filter(LINE=='ODDBALL') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
c.line = shipmentsLocations %>% filter(LINE=='C-LINE') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
d.line = shipmentsLocations %>% filter(LINE=='D-LINE') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
e.line = shipmentsLocations %>% filter(LINE=='E-LINE') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
f.line = shipmentsLocations %>% filter(LINE=='F-LINE') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
g.line = shipmentsLocations %>% filter(LINE=='G-LINE') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
h.line = shipmentsLocations %>% filter(LINE=='H-LINE') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
keg.room = shipmentsLocations %>% filter(LINE=='KEG ROOM') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
wine.room = shipmentsLocations %>% filter(LINE=='WINE ROOM') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
a.btl.line = shipmentsLocations %>% filter(LINE=='A-RACK') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
b.btl.line = shipmentsLocations %>% filter(LINE=='B-RACK') %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)
itemsWithInventoryButNoSales = shipmentsLocations %>% filter(is.na(CASES.SOLD)) %>% arrange(desc(CASES.ON.HAND), desc(BTLS.ON.HAND), ITEM.NUMBER)
itemsWithSalesButNoLocations = shipmentsLocations %>% filter(is.na(LOCATION) & CASES.SOLD>0) %>% arrange(desc(CASES.SOLD), ITEM.NUMBER)


print('Aggregate a summary page for report')
caseMovementByLine = aggregate(CASES.SOLD ~ LINE, data=shipmentsLocations, FUN=sum) 
caseMovementByLine = arrange(caseMovementByLine, -CASES.SOLD)
cases = caseMovementByLine$CASES.SOLD
total = sum(caseMovementByLine$CASES.SOLD)
caseMovementByLine$PERCENT.TTL.CASES = round(cases / total, 3)
caseMovementByLine

itemsPerLine = aggregate(DESCRIPTION ~ LINE, data=shipmentsLocations, FUN=countUnique)
names(itemsPerLine) = c('LINE', 'NUMBER.UNIQUE.ITEMS')

lineSummary = merge(caseMovementByLine, itemsPerLine, by='LINE')
lineSummary = arrange(lineSummary, -CASES.SOLD)
#casesPerDay = lineSummary$CASES.PER.DAY = round(lineSummary$CASES.SOLD / productionDays)
lineSummary




casesByLocationTtl = aggregate(CASES.SOLD ~ LOCATION, data=shipmentsLocations, FUN=sum)
casesByLocationTtl = arrange(casesByLocationAvg, -CASES.SOLD)
head(casesByLocationTtl, 50) 



print('Print results to a file for distribution')
setwd("C:/Users/pmwash/Desktop/R_Files/Data Output")
write.xlsx(lineSummary, file='Velocity_STL.xlsx', sheetName='Line Summary')
write.xlsx(a.btl.line, file='Velocity_STL.xlsx', sheetName='A Rack', append=TRUE)
write.xlsx(b.btl.line, file='Velocity_STL.xlsx', sheetName='B Rack', append=TRUE)
write.xlsx(c.line, append=TRUE, file='Velocity_STL.xlsx', sheetName='C Line')
write.xlsx(d.line, append=TRUE, file='Velocity_STL.xlsx', sheetName='D Line')
write.xlsx(e.line, append=TRUE, file='Velocity_STL.xlsx', sheetName='E Line')
write.xlsx(f.line, append=TRUE, file='Velocity_STL.xlsx', sheetName='F Line')
write.xlsx(g.line, append=TRUE, file='Velocity_STL.xlsx', sheetName='G Line')
write.xlsx(h.line, append=TRUE, file='Velocity_STL.xlsx', sheetName='H Line')
write.xlsx(keg.room, append=TRUE, file='Velocity_STL.xlsx', sheetName='Keg Room')
write.xlsx(wine.room, append=TRUE, file='Velocity_STL.xlsx', sheetName='Wine Room')
write.xlsx(oddball, append=TRUE, file='Velocity_STL.xlsx', sheetName='Oddball')
write.xlsx(itemsWithInventoryButNoSales, append=TRUE, file='Velocity_STL.xlsx', sheetName='Items in Inventory wo Sales')
write.xlsx(itemsWithSalesButNoLocations, append=TRUE, file='Velocity_STL.xlsx', sheetName='Items Sold wo Locations')




####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####
####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####
####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####
####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####


library(ggplot2)
g = ggplot(data=lineSummary, aes(x=LINE, y=PERCENT.TOTAL.CASES))
g + geom_bar(stat='identity')

g = ggplot(data=caseMovementByLine, aes(x=LINE, y=CASES.SOLD))
g + geom_bar(stat='identity', aes(group=LINE)) + facet_wrap(~LINE, scales='free') + 
  geom_smooth(aes(group=LINE, colour=LINE), se=FALSE, size=1.25) +
  theme(axis.text.x=element_text(angle=90, hjust=1)) + theme_bw() +
  theme(axis.text.x=element_blank(), legend.position='none') + 
  labs(title='Daily Velocity by Line', x='Date', y='Cases Sold')













































##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
# RE-ENGINEERING VELOCITY
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################

# VELOCITY REPORT
# Query ran for 6/1 - 9/30 for 2015
productionDays = 70 # There were 70 production days between 6/1 - 9/30

# Create functions needed later
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
isNumeric = function(x) {
  grepl("^(0|[1-9][0-9]*)$", x)
}


setwd("C:/Users/pmwash/Desktop/R_Files/Data Input")
library(dplyr)
btlVel = read.csv('bottle_velocity.csv', header=TRUE)
btlVel$PICK.FREQUENCY = as.numeric(btlVel$PICK.FREQUENCY)
btlVel$BOTTLE.SALES = as.numeric(btlVel$BOTTLE.SALES)

btlVel = arrange(btlVel, desc(BOTTLE.SALES))
btlVel$BOTTLES.PER.PICK = btlVel$BOTTLE.SALES / btlVel$PICK.FREQUENCY
btlVel$BTL.LINE.INDICATOR = substrLeft(btlVel$BOTTLE.LOCATION, 1)

###########################################################################################

csVel = read.csv('case_velocity.csv', header=TRUE)
csVel = filter(csVel, CASE.LOCATION != "")

csVel$PICK.FREQUENCY = as.numeric(csVel$PICK.FREQUENCY)
csVel$BOTTLE.SALES = as.numeric(csVel$CASE.SALES)
csVel$CASE.SALES = as.numeric(csVel$CASE.SALES)

csVel = arrange(csVel, desc(CASE.SALES))
csVel$BOTTLES.PER.PICK = csVel$BOTTLE.SALES / csVel$PICK.FREQUENCY
csVel$CS.LINE.INDICATOR = substrLeft(csVel$CASE.LOCATION, 1)
csVel$BTL.LINE.INDICATOR = substrLeft(csVel$BOTTLE.LOCATION, 1)

#filter out bogus location
csVel = filter(csVel, CASE.LOCATION != 'FRONT')


loc = csVel$CASE.LOCATION
line = csVel$CS.LINE.INDICATOR
unique(csVel$CS.LINE.INDICATOR)
csVel$CS.LINE = ifelse(line == 'C', 'C-LINE', 
                        ifelse(line == 'D', 'D-LINE', 
                               ifelse(line == 'E', 'E-LINE', 
                                      ifelse(line == 'F', 'F-LINE',
                                             ifelse(line == 'G', 'G-LINE',  
                                                    ifelse(line=='W'|line=='H'|line=='J'|line=='K'|line=='M'|line=='R'|line=='S'|line=='T'|line=='Y'|line=='Z'|
                                                             grepl('(^([0-9]{2})(F)([0-9]{1}))', loc)==TRUE | grepl('([0-9]{2}R[0-9]{2})', loc)==TRUE|isNumeric(loc)==TRUE|
                                                             grepl('^(L[0-9]{2}[A-Z][0-9]{1}$)', loc)==TRUE|grepl('LCKUP', loc)==TRUE, 'ODDBALL', 
                                                           ifelse(line=='A', 'A-Rack', 
                                                                  ifelse(line=='B', 'B-Rack', 
                                                                         ifelse(grepl('^([0-9]{2})A([0-9]{1})', loc)==TRUE, 'KEG ROOM','check again')))))))))
line = csVel$BTL.LINE.INDICATOR
loc = csVel$CASE.LOCATION
csVel$BTL.LINE = ifelse(line == 'C', 'C-LINE', 
                        ifelse(line == 'D', 'D-LINE', 
                               ifelse(line == 'E', 'E-LINE', 
                                      ifelse(line == 'F', 'F-LINE',
                                             ifelse(line == 'G', 'G-LINE',  
                                                    ifelse(line=='W'|line=='H'|line=='J'|line=='K'|line=='M'|line=='R'|line=='S'|line=='T'|line=='Y'|line=='Z'|
                                                             grepl('^([0-9]{2})(F)([0-9]{1})', loc)==TRUE | grepl('([0-9]{2}R[0-9]{2})', loc)==TRUE|isNumeric(loc)==TRUE|
                                                             grepl('^(L[0-9]{2}[A-Z][0-9]{1}$)', loc)==TRUE|grepl('LCKUP', loc)==TRUE, 'ODDBALL', 
                                                           ifelse(line=='A', 'A-Rack', 
                                                                  ifelse(line=='B', 'B-Rack', 
                                                                         ifelse(grepl('^([0-9]{2})A([0-9]{1})', loc)==TRUE, 'KEG ROOM','check again')))))))))



#ifelse(is.na(as.numeric(loc))==TRUE, 'ODDBALL', 'check again')
#ifelse(grepl('([;digit:])', loc)==TRUE, 'ODDBALL', 'check again')
#grepl('([0-9]{2}R[0-9]{2})', loc)



DESC = csVel$SIZE
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

csVel$IS.KEG = ifelse(grepl(k1, DESC) == TRUE, 'YES', 
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
                                                                                                                                      ifelse(grepl(k16, DESC), 'YES',
                                                                                                                                             ifelse(grepl(k17, DESC), 'YES', 
                                                                                                                                                    ifelse(grepl(k18, DESC), 'YES', 
                                                                                                                                                           ifelse(grepl(k19, DESC), 'YES', 'NO')))))))))))))))))))

# separate out cases that came from the keg room (which are oddballs) from kegs from keg room
LINE = csVel$CS.LINE
ISKEG = csVel$IS.KEG
csVel$CS.LINE = ifelse(ISKEG == 'YES', 'KEG ROOM', LINE)


# sort
csVel = arrange(csVel, desc(CASE.SALES))


# CHECKS
head(csVel, 20)
unique(csVel$CS.LINE)
check = filter(csVel, CS.LINE=='check again')
ok = list(unique(check$CASE.LOCATION))
names(ok) = 'Locations Not Categorized'
#setwd("C:/Users/pmwash/Desktop/R_Files/Data Output")
#write.csv(ok, 'caseLocations_notOddball_notOnLine_needCategorizationRules.csv')

# Aggregate by product
caseMovementByProduct = aggregate(CASE.SALES ~ DESCRIPTION + PRODUCT.ID, data=csVel, FUN=sum)
caseMovementByProduct = arrange(caseMovementByProduct, desc(CASE.SALES))

totes = sum(caseMovementByProduct$CASE.SALES)
share = caseMovementByProduct$CASE.SALES
caseMovementByProduct$PERCENT.TOTAL.CASES = round(share / totes, 7)
caseMovementByProduct$AVG.CASES.PER.DAY = round(share / productionDays, 2)

head(caseMovementByProduct)



# Aggregate by product location
caseMovementByProductLocation = aggregate(CASE.SALES ~ CS.LINE, 
                                           data=csVel, FUN=sum)
caseMovementByProductLocation = arrange(caseMovementByProductLocation, desc(CASE.SALES))
head(caseMovementByProductLocation,10)


# check for accuracy
oddballCheck = filter(csVel, CS.LINE == 'ODDBALL')
oddballLocs = data.frame(unique(oddballCheck$CASE.LOCATION))
oddballLocs = arrange(oddballLocs, unique.oddballCheck.CASE.LOCATION.)
length(oddballLocs$unique.oddballCheck.CASE.LOCATION.)
#setwd("C:/Users/pmwash/Desktop/R_Files/Data Output")
#write.csv(oddballLocs, 'oddball_locations.csv')


g = ggplot(data=caseMovementByProductLocation, aes(x=CS.LINE, y=CASE.SALES))
g+geom_bar(stat='identity')











#########working below


head(caseMovementByProduct, 50)






cases = caseMovementByProductLocation$CASES.SOLD
caseMovementByProductLocation$CASES.PER.NIGHT = round(cases / productionDays)
head(caseMovementByProductLocation, 50)

oddball = filter(caseMovementByProductLocation, LINE=='ODDBALL')
c.line = filter(caseMovementByProductLocation, LINE=='C-LINE')
d.line = filter(caseMovementByProductLocation, LINE=='D-LINE')
e.line = filter(caseMovementByProductLocation, LINE=='E-LINE')
f.line = filter(caseMovementByProductLocation, LINE=='F-LINE')
g.line = filter(caseMovementByProductLocation, LINE=='G-LINE')
h.line = filter(caseMovementByProductLocation, LINE=='H-LINE')
keg.room = filter(caseMovementByProductLocation, LINE=='KEG ROOM')

caseMovementByLine = aggregate(CASES.SOLD ~ LINE, data=shipmentsLocations, FUN=sum) 
caseMovementByLine = arrange(caseMovementByLine, -CASES.SOLD)
cases = caseMovementByLine$CASES.SOLD
total = sum(caseMovementByLine$CASES.SOLD)
caseMovementByLine$PERCENT.OF.TOTAL = round(cases / total, 3)
caseMovementByLine


caseMovementByLineByDate = aggregate(CASES.SOLD ~ LINE + INVOICE.DATE, data=shipmentsLocations,
                                      FUN=sum) 
caseMovementByLineByDate = arrange(caseMovementByLineByDate, -CASES.SOLD)
cases = caseMovementByLineByDate$CASES.SOLD
total = sum(caseMovementByLineByDate$CASES.SOLD)
caseMovementByLineByDate$PERCENT.OF.TOTAL = round(cases / total, 3)
head(caseMovementByLineByDate)




itemsPerLine = aggregate(DESCRIPTION ~ LINE, data=shipmentsLocations, FUN=countUnique)


lineSummary = merge(caseMovementByLine, itemsPerLine, by='LINE')
lineSummary = arrange(lineSummary, -CASES.SOLD)
names(lineSummary) = c('LINE', 'CASES.SOLD', 'PERCENT.TOTAL.CASES', 'NUMBER.UNIQUE.ITEMS')
casesPerDay = lineSummary$CASES.PER.DAY = round(lineSummary$CASES.SOLD / productionDays)
lineSummary




casesByLocationAvg = aggregate(CASES.SOLD ~ LOCATION, data=shipmentsLocations, FUN=mean)
casesByLocationAvg = arrange(casesByLocationAvg, -CASES.SOLD)
ROUNDED = round(casesByLocationAvg$CASES.SOLD)
casesByLocationAvg$CASES.SOLD = ROUNDED
names(casesByLocationAvg) = c('LOCATION', 'AVG.DAILY.VELOCITY')

head(casesByLocationAvg, 50)












