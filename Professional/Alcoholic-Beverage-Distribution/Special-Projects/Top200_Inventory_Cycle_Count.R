# Inventory Cycle Count
######################################################################
print('Load libraries.')
library(dplyr)
library(xlsx)

print('STL')
######################################################################
print('Read in file. Dive is Today\'s inventory in Diver.')
setwd('C:/Users/pmwash/Desktop/R_files/Data Input')
inventory <- read.csv('todays_inventory_STL_diver_01122016.csv', header=TRUE)
names(inventory)[1] <- 'Item.Number'
headTail(inventory)



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
sumInventorySTL <- sum(inventory$Value.On.Hand)
inventory$Percent.Inventory = round(inventory$Value.On.Hand / sumAllInventory, 6)
inventory = select(inventory, one_of(c(c('Item.Number', 'Brand', 'Product.Class', 'Value.On.Hand'))))
headTail(inventory)


######################################################################
print('Merge with Hi Jump for locs and sizes. This is to acquire locations etc for emergencies.')
hiJump = read.csv('all_inventory_export_stl_01112016.csv', header=TRUE)
hiJump = select(hiJump, one_of(c('Item.Number', 'Description', 'Location', 
                                 'QPC', 'Bottle.Size', 'Total.Bottles', 'Cases')))
inventoryLocations = merge(hiJump, inventory, by='Item.Number')
headTail(inventoryLocations)

print('Read in top 200 for STL. Manipulate.')
top200stl = read.csv('top200stl.csv', header=TRUE)
top200stl = top200stl %>% select(one_of(c('Item.Number', 'PrcntSales', 'Brand')))

print('Aggregate value on hand by item number, then derive % inventory for STL. Then merge with above.')
stl = aggregate(Value.On.Hand ~ Item.Number, data=inventory, FUN=sum)
top200stl = merge(top200stl, stl, by='Item.Number')
top200stl$PrctInventory = round(top200stl$Value.On.Hand / sumInventorySTL, 6)
top200stl$Rank = 1:200
top200stl = top200stl[,c('Item.Number', 'PrcntSales', 'PrctInventory', 'Rank', 'Brand')]
names(top200stl) = c('Item.Number', 'Percent.Sales', 'Percent.Inventory', 'Rank', 'Description') 
headTail(top200stl)


print('Write to file for Bill S. to feed into VBA for merge and preparation for counts.')
#setwd("C:/Users/pmwash/Desktop/R_files/Data Output")
#write.csv(top200stl, file='top200stl_formatted.csv')


print('For Randy, aggregate value on hand by class (STL here).')

print('Gather sums of inventory by category.')
wineStl = sum(inventory %>% filter(Product.Class == 'WINE')
           %>% select(one_of(c('Value.On.Hand'))))
liquorStl = sum(inventory %>% filter(Product.Class == 'LIQUOR')
                %>% select(one_of(c('Value.On.Hand'))))
naStl = sum(inventory %>% filter(Product.Class == 'NON-ALCOHOLIC')
                %>% select(one_of(c('Value.On.Hand'))))

print('Gather sums of sales by category.')
class = read.csv('class_breakdown.csv', header=TRUE)
sales = class$Dollars
wineSalesStl = sales[4]
nonalcSalesStl = sales[3]
liquorSalesStl = sales[2]

setwd('C:/Users/pmwash/Desktop/R_files/Data Input')
top200stl = read.csv('top200stl.csv', header=TRUE)
top200stl = top200stl %>% select(one_of(c('Item.Number', 'Brand', 'Product.Type', 
                                          'Dollars', 'PrcntSales')))
names(top200stl) = c('Item.Number', 'Description', 'Product.Class', 'Dollar.Sales', 'Percent.Sales')
stl200PercentSalesStl = sum(top200stl$Dollar.Sales / sum(class$Dollars))
stl200PercentInventoryStl = sum(top200stl$Value.On.Hand) / sum(inventory$Value.On.Hand)


stl = aggregate(Value.On.Hand ~ Item.Number, data=inventory, FUN=sum)
top200stl = merge(top200stl, stl, by='Item.Number')
class = top200stl$Product.Class
inventory = top200stl$Value.On.Hand

#wine
top200winePercent = round(sum(top200stl %>% filter(Product.Class == 'Wine')
          %>% select(one_of(c('Value.On.Hand'))))/wineStl, 5)
top200stl$Percent.Wine.Inventory = round(as.numeric(ifelse(class=='Wine', inventory/wineStl, 0)), 5)
 
