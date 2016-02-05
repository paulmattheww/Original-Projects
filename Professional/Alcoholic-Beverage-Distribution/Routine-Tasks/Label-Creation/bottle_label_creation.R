print('Label Creation, Upstream from Wasp')



print('BOTUPC file AS400')
upc = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/BOTUPC.csv')

print('Locations from Bob Kloeppinger; put locations in one column and one column marked X')
locsBob = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/locations_bob_labels.csv')

print('Inventory as of today from High Jump')
locations = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/all_inventory.csv')

make_labels = function(upc, locsBob, locations) {
  substrRight <- function(x, n){
    substr(x, nchar(x)-n+1, nchar(x))
  }
  print('Columns in BOTUPC must be formatted as numbers with no decimals prior to reading in data')
  options(scipen=999)
  names(locations) <- c('Product.Id', 'Description', 'Location', 'QPC',
                        'Bottle.Size', 'Total.Bottles', 'Cases', 'Bottles')
  names(upc) = c('Product.Id', 'UPC')
  output = merge(locations, upc, by='Product.Id', all=TRUE)
  print('Locations succcessfully merged with bottle UPCs')
  output = merge(output, locsBob, by='Location', all.y=TRUE)
  print('Locations/UPC successfully merged with Label Locations')
  output = output[,c('Product.Id', 'Location', 'Description', 'UPC')]
  output$Last.3 = substrRight(output$UPC, 3)
  write.csv(output, 'C:/Users/pmwash/Desktop/R_files/Data Output/locations_upcs_for_labels.csv')
  print('Output file produced. Format Last.3 column/paste values, save as Excel 97-03 and input into Wasp for label production')
  print('Verify in High Jump all is well by searching first by location, then drill into the item to check UPC')
  print('Delete description field after you have checked')
}

make_labels(upc, locsBob, locations)

