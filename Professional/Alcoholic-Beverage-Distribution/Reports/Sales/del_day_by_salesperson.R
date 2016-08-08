
## Gather Delivery Days for Each Customer
## Integrate with Salespersons
library(lubridate)
library(dplyr)
library(stringr)
library(tidyr)
library(xlsx)
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')

accts = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/Customers.csv', header=TRUE); headTail(accts)
accts$KegCustomer = ifelse(accts$KegRte %in% c(66, 67, 68, 69, 75, 366), 
                           'Yes', 'No')
slp1 = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/slp1.csv', header=TRUE); headTail(slp1)
cust_slsppl = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/customer_salespersons.csv', header=TRUE); headTail(cust_slsppl)
cust_slsppl = lapply(cust_slsppl, factor)
cust_slsppl = data.frame(cust_slsppl); str(cust_slsppl)


## Multiple salespeople for some accounts
gathercols = 2:14
valcol = 'SalespersonID'
keycol = 'CCUST.'

cust_slsppl = gather(cust_slsppl, keycol,  valcol, gathercols)#; duplicated(cust_slsppl)
names(cust_slsppl) = c('CustomerID', 'AS400Salesperson', 'SalespersonID'); head(cust_slsppl)
cust_slsppl$AS400Salesperson = NULL
cust_slsppl = unique(cust_slsppl)


customer_salespersons = merge(slp1, cust_slsppl, by='SalespersonID'); headTail(customer_salespersons)
customer_salespersons = customer_salespersons[, c('SalespersonID', 'Salesperson', 'CustomerID')]


customer_salespersons = merge(customer_salespersons, accts, by='CustomerID'); headTail(customer_salespersons)


## Get a handle on which days each customer gets for easy querying by sales
days = as.character(customer_salespersons$ShipFlag)
days = customer_salespersons$ShipFlag = str_pad(days, 7, pad='0')

customer_salespersons$Monday = mon =  ifelse(substrLeft(substrRight(days, 7), 1) == 1, 'Scheduled', '')
customer_salespersons$Tuesday = tue = ifelse(substrLeft(substrRight(days, 6), 1) == 1, 'Scheduled', '')
customer_salespersons$Wednesday = wed =  ifelse(substrLeft(substrRight(days, 5), 1) == 1, 'Scheduled', '')
customer_salespersons$Thursday = thu =  ifelse(substrLeft(substrRight(days, 4), 1) == 1, 'Scheduled', '')
customer_salespersons$Friday = fri = ifelse(substrLeft(substrRight(days, 3), 1) == 1, 'Scheduled', '')
customer_salespersons$Saturday = sat = ifelse(substrLeft(substrRight(days, 2), 1) == 1, 'Scheduled', '')
customer_salespersons$Sunday = sun = ifelse(substrRight(days, 1) == 1, 'Scheduled', '')

head(customer_salespersons)

gathercols = 26:32
valcol = 'DeliveryDays'
keycol = 'SalespersonID'

customer_salespersons = gather(customer_salespersons, keycol,  valcol, gathercols); customer_salespersons %>% filter(CustomerID == 1000) #check one customer
customer_salespersons$DOTW = ifelse(customer_salespersons$valcol == '', NA, customer_salespersons$keycol)
customer_salespersons = customer_salespersons %>% filter(is.na(DOTW) == FALSE)
customer_salespersons$keycol = customer_salespersons$valcol = NULL
customer_salespersons$Salesperson = gsub(',', '', customer_salespersons$Salesperson); head(customer_salespersons)
customer_salespersons$Salesperson = gsub('[punct]', '', customer_salespersons$Salesperson); head(customer_salespersons)
customer_salespersons$Salesperson = gsub('-', '_', customer_salespersons$Salesperson); head(customer_salespersons)
customer_salespersons$Salesperson = gsub(' ', '_', customer_salespersons$Salesperson); head(customer_salespersons)
customer_salespersons$DOTW = factor(customer_salespersons$DOTW, levels = c('Monday', 'Tuesday', 'Wednesday', 
                                                                           'Thursday', 'Friday', 'Saturday', 'Sunday'))
customer_salespersons = customer_salespersons %>% filter(DOTW %!in% c('Saturday', 'Sunday'))

unique_salespeople = unique(paste0(customer_salespersons$SalespersonID, '_', customer_salespersons$Salesperson))
unique_SID = unique(customer_salespersons$SalespersonID)



## Split and distribute by salesperson and weekday (tabs v spreadsheet)
by_salesperson = split(customer_salespersons, customer_salespersons$SalespersonID)# by_salesperson = head(by_salesperson, 5)#test!
# by_salesperson = tail(by_salesperson, 1)


for(i in 1:length(by_salesperson)) {
  
  df_to_print = by_salesperson[[i]]
  
  salesperson = paste0(by_salesperson[[i]][1, 10], '_', by_salesperson[[i]][1, 2], '_', by_salesperson[[i]][1, 3])
  salesperson_id = by_salesperson[[i]][1, 2]
  file_name = paste0('N:/Operations Intelligence/Sales/Delivery Days/', salesperson, '_customer_delivery_days.xlsx')
  
  print(paste0('WRITING FILE FOR:    ', salesperson))
  
  df_to_print_weekday = split(df_to_print, df_to_print$DOTW)
  
  for(j in 1:length(df_to_print_weekday)) {
    
    df = df_to_print_weekday[[j]]
    dotw = paste0(df_to_print_weekday[[j]][1, 26])
    
    if(nrow(df) == 0 ) {
      
      next 
    } else if(j == 1) {

      write.xlsx(df_to_print_weekday[[1]],
                 file=file_name,
                 sheetName=dotw)
    } else {
      
      write.xlsx(df_to_print_weekday[[j]],
                 file=file_name,
                 sheetName=dotw,
                 append=TRUE)
    }
  }
}

































































