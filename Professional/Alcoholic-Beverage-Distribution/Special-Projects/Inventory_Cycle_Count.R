# Inventory Cycle Count
library(dplyr)
library(xlsx)

setwd('C:/Users/pmwash/Desktop/R_files/Data Input')

# Diver = TODAY'S INVENTORY dive in Tanya's folder
inventory <- read.csv('todays_inventory_STL_diver_11122015.csv', header=TRUE)
names(inventory)[1] <- 'Item.Number'

####################################################################################
# Merge together for locations and sizes
#inventory <- merge(hiJump, diver, by='Item.Number')
head(inventory)

cls <- as.character(inventory$Product.Class)
inventory$Product.Class <- ifelse(grepl("Wine", cls) == TRUE, "WINE", 
                              ifelse(grepl("Beer", cls) == TRUE, "BEER", cls))
cls <- as.character(inventory$Product.Class)
inventory$Product.Class <- ifelse(cls == 'High Alcohol Malt', 'BEER', 
                              ifelse(cls == 'High Alcohol Malt Kegs', 'BEER',
                                     ifelse(cls == 'Other Non-Alcoholic', 'NON-ALCOHOLIC',
                                            ifelse(cls == 'Red Bull', 'NON-ALCOHOLIC',
                                                   ifelse(cls == 'Water / Soda', 'NON-ALCOHOLIC',
                                                          ifelse(cls == 'Keg Cider', 'BEER',
                                                                 ifelse(cls == 'Taxable Items - On Premise', 'LIQUOR',
                                                                        ifelse(cls == 'Misc', 'NON-ALCOHOLIC',
                                                                               ifelse(cls == 'Spirit Coolers', 'LIQUOR', 
                                                                                      ifelse(cls == 'Cider', 'BEER', 
                                                                                             ifelse(cls == 'Liquor', 'LIQUOR', cls)))))))))))


names(inventory)[1] <- 'Item.Number'
inventoryValues <- inventory[,c(3, 1, 15, 2)]
tail(inventoryValues)
sumAllInventory <- sum(inventoryValues$Value.On.Hand)

# Read in inventory data
locations <- read.csv('product_locations_10232015.csv', header=TRUE)
locNum <- locations[,c(1,3)]
head(locNum)

# merge in locations
invenLocs <- merge(inventoryValues, locNum, by='Item.Number')
head(invenLocs)

# Break out information by class
byClass <- aggregate(Value.On.Hand ~ Product.Class, data=invenLocs, FUN=sum)
val <- byClass$Value.On.Hand
tot <- sum(byClass$Value.On.Hand)
byClass$Percent.Value.OH <- round(as.numeric(val / tot), 3)
byClass <- arrange(byClass, desc(Percent.Value.OH))

byCount <- aggregate(Value.On.Hand ~ Product.Class, data=inventory, FUN=length)
names(byCount) <- c('Product.Class', 'Number.of.Items')
bySalesTY <- aggregate(Sales.YTD.TY ~ Product.Class, data=inventory, FUN=sum)

class <- merge(byClass, byCount, by='Product.Class')
class <- merge(class, bySalesTY, by='Product.Class')
class$Avg.OH.Per.Item <- class$Value.On.Hand / class$Number.of.Items


class <- arrange(class, desc(Value.On.Hand))
class

# Locations per product

locationsPerBrand <- aggregate(Location ~ Brand + Product.Class, data=invenLocs, function(x) length(unique(x)))
names(locationsPerBrand) <- c('Brand', 'Product.Class', 'Number.of.Locations')
#locationsPerBrand <- arrange(locationsPerBrand, desc(Number.of.Locations))

head(locationsPerBrand, 50)









## Identify top items 

setwd("C:/Users/pmwash/Desktop/R_Files/Data Input")
sales2015 <- read.csv('2015_sales_ytd_11182015.csv', header=TRUE)

sumAllSales <- sum(sales2015$Dollars)

