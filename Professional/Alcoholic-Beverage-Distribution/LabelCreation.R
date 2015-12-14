substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}



# Merge Item.No, Location, and UPC for printing label locations
setwd("C:/Users/pmwash/Desktop/R_files/Data Input")

upc <- read.csv('BOTUPC.csv', header=TRUE) # this is a file in as400 that you will need to run
names(upc) <- c('Product.Id', 'UPC')
head(upc)

locsBob <- read.csv('locations_bob_labels.csv', header=TRUE) # Bob will send a list of locations only
locsBob <- locsBob[,c(1:2)]
names(locsBob) <- c('Location', 'nanana')
head(locsBob)

locations <- read.csv("all_inventory.csv", header=TRUE) # this is today's inventory from hi jump 
names(locations) <- c('Product.Id', 'Description', 'Location', 'QPC',
                      'Bottle.Size', 'Total.Bottles', 'Cases', 'Bottles')
locations <- locations[,c('Product.Id', 'Location', 'Description')]
head(locations)


forLabels <- merge(locations, upc, by='Product.Id')
forLabels <- merge(forLabels, locsBob, by='Location')
forLabels <- forLabels[,c('Product.Id', 'Location', 'UPC', 'Description')]
















