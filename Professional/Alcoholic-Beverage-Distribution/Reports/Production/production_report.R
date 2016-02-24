
print('New Production Report 02242016')


print('Gather external utilities')
library(dplyr)
library(tidyr)
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')
raw_data = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/test_input_production_report.csv', header=TRUE)



print('Prepare the data')
tidy_production_data = function(raw_data) {
  raw_data = data.frame(raw_data %>% separate(Date, into=c('Date', 'X'), sep='\\.'))
  raw_data$Date = as.character(strptime(raw_data$Date, format='%m-%d'))
  raw_data = raw_data[,c(1:3, 5)]
  raw_data$Key = paste0(raw_data$Index, sep='_', raw_data$Key)
  raw_data = raw_data[,-c(4)]
  
  raw_data = reshape(raw_data, 
                     timevar = 'Date',
                     idvar = 'Key', 
                     direction = 'wide')

  row.names(raw_data) = toupper(as.character(raw_data[,1]))
  raw_data = raw_data[,-c(1)]
  
  row.names(raw_data) = sapply(rownames(raw_data), function(x)gsub('\\s+', '.',x))
  
  
  
  factor(rownames(raw_data), levels=c('54_TOTAL.CASES.', '55_.ST.LOUIS', '58_.KC.TRANSFER', '59_.COLUMBIA', '60_.CAPE', '57_.RED.BULL',
                                      '61_BOTTLES', '62_.ST.LOUIS', '63_.COLUMBIA', '64_.CAPE', ))
  
  #here is where sorting by factor comes in, do later
  
  raw_data = data.frame(t(raw_data))
  row.names(raw_data) = as.character(strptime(substrRight(rownames(raw_data), 10), format='%Y-%m-%d'))
  
  
  print(raw_data)
}






headTail(check)


headTail(raw_data)




#for figuring it out
x <- data.frame(x=rep(c("red","blue","green"),each=4), y=rep(letters[1:4],3), value.1 = 1:12, value.2 = 13:24)
x %>%
  gather(Var, val, starts_with("value")) %>% 
  unite(Var1,Var, y) 






























