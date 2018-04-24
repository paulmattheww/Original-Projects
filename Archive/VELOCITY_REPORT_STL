
# VELOCITY REPORT
# Query ran for 6/1 - 9/30 for 2015
productionDays <- 70 # There were 70 production days between 6/1 - 9/30

# Create functions needed later
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}
substrLeft <- function(x, n){
  substr(x, 1, n)
}
as400Date <- function(x) {
  date <- as.character(x)
  date <- substrRight(date, 6)
  date <- as.character((strptime(date, "%y%m%d")))
  date
}
countUnique <- function(x) {
  length(unique(x))
}


# Read in and merge the data
library(dplyr)
setwd("C:/Users/pmwash/Desktop/R_Files")
shipments <- read.csv('camtc1bk.csv', header=TRUE) # query containing transactions 
names(shipments) <- c('ITEM.NUMBER', 'CASES', 'QTY.SOLD', 'INVOICE.DATE', 'INVOICE.NO',
                      'QTY.PER.CASE', 'CLASS.CODE', 'SIZE.CODE', 'LINE.ITEM.NO', 'TRNS.CODE')

shipments$INVOICE.DATE <- as400Date(shipments$INVOICE.DATE)
shipments$TRNS.CODE <- as.character(shipments$TRNS.CODE)
head(shipments)
shipments <- na.omit(shipments)
shipments <- arrange(shipments, ITEM.NUMBER)

locations <- read.csv('product_locations_10232015.csv', header=TRUE)
names(locations) <- toupper(names(locations))
library(dplyr)
locations <- select(locations, c(ITEM.NUMBER, DESCRIPTION, LOCATION, QPC))
locations <- arrange(locations, ITEM.NUMBER)
head(locations, 200)


shipmentsLocations <- merge(shipments, locations, by="ITEM.NUMBER")
shipmentsLocations <- select(shipmentsLocations, c(ITEM.NUMBER, DESCRIPTION, LOCATION, CASES,
                                          QTY.PER.CASE, QTY.SOLD, CLASS.CODE, SIZE.CODE,
                                          TRNS.CODE, LINE.ITEM.NO, INVOICE.NO, INVOICE.DATE))
names(shipmentsLocations) <- c('ITEM.NUMBER', 'DESCRIPTION', 'LOCATION', 'CASES.SOLD',
                               'QTY.PER.CASE', 'QTY.SOLD', 'CLASS.CODE', 'SIZE.CODE',
                               'TRNS.CODE', 'LINE.ITEM.NO', 'INVOICE.NO', 'INVOICE.DATE')
shipmentsLocations$ITEM.NUMBER <- factor(shipmentsLocations$ITEM.NUMBER)
shipmentsLocations$LINE.IDENTIFIER <- substrLeft(shipmentsLocations$LOCATION, 1)

head(shipmentsLocations)

line <- shipmentsLocations$LINE.IDENTIFIER

forDelete <- grepl("(\\d)", line) # delete digits and A & B from line identifier 
shipmentsLocations <- shipmentsLocations[!forDelete,]
shipmentsLocations <- filter(shipmentsLocations, shipmentsLocations$LINE.IDENTIFIER != "A")
shipmentsLocations <- filter(shipmentsLocations, shipmentsLocations$LINE.IDENTIFIER != "B")

line <- shipmentsLocations$LINE.IDENTIFIER
shipmentsLocations$LINE <- ifelse(line == 'C', 'C-LINE', 
         ifelse(line == 'D', 'D-LINE', 
                ifelse(line == 'E', 'E-LINE', 
                       ifelse(line == 'F', 'F-LINE',
                              ifelse(line == 'G', 'G-LINE', 
                                     ifelse(line == 'H', 'H-LINE',
                                            ifelse(line == 'K', 'KEG ROOM',
                                                   ifelse(line == 'R', 'BULK/REPACK',
                                                          ifelse(line=='M'|line=='Z'|line=='Y'|line=='T'|line=='J'|line=='L'|line=='S', 'ODDBALL', 'ODDBALL')))))))))

DESC <- shipmentsLocations$DESCRIPTION
k1 <- "\\<1/6BL\\>" 
k2 <- "\\<1/2BL\\>"
k3 <- "\\<1/4BL\\>"
k4 <- "\\<20L\\>"
k5 <- "\\<10.8G\\>"
k6 <- "\\<15.5G\\>"
k7 <- "\\<15L\\>"
k8 <- "\\<2.6G\\>"
k9 <- "\\<19L\\>"
k10 <- "\\<3.3G\\>"
k11 <- "\\<4.9G\\>"
k12 <- "\\<5.16G\\>"
k13 <- "\\<5.2G\\>"
k14 <- "\\<5.4G\\>"
k15 <- "\\<19.5L\\>"
k16 <- "\\<50L\\>"
k17 <- "\\<30L\\>"
k18 <- "\\<5G\\>"
k19 <- "\\<25L\\>"