#liquor
top200liquorPercent = round(sum(top200stl %>% filter(Product.Class == 'Liquor / Spirit Coolers')
                              %>% select(one_of(c('Value.On.Hand'))))/liquorStl, 5)
top200stl$Percent.Liquor.Inventory = round(as.numeric(ifelse(class=='Liquor / Spirit Coolers', inventory/liquorStl, 0)), 5)

#non alcoholic
top200NAPercent = round(sum(top200stl %>% filter(Product.Class == 'Non-Alcoholic')
                                %>% select(one_of(c('Value.On.Hand'))))/naStl, 5)
top200stl$Percent.NA.Inventory = round(as.numeric(ifelse(class=='Non-Alcoholic', inventory/naStl, 0)), 5)


print('Do the same for sales ratios.')
class = top200stl$Product.Class

#wine
top200WineSalesPercent = round(sum(ifelse(class=='Wine', top200stl$Dollar.Sales, 0))/wineSalesStl,4)
top200LiquorSalesPercent = round(sum(ifelse(class=='Liquor / Spirit Coolers', top200stl$Dollar.Sales, 0))/liquorSalesStl,4)
top200NASalesPercent = round(sum(ifelse(class=='Non-Alcoholic', top200stl$Dollar.Sales, 0))/nonalcSalesStl,4)

class = top200stl$Product.Class
sales = top200stl$Dollar.Sales
top200stl$Percent.Wine.Sales = round(ifelse(class=='Wine', sales/wineSalesStl, 0), 4)
top200stl$Percent.Liquor.Sales = round(ifelse(class=='Liquor / Spirit Coolers', sales/liquorSalesStl, 0), 4)
top200stl$Percent.NA.Sales = round(ifelse(class=='Non-Alcoholic', sales/nonalcSalesStl, 0), 4)


top200stl$Percent.Tot.Inventory = round(top200stl$Value.On.Hand / sumInventorySTL, 5)



top200stl = top200stl %>% arrange(desc(Dollar.Sales))
headTail(top200stl) 

stlSalesClass = aggregate(Dollar.Sales~Product.Class, data=top200stl, FUN=sum)
stlInventoryClass = aggregate(Value.On.Hand~Product.Class, data=top200stl, FUN=sum)
stlPrctSalesClass = aggregate(Percent.Sales~Product.Class, data=top200stl, FUN=sum)
stlPrctInventoryClass = aggregate(Percent.Tot.Inventory~Product.Class, data=top200stl, FUN=sum)
stl = merge(stlSalesClass, stlInventoryClass, by='Product.Class')
stl = merge(stl, stlPrctSalesClass, by='Product.Class')
stl = merge(stl, stlPrctInventoryClass, by='Product.Class')
names(stl) = c('Product.Class', 'Dollar.Sales.Top.200', 'Value.On.Hand.Top.200', 'Percent.Sales.Top.200',
               'Percent.Inventory.Top.200')
stl$Top.200.Items.Only.Percent.Sales = round(stl$Dollar.Sales.Top.200 / sum(stl$Dollar.Sales.Top.200), 2)
stl$Top.200.Percent.Wine.Sales = round(ifelse(stl$Product.Class=='Wine', stl$Dollar.Sales.Top.200/wineSalesStl, 0), 2)
stl$Top.200.Percent.Liquor.Sales = round(ifelse(stl$Product.Class=='Liquor / Spirit Coolers', stl$Dollar.Sales.Top.200/liquorSalesStl, 0), 2)
stl$Top.200.Percent.NA.Sales = round(ifelse(stl$Product.Class=='Non-Alcoholic', stl$Dollar.Sales.Top.200/nonalcSalesStl, 0), 2)


setwd("C:/Users/pmwash/Desktop/R_files/Data Output")
write.xlsx(stl, file='top200_breakdown.xlsx', sheetName='STL Summary by Class')
write.xlsx(top200stl, file='top200_breakdown.xlsx', sheetName='STL Top 200 Items', append=TRUE)




print('KC')


print('KC')
######################################################################
print('Now do the same for KC.')

print('Read in file. Dive is Today\'s inventory in Diver.')
setwd('C:/Users/pmwash/Desktop/R_files/Data Input')
inventory <- read.csv('todays_inventory_KC_diver_01122016.csv', header=TRUE)
names(inventory)[1] <- 'Item.Number'
headTail(inventory)



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
sumInventoryKC <- sum(inventory$Value.On.Hand)
inventory$Percent.Inventory = round(inventory$Value.On.Hand / sumAllInventory, 6)
inventory = select(inventory, one_of(c(c('Item.Number', 'Brand', 'Product.Class', 'Value.On.Hand'))))
headTail(inventory)



