



setwd("C:/Users/pmwash/Desktop/R_Files")
daily <- read.csv("ProductionReport.csv", header=TRUE)
#daily <- filter(daily, Driver != "COLUMBIA")
#daily <- filter(daily, Driver != "PRIORITIES")
#daily <- filter(daily, Driver != "KC TRANSFER")
#daily <- filter(daily, Driver != "SATURDAY")
#daily <- filter(daily, Driver != "RUNYON/")
#daily <- filter(daily, Driver != "CURRY")
#daily <- filter(daily, Driver != "MAJOR BRANDS")
#daily <- filter(daily, Driver != "COL FLR STOCK")
#daily <- filter(daily, Driver != "STL WILL CALL")
#daily <- filter(daily, Driver != "CAPE/WHSE")
#daily <- filter(daily, Driver != "SAMPLES")

library(chron)
daily$Date <- as.Date(daily$Date, format="%m/%d/%Y")
daily$Weekday <- weekdays(daily$Date, abbr=TRUE)

library(dplyr)
library(reshape2)
library(ggplot2)
library(gridExtra)

totalCases <- summarise(daily, Total=sum(total.cases))


# Driver Analysis
byDriver <- group_by(daily, Driver)
byDriver <- summarise(byDriver, TotalCases=sum(total.cases), AvgCases=mean(total.cases), 
                      TotStops=sum(Stops), AvgStops=mean(Stops), TotHours=sum(Ttl.Hrs), 
                      AvgHours=mean(Ttl.Hrs), TotMi=sum(Ttl.Mi), AvgMi=mean(Ttl.Mi))
byDriver <- filter(byDriver, Driver != "COLUMBIA")
byDriver <- filter(byDriver, Driver != "PRIORITIES")
byDriver <- filter(byDriver, Driver != "KC TRANSFER")
byDriver <- filter(byDriver, Driver != "SATURDAY")
byDriver <- filter(byDriver, Driver != "RUNYON/")
byDriver <- filter(byDriver, Driver != "CURRY")
byDriver <- filter(byDriver, Driver != "MAJOR BRANDS")
byDriver <- filter(byDriver, Driver != "COL FLR STOCK")
byDriver <- filter(byDriver, Driver != "STL WILL CALL")
byDriver <- filter(byDriver, Driver != "CAPE/WHSE")
byDriver <- filter(byDriver, Driver != "SAMPLES")
byDriver$StopsPerMile <- byDriver$TotStops / byDriver$TotMi
byDriver$CasesPerStop <- byDriver$TotalCases / byDriver$TotStops

g <- ggplot(data=byDriver, aes(x=reorder(Driver, -TotalCases), y=TotalCases))
cases <- g + geom_bar(stat="identity", colour="black", fill="lightgreen") +
  labs(title="Total Cases Delivered in Aug. 2015 by Driver",
       x="Driver ID", y="Total Cases Delivered") +
  theme(legend.position="bottom", axis.text.x=element_text(angle=90,hjust=1)) 

g <- ggplot(data=byDriver, aes(x=reorder(Driver, -CasesPerStop), y=CasesPerStop))
casesPerStop <- g + geom_bar(stat="identity", colour="black", fill="coral") +
  labs(title="Cases Per Stop in Aug. 2015 by Driver",
       x="Driver ID", y="Cases Per Stop") +
  theme(legend.position="bottom", axis.text.x=element_text(angle=90,hjust=1)) 

grid.arrange(cases, casesPerStop)

# Appendix
library(ggplot2)
t <- ggplot(data=daily, aes(x=factor(Weekday), y=total.cases))
t + geom_boxplot() + 
  scale_x_discrete("Weekday", labels=c("Mon", "Tue", "Wed", "Thu")) +
  labs(title="Cases Delivered Per Day") + facet_wrap(~ LOC)


g <- ggplot(data=daily, aes(x=Stops, y=Ttl.Mi))
g + geom_point() + facet_wrap(~ Driver) +
  labs(title="August 2015: Number of Stops (x) vs. Number of Miles (y), Per Day by Driver")


