# August 2015
library(chron)
library(lubridate)
augBeg <- as.Date("08/01/2015", "%m/%d/%Y")
augEnd <- as.Date("08/31/2015", "%m/%d/%Y")

aug <- seq(augBeg, augEnd, by=1)
aug <- data.frame(aug)

# Don't forget to mark HOLIDAYS too
aug$Is.Monday <- NA
aug$Is.Monday <- ifelse(weekdays(aug$aug, abbr=TRUE) == "Mon", "Y", "N")
aug$Is.Saturday <- NA
aug$Is.Saturday <- ifelse(weekdays(aug$aug, abbr=TRUE) == "Sat", "Y", "N")
aug$Is.Sunday <- NA
aug$Is.Sunday <- ifelse(weekdays(aug$aug, abbr=TRUE) == "Sun", "Y", "N")

aug <- aug[which(aug$Is.Monday != "Y"),]
aug <- aug[which(aug$Is.Saturday != "Y"),]
aug <- aug[which(aug$Is.Sunday != "Y"),]

numberProductionDays <- length(aug$aug)
augDays <- numberProductionDays
aug

thisMonth <- month(augBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)



# September 2015

library(lubridate)
library(chron)
septBeg <- as.Date("09/01/2015", "%m/%d/%Y")
septEnd <- as.Date("09/30/2015", "%m/%d/%Y")

sept <- seq(septBeg, septEnd, by=1)
sept <- data.frame(sept)

# Don't forget to mark HOLIDAYS too
sept$Is.Monday <- NA
sept$Is.Monday <- ifelse(weekdays(sept$sept, abbr=TRUE) == "Mon", "Y", "N")
sept$Is.Saturday <- NA
sept$Is.Saturday <- ifelse(weekdays(sept$sept, abbr=TRUE) == "Sat", "Y", "N")
sept$Is.Sunday <- NA
sept$Is.Sunday <- ifelse(weekdays(sept$sept, abbr=TRUE) == "Sun", "Y", "N")

sept <- sept[which(sept$Is.Monday != "Y"),]
sept <- sept[which(sept$Is.Saturday != "Y"),]
sept <- sept[which(sept$Is.Sunday != "Y"),]

numberProductionDays <- length(sept$sept)
septDays <- numberProductionDays
sept

thisMonth <- month(septBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)







# October 2015

library(lubridate)
library(chron)
octBeg <- as.Date("10/01/2015", "%m/%d/%Y")
octEnd <- as.Date("10/31/2015", "%m/%d/%Y")

oct <- seq(octBeg, octEnd, by=1)
oct <- data.frame(oct)

# Don't forget to mark HOLIDAYS too
oct$Is.Monday <- NA
oct$Is.Monday <- ifelse(weekdays(oct$oct, abbr=TRUE) == "Mon", "Y", "N")
oct$Is.Saturday <- NA
oct$Is.Saturday <- ifelse(weekdays(oct$oct, abbr=TRUE) == "Sat", "Y", "N")
oct$Is.Sunday <- NA
oct$Is.Sunday <- ifelse(weekdays(oct$oct, abbr=TRUE) == "Sun", "Y", "N")

oct <- oct[which(oct$Is.Monday != "Y"),]
oct <- oct[which(oct$Is.Saturday != "Y"),]
oct <- oct[which(oct$Is.Sunday != "Y"),]

numberProductionDays <- length(oct$oct)
octDays <- numberProductionDays
oct

thisMonth <- month(octBeg, label=TRUE, abbr=FALSE)
paste("This month is", thisMonth)
paste("The number of production days this month is", numberProductionDays)








