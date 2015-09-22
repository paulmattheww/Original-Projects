# Beer Analysis 

setwd("C:/Users/pmwash/Desktop/R_Files")
beer <- read.csv("BeerAnalysis.csv", header=TRUE)

top10 <- beer[1:10,]
top10<-top10[order(Dollars.YTD)]
# Re-order the brands
top10$Brand <- factor(top10$Brand, 
                      levels=top10$Brand[order(top10$Dollars.YTD,
                                               decreasing=TRUE)])

library(ggplot2)
library(scales)
library(gridExtra)
library(RColorBrewer)
library(tidyr)
library(dplyr)


# Barplot of the top 10 Beer Brands (YTD 2015)
b <- ggplot(data=top10, aes(x=factor(Brand), y=Dollars.YTD))
b + geom_bar(stat="identity", aes(colour=Dollars.YTD, order=Dollars.YTD),
             colour="black", fill="lightgreen") +
  theme(axis.text.x=element_text(angle=90,hjust=1), legend.position="bottom") +
  scale_y_continuous(labels=dollar) +
  labs(title="Top 10 Beer Sellers 2015 YTD", x="Brand", 
       y="Dollars ($) Sold  YTD") 

brandSales <- beer$Dollars.YTD
quantile(brandSales, c(.01 ,.20, .40, .60, .80, .99))
summary(brandSales)

grossProfit <- beer$Percent.Gross.Profit
quantile(grossProfit, c(.01 ,.20, .40, .60, .80, .99))
summary(grossProfit)

# Histogram of Gross Profit (%) YTD 2015
breaks<-( 0.665- (-0.537)) / 50
numberTicks <- function(n) {function(limits) pretty(limits, n)}
b <- ggplot(beer, x=Percent.Gross.Profit)
b + geom_histogram(binwidth=breaks,colour="black", fill="pink",
                   aes(x=Percent.Gross.Profit)) +
  scale_x_continuous(breaks=numberTicks(10),labels=percent) +
  labs(title="Distribution of Beer Gross Profit, 2015 YTD") 


avgProfit<-mean(beer$Percent.Gross.Profit)
salesCutoff <- quantile(brandSales, .5)
highValueBrands <- beer[which(beer$Percent.Gross.Profit > avgProfit 
                              & beer$Dollars.YTD > salesCutoff), ]
highValueBrands <- select(highValueBrands, 
                          Brand, Dollars.YTD, Percent.Gross.Profit)


salesCutoff <- quantile(brandSales, .75)
profitCutoff <- quantile(beer$Percent.Gross.Profit, .25)
lowMarginHighVolume <- beer[which(beer$Percent.Gross.Profit < profitCutoff 
                                  & beer$Dollars.YTD > salesCutoff), ]
lowMarginHighVolume <- select(lowMarginHighVolume, 
                          Brand, Dollars.YTD, Percent.Gross.Profit, Profit.YTD)



avgProfitYTD<-mean(beer$Profit.YTD)
ytdProfitCutoff <- quantile(beer$Profit.YTD, 0.9)
mostValuableBeers <- beer[which(beer$Profit.YTD > ytdProfitCutoff) ,]
mostValuableBeers <- select(mostValuableBeers, 
                            Brand, Dollars.YTD, Percent.Gross.Profit, 
                            Profit.YTD)
mostValuableBeers <- mostValuableBeers[order(-mostValuableBeers$Profit.YTD),]
ytdProfitBestBeers<-sum(mostValuableBeers$Profit.YTD)
ytdProfitAllBeers<-sum(beer$Profit.YTD)


brand<-beer$Brand
ifelse(grepl(("HEFE | WHEAT"), brand), "HEFE", 
       ifelse(grepl("IPA | INDIAN PALE ALE", brand), "IPA", 
              ifelse(grepl("STOUT", brand), "STOUT", "")



adHoc <- read.csv("beerAdHoc.csv",header=TRUE)
a <- ggplot(data=adHoc, aes(x=Invoice.Date, y=Dollars, size=Gross.Profit.Percent))
a + geom_point(aes(group=1)) + geom_smooth(aes(group=1))


a + geom_point(aes(size=Gross.Profit.Percent, group=1) + 
                geom_smooth(aes(group=1))




