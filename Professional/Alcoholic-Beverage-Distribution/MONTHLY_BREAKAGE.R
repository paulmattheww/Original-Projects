# Monthly Breakage
  # DON"T FORGET TO DELETE POSITIVE NUMBERS AS THEY ARE NOT TRUE BREAKAGE
  # Run the query CABREAKAGE first and drop into CABREAKAGE csv doc
  # ENSURE THAT YOU HAVE CHOSEN THE CORRECT WAREHOUSE



library(xlsx)
setwd("C:/Users/pmwash/Desktop/R_Files")
breaks <- read.xlsx2("CABREAKAGE-KC.xlsx", sheetIndex=1)
breaks <- filter(breaks, X.RCODE != 1)

# Filter dataset 
library(dplyr)


# Break out a COUNT of incidents by Sales, Driver, Whse, Col, Totals
  # for liquor wine beer NA
spread <- aggregate(CASES ~ X.RCODE + PTYPE, data=breaks, FUN=length)
spread <- data.frame(spread)
library(tidyr)
moneyShot1 <- spread(spread, PTYPE, CASES)
names(moneyShot1) <- c("Reason.Code", "Liquor (1)", "Wine (2)", "Beer (3)", "Non-Alc (4)")
reason <- moneyShot1$Reason.Code
moneyShot1$Reason.Code <- ifelse(reason == 2, "Sales (2)", 
       ifelse(reason == 3, "Warehouse (3)",
              ifelse(reason==4, "Driver (4)", 
                     ifelse(reason==5, "Columbia (5)", ""))))
names(moneyShot1) <-c("", "Liquor (1)", "Wine (2)", "Beer (3)", "Non-Alc (4)")
moneyShot1
invert1 <- data.frame(t(moneyShot1))



# Break out a SUM of dollars by Sales, Driver, Whse, Col, Totals
  # for liquor wine beer NA
#positive <- filter(breaks, EXT_COST < 0)
breaks$EXT_COST <- as.numeric(as.character(breaks$EXT_COST))
spread <- aggregate(abs(EXT_COST) ~ X.RCODE + PTYPE, data=breaks, FUN=sum)
spread <- data.frame(spread)
library(tidyr)
moneyShot2 <- spread(spread, PTYPE, abs.EXT_COST.)
names(moneyShot2) <- c("Reason.Code", "Liquor (1)", "Wine (2)", "Beer (3)", "Non-Alc (4)")
reason <- moneyShot2$Reason.Code
moneyShot2$Reason.Code <- ifelse(reason == 2, "Sales (2)", 
                                ifelse(reason == 3, "Warehouse (3)",
                                       ifelse(reason==4, "Driver (4)", 
                                              ifelse(reason==5, "Columbia (5)", ""))))
names(moneyShot2) <-c("", "Liquor (1)", "Wine (2)", "Beer (3)", "Non-Alc (4)")
moneyShot2
invert2 <- data.frame(t(moneyShot2))
invert2




# Break out a SUM of CASES by ADJ CODES
  # for liquor wine beer NA
#breaks$CASES <- as.numeric(breaks$CASES)
spread <- aggregate(as.numeric(as.character(CASES)) ~ X.RCODE, data=breaks, FUN=sum)
spread <- data.frame(spread)
library(tidyr)
moneyShot3 <- spread
names(moneyShot3) <- c("Reason.Code", "Cases.Broken")
reason <- moneyShot3$Reason.Code
moneyShot3$Reason.Code <- ifelse(reason == 2, "Sales (2)", 
                                ifelse(reason == 3, "Warehouse (3)",
                                       ifelse(reason==4, "Driver (4)", 
                                              ifelse(reason==5, "Columbia (5)", ""))))
names(moneyShot3) <-c("", "Cases.Broken")
moneyShot3
invert3 <- data.frame(t(moneyShot3))
invert3


# See the results below

#View(invert1)
#View(invert2)
#View(invert3)

invert1 <- invert1[, c(1, 3, 2, 4)]
print("Remember that this is in dollar units.")
invert2 <- invert2[, c(1, 3, 2, 4)]
#DO NOT DO THIS FOR INVERT 3

invert1
invert2
invert3




