

################################################ 2014 ####################
##########################################################################


# january 2014
library(chron)
library(lubridate)
januaryBeg <- as.Date("01/01/2014", "%m/%d/%Y")
januaryEnd <- as.Date("01/31/2014", "%m/%d/%Y")

january <- seq(januaryBeg, januaryEnd, by=1)
january <- data.frame(january)

# Don't forget to mark HOLIDAYS too
january$Is.Monday <- NA
january$Is.Monday <- ifelse(weekdays(january$january, abbr=TRUE) == "Mon", "Y", "N")
january$Is.Saturday <- NA
january$Is.Saturday <- ifelse(weekdays(january$january, abbr=TRUE) == "Sat", "Y", "N")
january$Is.Sunday <- NA
january$Is.Sunday <- ifelse(weekdays(january$january, abbr=TRUE) == "Sun", "Y", "N")

january <- january[which(january$Is.Monday != "Y"),]
january <- january[which(january$Is.Saturday != "Y"),]
january <- january[which(january$Is.Sunday != "Y"),]

numberProductionDays <- length(january$january)
januaryDays <- numberProductionDays
january

thisMonth <- month(januaryBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

january2014 <- numberProductionDays
january2014




# february 2014
library(chron)
library(lubridate)
februaryBeg <- as.Date("02/01/2014", "%m/%d/%Y")
februaryEnd <- as.Date("02/28/2014", "%m/%d/%Y")

february <- seq(februaryBeg, februaryEnd, by=1)
february <- data.frame(february)

# Don't forget to mark HOLIDAYS too
february$Is.Monday <- NA
february$Is.Monday <- ifelse(weekdays(february$february, abbr=TRUE) == "Mon", "Y", "N")
february$Is.Saturday <- NA
february$Is.Saturday <- ifelse(weekdays(february$february, abbr=TRUE) == "Sat", "Y", "N")
february$Is.Sunday <- NA
february$Is.Sunday <- ifelse(weekdays(february$february, abbr=TRUE) == "Sun", "Y", "N")

february <- february[which(february$Is.Monday != "Y"),]
february <- february[which(february$Is.Saturday != "Y"),]
february <- february[which(february$Is.Sunday != "Y"),]

numberProductionDays <- length(february$february)
februaryDays <- numberProductionDays
february

thisMonth <- month(februaryBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

february2014 <- numberProductionDays
february2014



# march 2014
library(chron)
library(lubridate)
marchBeg <- as.Date("03/01/2014", "%m/%d/%Y")
marchEnd <- as.Date("03/31/2014", "%m/%d/%Y")

march <- seq(marchBeg, marchEnd, by=1)
march <- data.frame(march)

# Don't forget to mark HOLIDAYS too
march$Is.Monday <- NA
march$Is.Monday <- ifelse(weekdays(march$march, abbr=TRUE) == "Mon", "Y", "N")
march$Is.Saturday <- NA
march$Is.Saturday <- ifelse(weekdays(march$march, abbr=TRUE) == "Sat", "Y", "N")
march$Is.Sunday <- NA
march$Is.Sunday <- ifelse(weekdays(march$march, abbr=TRUE) == "Sun", "Y", "N")

march <- march[which(march$Is.Monday != "Y"),]
march <- march[which(march$Is.Saturday != "Y"),]
march <- march[which(march$Is.Sunday != "Y"),]

numberProductionDays <- length(march$march)
marchDays <- numberProductionDays
march

thisMonth <- month(marchBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

march2014 <- numberProductionDays
march2014




# april 2014
library(chron)
library(lubridate)
aprilBeg <- as.Date("04/01/2014", "%m/%d/%Y")
aprilEnd <- as.Date("04/30/2014", "%m/%d/%Y")

april <- seq(aprilBeg, aprilEnd, by=1)
april <- data.frame(april)

# Don't forget to mark HOLIDAYS too
april$Is.Monday <- NA
april$Is.Monday <- ifelse(weekdays(april$april, abbr=TRUE) == "Mon", "Y", "N")
april$Is.Saturday <- NA
april$Is.Saturday <- ifelse(weekdays(april$april, abbr=TRUE) == "Sat", "Y", "N")
april$Is.Sunday <- NA
april$Is.Sunday <- ifelse(weekdays(april$april, abbr=TRUE) == "Sun", "Y", "N")

april <- april[which(april$Is.Monday != "Y"),]
april <- april[which(april$Is.Saturday != "Y"),]
april <- april[which(april$Is.Sunday != "Y"),]

numberProductionDays <- length(april$april)
aprilDays <- numberProductionDays
april

thisMonth <- month(aprilBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

april2014 <- numberProductionDays
april2014


# may 2014
library(chron)
library(lubridate)
mayBeg <- as.Date("05/01/2014", "%m/%d/%Y")
mayEnd <- as.Date("05/31/2014", "%m/%d/%Y")

may <- seq(mayBeg, mayEnd, by=1)
may <- data.frame(may)

# Don't forget to mark HOLIDAYS too
may$Is.Monday <- NA
may$Is.Monday <- ifelse(weekdays(may$may, abbr=TRUE) == "Mon", "Y", "N")
may$Is.Saturday <- NA
may$Is.Saturday <- ifelse(weekdays(may$may, abbr=TRUE) == "Sat", "Y", "N")
may$Is.Sunday <- NA
may$Is.Sunday <- ifelse(weekdays(may$may, abbr=TRUE) == "Sun", "Y", "N")

may <- may[which(may$Is.Monday != "Y"),]
may <- may[which(may$Is.Saturday != "Y"),]
may <- may[which(may$Is.Sunday != "Y"),]

numberProductionDays <- length(may$may)
mayDays <- numberProductionDays
may

thisMonth <- month(mayBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

may2014 <- numberProductionDays
may2014




# June 2014
library(chron)
library(lubridate)
juneBeg <- as.Date("06/01/2014", "%m/%d/%Y")
juneEnd <- as.Date("06/30/2014", "%m/%d/%Y")

june <- seq(juneBeg, juneEnd, by=1)
june <- data.frame(june)

# Don't forget to mark HOLIDAYS too
june$Is.Monday <- NA
june$Is.Monday <- ifelse(weekdays(june$june, abbr=TRUE) == "Mon", "Y", "N")
june$Is.Saturday <- NA
june$Is.Saturday <- ifelse(weekdays(june$june, abbr=TRUE) == "Sat", "Y", "N")
june$Is.Sunday <- NA
june$Is.Sunday <- ifelse(weekdays(june$june, abbr=TRUE) == "Sun", "Y", "N")

june <- june[which(june$Is.Monday != "Y"),]
june <- june[which(june$Is.Saturday != "Y"),]
june <- june[which(june$Is.Sunday != "Y"),]

numberProductionDays <- length(june$june)
juneDays <- numberProductionDays
june

thisMonth <- month(juneBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

june2014 <- numberProductionDays
june2014



# July 2014
library(chron)
library(lubridate)
julyBeg <- as.Date("07/01/2014", "%m/%d/%Y")
julyEnd <- as.Date("07/31/2014", "%m/%d/%Y")

july <- seq(julyBeg, julyEnd, by=1)
july <- data.frame(july)

# Don't forget to mark HOLIDAYS too
july$Is.Monday <- NA
july$Is.Monday <- ifelse(weekdays(july$july, abbr=TRUE) == "Mon", "Y", "N")
july$Is.Saturday <- NA
july$Is.Saturday <- ifelse(weekdays(july$july, abbr=TRUE) == "Sat", "Y", "N")
july$Is.Sunday <- NA
july$Is.Sunday <- ifelse(weekdays(july$july, abbr=TRUE) == "Sun", "Y", "N")

july <- july[which(july$Is.Monday != "Y"),]
july <- july[which(july$Is.Saturday != "Y"),]
july <- july[which(july$Is.Sunday != "Y"),]

numberProductionDays <- length(july$july)
julyDays <- numberProductionDays
july

thisMonth <- month(julyBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

july2014 <- numberProductionDays
july2014



# augustust 2014
library(chron)
library(lubridate)
augustBeg <- as.Date("08/01/2014", "%m/%d/%Y")
augustEnd <- as.Date("08/31/2014", "%m/%d/%Y")

august <- seq(augustBeg, augustEnd, by=1)
august <- data.frame(august)

# Don't forget to mark HOLIDAYS too
august$Is.Monday <- NA
august$Is.Monday <- ifelse(weekdays(august$august, abbr=TRUE) == "Mon", "Y", "N")
august$Is.Saturday <- NA
august$Is.Saturday <- ifelse(weekdays(august$august, abbr=TRUE) == "Sat", "Y", "N")
august$Is.Sunday <- NA
august$Is.Sunday <- ifelse(weekdays(august$august, abbr=TRUE) == "Sun", "Y", "N")

august <- august[which(august$Is.Monday != "Y"),]
august <- august[which(august$Is.Saturday != "Y"),]
august <- august[which(august$Is.Sunday != "Y"),]

numberProductionDays <- length(august$august)
augustDays <- numberProductionDays
august

thisMonth <- month(augustBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

august2014 <- numberProductionDays
august2014


# September 2014
library(lubridate)
library(chron)
septemberBeg <- as.Date("09/01/2014", "%m/%d/%Y")
septemberEnd <- as.Date("09/30/2014", "%m/%d/%Y")

september <- seq(septemberBeg, septemberEnd, by=1)
september <- data.frame(september)

# Don't forget to mark HOLIDAYS too
september$Is.Monday <- NA
september$Is.Monday <- ifelse(weekdays(september$september, abbr=TRUE) == "Mon", "Y", "N")
september$Is.Saturday <- NA
september$Is.Saturday <- ifelse(weekdays(september$september, abbr=TRUE) == "Sat", "Y", "N")
september$Is.Sunday <- NA
september$Is.Sunday <- ifelse(weekdays(september$september, abbr=TRUE) == "Sun", "Y", "N")

september <- september[which(september$Is.Monday != "Y"),]
september <- september[which(september$Is.Saturday != "Y"),]
september <- september[which(september$Is.Sunday != "Y"),]

numberProductionDays <- length(september$september)
septemberDays <- numberProductionDays
september

thisMonth <- month(septemberBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

september2014 <- numberProductionDays
september2014




# October 2015

library(lubridate)
library(chron)
octoberBeg <- as.Date("10/01/2014", "%m/%d/%Y")
octoberEnd <- as.Date("10/31/2014", "%m/%d/%Y")

october <- seq(octoberBeg, octoberEnd, by=1)
october <- data.frame(october)

# Don't forget to mark HOLIDAYS too
october$Is.Monday <- NA
october$Is.Monday <- ifelse(weekdays(october$october, abbr=TRUE) == "Mon", "Y", "N")
october$Is.Saturday <- NA
october$Is.Saturday <- ifelse(weekdays(october$october, abbr=TRUE) == "Sat", "Y", "N")
october$Is.Sunday <- NA
october$Is.Sunday <- ifelse(weekdays(october$october, abbr=TRUE) == "Sun", "Y", "N")

october <- october[which(october$Is.Monday != "Y"),]
october <- october[which(october$Is.Saturday != "Y"),]
october <- october[which(october$Is.Sunday != "Y"),]

numberProductionDays <- length(october$october)
octoberDays <- numberProductionDays
october

thisMonth <- month(octoberBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

october2014 <- numberProductionDays
october2014



# november 2014
library(chron)
library(lubridate)
novemberBeg <- as.Date("11/01/2014", "%m/%d/%Y")
novemberEnd <- as.Date("11/30/2014", "%m/%d/%Y")

november <- seq(novemberBeg, novemberEnd, by=1)
november <- data.frame(november)

# Don't forget to mark HOLIDAYS too
november$Is.Monday <- NA
november$Is.Monday <- ifelse(weekdays(november$november, abbr=TRUE) == "Mon", "Y", "N")
november$Is.Saturday <- NA
november$Is.Saturday <- ifelse(weekdays(november$november, abbr=TRUE) == "Sat", "Y", "N")
november$Is.Sunday <- NA
november$Is.Sunday <- ifelse(weekdays(november$november, abbr=TRUE) == "Sun", "Y", "N")

november <- november[which(november$Is.Monday != "Y"),]
november <- november[which(november$Is.Saturday != "Y"),]
november <- november[which(november$Is.Sunday != "Y"),]

numberProductionDays <- length(november$november)
novemberDays <- numberProductionDays
november

thisMonth <- month(novemberBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

november2014 <- numberProductionDays
november2014



# december 2014
library(chron)
library(lubridate)
decemberBeg <- as.Date("12/01/2014", "%m/%d/%Y")
decemberEnd <- as.Date("12/31/2014", "%m/%d/%Y")

december <- seq(decemberBeg, decemberEnd, by=1)
december <- data.frame(december)

# Don't forget to mark HOLIDAYS too
december$Is.Monday <- NA
december$Is.Monday <- ifelse(weekdays(december$december, abbr=TRUE) == "Mon", "Y", "N")
december$Is.Saturday <- NA
december$Is.Saturday <- ifelse(weekdays(december$december, abbr=TRUE) == "Sat", "Y", "N")
december$Is.Sunday <- NA
december$Is.Sunday <- ifelse(weekdays(december$december, abbr=TRUE) == "Sun", "Y", "N")

december <- december[which(december$Is.Monday != "Y"),]
december <- december[which(december$Is.Saturday != "Y"),]
december <- december[which(december$Is.Sunday != "Y"),]

numberProductionDays <- length(december$december)
decemberDays <- numberProductionDays
december

thisMonth <- month(decemberBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

december2014 <- numberProductionDays
december2014






months <- c("January", "February", "March", "April", "May", "June", 
            "July", "August", "September", "October", "November", "December")
prodDays <- c(january2014, february2014, march2014, april2014, may2014, june2014,
              july2014, august2014, september2014, october2014, november2014, december2014)
productionDays2014 <- as.data.frame(cbind(months, prodDays))














################################################ 2015 ####################
##########################################################################
################################################ 2015 ####################
##########################################################################


# january 2015
library(chron)
library(lubridate)
januaryBeg <- as.Date("01/01/2015", "%m/%d/%Y")
januaryEnd <- as.Date("01/31/2015", "%m/%d/%Y")

january <- seq(januaryBeg, januaryEnd, by=1)
january <- data.frame(january)

# Don't forget to mark HOLIDAYS too
january$Is.Monday <- NA
january$Is.Monday <- ifelse(weekdays(january$january, abbr=TRUE) == "Mon", "Y", "N")
january$Is.Saturday <- NA
january$Is.Saturday <- ifelse(weekdays(january$january, abbr=TRUE) == "Sat", "Y", "N")
january$Is.Sunday <- NA
january$Is.Sunday <- ifelse(weekdays(january$january, abbr=TRUE) == "Sun", "Y", "N")

january <- january[which(january$Is.Monday != "Y"),]
january <- january[which(january$Is.Saturday != "Y"),]
january <- january[which(january$Is.Sunday != "Y"),]

numberProductionDays <- length(january$january)
januaryDays <- numberProductionDays
january

thisMonth <- month(januaryBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

january2015 <- numberProductionDays
january2015




# february 2015
library(chron)
library(lubridate)
februaryBeg <- as.Date("02/01/2015", "%m/%d/%Y")
februaryEnd <- as.Date("02/28/2015", "%m/%d/%Y")

february <- seq(februaryBeg, februaryEnd, by=1)
february <- data.frame(february)

# Don't forget to mark HOLIDAYS too
february$Is.Monday <- NA
february$Is.Monday <- ifelse(weekdays(february$february, abbr=TRUE) == "Mon", "Y", "N")
february$Is.Saturday <- NA
february$Is.Saturday <- ifelse(weekdays(february$february, abbr=TRUE) == "Sat", "Y", "N")
february$Is.Sunday <- NA
february$Is.Sunday <- ifelse(weekdays(february$february, abbr=TRUE) == "Sun", "Y", "N")

february <- february[which(february$Is.Monday != "Y"),]
february <- february[which(february$Is.Saturday != "Y"),]
february <- february[which(february$Is.Sunday != "Y"),]

numberProductionDays <- length(february$february)
februaryDays <- numberProductionDays
february

thisMonth <- month(februaryBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

february2015 <- numberProductionDays
february2015



# march 2015
library(chron)
library(lubridate)
marchBeg <- as.Date("03/01/2015", "%m/%d/%Y")
marchEnd <- as.Date("03/31/2015", "%m/%d/%Y")

march <- seq(marchBeg, marchEnd, by=1)
march <- data.frame(march)

# Don't forget to mark HOLIDAYS too
march$Is.Monday <- NA
march$Is.Monday <- ifelse(weekdays(march$march, abbr=TRUE) == "Mon", "Y", "N")
march$Is.Saturday <- NA
march$Is.Saturday <- ifelse(weekdays(march$march, abbr=TRUE) == "Sat", "Y", "N")
march$Is.Sunday <- NA
march$Is.Sunday <- ifelse(weekdays(march$march, abbr=TRUE) == "Sun", "Y", "N")

march <- march[which(march$Is.Monday != "Y"),]
march <- march[which(march$Is.Saturday != "Y"),]
march <- march[which(march$Is.Sunday != "Y"),]

numberProductionDays <- length(march$march)
marchDays <- numberProductionDays
march

thisMonth <- month(marchBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

march2015 <- numberProductionDays
march2015




# april 2015
library(chron)
library(lubridate)
aprilBeg <- as.Date("04/01/2015", "%m/%d/%Y")
aprilEnd <- as.Date("04/30/2015", "%m/%d/%Y")

april <- seq(aprilBeg, aprilEnd, by=1)
april <- data.frame(april)

# Don't forget to mark HOLIDAYS too
april$Is.Monday <- NA
april$Is.Monday <- ifelse(weekdays(april$april, abbr=TRUE) == "Mon", "Y", "N")
april$Is.Saturday <- NA
april$Is.Saturday <- ifelse(weekdays(april$april, abbr=TRUE) == "Sat", "Y", "N")
april$Is.Sunday <- NA
april$Is.Sunday <- ifelse(weekdays(april$april, abbr=TRUE) == "Sun", "Y", "N")

april <- april[which(april$Is.Monday != "Y"),]
april <- april[which(april$Is.Saturday != "Y"),]
april <- april[which(april$Is.Sunday != "Y"),]

numberProductionDays <- length(april$april)
aprilDays <- numberProductionDays
april

thisMonth <- month(aprilBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

april2015 <- numberProductionDays
april2015


# may 2015
library(chron)
library(lubridate)
mayBeg <- as.Date("05/01/2015", "%m/%d/%Y")
mayEnd <- as.Date("05/31/2015", "%m/%d/%Y")

may <- seq(mayBeg, mayEnd, by=1)
may <- data.frame(may)

# Don't forget to mark HOLIDAYS too
may$Is.Monday <- NA
may$Is.Monday <- ifelse(weekdays(may$may, abbr=TRUE) == "Mon", "Y", "N")
may$Is.Saturday <- NA
may$Is.Saturday <- ifelse(weekdays(may$may, abbr=TRUE) == "Sat", "Y", "N")
may$Is.Sunday <- NA
may$Is.Sunday <- ifelse(weekdays(may$may, abbr=TRUE) == "Sun", "Y", "N")

may <- may[which(may$Is.Monday != "Y"),]
may <- may[which(may$Is.Saturday != "Y"),]
may <- may[which(may$Is.Sunday != "Y"),]

numberProductionDays <- length(may$may)
mayDays <- numberProductionDays
may

thisMonth <- month(mayBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

may2015 <- numberProductionDays
may2015




# June 2015
library(chron)
library(lubridate)
juneBeg <- as.Date("06/01/2015", "%m/%d/%Y")
juneEnd <- as.Date("06/30/2015", "%m/%d/%Y")

june <- seq(juneBeg, juneEnd, by=1)
june <- data.frame(june)

# Don't forget to mark HOLIDAYS too
june$Is.Monday <- NA
june$Is.Monday <- ifelse(weekdays(june$june, abbr=TRUE) == "Mon", "Y", "N")
june$Is.Saturday <- NA
june$Is.Saturday <- ifelse(weekdays(june$june, abbr=TRUE) == "Sat", "Y", "N")
june$Is.Sunday <- NA
june$Is.Sunday <- ifelse(weekdays(june$june, abbr=TRUE) == "Sun", "Y", "N")

june <- june[which(june$Is.Monday != "Y"),]
june <- june[which(june$Is.Saturday != "Y"),]
june <- june[which(june$Is.Sunday != "Y"),]

numberProductionDays <- length(june$june)
juneDays <- numberProductionDays
june

thisMonth <- month(juneBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

june2015 <- numberProductionDays
june2015



# July 2015
library(chron)
library(lubridate)
julyBeg <- as.Date("07/01/2015", "%m/%d/%Y")
julyEnd <- as.Date("07/31/2015", "%m/%d/%Y")

july <- seq(julyBeg, julyEnd, by=1)
july <- data.frame(july)

# Don't forget to mark HOLIDAYS too
july$Is.Monday <- NA
july$Is.Monday <- ifelse(weekdays(july$july, abbr=TRUE) == "Mon", "Y", "N")
july$Is.Saturday <- NA
july$Is.Saturday <- ifelse(weekdays(july$july, abbr=TRUE) == "Sat", "Y", "N")
july$Is.Sunday <- NA
july$Is.Sunday <- ifelse(weekdays(july$july, abbr=TRUE) == "Sun", "Y", "N")

july <- july[which(july$Is.Monday != "Y"),]
july <- july[which(july$Is.Saturday != "Y"),]
july <- july[which(july$Is.Sunday != "Y"),]

numberProductionDays <- length(july$july)
julyDays <- numberProductionDays
july

thisMonth <- month(julyBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

july2015 <- numberProductionDays
july2015



# augustust 2015
library(chron)
library(lubridate)
augustBeg <- as.Date("08/01/2015", "%m/%d/%Y")
augustEnd <- as.Date("08/31/2015", "%m/%d/%Y")

august <- seq(augustBeg, augustEnd, by=1)
august <- data.frame(august)

# Don't forget to mark HOLIDAYS too
august$Is.Monday <- NA
august$Is.Monday <- ifelse(weekdays(august$august, abbr=TRUE) == "Mon", "Y", "N")
august$Is.Saturday <- NA
august$Is.Saturday <- ifelse(weekdays(august$august, abbr=TRUE) == "Sat", "Y", "N")
august$Is.Sunday <- NA
august$Is.Sunday <- ifelse(weekdays(august$august, abbr=TRUE) == "Sun", "Y", "N")

august <- august[which(august$Is.Monday != "Y"),]
august <- august[which(august$Is.Saturday != "Y"),]
august <- august[which(august$Is.Sunday != "Y"),]

numberProductionDays <- length(august$august)
augustDays <- numberProductionDays
august

thisMonth <- month(augustBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

august2015 <- numberProductionDays
august2015


# September 2015
library(lubridate)
library(chron)
septemberBeg <- as.Date("09/01/2015", "%m/%d/%Y")
septemberEnd <- as.Date("09/30/2015", "%m/%d/%Y")

september <- seq(septemberBeg, septemberEnd, by=1)
september <- data.frame(september)

# Don't forget to mark HOLIDAYS too
september$Is.Monday <- NA
september$Is.Monday <- ifelse(weekdays(september$september, abbr=TRUE) == "Mon", "Y", "N")
september$Is.Saturday <- NA
september$Is.Saturday <- ifelse(weekdays(september$september, abbr=TRUE) == "Sat", "Y", "N")
september$Is.Sunday <- NA
september$Is.Sunday <- ifelse(weekdays(september$september, abbr=TRUE) == "Sun", "Y", "N")

september <- september[which(september$Is.Monday != "Y"),]
september <- september[which(september$Is.Saturday != "Y"),]
september <- september[which(september$Is.Sunday != "Y"),]

numberProductionDays <- length(september$september)
septemberDays <- numberProductionDays
september

thisMonth <- month(septemberBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

september2015 <- numberProductionDays
september2015




# October 2015

library(lubridate)
library(chron)
octoberBeg <- as.Date("10/01/2015", "%m/%d/%Y")
octoberEnd <- as.Date("10/31/2015", "%m/%d/%Y")

october <- seq(octoberBeg, octoberEnd, by=1)
october <- data.frame(october)

# Don't forget to mark HOLIDAYS too
october$Is.Monday <- NA
october$Is.Monday <- ifelse(weekdays(october$october, abbr=TRUE) == "Mon", "Y", "N")
october$Is.Saturday <- NA
october$Is.Saturday <- ifelse(weekdays(october$october, abbr=TRUE) == "Sat", "Y", "N")
october$Is.Sunday <- NA
october$Is.Sunday <- ifelse(weekdays(october$october, abbr=TRUE) == "Sun", "Y", "N")

october <- october[which(october$Is.Monday != "Y"),]
october <- october[which(october$Is.Saturday != "Y"),]
october <- october[which(october$Is.Sunday != "Y"),]

numberProductionDays <- length(october$october)
octoberDays <- numberProductionDays
october

thisMonth <- month(octoberBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

october2015 <- numberProductionDays
october2015





# november 2015
library(chron)
library(lubridate)
novemberBeg <- as.Date("11/01/2015", "%m/%d/%Y")
novemberEnd <- as.Date("11/30/2015", "%m/%d/%Y")

november <- seq(novemberBeg, novemberEnd, by=1)
november <- data.frame(november)

# Don't forget to mark HOLIDAYS too
november$Is.Monday <- NA
november$Is.Monday <- ifelse(weekdays(november$november, abbr=TRUE) == "Mon", "Y", "N")
november$Is.Saturday <- NA
november$Is.Saturday <- ifelse(weekdays(november$november, abbr=TRUE) == "Sat", "Y", "N")
november$Is.Sunday <- NA
november$Is.Sunday <- ifelse(weekdays(november$november, abbr=TRUE) == "Sun", "Y", "N")

november <- november[which(november$Is.Monday != "Y"),]
november <- november[which(november$Is.Saturday != "Y"),]
november <- november[which(november$Is.Sunday != "Y"),]

numberProductionDays <- length(november$november)
novemberDays <- numberProductionDays
november

thisMonth <- month(novemberBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

november2015 <- numberProductionDays
november2015



# december 2015
library(chron)
library(lubridate)
decemberBeg <- as.Date("12/01/2015", "%m/%d/%Y")
decemberEnd <- as.Date("12/31/2015", "%m/%d/%Y")

december <- seq(decemberBeg, decemberEnd, by=1)
december <- data.frame(december)

# Don't forget to mark HOLIDAYS too
december$Is.Monday <- NA
december$Is.Monday <- ifelse(weekdays(december$december, abbr=TRUE) == "Mon", "Y", "N")
december$Is.Saturday <- NA
december$Is.Saturday <- ifelse(weekdays(december$december, abbr=TRUE) == "Sat", "Y", "N")
december$Is.Sunday <- NA
december$Is.Sunday <- ifelse(weekdays(december$december, abbr=TRUE) == "Sun", "Y", "N")

december <- december[which(december$Is.Monday != "Y"),]
december <- december[which(december$Is.Saturday != "Y"),]
december <- december[which(december$Is.Sunday != "Y"),]

numberProductionDays <- length(december$december)
decemberDays <- numberProductionDays
december

thisMonth <- month(decemberBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)

december2015 <- numberProductionDays
december2015






months <- c("January", "February", "March", "April", "May", "June", 
            "July", "August", "September", "October", "November", "December")
prodDays <- c(january2015, february2015, march2015, april2015, may2015, june2015,
              july2015, august2015, september2015, october2015, november2015, december2015)
productionDays2015 <- as.data.frame(cbind(months, prodDays))

production.history <- merge(productionDays2014, productionDays2015, by="months")
names(production.history) <- c("Month", "Production.Days.2014", "Production.Days.2015")
production.history$Month <- factor(production.history$Month, 
                                   levels=c("January", "February", "March", "April", "May", "June", 
                                            "July", "August", "September", "October", "November", "December"))
production.history <- production.history[order(production.history$Month),]
production.history