print('Read in top 200 for KC. Manipulate.')
top200kc = read.csv('top200kc.csv', header=TRUE)
top200kc = top200kc %>% select(one_of(c('Item.Number', 'PrctSales', 'Brand', 'Product.Type')))

print('Aggregate value on hand by item number, then derive % inventory for kc. Then merge with above.')
kc = aggregate(Value.On.Hand ~ Item.Number, data=inventory, FUN=sum)
top200kc = merge(top200kc, kc, by='Item.Number')
top200kc$PrctInventory = round(top200kc$Value.On.Hand / sumInventoryKC, 6)
top200kc$Rank = 1:200
top200kc = top200kc[,c('Item.Number', 'PrctSales', 'PrctInventory', 'Rank', 'Brand', 'Product.Type')]
names(top200kc) = c('Item.Number', 'Percent.Sales', 'Percent.Inventory', 'Rank', 'Description', 'Product.Class') 
headTail(top200kc)


print('Write to file for Bill S. to feed into VBA for merge and preparation for counts.')
#setwd("C:/Users/pmwash/Desktop/R_files/Data Output")
#write.csv(top200kc, file='top200kc_formatted.csv')


print('For Randy, aggregate value on hand by class (kc here).')

print('Gather sums of inventory by category.')
winekc = sum(inventory %>% filter(Product.Class == 'WINE')
              %>% select(one_of(c('Value.On.Hand'))))
liquorkc = sum(inventory %>% filter(Product.Class == 'LIQUOR')
                %>% select(one_of(c('Value.On.Hand'))))
nakc = sum(inventory %>% filter(Product.Class == 'NON-ALCOHOLIC')
            %>% select(one_of(c('Value.On.Hand'))))

print('Gather sums of sales by category.')
setwd("C:/Users/pmwash/Desktop/R_files/Data Input")
class = read.csv('class_breakdown_kc.csv', header=TRUE)
totSalesKc = sum(class$Dollars)
sales = class$Dollars
wineSaleskc = sales[4]
nonalcSaleskc = sales[3]
liquorSaleskc = sales[2]

setwd('C:/Users/pmwash/Desktop/R_files/Data Input')
top200kc = read.csv('top200kc.csv', header=TRUE)
top200kc = top200kc %>% select(one_of(c('Item.Number', 'Brand', 'Product.Type', 
                                          'Dollars', 'PrctSales')))
names(top200kc) = c('Item.Number', 'Description', 'Product.Class', 'Dollar.Sales', 'Percent.Sales')

print('Aggregate value on hand by item number, then derive % inventory for kc. Then merge with above.')
kc = aggregate(Value.On.Hand ~ Item.Number, data=inventory, FUN=sum)
top200kc = merge(top200kc, kc, by='Item.Number')

headTail(top200kc)
top200kc$PrctInventory = round(top200kc$Value.On.Hand / sumInventoryKC, 6)
top200kc$Rank = 1:200
headTail(top200kc)
top200kc = top200kc[,c('Item.Number', 'Dollar.Sales', 'Percent.Sales', 'Value.On.Hand', 
                       'PrctInventory', 'Rank', 'Description', 'Product.Class')]
names(top200kc) = c('Item.Number', 'Dollar.Sales', 'Percent.Sales', 'Value.On.Hand', 
                    'Percent.Inventory', 'Rank', 'Description', 'Product.Class') 
headTail(top200kc)


kc200PercentSaleskc = round(sum(top200kc$Dollar.Sales) / totSalesKc, 5)
kc200PercentInventorykc = round(sum(top200kc$Value.On.Hand) / sum(inventory$Value.On.Hand), 5)


#kc = aggregate(Value.On.Hand ~ Item.Number, data=inventory, FUN=sum)
#kc = kc[,-c('Value.On.Hand')]
#top200kc = merge(top200kc, kc, by='Item.Number')
class = top200kc$Product.Class
value = top200kc$Value.On.Hand

#wine
vino = top200kc %>% filter(Product.Class == 'Wine')
top200winePercent = round(sum(vino$Value.On.Hand)/winekc, 5)
top200kc$Percent.Wine.Inventory = round(as.numeric(ifelse(class=='Wine', value/winekc, 0)), 5)