#######################################
#######################################
############## HISTORY ################
#######################################
#######################################
############## HISTORY ################
#######################################
#######################################
############## HISTORY ################
#######################################
#######################################
############## HISTORY ################
#######################################
#######################################



# THIS IS FOR STL 



# HISTORY

library(ggplot2)
library(reshape2)
library(scales)

# Looking at breakage in more tidy format than the Breakage report
setwd("C:/Users/pmwash/Desktop/R_Files")
breaks<-read.csv("Breakage_2013-2015.csv",header=TRUE)


# 3 Graphs Faceted, Monthly WAREHOUSE Breakage STL
p <- ggplot(breaks, aes(Month, Warehouse.Breakage))
p + geom_point(aes(colour=Warehouse.Breakage, size=Warehouse.Breakage)) + 
  theme(legend.position="bottom") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly Warehouse Breakage",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="purple", high="orange")

# 3 Graphs Faceted, PERCENT OF SALES Monthly WAREHOUSE Breakage STL
library(scales)
p <- ggplot(breaks, aes(Month, Whse.Break.Percent.Sales))
p + geom_point(aes(colour=Whse.Break.Percent.Sales, 
                   size=Whse.Break.Percent.Sales)) + 
  theme(legend.position="bottom") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly Warehouse Breakage (% of Sales)",
       x="Month", y="Percent of Sales") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="purple", high="orange") +
  scale_y_continuous(labels=percent)



#### DRIVER GRAPHS ####
# 3 Graphs Faceted, Monthly DRIVER Breakage STL
p <- ggplot(breaks, aes(Month, Driver.Breakage))
p + geom_point(aes(colour=Driver.Breakage, size=Driver.Breakage)) + 
  theme(legend.position="bottom") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly Driver Breakage",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="green", high="red")

# 3 Graphs Faceted, PERCENT OF SALES Monthly DRIVER BREAKAGE STL
library(scales)
p <- ggplot(breaks, aes(Month, Driver.Brk.Percent.Sales))
p + geom_point(aes(colour=Driver.Brk.Percent.Sales, 
                   size=Driver.Brk.Percent.Sales)) + 
  theme(legend.position="bottom") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly STL Driver Breakage (% of Sales)",
       x="Month", y="Percent of Sales") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="green", high="red") +
  scale_y_continuous(labels=percent)




#### COLUMBIA GRAPHS ####
# 3 Graphs Faceted, Monthly COLUMBIA Breakage 
p <- ggplot(breaks, aes(Month, Col.Breakage))
p + geom_point(aes(colour=Col.Breakage, size=Col.Breakage)) + 
  theme(legend.position="bottom") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly Columbia Breakage",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="green", high="black") +
  scale_y_continuous(limits=c(0, 2500))





#### STL TOTAL BREAKGE GRAPHS ####
# 3 Graphs Faceted, Monthly STL TOTAL Breakage 
p <- ggplot(breaks, aes(factor(Month), STL.Total))
p + geom_point(aes(colour=STL.Total, size=STL.Total)) + 
  theme(legend.position="bottom") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Total STL Monthly Breakage",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="darkblue", high="yellow") 


# Cumulative STL TOTAL BREAKAGE
p <- ggplot(breaks, aes(factor(Month), STL.Cumulative.By.Year, 
                        fill=factor(Year)))
p + geom_point(aes(fill=factor(Year), group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=STL.Cumulative.By.Year, colour=factor(Year),
                group=factor(Year))) +
  geom_smooth(method="lm", aes(group=factor(Year))) +
  theme(legend.position="bottom") + 
  labs(title="Cumulative Total Breakage (STL) By Year",
       x="Month", y="Dollars ($)") +
  facet_wrap(~Year, nrow=1) +
  geom_vline(xintercept=9) +
  geom_hline(yintercept= 68250.77)





























################################################ KANSAS CITY
################################################ KANSAS CITY
################################################ KANSAS CITY
################################################ KANSAS CITY
################################################ KANSAS CITY
################################################ KANSAS CITY
################################################ KANSAS CITY
################################################ KANSAS CITY










# HISTORY

library(ggplot2)
library(reshape2)
library(scales)