g <- ggplot(data=daily, aes(x=Stops))
g + geom_histogram() + facet_wrap(~ Driver) 
















# Look at history of production daily data
history <- read.csv("Production_2013-2015.csv", header=TRUE)
history$Date <- as.Date(history$Date, format="%m/%d/%Y")
month <- history$Month
history$Season <- ifelse(month==1 | month==2 |month==3, "Winter", 
                         ifelse(month==4 | month==5 | month==6, "Spring",
                                ifelse(month==7 | month==8 | month==9, "Summer",
                                       ifelse(month==10 | month==11 | month==12, "Fall", ""))
                         ))

library(ggplot2)
library(scales)

# CUM Cases produced graph 2011 - 2015 five faceted graph,
g <- ggplot(data=history, aes(x=factor(Month), y=Total.Cases.YTD))
g + geom_point(aes(size=Total.Cases.YTD, colour=factor(Year))) +
  geom_line(aes(colour=factor(Year))) +
  theme(legend.position="bottom", 
        axis.text.x=element_text(angle=90,hjust=1)) +
  facet_wrap(~ Year, nrow=1) + 
  scale_y_continuous(labels=comma) + 
  labs(title='YTD Number of Cases Produced (STL + KC), by Year',
       x="Month", y="Total Cases YTD") +
  geom_vline(xintercept=8, linetype="longdash") + 
  geom_hline(yintercept=2046091, linetype="longdash")
  
# MONTHLY Cases produced graph 2011 - 2015 five faceted graph,
meanMonthly <- mean(history$Total.Cases)
g <- ggplot(data=history, aes(x=factor(Month), y=Total.Cases))
g + geom_point(aes(size=Total.Cases, colour=factor(Year))) +
  theme(legend.position="bottom", 
        axis.text.x=element_text(angle=90,hjust=1)) +
  facet_wrap(~ Year, nrow=1) + 
  scale_y_continuous(labels=comma) + 
  labs(title='Number of Cases Produced by Month (STL + KC), by Year',
       x="Month", y="Total Cases YTD") +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  geom_vline(xintercept=8, linetype="longdash") + 
  geom_hline(yintercept=meanMonthly, linetype="longdash")


# SEASONAL Cases produced graph 2011 - 2015 five faceted graph,
g <- ggplot(data=history, aes(x=factor(Season), y=Total.Cases))
g + geom_boxplot(colour="black", aes(fill=factor(Season))) +
  theme(legend.position="bottom") +
  facet_wrap(~ Year, nrow=1) + 
  scale_y_continuous(labels=comma) + 
  labs(title='Number of Cases Produced by Season (STL + KC)',
       x="Season", y="Total Cases") +
  scale_x_discrete(limits=c("Winter","Spring","Summer","Fall"))




# Look at man hours by SEASON
g <- ggplot(data=history, aes(x=factor(Year), y=Man.Hours))
g + geom_boxplot() + facet_wrap(~Season, nrow=2) +
  labs(title="Production Man Hours")



# Look at CPMH
meanCPMH <- mean(history$CPMH)
g <- ggplot(data=history, aes(x=factor(Month), y=CPMH))
g + geom_point(aes(size=CPMH)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="Cases Per Man Hour", x="Month") + 
  theme(legend.position="bottom") +
  geom_hline(yintercept=meanCPMH, linetype="longdash") +
  annotate("text", y=35, x=8, size=3,
           label="Avg CPMH = 42.9")




# Look at ODDBALL CPMH
meanOddball <- mean(history$Oddball.CPMH)
sdOddball <- sd(history$Oddball.CPMH)
spot <- meanOddball - (4 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Oddball.CPMH))
g + geom_point(aes(size=Oddball.CPMH)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="Oddball Cases Per Man Hour", x="Month") + 
  theme(legend.position="bottom") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=8, size=3,
           label="Avg. Oddball CPMH = 971.6")



