library(ggplot2)
library(reshape2)
library(scales)

# Looking at breakage in more tidy format than the Breakage report
setwd("C:/Users/pmwash/Desktop/R_Files")
breaks<-read.csv("Breakage_2013-2015.csv",header=TRUE)




# Gross Unsaleable Time Series by Year/Month (% Revenue)
g <- ggplot(breaks, aes(x=Year.Month, y=Driver.Breakage,
                        size=Sales), group=1)
g + geom_point(aes(size=Driver.Breakage)) + geom_line(aes(group=1), colour="red", size=1) + 
  geom_smooth(aes(group=1), colour="black") +
  theme(axis.text.x=element_text(angle=90,hjust=1),
        plot.background=element_rect(fill=40)) +
  labs(title="Driver Breakage") + 
  scale_shape_identity() + theme(legend.position="bottom") +
  labs(x="Year & Month", y="Dollars ($)")



# Look at monthly unsaleables in 2013, 2014, 2015
# This output is looking at the average for each month, and 
# Shouldn't be considered a sum of each year
p <- ggplot(breaks, aes(factor(Year), 
                        Gross.Unsaleable.Percent.Revenue))
total <- p + geom_boxplot(outlier.colour="red", aes(fill=factor(Year))) + 
  geom_jitter(aes(size=Sales)) + 
  labs(title="Average Monthly Gross Unsaleable STL (% Sales)",
       x="Year", y="Percent of Sales") +
  theme(legend.position="right") + scale_y_continuous(labels=percent)

# LOOK AT SAME DATA FOR DRIVER
p <- ggplot(breaks, aes(factor(Year), 
                        Driver.Brk.Percent.Sales))
driver <- p + geom_boxplot(outlier.colour="red", aes(fill=factor(Year))) + 
  geom_jitter(aes(size=Sales)) + 
  labs(title="Average Monthly Driver Breakage (% Sales)",
       x="Year", y="Percent of Sales") +
  theme(legend.position="right") + scale_y_continuous(labels=percent)

# LOOK AT SAME DATA FOR WAREHOUSE
p <- ggplot(breaks, aes(factor(Year), 
                        Whse.Break.Percent.Sales))
warehouse <- p + geom_boxplot(outlier.colour="red", aes(fill=factor(Year))) + 
  geom_jitter(aes(size=Sales)) + 
  labs(title="Average Monthly Warehouse Breakage (% Sales)",
       x="Year", y="Percent of Sales") +
  theme(legend.position="right") + scale_y_continuous(labels=percent)+geom_line()

# Put the graphs together
library(grid)
library(gridExtra)
grid.arrange(total, driver, warehouse, ncol=1)




# Look at distribution of monthly unsaleables for 2013, 2014, 2015

p <- ggplot(breaks, aes(Gross.Unsaleable.Percent.Revenue))
p + geom_histogram(colour="black", aes(y=..density.., fill=..count..)) + 
  geom_density(alpha=.2) +
  scale_fill_gradient("Count", low="blue", high="orange") +
  labs(title="Histogram, Gross Unsaleable As % Revenue",
       x="Gross Unsaleable As A Percent of Revenue Bins",
       y="Density") +
  theme(legend.position="bottom")


# Look at data separated by months (factor month)

p <- ggplot(breaks, aes(factor(Month), 
                        Driver.Breakage, size=Driver.Breakage))
p + geom_boxplot(aes(fill=factor(Month))) + geom_jitter(aes(size=Driver.Breakage)) +
  theme(legend.position="bottom") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Average Driver Breakage by Month (2013-2015)",
       x="Month", y="Dollars($)")

# Check quantiles of Unsaleables
unsaleable<-breaks$Gross.Unsaleable.Percent.Revenue
sales<-breaks$Sales
quantile(unsaleable, c(0.1, 0.25, 0.5, 0.75, 0.9, 0.99))











#### WAREHOUSE GRAPHS ####
# Warehouse Breakage Time Series
v <- ggplot(data=breaks, aes(Year.Month, Warehouse.Breakage, group=1))
v + geom_line(colour="blue", size=1, aes(y=Warehouse.Breakage)) +
  geom_point(aes(size=Warehouse.Breakage)) +
  theme(axis.text.x=element_text(angle=90,hjust=1),
        plot.background=element_rect(fill=40), legend.position="bottom") +
  labs(title="Monthly Warehouse Breakage 2013-Present", x="Year & Month",
       y="Breakage ($)") + 
  geom_smooth(colour="black")




# Histogram of Warehouse Breakage (Monthly) Since 2013
p <- ggplot(breaks, aes(Warehouse.Breakage))
p + geom_histogram(colour="black", aes(y=..density.., fill=..count..),
                   binwidth=350) + 
  geom_density(alpha=.2) +
  scale_fill_gradient("Count", low="blue", high="orange") +
  labs(title="Histogram of Monthly Warehouse Breakage, 2013-2015",
       x="Warehouse Breakage ($) Bins",
       y="Density") +
  theme(legend.position="bottom")




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



# Histogram of STL Driver Breakage Per Month
p <- ggplot(data=breaks, aes(Driver.Breakage))
p + geom_histogram(binwidth=175, colour="black", 
                   aes(y=..density.., fill=..count..)) + 
  geom_density() + theme(legend.position="bottom") +
  labs(title="Histogram of Monthly Driver Breakage, 2013-2015",
       x="Monthly Driver Breakage ($) Bins", y="Density")

driver<-breaks$Driver.Breakage
quantile(driver, c(0.05, 0.25, 0.5, 0.75, 0.95))



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
p <- ggplot(breaks, aes(Month, STL.Total))
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
  facet_wrap(~Year, nrow=1) 

  theme(legend.position="bottom") + 
  labs(title="Cumulative Total Breakage (STL) By Year",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="lightblue", high="darkblue") + 
  geom_bar(stat='identity', colour="black", fill="coral") + 
  geom_smooth(size=1.5, colour="black", method="lm", aes(group=1))




















