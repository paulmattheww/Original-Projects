
# Identifying salespersons who's accounts are delivered on off-days
# Data from "Pivot by Delivery" tab in Delivery Audit report
setwd("C:/Users/pmwash/Desktop/R_Files")

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
library(dplyr)
deliveries <- arrange(deliveries, -CASES) #sort large to small so highest volume 
deliveries <- select(deliveries,(c(DATE, CUST.., CUSTOMER, COMP, SHIP.FLAG, 
                                          CITY, CASES, DOLLARS, COMPANY, TIER,
                                          OFF.DAY.DELIVERY, DAYS.SCHEDULED.FOR.DELIVERY)))
head(deliveries, 25)
str(deliveries)



# ##  ### ####  ##### ######  ####### # ##  ### ####  ##### ######  ####### # ##  ### ####  ##### ######  #######



offDayDeliveries <- filter(deliveries, OFF.DAY.DELIVERY == 'YES')

offDayClients <- aggregate(CASES ~ CUSTOMER + CUST.. + CITY + COMP, data=offDayDeliveries, FUN=sum)
offDayClients <- arrange(offDayClients, -CASES)
#head(offDayClients)
names(offDayClients) <- c('CUSTOMER', 'CUST..', 'CITY', 'COMP','CASES')

offDayCount <- aggregate(CASES ~ CUSTOMER + CUST.. + CITY + COMP, data=offDayDeliveries, FUN=length)
offDayCount <- arrange(offDayCount, -CASES)
#head(offDayCount)
names(offDayCount) <- c('CUSTOMER', 'CUST..', 'CITY', 'COMP','NUMBER.OFF.DAY.DELIVERIES')
#filter(deliveries, CUST.. == 3283) #quick check

offDaySummary <- merge(offDayClients, offDayCount, by=c('CUST..', 'CUSTOMER', 'COMP', 'CITY'))
offDaySummary <- arrange(offDaySummary, -NUMBER.OFF.DAY.DELIVERIES)

offDaySummary$AVG.OFF.DAY.CASES <- round(offDaySummary$CASES / offDaySummary$NUMBER.OFF.DAY.DELIVERIES, 1)

head(offDaySummary)

# ##  ### ####  ##### ######  ####### # ##  ### ####  ##### ######  ####### # ##  ### ####  ##### ######  #######



repClient <- read.csv('key_value_salesperson_customer.csv', header=TRUE)
head(repClient)

salespeople <- aggregate(Salesperson ~ Customer, data=repClient, FUN=paste)
count <- aggregate(Salesperson ~ Customer, data=repClient, FUN=length)
count <- arrange(count, -Salesperson)

customerSalespeople <- merge(count, salespeople, by='Customer')
#head(customerSalespeople)
names(customerSalespeople) <- c('Customer', 'Number.of.Salespeople', 'Salespeople')

rawCustNo <- substrRight(as.character(customerSalespeople$Customer), 10)
customerSalespeople$CUST.. <- str_extract(rawCustNo, "(([0-9]+))")

# ##  ### ####  ##### ######  ####### # ##  ### ####  ##### ######  ####### # ##  ### ####  ##### ######  #######

head(customerSalespeople)
head(offDaySummary)
filter(offDaySummary, CUST.. == 10382) #quick check
filter(customerSalespeople, CUST.. == 10382) #quick check
print("NOTE: CLIENTS ON EDI WILL NOT BE REPRESENTED!")

moneyShot <- merge(offDaySummary, customerSalespeople, by='CUST..')
names(moneyShot) <- c('CUSTOMER.NUMBER', 'CUSTOMER', 'WAREHOUSE', 'CITY', 'CASES', 'NUMBER.OFF.DAY.DELIVERIES', 
                      'AVG.OFF.DAY.CASES', 'Customer2', 'NUMBER.OF.SALESPEOPLE', 'SALESPEOPLE')
moneyShot <- moneyShot[, -8]
moneyShot <- moneyShot[, c(8, 2, 1, 3:7, 9)]
moneyShot <- data.frame(moneyShot)
moneyShot$SALESPEOPLE <- as.character(moneyShot$SALESPEOPLE)
moneyShot <- arrange(moneyShot, -NUMBER.OFF.DAY.DELIVERIES)

head(moneyShot, 50)
write.csv(moneyShot, file='90days_OffDayDeliveries_SalespeopleCustomerWarehouse.csv')


# ##  ### ####  ##### ######  ####### # ##  ### ####  ##### ######  ####### # ##  ### ####  ##### ######  #######



frequencyOffDayByRep <- aggregate(NUMBER.OFF.DAY.DELIVERIES ~ SALESPEOPLE, data=moneyShot, FUN=sum)
frequencyOffDayByRep <- arrange(frequencyOffDayByRep, -NUMBER.OFF.DAY.DELIVERIES)
head(frequencyOffDayByRep, 50)
write.csv(frequencyOffDayByRep, file='OffDayDeliveries_frequencyOffDayByRep.csv')


offDayClientsNotOnEDI <- aggregate(NUMBER.OFF.DAY.DELIVERIES ~ CUSTOMER + CITY + COMP, data=offDaySummary, FUN=sum)
offDayClientsNotOnEDI <- arrange(offDayClientsNotOnEDI, -NUMBER.OFF.DAY.DELIVERIES)

head(offDayClientsNotOnEDI, 50)