library(dplyr)
sales2015 <- arrange(sales2015, desc(Dollars))
noBeer <- filter(sales2015, Product.Type != 'Beer')
top500 <- head(noBeer, 250)


# Merge locations with sales data

names(top500) <- c('Brand', 'Size', 'Item.Number', 'Type', 'Std.Cases', 'Dollar.Sales', 'Gross.Profit.Percent')
#locs <- locations[,1:5]
#head(top500)
#head(locs)
head(invenLocs)
salesLocations <- merge(top500, invenLocs, by='Item.Number')
#names(salesLocations)
salesLocations <- arrange(salesLocations, desc(Dollar.Sales))
salesLocations <- salesLocations[,c(1:7, 9:11)]
salesLocations$Percent.Of.Inventory <- round(salesLocations$Value.On.Hand / sumAllInventory, 5)
salesLocations$Percent.Of.Sales <- round(salesLocations$Dollar.Sales / sumAllSales, 5)
#head(salesLocations, 100)


# graph
head(salesLocations)
length(unique(salesLocations$Item.Number))
length(unique(salesLocations$Location))
library(ggplot2)
library(scales)
g <- ggplot(data=salesLocations, aes(x=Percent.Of.Inventory, y=Percent.Of.Sales))
g + geom_point(size=3, aes(colour=Product.Class)) + 
  geom_smooth(method='lm', se=FALSE, colour='black') + 
  scale_y_continuous(labels=percent) +
  labs(title='Percent Sales ~ Percent Inventory by SKU') +
  theme(legend.position='bottom')



#salesLocsOH <- merge(salesLocations, inventoryValues, by='Item.Number')
#salesLocsOH <- arrange(salesLocsOH, desc(Dollar.Sales))
#salesLocsOH$Turnover.Ratio <- salesLocsOH$Dollar.Sales / salesLocsOH$Value.On.Hand
#salesLocsOH <- salesLocsOH[,c(1, 3:13)]
#salesLocsOH <- salesLocsOH[,c(7,1:6,8:13)]
#names(salesLocsOH)
#head(salesLocsOH, 20)



# Aggregate sales by class
salesByClass <- aggregate(Dollars ~ Product.Type, data=sales2015, FUN=sum)
salesByClass <- arrange(salesByClass, desc(Dollars))
salesByClass$Percent.Sales <- round(salesByClass$Dollars / sum(salesByClass$Dollars),4)
salesByClass

# Aggregate number of locations per item

locationsPerItem <- aggregate(Location ~ Item.Number + Description, data=salesLocsOH, FUN=length)
locationsPerItem <- arrange(locationsPerItem, desc(Location))

#Write to xlsx

setwd("C:/Users/pmwash/Desktop/R_Files/Data Output")
library(xlsx)
#write.xlsx(salesLocsOH, file='cycle_count_planning.xlsx', sheetName='Summary Top Selling Items')
#write.xlsx(locationsPerItem, file='cycle_count_planning.xlsx', sheetName='Locations per Item', append=TRUE)
#write.xlsx(class, file='cycle_count_planning.xlsx', sheetName='Summary of Inventory by Class', append=TRUE)
#write.xlsx(salesByClass, file='cycle_count_planning.xlsx', sheetName='Summary of YTD Sales by Class', append=TRUE)
write.xlsx(salesLocations, file='top250_cycle_count.xlsx', sheetName='Top 200 Items')



# characterize percent of 500 top items of inventory etc
head(inventory)
totInventoryValue <- sum(inventory$Value.On.Hand)


noBeerSum <- sum(noBeer$Dollars)
noBeerSum
top500Sum <- sum(top500$Dollars)
allSalesSum <- sum(sales2015$Dollars)
allSalesSum
percentTop500 <- top500Sum / allSalesSum
percentTop500
percentNotBeer <- noBeerSum / allSalesSum
percentNotBeer
numberItemsSold <- length(sales2015$Brand)
numberItemsSold



sum(noBeer$Std.Cases) / sum(sales2015$Std.Cases)