#liquor
top200liquorPercent = round(sum(top200kc %>% filter(Product.Class == 'Liquor / Spirit Coolers')
                                %>% select(one_of(c('Value.On.Hand'))))/liquorkc, 5)
top200kc$Percent.Liquor.Inventory = round(as.numeric(ifelse(class=='Liquor / Spirit Coolers', value/liquorkc, 0)), 5)

#non alcoholic
top200NAPercent = round(sum(top200kc %>% filter(Product.Class == 'Non-Alcoholic')
                            %>% select(one_of(c('Value.On.Hand'))))/nakc, 5)
top200kc$Percent.NA.Inventory = round(as.numeric(ifelse(class=='Non-Alcoholic', value/nakc, 0)), 5)


print('Do the same for sales ratios.')
class = top200kc$Product.Class

#wine
top200WineSalesPercent = round(sum(ifelse(class=='Wine', top200kc$Dollar.Sales, 0))/wineSaleskc,4)
top200LiquorSalesPercent = round(sum(ifelse(class=='Liquor / Spirit Coolers', top200kc$Dollar.Sales, 0))/liquorSaleskc,4)
top200NASalesPercent = round(sum(ifelse(class=='Non-Alcoholic', top200kc$Dollar.Sales, 0))/nonalcSaleskc,4)

class = top200kc$Product.Class
sales = top200kc$Dollar.Sales
top200kc$Percent.Wine.Sales = round(ifelse(class=='Wine', sales/wineSaleskc, 0), 4)
top200kc$Percent.Liquor.Sales = round(ifelse(class=='Liquor / Spirit Coolers', sales/liquorSaleskc, 0), 4)
top200kc$Percent.NA.Sales = round(ifelse(class=='Non-Alcoholic', sales/nonalcSaleskc, 0), 4)


top200kc$Percent.Tot.Inventory = round(top200kc$Value.On.Hand / sumInventoryKC, 5)



top200kc = top200kc %>% arrange(desc(Dollar.Sales))
top200kc = top200kc %>% select(one_of('Item.Number', 'Description', 'Product.Class', 'Dollar.Sales', 'Percent.Sales', 
                                      'Percent.Wine.Sales', 'Percent.Liquor.Sales', 'Percent.NA.Sales',
                                      'Value.On.Hand', 'Percent.Inventory', 'Percent.Wine.Inventory', 'Percent.Liquor.Inventory',
                                      'Percent.NA.Inventory'))
headTail(top200kc) 

kcSalesClass = aggregate(Dollar.Sales~Product.Class, data=top200kc, FUN=sum)
kcInventoryClass = aggregate(Value.On.Hand~Product.Class, data=top200kc, FUN=sum)
kcPrctSalesClass = aggregate(Percent.Sales~Product.Class, data=top200kc, FUN=sum)
kcPrctInventoryClass = aggregate(Percent.Inventory~Product.Class, data=top200kc, FUN=sum)
kc = merge(kcSalesClass, kcInventoryClass, by='Product.Class')
kc = merge(kc, kcPrctSalesClass, by='Product.Class')
kc = merge(kc, kcPrctInventoryClass, by='Product.Class')
names(kc) = c('Product.Class', 'Dollar.Sales.Top.200', 'Value.On.Hand.Top.200', 'Percent.Sales.Top.200',
               'Percent.Inventory.Top.200')
kc$Top.200.Items.Only.Percent.Sales = round(kc$Dollar.Sales.Top.200 / sum(kc$Dollar.Sales.Top.200), 2)
kc$Top.200.Percent.Wine.Sales = round(ifelse(kc$Product.Class=='Wine', kc$Dollar.Sales.Top.200/wineSaleskc, 0), 2)
kc$Top.200.Percent.Liquor.Sales = round(ifelse(kc$Product.Class=='Liquor / Spirit Coolers', kc$Dollar.Sales.Top.200/liquorSaleskc, 0), 2)
kc$Top.200.Percent.NA.Sales = round(ifelse(kc$Product.Class=='Non-Alcoholic', kc$Dollar.Sales.Top.200/nonalcSaleskc, 0), 2)
headTail(kc)

setwd("C:/Users/pmwash/Desktop/R_files/Data Output")
write.xlsx(top200kc, file='top200_breakdown_kc.xlsx', sheetName='KC Top 200 Items Detail')
write.xlsx(kc, file='top200_breakdown_kc.xlsx', sheetName='KC Summary by Class', append=TRUE)
























print('Below is old and may not be relevant anymore.')





#################






headTail(inventory)

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



