
print('Define functions necessary for analysis.')
headTail = function(x, y=5) {
  h <- head(x, y)
  t <- tail(x, y)
  print(h)
  print(t)
}
as400Date <- function(x) {
  date <- as.character(x)
  date <- substrRight(date, 6)
  date <- as.character((strptime(date, "%y%m%d")))
  date
}
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}
substrLeft <- function(x, n){
  substr(x, 1, n)
}
thisMonth = function(x) {
  library(lubridate)
  this = month(Sys.Date())
  if(this-1==0) {
    12
  } else {
    this-1
  }
}


print('Load libraries needed.')
library(ggplot2)
library(scales)
library(dplyr)
library(zoo)
library(gridExtra)
library(lubridate)

print('Declare useful variables.')
thisMonth = thisMonth()



print('STL below.')
####################################
print('This is for Saint Louis. Version 3. January 2015. Paul Washburn.')
print('Read in the file. This data comes from the Error analysis report Total tab. \\n
      The total tab is copied by month, then transposed and pasted values into the Production_2013-2015.csv doc.')
setwd("C:/Users/pmwash/Desktop/R_Files/Data Input")
history <- read.csv("Production_2013-2015.csv", header=TRUE)


print('Prepare data.')
history$Date <- as.Date(history$Date, format="%m/%d/%Y")
month <- history$Month
history$Season <- ifelse(month==1 | month==2 |month==3, "Winter", 
                         ifelse(month==4 | month==5 | month==6, "Spring",
                                ifelse(month==7 | month==8 | month==9, "Summer",
                                       ifelse(month==10 | month==11 | month==12, "Fall", ""))
                         ))
history$Oddball.Cases.Percent.Total <- round(history$Oddball.Cases / history$Total.Cases, 4)



print('Create cumulative sums.')
history = history %>% group_by(Year) %>% 
  mutate(YTD.Total.Cases=cumsum(Total.Cases))
history = history %>% group_by(Year) %>%
  mutate(YTD.KC.Transfer=cumsum(KC.Transfer))
history = history %>% group_by(Year) %>%
  mutate(YTD.Man.Hours=cumsum(Man.Hours))
history = history %>% group_by(Year) %>%
  mutate(YTD.OT.Hours=cumsum(OT.Hours))
history = history %>% group_by(Year) %>%
  mutate(YTD.Kegs=cumsum(Kegs))
history = history %>% group_by(Year) %>%
  mutate(YTD.Total.Stops=cumsum(Total.Stops.STL))
history = history %>% group_by(Year) %>%
  mutate(YTD.Oddball.Cases=cumsum(Oddball.Cases))
history = history %>% group_by(Year) %>%
  mutate(YTD.Empty.Kegs=cumsum(Empty.Kegs))
history = history %>% group_by(Year) %>%
  mutate(YTD.Non.Conveyables=cumsum(Non.Conveyable.Cases))
history = history %>% group_by(Year) %>%
  mutate(YTD.Case.O.S.Errors.STL=cumsum(Case.O.S.Errors.STL))
history = history %>% group_by(Year) %>%
  mutate(YTD.Bottle.O.S.Errors.STL=cumsum(Bottle.O.S.Errors.STL))



print('Create moving averages.')
history = history %>% group_by(Year) %>%
  mutate(Keg.Other.Trucks.3.Month.Mvg.Avg = rollmean(x=Keg.Other.Trucks, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Kegs.3.Month.Mvg.Avg = rollmean(x=Kegs, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Package.Trucks.Month.Mvg.Avg = rollmean(x=Package.Trucks, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Total.Stops.3.Month.Mvg.Avg = rollmean(x=Total.Stops, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(C.Line.Cases.3.Month.Mvg.Avg = rollmean(x=C.Line.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(D.Line.Cases.3.Month.Mvg.Avg = rollmean(x=D.Line.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(E.Line.Cases.3.Month.Mvg.Avg = rollmean(x=E.Line.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(F.Line.Cases.3.Month.Mvg.Avg = rollmean(x=F.Line.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(G.Line.Cases.3.Month.Mvg.Avg = rollmean(x=G.Line.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Oddball.Cases.3.Month.Mvg.Avg = rollmean(x=Oddball.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Wine.Room.Cases.3.Month.Mvg.Avg = rollmean(x=W.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Unknown.Cases.3.Month.Mvg.Avg = rollmean(x=Unknown.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Non.Conveyable.Cases.3.Month.Mvg.Avg = rollmean(x=Non.Conveyable.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Pallet.Picks.3.Month.Mvg.Avg = rollmean(x=Pallet.Picks, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(BPMH.3.Month.Mvg.Avg = rollmean(x=BPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(CPMH.3.Month.Mvg.Avg = rollmean(x=CPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Total.Cases.3.Month.Mvg.Avg = rollmean(x=Total.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(C.Line.CPMH.3.Month.Mvg.Avg = rollmean(x=C.Line...W.Line.CPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(D.Line.CPMH.3.Month.Mvg.Avg = rollmean(x=D.Line.CPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(E.Line.CPMH.3.Month.Mvg.Avg = rollmean(x=E.Line...Unknown.CPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(F.Line.CPMH.3.Month.Mvg.Avg = rollmean(x=F.Line...Oddball.CPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(G.Line.CPMH.3.Month.Mvg.Avg = rollmean(x=G.Line.CPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Wine.Room.CPMH.3.Month.Mvg.Avg = rollmean(x=W.CPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Unknown.CPMH.3.Month.Mvg.Avg = rollmean(x=Unknown.CPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Oddball.CPMH.3.Month.Mvg.Avg = rollmean(x=Oddball.CPMH, 3, align='right', fill=NA))


history = data.frame(history)
headTail(history)

######################################################################################################### End Data Preparation
print('Produce graphics from data above.')


print('Cumulative Cases Produced since 2011.')
g <- ggplot(data=history, aes(x=factor(Month), y=YTD.Total.Cases))
g + geom_point(aes(size=YTD.Total.Cases, colour=factor(Year))) +
  geom_line(aes(colour=factor(Year))) +
  theme(legend.position="none", 
        axis.text.x=element_text(angle=90,hjust=1)) +
  facet_wrap(~ Year, nrow=1) + 
  scale_y_continuous(labels=comma) + 
  labs(title='YTD Number of Cases Produced from STL by Year',
       x="Month", y="Total Cases YTD") +
  geom_vline(xintercept=12, linetype="longdash") + 
  geom_hline(yintercept=3223498, linetype="longdash")


print('Monthly cases produced graph 2011 - 2015 five faceted graph. CPMH added to it.')
meanMonthly <- mean(history$Total.Cases)
g <- ggplot(data=history, aes(x=factor(Month), y=Total.Cases, group=factor(Year)))
one = g + geom_point(aes(size=Total.Cases, colour=factor(Year))) +
  theme(legend.position="none", 
        axis.text.x=element_text(angle=90,hjust=1)) +
  facet_wrap(~ Year, nrow=1) + 
  scale_y_continuous(labels=comma) + 
  labs(title='Number of Cases Produced by Month (STL), by Year w/ 3 Month Moving Avg.',
       x="Month", y="Total Cases") +
  geom_vline(xintercept=12, linetype="longdash") + 
  geom_hline(yintercept=16024.57, linetype="longdash") + 
  geom_line(size=1,aes(x=factor(Month), y=Total.Cases.3.Month.Mvg.Avg))
meanCPMH <- round(mean(history$CPMH, na.rm=T), 2)
spot = meanCPMH - 2*round(sd(history$CPMH, na.rm=T), 2)
g <- ggplot(data=history, aes(x=factor(Month), y=CPMH))
two = g + geom_point(aes(size=CPMH)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=F, aes(group=Year, colour=factor(Year))) +
  labs(title="STL Cases Per Man Hour", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanCPMH, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg CPMH = ", meanCPMH))
grid.arrange(one, two, ncol=1)


print('Seasonal Cases produced graph 2011 - 2015 five faceted graph.')
g <- ggplot(data=history, aes(x=factor(Season), y=Total.Cases))
g + geom_boxplot(colour="black", aes(fill=factor(Season))) +
  theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) +
  facet_wrap(~ Year, nrow=1) + 
  scale_y_continuous(labels=comma) + 
  labs(title='STL Monthly Cases Produced Grouped by Season',
       x="Season", y="Total Cases") +
  scale_x_discrete(limits=c("Winter","Spring","Summer","Fall")) +
  geom_smooth(se=F, aes(group=Season))




print('Man hours by Season.')
history$Season <- factor(history$Season, levels=c('Winter', 'Spring', 'Summer', 'Fall'))
g <- ggplot(data=history, aes(x=factor(Season), y=Man.Hours))
g + geom_boxplot(aes(fill=factor(Season))) + facet_wrap(~Year, nrow=2) +
  labs(title="Production Man Hours", x='Season', y='Man Hours') +
  theme(legend.position='none')



print('Three month moving average of CPMH.')
meanCPMH <- round(mean(history$CPMH.3.Month.Mvg.Avg, na.rm=T), 2)
spot = meanCPMH - round(sd(history$CPMH.3.Month.Mvg.Avg, na.rm=T), 2)
g <- ggplot(data=history, aes(x=factor(Month), y=CPMH.3.Month.Mvg.Avg))
g + geom_point(aes(size=CPMH.3.Month.Mvg.Avg)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="STL Cases Per Man Hour 3 Month Moving Avg.", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanCPMH, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg CPMH = ", meanCPMH))




print('Oddball CPMH and Oddball Cases, cumulative, and oddball hours.')
g <- ggplot(data=history, aes(x=factor(Month), y=Oddball.Cases.3.Month.Mvg.Avg))
one = g + geom_point(aes(size=Oddball.Cases.3.Month.Mvg.Avg)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="STL Oddball Cases 3 Month Moving Avg.", x="Month") + 
  theme(legend.position="none") 
meanOddball <- round(mean(history$Oddball.CPMH, na.rm=T), 2)
sdOddball <- sd(history$Oddball.CPMH, na.rm=T)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Oddball.CPMH))
two = g + geom_point(aes(size=Oddball.CPMH)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="Oddball Cases Per Man Hour STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball , linetype="longdash") +
  annotate("text", y=spot, x=7, size=3,
           label=paste("Avg. Oddball CPMH =", meanOddball)) 
g <- ggplot(data=history, aes(x=factor(Month), y=YTD.Oddball.Cases))
three = g + geom_point(aes(size=YTD.Oddball.Cases)) + facet_wrap(~Year, nrow=1) +
  geom_line(size=1, aes(group=Year, colour=factor(Year))) +
  labs(title="YTD Oddball Cases STL", x="Month") + 
  theme(legend.position="none") 
meanOddball <- round(mean(history$Oddball.Hours), 1)
sdOddball <- sd(history$Oddball.Hours)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Oddball.Hours))
four = g + geom_point(aes(size=Oddball.Hours)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="Oddball Hours STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=7, size=3,
           label=paste("Avg. Oddball Hours =", meanOddball))
meanOddball <- round(mean(history$Oddball.Cases.Percent.Total), 4)
sdOddball <- sd(history$Oddball.Cases.Percent.Total)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Oddball.Cases.Percent.Total))
five = g + geom_point(aes(size=Oddball.Cases.Percent.Total)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="Percent Oddball Cases STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg % Oddballs =", meanOddball)) +
  geom_vline(xintercept=12, linetype='longdash') + scale_y_continuous(labels=percent)
grid.arrange(five, one, three, two, four, ncol=1)




print('Bottles & BPMH.')
g <- ggplot(data=history, aes(x=factor(Month), y=Bottles))
one = g + geom_point(aes(size=Bottles)) + facet_wrap(~Year, nrow=1) +
  labs(title="STL Bottles", x="Month") + 
  theme(legend.position="none") + 
  geom_smooth(aes(group=Year, colour=factor(Year)), se=F) + 
  scale_y_continuous(labels=comma)
history$BPHM <- as.numeric(history$BPHM)
meanBPMH <- mean(history$BPHM, na.rm=T)
sdBPMH <- sd(history$BPMH, na.rm=T)
spot <- meanBPMH - (4 * sdBPMH)
g <- ggplot(data=history, aes(x=factor(Month), y=BPMH))
two = g + geom_point(aes(size=BPMH)) + facet_wrap(~Year, nrow=1) +
  labs(title="Bottles Per Man Hour", x="Month") + 
  theme(legend.position="none") +
  geom_smooth(aes(group=Year, colour=factor(Year)), se=F)+
scale_y_continuous(labels=comma)
grid.arrange(one, two, ncol=1)


print('Distribution of Oddball cases by year.')
g <- ggplot(data=history, aes(x=Oddball.Cases))
g + geom_density(aes(group=Year, fill=factor(Year)), alpha=0.5) + facet_wrap(~Year, ncol=1) +
  theme(legend.position="none") +
  labs(title='Distribution of STL Monthly Oddball Cases by Year')



print('Monthly and cumulative Man Hours STL.')
meanOddball <- round(mean(history$Man.Hours), 1)
sdOddball <- sd(history$Man.Hours)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Man.Hours))
one = g + geom_point(aes(size=Man.Hours)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="Total Monthly Man Hours STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg. Man Hours =", meanOddball)) +
  scale_y_continuous(labels=comma)
g <- ggplot(data=history, aes(x=factor(Month), y=YTD.Man.Hours))
two = g + geom_point(aes(size=YTD.Man.Hours)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="YTD Man Hours STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=79896.85, linetype="longdash") +
  geom_vline(xintercept=12, linetype="longdash") +
  scale_y_continuous(labels=comma)
grid.arrange(one, two, ncol=1)


print('Empty kegs & YTD empty kegs. REMEMBER to change the final filter number.')
dat <- history[c(25:60),]
meanOddball <- round(mean(dat$Empty.Kegs), 1)
sdOddball <- sd(dat$Empty.Kegs)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=dat, aes(x=factor(Month), y=Empty.Kegs))
one = g + geom_point(aes(size=Empty.Kegs)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="Empty Kegs STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=5, size=3,
           label=paste("Avg. Empty Kegs =", meanOddball))
g <- ggplot(data=dat, aes(x=factor(Month), y=YTD.Empty.Kegs))
two = g + geom_point(aes(size=YTD.Empty.Kegs)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="YTD Empty Kegs STL", x="Month") + 
  theme(legend.position="none")
grid.arrange(one, two, ncol=1)
rm(dat)


print('Non-conveyables and cumulative non-conveyables.')
meanOddball <- round(mean(history$Non.Conveyable.Cases), 1)
sdOddball <- sd(history$Non.Conveyable.Cases)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Non.Conveyable.Cases))
one = g + geom_point(aes(size=Non.Conveyable.Cases)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="Non-Conveyable Cases STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=5, size=3,
           label=paste("Avg. Non-Conveyable Cases =", meanOddball))
g <- ggplot(data=history, aes(x=factor(Month), y=YTD.Non.Conveyables))
two = g + geom_point(aes(size=YTD.Non.Conveyables)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="YTD Non-Conveyable Cases STL", x="Month") + 
  theme(legend.position="none")
grid.arrange(one,two,ncol=1)


print('Accuracy [UNDER CONSTRUCTION]')
meanOddball <- round(mean(history$Accuracy), 4)
sdOddball <- sd(history$Accuracy)
spot <- meanOddball - (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Accuracy))
g + geom_point(aes(size=Accuracy)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="Accuracy STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=5, size=3,
           label=paste("Avg Accuracy =", meanOddball)) +
  geom_vline(xintercept=12)



print('Pallets returned')
dat <- history[c(25:60),]
meanOddball <- round(mean(dat$PLLTS), 2)
sdOddball <- sd(dat$PLLTS)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=dat, aes(x=factor(Month), y=PLLTS))
g + geom_point(aes(size=PLLTS)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="Pallets Returned STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=5, size=3,
           label=paste("Avg PLLTS =", meanOddball))



print('OT hours monthly and cumulative YTD.')
meanOddball <- round(mean(history$OT.Hours), 2)
sdOddball <- sd(history$OT.Hours)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=OT.Hours))
one = g + geom_bar(stat='identity', aes(fill=factor(Month))) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=F, aes(group=Year, colour=factor(Year))) +
  labs(title="STL Monthly OT Hours", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=5, size=3,
           label=paste("Avg OT Hrs =", meanOddball)) +
  geom_vline(xintercept=12, linetype="longdash")
g <- ggplot(data=history, aes(x=factor(Month), y=YTD.OT.Hours))
two = g + geom_bar(stat='identity', aes(fill=factor(Month))) + facet_wrap(~Year, nrow=1) +
  labs(title="STL YTD OT Hours", x="Month") + 
  theme(legend.position="none") +
  geom_vline(xintercept=12, linetype="longdash") +
  geom_hline(yintercept=2545.480, linetype="longdash")
grid.arrange(one,two,ncol=1)



print('Bottle line accuracy [UNDER CONSTRUCTION].')
meanOddball <- round(mean(history$BTL.Accuracy.STL), 5)
sdOddball <- sd(history$BTL.Accuracy.STL)
spot <- meanOddball - (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=BTL.Accuracy.STL))
g + geom_point(aes(size=BTL.Accuracy.STL)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="Bottle Accuracy STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=5, size=3,
           label=paste("Avg Btl Accuracy =", meanOddball)) +
  geom_vline(xintercept=12)


print('Case accuracy [UNDER CONSTRUCTION].')
meanOddball <- round(mean(history$Case.Accuracy.STL), 5)
sdOddball <- sd(history$Case.Accuracy.STL)
spot <- meanOddball - (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Case.Accuracy.STL))
g + geom_point(aes(size=Case.Accuracy.STL)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="Case Accuracy STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=5, size=3,
           label=paste("Avg Cs Accuracy =", meanOddball)) +
  geom_vline(xintercept=11)


print('Case over/short errors.')
meanOddball <- round(mean(history$Case.O.S.Errors.STL), 2)
sdOddball <- sd(history$Case.O.S.Errors.STL)
spot <- meanOddball - (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Case.O.S.Errors.STL))
one = g + geom_point(aes(size=Case.O.S.Errors.STL)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="Case O/S Errors STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg O/S Cases =", meanOddball)) +
  geom_vline(xintercept=12, linetype="longdash")
g <- ggplot(data=history, aes(x=factor(Month), y=YTD.Case.O.S.Errors.STL))
two = g + geom_point(aes(size=YTD.Case.O.S.Errors.STL)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="YTD Case O/S Errors STL", x="Month") + 
  theme(legend.position="none") +
  geom_vline(xintercept=12, linetype="longdash") +
  geom_hline(yintercept=765, linetype='longdash')
grid.arrange(one, two, ncol=1)





print('Bottle over/short errors.')
meanOddball <- round(mean(history$Bottle.O.S.Errors.STL), 2)
sdOddball <- sd(history$Bottle.O.S.Errors.STL)
spot <- meanOddball - (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Bottle.O.S.Errors.STL))
one = g + geom_point(aes(size=Bottle.O.S.Errors.STL)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="Bottle O/S Errors STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg O/S Bottles =", meanOddball)) +
  geom_vline(xintercept=12, linetype='longdash')
g <- ggplot(data=history, aes(x=factor(Month), y=YTD.Bottle.O.S.Errors.STL))
two = g + geom_point(aes(size=YTD.Bottle.O.S.Errors.STL)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="YTD Bottle O/S Errors STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept= 563, linetype="longdash") +
  geom_vline(xintercept=12, linetype='longdash')
grid.arrange(one,two,ncol=1)


print("p2v under construction")
meanOddball <- round(mean(history$P2V.BPMH), 5)
sdOddball <- sd(history$P2V.BPMH)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=P2V.BPMH))
g + geom_point(aes(size=P2V.BPMH)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=F, aes(group=Year, colour=factor(Year))) +
  labs(title="P2V BPMH STL", x="Month") + 
  theme(legend.position="bottom") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg P2V BPMH =", meanOddball)) +
  geom_vline(xintercept=11)


print('Empty boxes.')
dat <- history[c(25:60),]
meanOddball <- round(mean(dat$Empty.Boxes), 5)
sdOddball <- sd(dat$Empty.Boxes)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=dat, aes(x=factor(Month), y=Empty.Boxes))
g + geom_point(aes(size=Empty.Boxes)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="Empty Boxes Returned STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg Empty Boxes =", meanOddball)) +
  geom_vline(xintercept=12, linetype="longdash")
rm(dat)





print('Examine cases per line trends.')
c = data.frame(history$C.Line.Cases.3.Month.Mvg.Avg) 
c$Line = 'C-Line'
c$Year = history$Year
c$Month = history$Month
c$Year.Month = history$Year.Month
names(c) = c('Three.Month.Mvg.Avg.Cases', 'Line', 'Year', 'Month', 'Year.Month')
d = data.frame(history$D.Line.Cases.3.Month.Mvg.Avg) 
d$Line = 'D-Line'
d$Year = history$Year
d$Month = history$Month
d$Year.Month = history$Year.Month
names(d) =  c('Three.Month.Mvg.Avg.Cases', 'Line', 'Year', 'Month', 'Year.Month')
e = data.frame(history$E.Line.Cases.3.Month.Mvg.Avg) 
e$Line = 'E-Line'
e$Year = history$Year
e$Month = history$Month
e$Year.Month = history$Year.Month
names(e) =  c('Three.Month.Mvg.Avg.Cases', 'Line', 'Year', 'Month', 'Year.Month')
f = data.frame(history$F.Line.Cases.3.Month.Mvg.Avg) 
f$Line = 'F-Line'
f$Year = history$Year
f$Month = history$Month
f$Year.Month = history$Year.Month
names(f) =  c('Three.Month.Mvg.Avg.Cases', 'Line', 'Year', 'Month', 'Year.Month')
g = data.frame(history$G.Line.Cases.3.Month.Mvg.Avg) 
g$Line = 'G-Line'
g$Year = history$Year
g$Month = history$Month
g$Year.Month = history$Year.Month
names(g) =  c('Three.Month.Mvg.Avg.Cases', 'Line', 'Year', 'Month', 'Year.Month')
o = data.frame(history$Oddball.Cases.3.Month.Mvg.Avg) 
o$Line = 'Odd Ball'
o$Year = history$Year
o$Month = history$Month
o$Year.Month = history$Year.Month
names(o) =  c('Three.Month.Mvg.Avg.Cases', 'Line', 'Year', 'Month', 'Year.Month')
w = data.frame(history$Wine.Room.Cases.3.Month.Mvg.Avg) 
w$Line = 'Wine Room'
w$Year = history$Year
w$Month = history$Month
w$Year.Month = history$Year.Month
names(w) =  c('Three.Month.Mvg.Avg.Cases', 'Line', 'Year', 'Month', 'Year.Month')
u = data.frame(history$Unknown.Cases.3.Month.Mvg.Avg) 
u$Line = 'Unknown'
u$Year = history$Year
u$Month = history$Month
u$Year.Month = history$Year.Month
names(u) =  c('Three.Month.Mvg.Avg.Cases', 'Line', 'Year', 'Month', 'Year.Month')

lines = rbind(c, d, e, f, g, o, w, u)
lines$Year.Month = factor(lines$Year.Month, 
                          levels=c('11-Jan', '11-Feb', '11-Mar', '11-Apr', '11-May', '11-Jun',
                                   '11-Jul', '11-Aug', '11-Sep', '11-Oct', '11-Nov', '11-Dec',
                                   '12-Jan', '12-Feb', '12-Mar', '12-Apr', '12-May', '12-Jun',
                                   '12-Jul', '12-Aug', '12-Sep', '12-Oct', '12-Nov', '12-Dec',
                                   '13-Jan', '13-Feb', '13-Mar', '13-Apr', '13-May', '13-Jun',
                                   '13-Jul', '13-Aug', '13-Sep', '13-Oct', '13-Nov', '13-Dec',
                                   '14-Jan', '14-Feb', '14-Mar', '14-Apr', '14-May', '14-Jun',
                                   '14-Jul', '14-Aug', '14-Sep', '14-Oct', '14-Nov', '14-Dec',
                                   '15-Jan', '15-Feb', '15-Mar', '15-Apr', '15-May', '15-Jun',
                                   '15-Jul', '15-Aug', '15-Sep', '15-Oct', '15-Nov', '15-Dec'))
headTail(lines)

g = ggplot(data=lines, aes(x=factor(Year.Month), y=Three.Month.Mvg.Avg.Cases, group=Line))
one = g + geom_point() + facet_wrap(~Line, ncol=1, scales='free_y') +
  geom_line(size=1, aes(colour=Line)) + 
  theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1)) +
  geom_smooth(aes(group=Line), se=F, colour='black', size=0.5) +
  scale_y_continuous(labels=comma) +
  labs(title='Three Month Moving Average of Monthly Volume by Case Line', 
       x='Year & Month', y='Case Volume')
rm(c, d, e, f, g, o, lines)
print('Examine production rate by line and warehouse area and combine with above.')
c = data.frame(history$C.Line.CPMH.3.Month.Mvg.Avg) 
c$Line = 'C-Line'
c$Year = history$Year
c$Month = history$Month
c$Year.Month = history$Year.Month
names(c) = c('Three.Month.Mvg.Avg.CPMH', 'Line', 'Year', 'Month', 'Year.Month')
d = data.frame(history$D.Line.CPMH.3.Month.Mvg.Avg) 
d$Line = 'D-Line'
d$Year = history$Year
d$Month = history$Month
d$Year.Month = history$Year.Month
names(d) =  c('Three.Month.Mvg.Avg.CPMH', 'Line', 'Year', 'Month', 'Year.Month')
e = data.frame(history$E.Line.CPMH.3.Month.Mvg.Avg) 
e$Line = 'E-Line'
e$Year = history$Year
e$Month = history$Month
e$Year.Month = history$Year.Month
names(e) =  c('Three.Month.Mvg.Avg.CPMH', 'Line', 'Year', 'Month', 'Year.Month')
f = data.frame(history$F.Line.CPMH.3.Month.Mvg.Avg) 
f$Line = 'F-Line'
f$Year = history$Year
f$Month = history$Month
f$Year.Month = history$Year.Month
names(f) =  c('Three.Month.Mvg.Avg.CPMH', 'Line', 'Year', 'Month', 'Year.Month')
g = data.frame(history$G.Line.CPMH.3.Month.Mvg.Avg) 
g$Line = 'G-Line'
g$Year = history$Year
g$Month = history$Month
g$Year.Month = history$Year.Month
names(g) =  c('Three.Month.Mvg.Avg.CPMH', 'Line', 'Year', 'Month', 'Year.Month')
w = data.frame(history$Wine.Room.CPMH.3.Month.Mvg.Avg) 
w$Line = 'Wine Room'
w$Year = history$Year
w$Month = history$Month
w$Year.Month = history$Year.Month
names(w) =  c('Three.Month.Mvg.Avg.CPMH', 'Line', 'Year', 'Month', 'Year.Month')
u = data.frame(history$Wine.Room.CPMH.3.Month.Mvg.Avg) 
u$Line = 'Unknown'
u$Year = history$Year
u$Month = history$Month
u$Year.Month = history$Year.Month
names(u) =  c('Three.Month.Mvg.Avg.CPMH', 'Line', 'Year', 'Month', 'Year.Month')
o = data.frame(history$Oddball.CPMH.3.Month.Mvg.Avg) 
o$Line = 'Odd Ball'
o$Year = history$Year
o$Month = history$Month
o$Year.Month = history$Year.Month
names(o) =  c('Three.Month.Mvg.Avg.CPMH', 'Line', 'Year', 'Month', 'Year.Month')
###
lines = rbind(c, d, e, f, g, o, w, u)
lines$Year.Month = factor(lines$Year.Month, 
                          levels=c('11-Jan', '11-Feb', '11-Mar', '11-Apr', '11-May', '11-Jun',
                                   '11-Jul', '11-Aug', '11-Sep', '11-Oct', '11-Nov', '11-Dec',
                                   '12-Jan', '12-Feb', '12-Mar', '12-Apr', '12-May', '12-Jun',
                                   '12-Jul', '12-Aug', '12-Sep', '12-Oct', '12-Nov', '12-Dec',
                                   '13-Jan', '13-Feb', '13-Mar', '13-Apr', '13-May', '13-Jun',
                                   '13-Jul', '13-Aug', '13-Sep', '13-Oct', '13-Nov', '13-Dec',
                                   '14-Jan', '14-Feb', '14-Mar', '14-Apr', '14-May', '14-Jun',
                                   '14-Jul', '14-Aug', '14-Sep', '14-Oct', '14-Nov', '14-Dec',
                                   '15-Jan', '15-Feb', '15-Mar', '15-Apr', '15-May', '15-Jun',
                                   '15-Jul', '15-Aug', '15-Sep', '15-Oct', '15-Nov', '15-Dec'))
headTail(lines)

g = ggplot(data=lines, aes(x=factor(Year.Month), y=Three.Month.Mvg.Avg.CPMH, group=Line))
two = g + geom_point() + facet_wrap(~Line, ncol=1, scales='free_y') +
  geom_line(size=1, aes(colour=Line)) + 
  theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1)) +
  geom_smooth(aes(group=Line), se=F, colour='black', size=0.5) +
  scale_y_continuous(labels=comma) +
  labs(title='Three Month Moving Average of Monthly CPMH by Case Line', 
       x='Year & Month', y='Case Per Man Hour')
grid.arrange(one,two, ncol=2)

rm(c, d, e, f, g, o, u, lines)




print('Number of employees moving average.')


print('Examine Total Stops moving average.')











print('KC below.')
#############################
print('This is for Kansas City. Version 3. January 2015. Paul Washburn.')
print('Read in the file. This data comes from the Error analysis report Total tab. \\n
      The total tab is copied by month, then transposed and pasted values into the kcProduction.csv doc.')
setwd("C:/Users/pmwash/Desktop/R_Files/Data Input")
history <- read.csv("kcProduction.csv", header=TRUE)


print('Prepare data.')
history$Date <- as.Date(history$Date, format="%m/%d/%Y")
month <- history$Month
history$Season <- ifelse(month==1 | month==2 |month==3, "Winter", 
                         ifelse(month==4 | month==5 | month==6, "Spring",
                                ifelse(month==7 | month==8 | month==9, "Summer",
                                       ifelse(month==10 | month==11 | month==12, "Fall", ""))
                         ))
history$Oddball.Cases.Percent.Total <- round(history$R.Oddball.Cases / history$Total.Cases, 4)
headTail(history, 10)


print('Create cumulative sums.')
history = history %>% group_by(Year) %>% 
  mutate(YTD.Total.Cases=cumsum(Total.Cases))
history = history %>% group_by(Year) %>%
  mutate(YTD.KC.Transfer=cumsum(STL.Transfer))
history = history %>% group_by(Year) %>%
  mutate(YTD.Man.Hours=cumsum(Man.Hours))
history = history %>% group_by(Year) %>%
  mutate(YTD.OT.Hours=cumsum(OT.Hours))
history = history %>% group_by(Year) %>%
  mutate(YTD.Total.Stops=cumsum(Total.Stops.KC))
history = history %>% group_by(Year) %>%
  mutate(YTD.Oddball.Bottles=cumsum(Oddball.Bottles))
history = history %>% group_by(Year) %>%
  mutate(YTD.Non.Conveyables=cumsum(Non.Conveyable.Cases))
history = history %>% group_by(Year) %>%
  mutate(YTD.Case.O.S.Errors=cumsum(Case.O.S.Errors))
history = history %>% group_by(Year) %>%
  mutate(YTD.Bottle.O.S.ErrorsL=cumsum(Bottle.O.S.Errors))
history = history %>% group_by(Year) %>%
  mutate(YTD.Oddball.Cases=cumsum(R.Oddball.Cases.1))



print('Create moving averages.')
history = history %>% group_by(Year) %>%
  mutate(KC.Month.Mvg.Avg = rollmean(x=KC.Trucks, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Total.Stops.KC.3.Month.Mvg.Avg = rollmean(x=Total.Stops.KC, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Total.Stops.Spfd.3.Month.Mvg.Avg = rollmean(x=Total.Stops.Springfield, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(C.100.Cases.3.Month.Mvg.Avg = rollmean(x=C.100.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(C.200.Cases.3.Month.Mvg.Avg = rollmean(x=C.200.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(C.300.400.Cases.3.Month.Mvg.Avg = rollmean(x=C.300.400.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(R.Oddball.Cases.3.Month.Mvg.Avg = rollmean(x=R.Oddball.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(W.Cases.3.Month.Mvg.Avg = rollmean(x=W.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Unknown.Cases.3.Month.Mvg.Avg = rollmean(x=Unknown.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Warehouse.Employees.3.Month.Mvg.Avg = rollmean(x=Whse.Employees, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(OT.Hours.3.Month.Mvg.Avg = rollmean(x=OT.Hours, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Non.Conveyable.Cases.3.Month.Mvg.Avg = rollmean(x=Non.Conveyable.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Pallet.Picks.3.Month.Mvg.Avg = rollmean(x=Pallet.Picks, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(BPMH.3.Month.Mvg.Avg = rollmean(x=BPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(CPMH.3.Month.Mvg.Avg = rollmean(x=CPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Total.Cases.3.Month.Mvg.Avg = rollmean(x=Total.Cases, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(C.100.CPMH.3.Month.Mvg.Avg = rollmean(x=C.100.CPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(C.200.CPMH.3.Month.Mvg.Avg = rollmean(x=C.200.CPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(C.300.400.CPMH.3.Month.Mvg.Avg = rollmean(x=C.300.400.CPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(R.Oddball.CPMH.3.Month.Mvg.Avg = rollmean(x=R.Oddball.CPMH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Unknown.CPMH.3.Month.Mvg.Avg = rollmean(x=Unknown.CMPH, 3, align='right', fill=NA))
history = history %>% group_by(Year) %>%
  mutate(Wine.Room.CPMH.3.Month.Mvg.Avg = rollmean(x=W.CMPH, 3, align='right', fill=NA))


history = data.frame(history)
headTail(history)

######################################################################################################### End Data Preparation
print('Produce graphics from data above.')




print('Cumulative Cases Produced since 2011.')
print('Monthly cases produced graph 2011 - 2015 five faceted graph. CPMH added to it.')
mostRecent = tail(history$YTD.Total.Cases, 1)
g <- ggplot(data=history, aes(x=factor(Month), y=YTD.Total.Cases))
three = g + geom_point(aes(size=YTD.Total.Cases, colour=factor(Year))) +
  geom_line(aes(colour=factor(Year))) +
  theme(legend.position="none", 
        axis.text.x=element_text(angle=90,hjust=1)) +
  facet_wrap(~ Year, nrow=1) + 
  scale_y_continuous(labels=comma) + 
  labs(title='YTD Number of Cases Produced from KC by Year',
       x="Month", y="Total Cases YTD") +
  geom_vline(xintercept=thisMonth, linetype="longdash") + 
  geom_hline(yintercept=mostRecent, linetype="longdash")
meanMonthly <- mean(history$Total.Cases)
mostRecent = tail(history$Total.Cases, 1)
g <- ggplot(data=history, aes(x=factor(Month), y=Total.Cases, group=factor(Year)))
one = g + geom_point(aes(size=Total.Cases, colour=factor(Year))) +
  theme(legend.position="none", 
        axis.text.x=element_text(angle=90,hjust=1)) +
  facet_wrap(~ Year, nrow=1) + 
  scale_y_continuous(labels=comma) + 
  labs(title='Number of Cases Produced by Month (KC), by Year w/ 3 Month Moving Avg.',
       x="Month", y="Total Cases") +
  geom_vline(xintercept=thisMonth, linetype="longdash") + 
  geom_hline(yintercept=mostRecent, linetype="longdash") + 
  geom_line(size=1,aes(x=factor(Month), y=Total.Cases.3.Month.Mvg.Avg))
meanCPMH <- round(mean(history$CPMH, na.rm=T), 2)
spot = meanCPMH - 2*round(sd(history$CPMH, na.rm=T), 2)
g <- ggplot(data=history, aes(x=factor(Month), y=CPMH))
two = g + geom_point(aes(size=CPMH)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=F, aes(group=Year, colour=factor(Year))) +
  labs(title="KC Cases Per Man Hour", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanCPMH, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg CPMH = ", meanCPMH))
grid.arrange(three, one, two, ncol=1)


print('Seasonal Cases produced graph 2011 - 2015 five faceted graph.')
g <- ggplot(data=history, aes(x=factor(Season), y=Total.Cases))
g + geom_boxplot(colour="black", aes(fill=factor(Season))) +
  theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) +
  facet_wrap(~ Year, nrow=1) + 
  scale_y_continuous(labels=comma) + 
  labs(title='STL Monthly Cases Produced Grouped by Season',
       x="Season", y="Total Cases") +
  scale_x_discrete(limits=c("Winter","Spring","Summer","Fall")) +
  geom_smooth(se=F, aes(group=Season))


print('Man hours by Season.')
history$Season <- factor(history$Season, levels=c('Winter', 'Spring', 'Summer', 'Fall'))
g <- ggplot(data=history, aes(x=factor(Season), y=Man.Hours))
g + geom_boxplot(aes(fill=factor(Season))) + facet_wrap(~Year, nrow=2) +
  labs(title="Production Man Hours", x='Season', y='Man Hours') +
  theme(legend.position='none')


print('Three month moving average of CPMH.')
meanCPMH <- round(mean(history$CPMH.3.Month.Mvg.Avg, na.rm=T), 2)
spot = meanCPMH - round(sd(history$CPMH.3.Month.Mvg.Avg, na.rm=T), 2)
g <- ggplot(data=history, aes(x=factor(Month), y=CPMH.3.Month.Mvg.Avg))
g + geom_point(aes(size=CPMH.3.Month.Mvg.Avg)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="KC Cases Per Man Hour 3 Month Moving Avg.", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanCPMH, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg CPMH = ", meanCPMH))


print('Oddball CPMH and Oddball Cases, cumulative, and oddball hours.')
g <- ggplot(data=history, aes(x=factor(Month), y=R.Oddball.Cases.3.Month.Mvg.Avg))
one = g + geom_point(aes(size=R.Oddball.Cases.3.Month.Mvg.Avg)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="KC Oddball Cases 3 Month Moving Avg.", x="Month") + 
  theme(legend.position="none") +
  scale_y_continuous(labels=comma)

meanOddball <- round(mean(history$R.Oddball.CPMH, na.rm=T), 2)
sdOddball <- sd(history$R.Oddball.CPMH, na.rm=T)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=R.Oddball.CPMH))
two = g + geom_point(aes(size=R.Oddball.CPMH)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="Oddball Cases Per Man Hour KC", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball , linetype="longdash") +
  annotate("text", y=spot, x=7, size=3,
           label=paste("Avg. Oddball CPMH =", meanOddball)) +
  scale_y_continuous(labels=comma)
mostRecent = tail(history$YTD.Oddball.Cases, 1)
g <- ggplot(data=history, aes(x=factor(Month), y=YTD.Oddball.Cases))
three = g + geom_point(aes(size=YTD.Oddball.Cases)) + facet_wrap(~Year, nrow=1) +
  geom_line(size=1, aes(group=Year, colour=factor(Year))) +
  labs(title="YTD Oddball Cases KC", x="Month") + 
  theme(legend.position="none") + 
  geom_hline(yintercept=mostRecent, linetype='longdash') +
  geom_vline(xintercept=thisMonth, linetype='longdash') +
  scale_y_continuous(labels=comma)
meanOddball <- round(mean(history$R.Oddball.Hours), 1)
sdOddball <- sd(history$R.Oddball.Hours)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=R.Oddball.Hours))
four = g + geom_point(aes(size=R.Oddball.Hours)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="Oddball Hours KC", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=7, size=3,
           label=paste("Avg. Oddball Hours =", meanOddball)) +
  scale_y_continuous(labels=comma)
meanOddball <- round(mean(history$Oddball.Cases.Percent.Total), 4)
sdOddball <- sd(history$Oddball.Cases.Percent.Total)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Oddball.Cases.Percent.Total))
five = g + geom_point(aes(size=Oddball.Cases.Percent.Total)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="Percent Oddball Cases KC", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg % Oddballs =", meanOddball)) +
  geom_vline(xintercept=12, linetype='longdash') + scale_y_continuous(labels=percent) +
  scale_y_continuous(labels=percent)
grid.arrange(five, one, three, two, four, ncol=1)




print('Bottles & BPMH.')
g <- ggplot(data=history, aes(x=factor(Month), y=Bottles..includes.samples.))
one = g + geom_point(aes(size=Bottles..includes.samples.)) + facet_wrap(~Year, nrow=1) +
  labs(title="KC Bottles (w/ Samples)", x="Month") + 
  theme(legend.position="none") + 
  geom_smooth(aes(group=Year, colour=factor(Year)), se=F) + 
  scale_y_continuous(labels=comma)
meanBPMH <- mean(history$BPMH.3.Month.Mvg.Avg, na.rm=T)
sdBPMH <- sd(history$BPMH.3.Month.Mvg.Avg, na.rm=T)
spot <- meanBPMH - (4 * sdBPMH)
g <- ggplot(data=history, aes(x=factor(Month), y=BPMH.3.Month.Mvg.Avg))
two = g + geom_point(aes(size=BPMH.3.Month.Mvg.Avg)) + facet_wrap(~Year, nrow=1) +
  labs(title="BPMH 3 Month Moving Avg.", x="Month") + 
  theme(legend.position="none") +
  geom_smooth(aes(group=Year, colour=factor(Year)), se=F)+
  scale_y_continuous(labels=comma)
grid.arrange(one, two, ncol=1)


print('Distribution of Oddball cases by year.')
g <- ggplot(data=history, aes(x=R.Oddball.Cases))
g + geom_density(aes(group=Year, fill=factor(Year)), alpha=0.5) + facet_wrap(~Year, ncol=1) +
  theme(legend.position="none") +
  labs(title='Distribution of KC Monthly Oddball Cases by Year') +
  scale_y_continuous(labels=percent) +
  scale_x_continuous(labels=comma)



print('Monthly and cumulative Man Hours KC')
meanOddball <- round(mean(history$Man.Hours), 1)
sdOddball <- sd(history$Man.Hours)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Man.Hours))
one = g + geom_point(aes(size=Man.Hours)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="Total Monthly Man Hours KC", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg. Man Hours =", meanOddball)) +
  scale_y_continuous(labels=comma)
mostRecent = tail(history$YTD.Man.Hours, 1)
g <- ggplot(data=history, aes(x=factor(Month), y=YTD.Man.Hours))
two = g + geom_point(aes(size=YTD.Man.Hours)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="YTD Man Hours KC", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=mostRecent, linetype="longdash") +
  geom_vline(xintercept=thisMonth, linetype="longdash") +
  scale_y_continuous(labels=comma)
grid.arrange(one, two, ncol=1)


print('Non-conveyables and cumulative non-conveyables.')
meanOddball <- round(mean(history$Non.Conveyable.Cases), 1)
sdOddball <- sd(history$Non.Conveyable.Cases)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Non.Conveyable.Cases))
one = g + geom_point(aes(size=Non.Conveyable.Cases)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="Non-Conveyable Cases KC", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=5, size=3,
           label=paste("Avg. Non-Conv. Cases =", meanOddball)) +
  scale_y_continuous(labels=comma)
mostRecent = tail(history$YTD.Non.Conveyables, 1)
g <- ggplot(data=history, aes(x=factor(Month), y=YTD.Non.Conveyables))
two = g + geom_point(aes(size=YTD.Non.Conveyables)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(aes(group=Year, colour=factor(Year))) +
  labs(title="YTD Non-Conveyable Cases KC", x="Month") + 
  theme(legend.position="none") + 
  geom_hline(yintercept=mostRecent, linetype="longdash")+
  scale_y_continuous(labels=comma)
grid.arrange(one,two,ncol=1)



print('OT hours monthly and cumulative YTD.')
meanOddball <- round(mean(history$OT.Hours), 2)
sdOddball <- sd(history$OT.Hours)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=OT.Hours))
one = g + geom_bar(stat='identity', aes(fill=factor(Month))) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=F, aes(group=Year, colour=factor(Year))) +
  labs(title="KC Monthly OT Hours", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=5, size=3,
           label=paste("Avg OT Hrs =", meanOddball)) +
  geom_vline(xintercept=thisMonth, linetype="longdash")
mostRecent = tail(history$YTD.OT.Hours, 1)
g <- ggplot(data=history, aes(x=factor(Month), y=YTD.OT.Hours))
two = g + geom_bar(stat='identity', aes(fill=factor(Month))) + facet_wrap(~Year, nrow=1) +
  labs(title="KC YTD OT Hours", x="Month") + 
  theme(legend.position="none") +
  geom_vline(xintercept=thisMonth, linetype="longdash") +
  geom_hline(yintercept=mostRecent, linetype="longdash")
grid.arrange(one,two,ncol=1)



print('Bottle line accuracy [UNDER CONSTRUCTION].')
meanOddball <- round(mean(history$BTL.Accuracy.STL), 5)
sdOddball <- sd(history$BTL.Accuracy.STL)
spot <- meanOddball - (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=BTL.Accuracy.STL))
g + geom_point(aes(size=BTL.Accuracy.STL)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="Bottle Accuracy STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=5, size=3,
           label=paste("Avg Btl Accuracy =", meanOddball)) +
  geom_vline(xintercept=12)


print('Case accuracy [UNDER CONSTRUCTION].')
meanOddball <- round(mean(history$Case.Accuracy.STL), 5)
sdOddball <- sd(history$Case.Accuracy.STL)
spot <- meanOddball - (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Case.Accuracy.STL))
g + geom_point(aes(size=Case.Accuracy.STL)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="Case Accuracy STL", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=5, size=3,
           label=paste("Avg Cs Accuracy =", meanOddball)) +
  geom_vline(xintercept=11)


print('Case over/short errors.')
meanOddball <- round(mean(history$Case.O.S.Errors), 2)
sdOddball <- sd(history$Case.O.S.Errors)
spot <- meanOddball - (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Case.O.S.Errors))
one = g + geom_point(aes(size=Case.O.S.Errors)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=F, aes(group=Year, colour=factor(Year))) +
  labs(title="Case O/S Errors KC", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg O/S Cases =", meanOddball)) +
  geom_vline(xintercept=thisMonth, linetype="longdash")
mostRecent = tail(history$YTD.Case.O.S.Errors, 1)
g <- ggplot(data=history, aes(x=factor(Month), y=YTD.Case.O.S.Errors))
two = g + geom_point(aes(size=YTD.Case.O.S.Errors)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="YTD Case O/S Errors KC", x="Month") + 
  theme(legend.position="none") +
  geom_vline(xintercept=thisMonth, linetype="longdash") +
  geom_hline(yintercept=mostRecent, linetype='longdash')
grid.arrange(one, two, ncol=1)





print('Bottle over/short errors.')
meanOddball <- round(mean(history$Bottle.O.S.Errors), 2)
sdOddball <- sd(history$Bottle.O.S.Errors)
spot <- meanOddball - (2 * sdOddball)
g <- ggplot(data=history, aes(x=factor(Month), y=Bottle.O.S.Errors))
one = g + geom_point(aes(size=Bottle.O.S.Errors)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=F, aes(group=Year, colour=factor(Year))) +
  labs(title="Bottle O/S Errors KC", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg O/S Bottles =", meanOddball)) +
  geom_vline(xintercept=thisMonth, linetype='longdash')
mostRecent = tail(history$YTD.Bottle.O.S.Errors, 1)
g <- ggplot(data=history, aes(x=factor(Month), y=YTD.Bottle.O.S.ErrorsL))
two = g + geom_point(aes(size=YTD.Bottle.O.S.ErrorsL)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=T, aes(group=Year, colour=factor(Year))) +
  labs(title="YTD Bottle O/S Errors KC", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept= mostRecent, linetype="longdash") +
  geom_vline(xintercept=thisMonth, linetype='longdash')
grid.arrange(one,two,ncol=1)


print("P2V")
p2v = filter(history, P2V.BPMH > 0)
meanOddball <- round(mean(p2v$P2V.BPMH), 1)
sdOddball <- sd(p2v$P2V.BPMH)
spot <- meanOddball + (2 * sdOddball)
g <- ggplot(data=p2v, aes(x=factor(Month), y=P2V.BPMH))
g + geom_point(aes(size=P2V.BPMH)) + facet_wrap(~Year, nrow=1) +
  geom_smooth(se=F, aes(group=Year, colour=factor(Year))) +
  labs(title="P2V BPMH KC", x="Month") + 
  theme(legend.position="none") +
  geom_hline(yintercept=meanOddball, linetype="longdash") +
  annotate("text", y=spot, x=6, size=3,
           label=paste("Avg P2V BPMH =", meanOddball)) +
  geom_vline(xintercept=thisMonth, linetype='longdash') +
  scale_y_continuous(labels=comma)
rm(p2v)








print('Examine cases per line trends.')
c = data.frame(history$C.100.Cases.3.Month.Mvg.Avg) 
c$Line = 'C-100'
c$Year = history$Year
c$Month = history$Month
c$Year.Month = history$Year.Month
names(c) = c('Three.Month.Mvg.Avg.Cases', 'Line', 'Year', 'Month', 'Year.Month')

d = data.frame(history$C.200.Cases.3.Month.Mvg.Avg) 
d$Line = 'C-200'
d$Year = history$Year
d$Month = history$Month
d$Year.Month = history$Year.Month
names(d) =  c('Three.Month.Mvg.Avg.Cases', 'Line', 'Year', 'Month', 'Year.Month')

e = data.frame(history$C.300.400.Cases.3.Month.Mvg.Avg) 
e$Line = 'C-300 & C-400'
e$Year = history$Year
e$Month = history$Month
e$Year.Month = history$Year.Month
names(e) =  c('Three.Month.Mvg.Avg.Cases', 'Line', 'Year', 'Month', 'Year.Month')

o = data.frame(history$R.Oddball.Cases.3.Month.Mvg.Avg) 
o$Line = 'Odd Ball'
o$Year = history$Year
o$Month = history$Month
o$Year.Month = history$Year.Month
names(o) =  c('Three.Month.Mvg.Avg.Cases', 'Line', 'Year', 'Month', 'Year.Month')

w = data.frame(history$W.Cases.3.Month.Mvg.Avg) 
w$Line = 'Wine Room'
w$Year = history$Year
w$Month = history$Month
w$Year.Month = history$Year.Month
names(w) =  c('Three.Month.Mvg.Avg.Cases', 'Line', 'Year', 'Month', 'Year.Month')

u = data.frame(history$Unknown.Cases.3.Month.Mvg.Avg) 
u$Line = 'Unknown'
u$Year = history$Year
u$Month = history$Month
u$Year.Month = history$Year.Month
names(u) =  c('Three.Month.Mvg.Avg.Cases', 'Line', 'Year', 'Month', 'Year.Month')

lines = rbind(c, d, e, o, w, u)
lines$Year.Month = factor(lines$Year.Month, 
                          levels=c('2011-01', '2011-02', '2011-03', '2011-04', '2011-05', '2011-06',
                                   '2011-07', '2011-08', '2011-09', '2011-10', '2011-11', '2011-12',
                                   '2012-01', '2012-02', '2012-03', '2012-04', '2012-05', '2012-06',
                                   '2012-07', '2012-08', '2012-09', '2012-10', '2012-11', '2012-12',
                                   '2013-01', '2013-02', '2013-03', '2013-04', '2013-05', '2013-06',
                                   '2013-07', '2013-08', '2013-09', '2013-10', '2013-11', '2013-12',
                                   '2014-01', '2014-02', '2014-03', '2014-04', '2014-05', '2014-06',
                                   '2014-07', '2014-08', '2014-09', '2014-10', '2014-11', '2014-12',
                                   '2015-01', '2015-02', '2015-03', '2015-04', '2015-05', '2015-06',
                                   '2015-07', '2015-08', '2015-09', '2015-10', '2015-11', '2015-12'))
headTail(lines)

g = ggplot(data=lines, aes(x=factor(Year.Month), y=Three.Month.Mvg.Avg.Cases, group=Line))
one = g + geom_point() + facet_wrap(~Line, ncol=1, scales='free_y') +
  geom_line(size=1, aes(colour=Line)) + 
  theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1)) +
  geom_smooth(aes(group=Line), se=F, colour='black', size=0.5) +
  scale_y_continuous(labels=comma) +
  labs(title='Monthly Volume Three Month Moving Average by Case Line', 
       x='Year & Month', y='Case Volume')

rbind(c, d, e, o, w, u, lines)

print('Examine production rate by line and warehouse area and combine with above.')
c = data.frame(history$C.100.CPMH.3.Month.Mvg.Avg) 
c$Line = 'C-100'
c$Year = history$Year
c$Month = history$Month
c$Year.Month = history$Year.Month
names(c) = c('Three.Month.Mvg.Avg.CPMH', 'Line', 'Year', 'Month', 'Year.Month')

d = data.frame(history$C.200.CPMH.3.Month.Mvg.Avg) 
d$Line = 'C-200'
d$Year = history$Year
d$Month = history$Month
d$Year.Month = history$Year.Month
names(d) =  c('Three.Month.Mvg.Avg.CPMH', 'Line', 'Year', 'Month', 'Year.Month')

e = data.frame(history$C.300.400.CPMH.3.Month.Mvg.Avg) 
e$Line = 'C-300 & C-400'
e$Year = history$Year
e$Month = history$Month
e$Year.Month = history$Year.Month
names(e) =  c('Three.Month.Mvg.Avg.CPMH', 'Line', 'Year', 'Month', 'Year.Month')

o = data.frame(history$R.Oddball.CPMH.3.Month.Mvg.Avg) 
o$Line = 'Odd Ball'
o$Year = history$Year
o$Month = history$Month
o$Year.Month = history$Year.Month
names(o) =  c('Three.Month.Mvg.Avg.CPMH', 'Line', 'Year', 'Month', 'Year.Month')


w = data.frame(history$Wine.Room.CPMH.3.Month.Mvg.Avg) 
w$Line = 'Wine Room'
w$Year = history$Year
w$Month = history$Month
w$Year.Month = history$Year.Month
names(w) =  c('Three.Month.Mvg.Avg.CPMH', 'Line', 'Year', 'Month', 'Year.Month')

u = data.frame(history$Unknown.CPMH.3.Month.Mvg.Avg) 
u$Line = 'Unknown'
u$Year = history$Year
u$Month = history$Month
u$Year.Month = history$Year.Month
names(u) =  c('Three.Month.Mvg.Avg.CPMH', 'Line', 'Year', 'Month', 'Year.Month')

lines = rbind(c, d, e, o, w, u)
lines$Year.Month = factor(lines$Year.Month, 
                          levels=c('2011-01', '2011-02', '2011-03', '2011-04', '2011-05', '2011-06',
                                   '2011-07', '2011-08', '2011-09', '2011-10', '2011-11', '2011-12',
                                   '2012-01', '2012-02', '2012-03', '2012-04', '2012-05', '2012-06',
                                   '2012-07', '2012-08', '2012-09', '2012-10', '2012-11', '2012-12',
                                   '2013-01', '2013-02', '2013-03', '2013-04', '2013-05', '2013-06',
                                   '2013-07', '2013-08', '2013-09', '2013-10', '2013-11', '2013-12',
                                   '2014-01', '2014-02', '2014-03', '2014-04', '2014-05', '2014-06',
                                   '2014-07', '2014-08', '2014-09', '2014-10', '2014-11', '2014-12',
                                   '2015-01', '2015-02', '2015-03', '2015-04', '2015-05', '2015-06',
                                   '2015-07', '2015-08', '2015-09', '2015-10', '2015-11', '2015-12'))
headTail(lines)

g = ggplot(data=lines, aes(x=factor(Year.Month), y=Three.Month.Mvg.Avg.CPMH, group=Line))
two = g + geom_point() + facet_wrap(~Line, ncol=1, scales='free_y') +
  geom_line(size=1, aes(colour=Line)) + 
  theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1)) +
  geom_smooth(aes(group=Line), se=F, colour='black', size=0.5) +
  scale_y_continuous(labels=comma) +
  labs(title='Monthly CPMH Three Month Moving Average by Case Line', 
       x='Year & Month', y='Case Per Man Hour')
grid.arrange(one,two, ncol=2)

rm(c, d, e, o, w, u, lines)




print('Number of employees moving average.')


print('Examine Total Stops moving average.')