shipmentsLocations$IS.KEG <- ifelse(grepl(k1, DESC) == TRUE, 'YES', 
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
LINE <- shipmentsLocations$LINE
ISKEG <- shipmentsLocations$IS.KEG
shipmentsLocations$LINE <- ifelse(LINE == 'KEG ROOM' & ISKEG == 'NO', 'ODDBALL', LINE)

shipmentsLocations <- arrange(shipmentsLocations, ITEM.NUMBER)

head(shipmentsLocations, 100)


  

####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####
####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####
####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####
####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####


caseMovementByProduct = aggregate(CASES.SOLD ~ DESCRIPTION + ITEM.NUMBER, data=shipmentsLocations, FUN=sum)
caseMovementByProduct <- arrange(caseMovementByProduct, -CASES.SOLD)
totes <- sum(caseMovementByProduct$CASES.SOLD)
share <- caseMovementByProduct$CASES.SOLD
caseMovementByProduct$PERCENT.TOTAL.CASES <- round(share / totes, 3)
caseMovementByProduct$AVG.CASES.PER.DAY <- round(share / productionDays, 2)
head(caseMovementByProduct, 50)




caseMovementByProductLocation <- aggregate(CASES.SOLD ~ LOCATION + LINE, 
                                           data=shipmentsLocations, FUN=sum)
caseMovementByProductLocation <- arrange(caseMovementByProductLocation, -CASES.SOLD)
cases <- caseMovementByProductLocation$CASES.SOLD
caseMovementByProductLocation$CASES.PER.NIGHT <- round(cases / productionDays)
head(caseMovementByProductLocation, 50)

oddball <- filter(caseMovementByProductLocation, LINE=='ODDBALL')
c.line <- filter(caseMovementByProductLocation, LINE=='C-LINE')
d.line <- filter(caseMovementByProductLocation, LINE=='D-LINE')
e.line <- filter(caseMovementByProductLocation, LINE=='E-LINE')
f.line <- filter(caseMovementByProductLocation, LINE=='F-LINE')
g.line <- filter(caseMovementByProductLocation, LINE=='G-LINE')
h.line <- filter(caseMovementByProductLocation, LINE=='H-LINE')
keg.room <- filter(caseMovementByProductLocation, LINE=='KEG ROOM')

caseMovementByLine <- aggregate(CASES.SOLD ~ LINE, data=shipmentsLocations, FUN=sum) 
caseMovementByLine <- arrange(caseMovementByLine, -CASES.SOLD)
cases <- caseMovementByLine$CASES.SOLD
total <- sum(caseMovementByLine$CASES.SOLD)
caseMovementByLine$PERCENT.OF.TOTAL <- round(cases / total, 3)
caseMovementByLine


caseMovementByLineByDate <- aggregate(CASES.SOLD ~ LINE + INVOICE.DATE, data=shipmentsLocations,
                                FUN=sum) 
caseMovementByLineByDate <- arrange(caseMovementByLineByDate, -CASES.SOLD)
cases <- caseMovementByLineByDate$CASES.SOLD
total <- sum(caseMovementByLineByDate$CASES.SOLD)
caseMovementByLineByDate$PERCENT.OF.TOTAL <- round(cases / total, 3)
head(caseMovementByLineByDate)




itemsPerLine <- aggregate(DESCRIPTION ~ LINE, data=shipmentsLocations, FUN=countUnique)


lineSummary <- merge(caseMovementByLine, itemsPerLine, by='LINE')
lineSummary <- arrange(lineSummary, -CASES.SOLD)
names(lineSummary) <- c('LINE', 'CASES.SOLD', 'PERCENT.TOTAL.CASES', 'NUMBER.UNIQUE.ITEMS')
casesPerDay <- lineSummary$CASES.PER.DAY <- round(lineSummary$CASES.SOLD / productionDays)
lineSummary




casesByLocationAvg <- aggregate(CASES.SOLD ~ LOCATION, data=shipmentsLocations, FUN=mean)
casesByLocationAvg <- arrange(casesByLocationAvg, -CASES.SOLD)
ROUNDED <- round(casesByLocationAvg$CASES.SOLD)
casesByLocationAvg$CASES.SOLD <- ROUNDED
names(casesByLocationAvg) <- c('LOCATION', 'AVG.DAILY.VELOCITY')

head(casesByLocationAvg, 50)


library(xlsx)
write.xlsx2(lineSummary, file='VelocitySummary_10262015.xlsx', sheetName='velocityByLine')
write.xlsx2(caseMovementByProduct, append=TRUE,
           file='VelocitySummary_10262015.xlsx', sheetName='velocityByProduct')
write.xlsx2(caseMovementByProductLocation, append=TRUE,
           file='VelocitySummary_10262015.xlsx', sheetName='velocityByLocation')

library(xlsx)
write.xlsx2(oddball, file='VelocityReport_byLine_10262015.xlsx', sheetName='oddballs')
write.xlsx2(g.line, append=TRUE,
           file='VelocityReport_byLine_10262015.xlsx', sheetName='G')
write.xlsx2(c.line, append=TRUE,
           file='VelocityReport_byLine_10262015.xlsx', sheetName='C')
write.xlsx2(e.line, append=TRUE,
           file='VelocityReport_byLine_10262015.xlsx', sheetName='E')
write.xlsx2(d.line, append=TRUE,
           file='VelocityReport_byLine_10262015.xlsx', sheetName='D')
write.xlsx2(f.line, append=TRUE,
           file='VelocityReport_byLine_10262015.xlsx', sheetName='F')
write.xlsx2(h.line, append=TRUE,
           file='VelocityReport_byLine_10262015.xlsx', sheetName='H')
write.xlsx2(keg.room, append=TRUE,
           file='VelocityReport_byLine_10262015.xlsx', sheetName='kegRoom')


# Move files
moveRenameFile <- function(from, to) {
  destination <- dirname(to)
  if (!isTRUE(file.info(destination)$isdir)) dir.create(destination, recursive=TRUE)
  file.rename(from = from,  to = to)
}

to <- "N:/Operations-IT/Operations Specialist/Velocity   !/VelocitySummary_10262015.xlsx"
from <- "C:/Users/pmwash/Desktop/R_files/VelocitySummary_10262015.xlsx"
moveRenameFile(from, to)


####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####
####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####
####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####
####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####  ####


library(ggplot2)
g <- ggplot(data=lineSummary, aes(x=LINE, y=PERCENT.TOTAL.CASES))
g + geom_bar(stat='identity')

g <- ggplot(data=caseMovementByLineByDate, aes(x=INVOICE.DATE, y=CASES.SOLD, group=LINE))
g + geom_point(aes(group=LINE)) + facet_wrap(~LINE, scales='free') + 
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

library(dplyr)
btlVel <- read.csv('bottle_velocity.csv', header=TRUE)
btlVel$PICK.FREQUENCY <- as.numeric(btlVel$PICK.FREQUENCY)
btlVel$BOTTLE.SALES <- as.numeric(btlVel$BOTTLE.SALES)

btlVel <- arrange(btlVel, desc(BOTTLE.SALES))
btlVel$BOTTLES.PER.PICK <- btlVel$BOTTLE.SALES / btlVel$PICK.FREQUENCY
###########################################################################################
csVel <- read.csv('case_velocity.csv', header=TRUE)
csVel$PICK.FREQUENCY <- as.numeric(csVel$PICK.FREQUENCY)
csVel$BOTTLE.SALES <- as.numeric(csVel$CASE.SALES)

csVel <- arrange(csVel, desc(CASE.SALES))
csVel$BOTTLES.PER.PICK <- csVel$BOTTLE.SALES / csVel$PICK.FREQUENCY
csVel$CS.LINE.INDICATOR <- substrLeft(csVel$CASE.LOCATION, 1)

DESC <- csVel$SIZE
k1 <- "\\<1/6BL\\>" 
k2 <- "\\<1/2BL\\>"
k3 <- "\\<1/4BL\\>"
k4 <- "\\<20L\\>"
k5 <- "\\<10.8G\\>"
k6 <- "\\<15.5G\\>"
k7 <- "\\<15L\\>"
k8 <- "\\<2.6G\\>"
k9 <- "\\<19L\\>"
k10 <- "\\<3.3G\\>"
k11 <- "\\<4.9G\\>"
k12 <- "\\<5.16G\\>"
k13 <- "\\<5.2G\\>"
k14 <- "\\<5.4G\\>"
k15 <- "\\<19.5L\\>"
k16 <- "\\<50L\\>"
k17 <- "\\<30L\\>"
k18 <- "\\<5G\\>"
k19 <- "\\<25L\\>"

csVel$IS.KEG <- ifelse(grepl(k1, DESC) == TRUE, 'YES', 
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
LINE <- shipmentsLocations$LINE
ISKEG <- shipmentsLocations$IS.KEG
shipmentsLocations$LINE <- ifelse(LINE == 'KEG ROOM' & ISKEG == 'NO', 'ODDBALL', LINE)

shipmentsLocations <- arrange(shipmentsLocations, ITEM.NUMBER)

head(shipmentsLocations, 100)















