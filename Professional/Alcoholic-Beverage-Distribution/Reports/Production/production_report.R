
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
  
  
  
  factor(rownames(raw_data), levels=c('103_TOTAL.CASES.', '104_.ST.LOUIS', '107_.KC.TRANSFER', '108_.COLUMBIA', '109_.CAPE', '106_.RED.BULL',
                                      '110_BOTTLES', '111_.ST.LOUIS', '112_.COLUMBIA', '113_.CAPE', '105_.KEGS', 
                                      '62_.O/S.CASES', '63_.O/S.BOTTLES' , '65_.CASE', '66_.BOTTLES',             #add in case errors columbia when they put it in the daily report
                                      '67_RAW.CASE.ERRORS', '68_RAW.BOTTLE.ERRORS', '149_COMPLETION.TIME:',
                                      '132_TOTAL.HOURS', '133_.SENIORITY', '134_.CASUAL',' 135_REGULAR.HOURS', '136_.SENIORITY', '137_.CASUAL',
                                      '138_OT.HOURS', '139_.SENIORITY', '140_.CASUAL', '141_TEMP.HOURS', '142_DRIVER.CHECK-IN.HOURS',
                                      '143_ABSENT.EMPLOYEES', '144_.SENIORITY', '145_.CASUAL',
                                      '147_TOTAL.EMPLOYEES.ON.HAND', '146_TOTAL.TEMPS.ON.HAND', '148_TOTAL.EMPLOYEES.WITH.TEMPS',
                                      '118_TOTAL.STLTRUCKS', '119_.CASE/SPLIT', '120_.KEG/OTHER', 
                                      '58_EMPTY.BOXES.RETURNED', 
                                      '114_TOTAL.STOPS', '115_.ST.LOUIS', '116_.CAPE', '117_.COLUMBIA.(ONLY)',
                                      
                                      '151_CASES.PER.MAN.HOUR', '150_CASES.PER.MAN.HOUR.(OT.ADJUSTED)', '121_CASES.PER.HOUR'))
  
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






























