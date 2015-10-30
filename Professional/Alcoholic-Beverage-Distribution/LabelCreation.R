# Merge Item.No, Location, and UPC for printing label locations
setwd("C:/Users/pmwash/Desktop/R_files")
locations <- read.csv("locations.csv", header=TRUE)
upc <- read.csv('BOTUPC.csv', header=TRUE)

head(locations)
head(upc)

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

upc$BUPC. <- as.character(upc$BUPC.)
upc$UPC.CLEAN <- str_pad(substrRight(upc$BUPC., 3), 3, pad="0")

merged <- merge(locations, upc, by='ITEM')
head(merged)

write.csv(merged, 'forLabels.csv')

# Check
filter(locations, ITEM == '1250019')
filter(upc, ITEM == '1250019')
filter(merged, ITEM == '1250019')
View(merged)
