
# Identifying salespersons who's accounts are delivered on off-days
# Data from "Pivot by Delivery" tab in Delivery Audit report

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

substrLeft <- function(x, n){
  substr(x, 1, n)
}


deliveries <- read.csv("deliveries.csv", header=TRUE)
names(deliveries) <- toupper(names(deliveries))


date <- deliveries$DATE
date <- as.character(substrRight(date, 6))
deliveries$DATE <- as.character((strptime(date, "%y%m%d")))



library(stringr)
days <- as.character(deliveries$SHIP.FLAG)
days <- str_pad(days, 7, pad='0')

deliveries$SUNDAY.PLAN <- ifelse(substrRight(days, 1) == 1, "SUN", "")
deliveries$SATURDAY.PLAN <- ifelse(substrLeft(substrRight(days, 2), 1) == 1, "SAT", "")
deliveries$FRIDAY.PLAN <- ifelse(substrLeft(substrRight(days, 3), 1) == 1, "FRI", "")
deliveries$THURSDAY.PLAN <- ifelse(substrLeft(substrRight(days, 4), 1) == 1, "THUR", "")
deliveries$WEDNESDAY.PLAN <- ifelse(substrLeft(substrRight(days, 5), 1) == 1, "WED", "")
deliveries$TUESDAY.PLAN <- ifelse(substrLeft(substrRight(days, 6), 1) == 1, "TUE", "")
deliveries$MONDAY.PLAN <- ifelse(substrLeft(substrRight(days, 7), 1) == 1, "MON", "")


actual <- deliveries$WEEK.DAY
sun <- deliveries$SUNDAY.PLAN
sat <- deliveries$SATURDAY.PLAN
fri <- deliveries$FRIDAY.PLAN
thurs <- deliveries$THURSDAY.PLAN
wed <- deliveries$WEDNESDAY.PLAN
tues <- deliveries$TUESDAY.PLAN
mon <- deliveries$MONDAY.PLAN

deliveries$OFF.DAY.DELIVERY <- 
  ifelse(actual == sun, 'NO', 
         ifelse(actual == sat, 'NO', 
                ifelse(actual == fri, 'NO', 
                       ifelse(actual == thurs, 'NO',
                              ifelse(actual == wed, 'NO', 
                                     ifelse(actual == tues, 'NO',
                                            ifelse(actual == mon, 'NO', 'YES')))))))

deliveries$DAYS.SCHEDULED.FOR.DELIVERY <- paste(mon, tues, wed, thurs, fri, sat, sun, sep=".")
deliveries <- arrange(deliveries, -CASES) #sort large to small so highest volume 

head(deliveries)
str(deliveries)

offDayDeliveries <- filter(deliveries, OFF.DAY.DELIVERY == 'YES')

offDayClients <- aggregate(CASES ~ CUSTOMER + CUST.., data=offDayDeliveries, FUN=sum)
offDayClients <- arrange(offDayClients, -CASES)

offDayCount <- aggregate(CASES ~ CUSTOMER + CUST.., data=offDayDeliveries, FUN=length)
offDayCount <- arrange(offDayCount, -CASES)
names(offDayCount) <- c('CUSTOMER', 'CUST..', 'NUMBER.OFF.DAY.DELIVERIES')
filter(deliveries, CUST.. == 3283) #quick check

offDaySummary <- merge(offDayClients, offDayCount, by=c('CUST..', 'CUSTOMER'))
offDaySummary <- arrange(offDaySummary, -NUMBER.OFF.DAY.DELIVERIES)

offDaySummary$AVG.OFF.DAY.CASES <- round(offDaySummary$CASES / offDaySummary$NUMBER.OFF.DAY.DELIVERIES, 1)