# Looking at breakage in more tidy format than the Breakage report
setwd("C:/Users/pmwash/Desktop/R_Files")
breaks<-read.csv("KC_BREAKAGE_REPORT.csv",header=TRUE)
breaks$Warehouse.Breakage <- as.numeric(breaks$Warehouse.Breakage)
breaks$Driver.Breakage <- as.numeric(breaks$Driver.Breakage)
breaks$Springfield.Breakage <- as.numeric(breaks$Springfield.Breakage)
#breaks$Total.Breakage.KC <- as.numeric(as.character(breaks$Total.Breakage.KC))
breaks$Cumulative.Sales.YTD <- as.numeric(breaks$Cumulative.Sales.YTD)
breaks$Cumulative.Unsaleables.YTD <- as.numeric(breaks$Cumulative.Unsaleables.YTD)
breaks$Cumulative.YTD.Breakage.Only <- as.numeric(breaks$Cumulative.YTD.Breakage.Only)

breaks <- breaks[!is.na(breaks$Year), ]
breaks <- breaks[!is.na(breaks$Month), ]


# 3 Graphs Faceted, Monthly WAREHOUSE Breakage STL PERCENT OF SALES
p <- ggplot(breaks, aes(factor(Month), Whse.Break.Percent.Sales))
p + geom_point(aes(colour=Warehouse.Breakage, size=Warehouse.Breakage)) + 
  theme(legend.position="bottom", axis.text.x=element_text(angle=90,hjust=1)) +
  geom_smooth(aes(group=1), colour="black") +
  labs(title="Monthly Warehouse Breakage Kansas City",
       x="Month", y="Percent of Sales") + facet_wrap(~Year, nrow=2) +
  scale_colour_gradient(low="purple", high="orange")

# UNDER CONSTRUCTION, USE DOLLARS NOT PERCENT OF SALES
library(scales)
#p <- ggplot(breaks, aes(Month, Whse.Break.Percent.Sales))
#p + geom_point(aes(colour=Whse.Break.Percent.Sales, 
                  # size=Whse.Break.Percent.Sales)) + 
  theme(legend.position="bottom") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly Warehouse Breakage (% of Sales)",
       x="Month", y="Percent of Sales") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="purple", high="orange") +
  scale_y_continuous(labels=percent)



#### DRIVER GRAPHS ####
# 3 Graphs Faceted, Monthly DRIVER Breakage STL
p <- ggplot(breaks, aes(factor(Month), Driver.Breakage))
p + geom_point(aes(colour=Driver.Breakage, size=Driver.Breakage)) + 
  theme(legend.position="bottom") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly Driver Breakage",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=2) +
  scale_colour_gradient(low="green", high="red")

# 3 Graphs Faceted, PERCENT OF SALES Monthly DRIVER BREAKAGE STL
library(scales)
p <- ggplot(breaks, aes(Month, Driver.Brk.Percent.Sales))
p + geom_point(aes(colour=Driver.Brk.Percent.Sales, 
                   size=Driver.Brk.Percent.Sales)) + 
  theme(legend.position="bottom") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly KC Driver Breakage (% of Sales)",
       x="Month", y="Percent of Sales") + facet_wrap(~Year, nrow=2) +
  scale_colour_gradient(low="green", high="red") +
  scale_y_continuous(labels=percent)




#### Springfield GRAPHS ####
# 3 Graphs Faceted, Monthly sprg Breakage 
library(dplyr)
pup <- filter(breaks, Year >= 2009)
p <- ggplot(pup, aes(factor(Month), Sprgfld.Percent.Sales))
p + geom_point(aes(colour=Springfield.Breakage, 
                   size=Springfield.Breakage)) + 
  theme(legend.position="bottom") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly Springfield Breakage",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="green", high="black") #+
  scale_y_continuous(limits=c(0, 2500))





#### KC TOTAL BREAKGE GRAPHS ####
# 3 Graphs Faceted, Monthly STL TOTAL Breakage 
p <- ggplot(breaks, aes(factor(Month), 
                        Total.KC.Breakage.Percent.Sales))