# Look at BPMH
meanBPMH <- mean(history$BPHM)
sdBPMH <- sd(history$BPMH)
spot <- meanBPMH - (4 * sdBPMH)
g <- ggplot(data=history, aes(x=factor(Month), y=BPMH))
g + geom_point(aes(size=BPMH)) + facet_wrap(~Year, nrow=1) +
  labs(title="Bottles Per Man Hour", x="Month") + 
  theme(legend.position="bottom") +
  geom_hline(yintercept=meanBPMH, linetype="longdash") +
  annotate("text", y=spot, x=8, size=3,
           label="TEXT")



















#######

## KANSAS CITY PRODUCTION

# Look at history of production daily data
setwd("C:/Users/pmwash/Desktop/R_Files")
history <- read.csv("kcProduction.csv", header=TRUE)
history$Date <- as.Date(history$Date, format="%m/%d/%Y")
month <- history$Month
history$Season <- ifelse(month==1 | month==2 |month==3, "Winter", 
                         ifelse(month==4 | month==5 | month==6, "Spring",
                                ifelse(month==7 | month==8 | month==9, "Summer",
                                       ifelse(month==10 | month==11 | month==12, "Fall", ""))
                         ))

library(ggplot2)
library(scales)

# CUM Cases produced graph 2011 - 2015 five faceted graph,
g <- ggplot(data=history, aes(x=factor(Month), y=Total.Cases.YTD))
g + geom_point(aes(size=Total.Cases.YTD, colour=factor(Year))) +
  geom_line(aes(colour=factor(Year))) +
  theme(legend.position="bottom", 
        axis.text.x=element_text(angle=90,hjust=1)) +
  facet_wrap(~ Year, nrow=1) + 
  scale_y_continuous(labels=comma) + 
  labs(title='YTD Number of Cases Produced (KC), by Year',
       x="Month", y="Total Cases YTD") +
  geom_vline(xintercept=8, linetype="longdash") + 
  geom_hline(yintercept=1403134, linetype="longdash")

# MONTHLY Cases produced graph 2011 - 2015 five faceted graph,
meanMonthly <- mean(history$Total.Cases)
g <- ggplot(data=history, aes(x=factor(Month), y=Total.Cases))
g + geom_point(aes(size=Total.Cases, colour=factor(Year))) +
  theme(legend.position="bottom", 
        axis.text.x=element_text(angle=90,hjust=1)) +
  facet_wrap(~ Year, nrow=1) + 
  scale_y_continuous(labels=comma) + 
  labs(title='Number of Cases Produced by Month (KC), by Year',
       x="Month", y="Total Cases YTD") +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  geom_vline(xintercept=8, linetype="longdash") + 
  geom_hline(yintercept=meanMonthly, linetype="longdash") +
  annotate("text", y=meanMonthly-50000, x=8, size=3,
           label=c("Avg Total Cases = 174846"))


# SEASONAL Cases produced graph 2011 - 2015 five faceted graph,
g <- ggplot(data=history, aes(x=factor(Season), y=Total.Cases))
g + geom_boxplot(colour="black", aes(fill=factor(Season))) +
  theme(legend.position="bottom") +
  facet_wrap(~ Year, nrow=1) + 
  scale_y_continuous(labels=comma) + 
  labs(title='Number of Cases Produced by Season (KC)',
       x="Season", y="Total Cases") +
  scale_x_discrete(limits=c("Winter","Spring","Summer","Fall")) +
  geom_smooth(aes(group=Year))




# Look at man hours by SEASON
g <- ggplot(data=history, aes(x=factor(Season), y=Man.Hours))
g + geom_boxplot(aes(fill=factor(Season))) + 
  facet_wrap(~Year, nrow=1) +
  labs(title="Production Man Hours") + 
  labs(title="Production Man Hours by Year/Season",
       x="Season", y="Man Hours") +
  theme(legend.position="bottom") + geom_smooth(aes(group=Year))