p + geom_point(aes(colour=Total.KC.Breakage.Percent.Sales, 
                   size=Total.KC.Breakage.Percent.Sales)) + 
  theme(legend.position="bottom") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Total KC Monthly Breakage",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=2) +
  scale_colour_gradient(low="darkblue", high="yellow") +
  scale_y_continuous(label=percent, limits=c(0, 0.008))




# CUM KC BREAKAGE
p <- ggplot(breaks, aes(factor(Month), Cumulative.Breakage.YTD, 
                        fill=factor(Year)))
p + geom_point(aes(fill=factor(Year), group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=Cumulative.Breakage.YTD, colour=factor(Year),
                group=factor(Year))) +
  geom_smooth(method="lm", aes(group=factor(Year))) +
  theme(legend.position="bottom") + 
  labs(title="Cumulative Total Breakage + Unsaleables (KC) By Year (Including Unsaleables)",
       x="Month", y="Dollars ($)") +
  facet_wrap(~Year, nrow=2) +
  geom_vline(xintercept=9) +
  geom_hline(yintercept= 479396.5407) +
  scale_y_continuous(label=dollar, limits=c(0,500000))



# CUM KC TOTAL BREAKAGE AS PERCENT OF CUM SALES
p <- ggplot(breaks, aes(factor(Month), Percent.Cumulative.Breakage.YTD, 
                        fill=factor(Year)))
p + geom_point(aes(fill=factor(Year), size=Cumulative.Sales.YTD,
                   group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=Percent.Cumulative.Breakage.YTD, 
                colour=factor(Year),
                group=factor(Year))) +
  geom_smooth(method="lm", aes(group=factor(Year))) +
  theme(legend.position="bottom") + 
  labs(title="KC: Percent Cumulative Breakage of Cumulative Sales YTD (Including Unsaleables)",
       x="Month", y="Percent of Cumulative Sales") +
  facet_wrap(~Year, nrow=2) +
  geom_vline(xintercept=9) +
  geom_hline(yintercept= 0.00446870883008866) +
  scale_y_continuous(label=percent) #, limits=c(0,500000))



# Cum sales
p <- ggplot(breaks, aes(factor(Month), Cumulative.Sales.YTD, 
                        fill=factor(Year)))
p + geom_point(aes(fill=factor(Year), group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=Cumulative.Sales.YTD, colour=factor(Year),
                group=factor(Year))) +
  geom_smooth(method="lm", aes(group=factor(Year))) +
  theme(legend.position="bottom") + 
  labs(title="KC Cumulative Sales YTD",
       x="Month", y="Dollars ($)") +
  facet_wrap(~Year, nrow=2) +
  geom_vline(xintercept=9) +
  geom_hline(yintercept= 107278535.91) +
  scale_y_continuous(label=dollar) #, limits=c(0,500000))



# Cum UNSALEABLES
p <- ggplot(breaks, aes(factor(Month), Cumulative.Unsaleables.YTD, 
                        fill=factor(Year)))
p + geom_point(aes(fill=factor(Year), group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=Cumulative.Unsaleables.YTD, colour=factor(Year),
                group=factor(Year))) +
  geom_smooth(method="lm", aes(group=factor(Year))) +
  theme(legend.position="bottom") + 
  labs(title="KC Cumulative Unsaleables YTD",
       x="Month", y="Dollars ($)") +
  facet_wrap(~Year, nrow=2) +
  geom_vline(xintercept=9) +
  geom_hline(yintercept= 420849.8167) +
  scale_y_continuous(label=dollar) #, limits=c(0,500000))



# Cum BREAKAGE ONLY
p <- ggplot(breaks, aes(factor(Month), Cumulative.YTD.Breakage.Only, 
                        fill=factor(Year)))
p + geom_point(aes(fill=factor(Year), group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=Cumulative.YTD.Breakage.Only, colour=factor(Year),
                group=factor(Year))) +
  geom_smooth(method="lm", aes(group=factor(Year))) +
  theme(legend.position="bottom") + 
  labs(title="KC Cumulative Breakage Only YTD",
       x="Month", y="Dollars ($)") +
  facet_wrap(~Year, nrow=2) +
  geom_vline(xintercept=9) +
  geom_hline(yintercept= 58546.724) +
  scale_y_continuous(label=dollar) #, limits=c(0,500000))