# Look at CPMH
meanCPMH <- mean(history$CPMH)
g <- ggplot(data=history, aes(x=factor(Month), y=CPMH))
g + geom_point(aes(size=CPMH)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="Cases Per Man Hour", x="Month") + 
  theme(legend.position="bottom") +
  geom_hline(yintercept=meanCPMH, linetype="longdash") +
  annotate("text", y=35, x=8, size=3,
           label="Avg CPMH = 51.9")

# Look at ODDBALL CPMH
meanOddball <- mean(history$R.Oddball.CPMH)
sdOddball <- sd(history$R.Oddball.CPMH)
spot <- meanOddball - (4 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=R.Oddball.CPMH))
g + geom_point(aes(size=R.Oddball.CPMH)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="Oddball Cases Per Man Hour", x="Month") + 
  theme(legend.position="bottom") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=8, size=3,
           label="Avg. Oddball CPMH = 1324.22")




# Look at ODDBALL BPMH
meanOddball <- mean(history$Oddball.BPMH)
sdOddball <- sd(history$Oddball.BPMH)
spot <- meanOddball - (4 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Oddball.BPMH))
g + geom_point(aes(size=Oddball.BPMH)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="Oddball Bottles Per Man Hour", x="Month") + 
  theme(legend.position="bottom") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=8, size=3,
           label="Avg. Oddball CPMH = 971.6")



# Look at BPMH
meanBPMH <- mean(history$BPHM, na.rm=T)
sdBPMH <- sd(history$BPMH, na.rm=T)
spot <- meanBPMH - (4 * sdBPMH)
g <- ggplot(data=history, aes(x=factor(Month), y=BPMH))
g + geom_point(aes(size=BPMH)) + facet_wrap(~Year, nrow=1) +
  labs(title="Bottles Per Man Hour", x="Month") + 
  theme(legend.position="bottom") +
  geom_hline(yintercept=meanBPMH, linetype="longdash") +
  geom_smooth(aes(group=Year))


# Look at P2V BPMH
meanBPMH <- mean(history$P2V.BPMH, na.rm=T)
sdBPMH <- sd(history$P2V.BPMH, na.rm=T)
spot <- meanBPMH - (4 * sdBPMH)
g <- ggplot(data=history, aes(x=factor(Month), y=P2V.BPMH))
g + geom_point(aes(size=P2V.BPMH)) + facet_wrap(~Year, nrow=1) +
  labs(title="P2V Bottles Per Man Hour", x="Month") + 
  theme(legend.position="bottom") +
  geom_hline(yintercept=meanBPMH, linetype="longdash") +
  geom_smooth(aes(group=Year))



# Look at man hours 
meanHours <- mean(history$Man.Hours, na.rm=T)
sdHours <- sd(history$Man.Hours, na.rm=T)
spot <- meanHours - (4 * sdHours)
g <- ggplot(data=history, aes(x=factor(Month), y=Man.Hours))
g + geom_point(aes(size=Man.Hours, colour=factor(Year))) + 
  facet_wrap(~Year, nrow=1) +
  labs(title="Total Man Hours KC", x="Month") + 
  theme(legend.position="bottom") +
  geom_hline(yintercept=meanHours, linetype="longdash") +
  geom_smooth(aes(group=Year))

# Look at Whse.Employees
meanEmp <- mean(history$Whse.Employees, na.rm=T)
sdHours <- sd(history$Whse.Employees, na.rm=T)
spot <- meanEmp - (4 * sdHours)
g <- ggplot(data=history, aes(x=factor(Month), y=Whse.Employees))
g + geom_point(aes(size=Whse.Employees, colour=factor(Year))) + 
  facet_wrap(~Year, nrow=1) +
  labs(title="Total Warehouse Employees KC", x="Month") + 
  theme(legend.position="bottom") +
  geom_hline(yintercept=meanEmp, linetype="longdash") +
  geom_smooth(aes(group=Year))




















