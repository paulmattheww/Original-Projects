print('Monthly Breakage')

print('Load in necessary libraries')
library(XLConnect)
library(dplyr)
library(ggplot2)
library(reshape2)
library(scales)
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')


print('(1) Run pwbreakage for house and time frame & replace data')
print('(2) Acquire sales data from Diver and update file')
print('(3) Acquire Supplier breakage using suppbreaka')
print('(4) Merge history with current data')



print('Read in STL data; do not change column headers')
breaks = read.csv("C:/Users/pmwash/Desktop/R_Files/Data Input/PWBREAKAGE_STL.csv", header=TRUE) 
sales = read.csv('C:/Users/pmwash/Desktop/R_Files/Data Input/sales_history_for_breakage_report.csv', header=TRUE)
supplier = read.csv('C:/Users/pmwash/Desktop/R_Files/Data Input/suppbreaka.csv', header=TRUE)
supplier_history = read.csv('C:/Users/pmwash/Desktop/R_Files/Data Input/supplier_history_for_breakage.csv', header=TRUE)
history = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/breakage_detailed_history.csv', header=TRUE)

# print('Read in KC data, do not chagen column headers')
# breaks = read.csv("C:/Users/pmwash/Desktop/R_Files/Data Input/PWBREAKAGE_KC.csv", header=TRUE) 




print('Create functions for use in breakage analysis')

breakage_by_class_incidents = function(breaks) {
  spread1 = aggregate(CASES ~ X.RCODE + PTYPE, data=breaks, FUN=length)
  spread1 = data.frame(spread1)
  moneyShot1 = spread(spread1, PTYPE, CASES)
  names(moneyShot1) = c("Reason.Code", "Liquor (1)", "Wine (2)", "Beer (3)", "Non-Alc (4)")
  reason = moneyShot1$Reason.Code
  moneyShot1$Reason.Code = ifelse(reason == 2, "Sales (2)", 
                                  ifelse(reason == 3, "Warehouse (3)",
                                         ifelse(reason==4, "Driver (4)", 
                                                ifelse(reason==5, "Columbia (5)", ""))))
  names(moneyShot1) =c("", "Liquor (1)", "Wine (2)", "Beer (3)", "Non-Alc (4)")
  invert1 = data.frame(t(moneyShot1))
  names(invert1) = c('Sales (2)', 'Warehouse (3)', 'Driver (4)', 'Columbia (5)')
  invert1 = invert1[-c(1) ,]
  invert1 = invert1[, c('Sales (2)', 'Driver (4)', 'Warehouse (3)', 'Columbia (5)')]
  print(invert1)
}

incident_summary = breakage_by_class_incidents(breaks)


breakage_by_class_cost = function(breaks) {
  breaks$EXT_COST = as.numeric(as.character(breaks$EXT_COST))
  spread2 = aggregate(EXT_COST ~ X.RCODE + PTYPE, data=breaks, FUN=function(x) abs(round(sum(x), 2)))
  spread2 = data.frame(spread2)
  moneyShot2 = spread(spread2, PTYPE, EXT_COST)
  names(moneyShot2) = c("Reason.Code", "Liquor (1)", "Wine (2)", "Beer (3)", "Non-Alc (4)")
  reason = moneyShot2$Reason.Code
  moneyShot2$Reason.Code = ifelse(reason == 2, "Sales (2)", 
                                  ifelse(reason == 3, "Warehouse (3)",
                                         ifelse(reason==4, "Driver (4)", 
                                                ifelse(reason==5, "Columbia (5)", ""))))
  names(moneyShot2) =c("", "Liquor (1)", "Wine (2)", "Beer (3)", "Non-Alc (4)")
  invert2 = data.frame(t(moneyShot2))
  names(invert2) = c("Sales (2)", "Warehouse (3)", "Driver (4)", "Columbia (5)")
  invert2 = invert2[-c(1) ,]
  invert2 = invert2[, c("Sales (2)", "Driver (4)", "Warehouse (3)", "Columbia (5)")]
  print(invert2)
}

cost_summary = breakage_by_class_cost(breaks)


breakage_by_class_cases = function(breaks) {
  spread3 = aggregate(as.numeric(as.character(CASES)) ~ X.RCODE, data=breaks, FUN=function(x) round(sum(x), 2))
  spread3 = data.frame(spread3)
  moneyShot3 = spread3
  names(moneyShot3) = c("Reason.Code", "Cases.Broken")
  reason = moneyShot3$Reason.Code
  moneyShot3$Reason.Code = ifelse(reason == 2, "Sales (2)", 
                                  ifelse(reason == 3, "Warehouse (3)",
                                         ifelse(reason==4, "Driver (4)", 
                                                ifelse(reason==5, "Columbia (5)", ""))))
  names(moneyShot3) =c("", "Cases.Broken")
  moneyShot3
  invert3 = data.frame(t(moneyShot3))
  names(invert3) = c('Sales (2)', 'Warehouse (3)', 'Driver (4)', 'Columbia (5)')
  invert3 = invert3[-c(1) ,]
  print(invert3)
}

case_summary = breakage_by_class_cases(breaks)


warehouse_breakage_by_item = function(breaks) {
  library(dplyr)
  breaks$CASES = round(breaks$X.RCASE + (breaks$X.RBOTT / breaks$X.RQPC), 2)
  #Warehouse is code 3
  warehouse = breaks %>% filter(X.RCODE == 3)
  warehouse = warehouse[, c('X.RDESC', 'X.RSIZE', 'CASES', 'EXT_COST')]
  
  whse_cost = aggregate(EXT_COST ~ X.RDESC + X.RSIZE, data=warehouse, FUN=sum)
  whse_cases = aggregate(CASES ~ X.RDESC + X.RSIZE, data=warehouse, FUN=sum)
  
  whse_summary = merge(whse_cases, whse_cost, by=c('X.RDESC', 'X.RSIZE'))
  whse_summary = arrange(whse_summary, CASES)
  names(whse_summary) = c('DESCRIPTION', 'SIZE', 'SUM.CASES', 'SUM.COST')
  
  print(whse_summary)
}

warehouse_breakage = warehouse_breakage_by_item(breaks)


driver_breakage_by_item = function(breaks) {
  library(dplyr)
  breaks$CASES = round(breaks$X.RCASE + (breaks$X.RBOTT / breaks$X.RQPC), 2)
  #driver is code 3
  driver = breaks %>% filter(X.RCODE == 4)
  driver = driver[, c('X.RDESC', 'X.RSIZE', 'CASES', 'EXT_COST')]
  
  drv_cost = aggregate(EXT_COST ~ X.RDESC + X.RSIZE, data=driver, FUN=sum)
  drv_cases = aggregate(CASES ~ X.RDESC + X.RSIZE, data=driver, FUN=sum)
  
  drv_summary = merge(drv_cases, drv_cost, by=c('X.RDESC', 'X.RSIZE'))
  drv_summary = arrange(drv_summary, CASES)
  names(drv_summary) = c('DESCRIPTION', 'SIZE', 'SUM.CASES', 'SUM.COST')
  
  print(drv_summary)
}

driver_breakage_item = driver_breakage_by_item(breaks)


breakage_supplier_cost = function(supplier) {
  total_supplier_breakage = round(abs(sum(supplier$EXT_COST, na.rm=TRUE)), 2)
  print(total_supplier_breakage)
}

supplier_breakage = breakage_supplier_cost(supplier)


append_supplier_records = function(supplier_breakage, supplier_history, month='January', year=2016) {
  old = supplier_history
  new = data.frame(year, month, supplier_breakage)
  names(new) = c('Year', 'Month', 'Supplier.Breakage')
  appended = rbind(old, new)
  
  write.csv(appended, 'C:/Users/pmwash/Desktop/R_files/Data Output/save_as_____supplier_history_for_breakage.csv')
  appended
}

supplier_breakage = append_supplier_records(supplier_breakage, supplier_history)
#if goes wrong, use this to delete last row duplicated:
#supplier_breakage = supplier_breakage[-c(14)]



combine_incidents_cost = function(incident_summary, cost_summary, month='January', year=2016) {
  combo = cbind(incident_summary, cost_summary)
  combo$Year = year
  combo$Month = month
  combo = combo[,c(9:10, 1:8)]
  names(combo) = c('Year', 'Month', 'Sales.Incidents', 'Driver.Incidents', 'Warehouse.Incidents', 'Columbia.Incidents',
                   'Sales.Cost', 'Driver.Cost', 'Warehouse.Cost', 'Columbia.Cost')
  combo = cbind(rownames(combo), combo)
  rownames(combo) = NULL
  colnames(combo) = c('Type', 'Year', 'Month', 'Sales.Incidents', 'Driver.Incidents', 'Warehouse.Incidents', 'Columbia.Incidents',
                      'Sales.Cost', 'Driver.Cost', 'Warehouse.Cost', 'Columbia.Cost')
  combo
}

current = combine_incidents_cost(incident_summary, cost_summary)


append_old_new = function(history, current) {
  appended = rbind(history, current)
  write.csv(appended, 'C:/Users/pmwash/Desktop/R_files/Data Output/save_as____breakage_detailed_history.csv')
  appended[,c(4)] = as.numeric(appended[,c(4)])
  appended[,c(5)] = as.numeric(appended[,c(5)])
  appended[,c(6)] = as.numeric(appended[,c(6)])
  appended[,c(7)] = as.numeric(appended[,c(7)])
  appended[,c(8)] = as.numeric(appended[,c(8)])
  appended[,c(9)] = as.numeric(appended[,c(9)])
  appended[,c(10)] = as.numeric(appended[,c(10)])
  appended[,c(11)] = as.numeric(appended[,c(11)])
  
  appended
}

appended_dataset = append_old_new(history, current)



calculate_ytd = function(appended_dataset) {
  library(dplyr)
  master = appended_dataset %>% group_by(Year, Type) %>% 
    mutate(YTD.Sales.Incidents=cumsum(Sales.Incidents),
           YTD.Driver.Incidents=cumsum(Driver.Incidents),
           YTD.Warehouse.Incidents=cumsum(Warehouse.Incidents),
           YTD.Columbia.Incidents=cumsum(Columbia.Incidents),
           YTD.Sales.Cost=cumsum(Sales.Cost),
           YTD.Driver.Cost=cumsum(Driver.Cost),
           YTD.Warehouse.Cost=cumsum(Warehouse.Cost),
           YTD.Columbia.Cost=cumsum(Columbia.Cost))
  master = data.frame(master)
  
  master$Total.Incidents = abs(master$Sales.Incidents + master$Driver.Incidents + master$Warehouse.Incidents + master$Columbia.Incidents)
  master$Total.Cost = abs(master$Sales.Cost + master$Driver.Cost + master$Warehouse.Cost + master$Columbia.Cost)
  
  master
}

master_dataset = calculate_ytd(appended_dataset)


calculate_delta = function(master_dataset) {
  m = master_dataset
  
  yoy_pct_chg = function(x) {
    round((x - lag(x, 48)) / lag(x, 48), 2)
  }
  
  m$delta.Sales.Incidents = yoy_pct_chg(m$Sales.Incidents)
  m$delta.Driver.Incidents = yoy_pct_chg(m$Driver.Incidents)
  m$delta.Warehouse.Incidents = yoy_pct_chg(m$Warehouse.Incidents)
  m$delta.Columbia.Incidents = yoy_pct_chg(m$Columbia.Incidents)
  
  m$delta.Sales.Cost = yoy_pct_chg(m$Sales.Cost)
  m$delta.Driver.Cost = yoy_pct_chg(m$Driver.Cost)
  m$delta.Warehouse.Cost = yoy_pct_chg(m$Warehouse.Cost)
  m$delta.Columbia.Cost = yoy_pct_chg(m$Columbia.Cost)
  
  m$delta.Total.Incidents = yoy_pct_chg(m$Total.Incidents)
  m$delta.Total.Cost = yoy_pct_chg(m$Total.Cost)
  
  write.csv(m, 'C:/Users/pmwash/Desktop/R_files/Data Output/backup_of_breakage_data.csv')
  
  m
}

master_dataset = calculate_delta(master_dataset)


calculate_ytd_sales = function(sales) {
  library(dplyr)
  s = sales
  
  s = s %>% group_by(Year) %>%
    mutate(YTD.Sales = cumsum(Dollars))
  names(s) = c('Year', 'Year.Month', 'Std.Cases', 'Sales', 'YTD.Sales')
  
  s
}

sales = calculate_ytd_sales(sales)


calculate_percent_sales = function(master_dataset, ytd_sales, current_sales) {
  m = master_dataset
  
  m$Sales.Break.Percent.Sales = round(m$Sales.Cost / current_sales, 6)
  m$Driver.Break.Percent.Sales = round(m$Driver.Cost / current_sales, 6)
  m$Warehouse.Break.Percent.Sales = round(m$Warehouse.Cost / current_sales, 6)
  m$Columbia.Break.Percent.Sales = round(m$Columbia.Cost / current_sales, 6)
  
  m$YTD.Sales.Break.Percent.Sales = round(m$YTD.Sales.Cost / ytd_sales, 6)
  m$YTD.Driver.Break.Percent.Sales = round(m$YTD.Driver.Cost / ytd_sales, 6)
  m$YTD.Warehouse.Break.Percent.Sales = round(m$YTD.Warehouse.Cost / ytd_sales, 6)
  m$YTD.Columbia.Break.Percent.Sales = round(m$YTD.Columbia.Cost / ytd_sales, 6)
  
  write.csv(m, 'C:/Users/pmwash/Desktop/R_files/Data Output/backup_of_breakage_data.csv')
  
  m
}

print('Check to be sure these are correctly associated')
ytd_sales = tail(sales$YTD.Sales, 1)
current_sales = tail(sales$Sales, 1)
master_dataset = calculate_percent_sales(master_dataset, ytd_sales, current_sales)




print('Summarize information for export to file')

create_supplier_summary = function(supplier_breakage, month='January', year=2016) {
  lastyr = year-1
  s = supplier_breakage %>% filter(Month == month) %>% 
    filter(Year == year | Year == lastyr)
  previous = s[2,3]
  current = s[1,3]
  
  s = data.frame('Supplier.Cost', current, previous)
  names(s) = c('', paste0(month, '-', lastyr), paste0(month, '-', year))
  s = s[, c(1, 3, 2)]
  
  s
}

supplier_for_summary = create_supplier_summary(supplier_breakage)


create_monthly_summary = function(master_dataset, month='January', year=2016) {
  library(dplyr)
  lastyr = year-1
  this_month = master_dataset %>% filter(Month == month) %>% filter(Year == year | Year == lastyr)
  
  cost_warehouse = aggregate(Warehouse.Cost ~ Month + Year, data=this_month, FUN=function(x) round(sum(x), 2))
  cost_driver = aggregate(Driver.Cost ~ Month + Year, data=this_month, FUN=function(x) round(sum(x), 2))
  cost_columbia = aggregate(Columbia.Cost ~ Month + Year, data=this_month, FUN=function(x) round(sum(x), 2))
  

  cost_warehouse_ytd = aggregate(YTD.Warehouse.Cost ~ Month + Year, data=this_month, FUN=function(x) round(sum(x), 2))
  cost_driver_ytd = aggregate(YTD.Driver.Cost ~ Month + Year, data=this_month, FUN=function(x) round(sum(x), 2))
  cost_columbia_ytd = aggregate(YTD.Columbia.Cost ~ Month + Year, data=this_month, FUN=function(x) round(sum(x), 2))
  
  
  summary = merge(cost_warehouse, cost_driver, by=c('Month', 'Year'))
  summary = merge(summary, cost_columbia, by=c('Month', 'Year'))
  
  summary = merge(summary, cost_warehouse_ytd, by=c('Month', 'Year'))
  summary = merge(summary, cost_driver_ytd, by=c('Month', 'Year'))
  summary = merge(summary, cost_columbia_ytd, by=c('Month', 'Year'))
  
  t_summary = data.frame(t(summary))
  names(t_summary) = c(paste0(month, '-', lastyr), paste0(month, '-', year))
  t_summary = t_summary[-c(1:2) , c(2,1)]
  
  t_summary = cbind(rownames(t_summary), t_summary)
  rownames(t_summary) = NULL
  names(t_summary) = c('', 'January-2016', 'January-2015')
  
  
  
  #incidents =
  
  print(t_summary)
  
}

monthly_summary = create_monthly_summary(master_dataset)



prepare_summary = function(supplier_for_summary, monthly_summary) {
  summary = rbind(supplier_for_summary, monthly_summary)
  summary[,3] = as.numeric(summary[,3])
  summary[,2] = as.numeric(summary[,2])
  
  summary$YOY.Percent.Change = round(((summary[,2] - summary[,3]) / summary[,3]), 4)
  summary$Percent.Sales = summary[,2] / sales
  summary$Percent.Sales.YTD =
  
  summary
}

prepare_summary(supplier_for_summary, monthly_summary)



































































print('################################')
print('Characterize history of breakage')
print('################################')




print('Read in the historical data.')
# old C:/Users/pmwash/Desktop/R_Files/Data Input/Breakage_2013-2015.csv
brk = read.csv("C:/Users/pmwash/Desktop/R_Files/Data Input/breakage_history_for_graphs.csv", header=TRUE)
















print('3 Graphs Faceted, Monthly WAREHOUSE Breakage STL')
p = ggplot(breaks, aes(factor(Month), Warehouse.Breakage))
one = p + geom_point(aes(colour=Warehouse.Breakage, size=Warehouse.Breakage)) + 
  theme(legend.position='none') + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly Warehouse Breakage",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="purple", high="orange")
# 3 Graphs Faceted, PERCENT OF SALES Monthly WAREHOUSE Breakage STL
library(scales)
p = ggplot(breaks, aes(factor(Month), Whse.Break.Percent.Sales))
two = p + geom_point(aes(colour=Whse.Break.Percent.Sales, 
                   size=Whse.Break.Percent.Sales)) + 
  theme(legend.position='none') + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly Warehouse Breakage (% of Sales)",
       x="Month", y="Percent of Sales") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="purple", high="orange") +
  scale_y_continuous(labels=percent)
# get cumsum warehouse
breaks = breaks %>% group_by(Year) %>% 
  mutate(Cumulative.Warehouse.Breakage=cumsum(Warehouse.Breakage))
breaks = data.frame(breaks)
p = ggplot(breaks, aes(factor(Month), Cumulative.Warehouse.Breakage))
three = p + geom_point(aes(colour=Cumulative.Warehouse.Breakage, 
                         size=Cumulative.Warehouse.Breakage)) + 
  theme(legend.position='none') + geom_smooth(aes(group=1),
                                              colour="black") +
  labs(title="Cumulative Warehouse Breakage (Monthly Data)",
       x="Month", y="YTD Warehouse Breakage ($)") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="purple", high="orange") +
  scale_y_continuous(labels=dollar) +
  geom_vline(xintercept=12) +
  geom_hline(yintercept=79386.65)
library(gridExtra)
grid.arrange(one,two,three,ncol=1)


#### DRIVER GRAPHS ####
# 3 Graphs Faceted, Monthly DRIVER Breakage STL
p = ggplot(breaks, aes(factor(Month), Driver.Breakage))
one = p + geom_point(aes(colour=Driver.Breakage, size=Driver.Breakage)) + 
  theme(legend.position='none') + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly Driver Breakage",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="green", high="red")

# 3 Graphs Faceted, PERCENT OF SALES Monthly DRIVER BREAKAGE STL
library(scales)
p = ggplot(breaks, aes(factor(Month), Driver.Brk.Percent.Sales))
two = p + geom_point(aes(colour=Driver.Brk.Percent.Sales, 
                   size=Driver.Brk.Percent.Sales)) + 
  theme(legend.position='none') + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly STL Driver Breakage (% of Sales)",
       x="Month", y="Percent of Sales") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="green", high="red") +
  scale_y_continuous(labels=percent)

breaks = breaks %>% group_by(Year) %>% 
  mutate(Cumulative.Driver.Breakage=cumsum(Driver.Breakage))
breaks = data.frame(breaks)

p = ggplot(breaks, aes(factor(Month), Cumulative.Driver.Breakage))
three = p + geom_point(aes(colour=Cumulative.Driver.Breakage, 
                         size=Cumulative.Driver.Breakage)) + 
  theme(legend.position='none') + geom_smooth(aes(group=1),
                                              colour="black") +
  labs(title="Cumulative Driver Breakage (Monthly Data)",
       x="Month", y="Total Driver Breakage YTD ($)") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="green", high="red") +
  scale_y_continuous(labels=dollar) +
  geom_vline(xintercept=12) +
  geom_hline(yintercept=18257.36)
grid.arrange(one, two, three, ncol=1)



#### COLUMBIA GRAPHS ####
# 3 Graphs Faceted, Monthly COLUMBIA Breakage 
p = ggplot(breaks, aes(factor(Month), Col.Breakage))
one = p + geom_point(aes(colour=Col.Breakage, size=Col.Breakage)) + 
  theme(legend.position='none') + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly Columbia Breakage",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="green", high="black") +
  scale_y_continuous(limits=c(0, 2500))

p = ggplot(breaks, aes(factor(Month), Col.Break.Percent.Sales))
two = p + geom_point(aes(colour=Col.Break.Percent.Sales, size=Col.Break.Percent.Sales)) + 
  theme(legend.position='none') + geom_smooth(aes(group=1),
                                              colour="black") +
  labs(title="Monthly Columbia Breakage % Sales",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="green", high="black") +
  scale_y_continuous(labels=percent)
#get col cumsum
breaks = breaks %>% group_by(Year) %>% 
  mutate(Cumulative.Columbia.Breakage=cumsum(Col.Breakage))
breaks = data.frame(breaks)

p = ggplot(breaks, aes(factor(Month), Cumulative.Columbia.Breakage))
three = p + geom_point(aes(colour=Cumulative.Columbia.Breakage, 
                           size=Cumulative.Columbia.Breakage)) + 
  theme(legend.position='none') + geom_smooth(aes(group=1),
                                              colour="black") +
  labs(title="Cumulative Columbia Breakage (Monthly Data)",
       x="Month", y="Total Columbia Breakage YTD ($)") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="green", high="black") +
  scale_y_continuous(labels=dollar) +
  geom_vline(xintercept=12) +
  geom_hline(yintercept=12712.30)
grid.arrange(one, two, three, ncol=1)


#### STL TOTAL BREAKGE GRAPHS ####
# 3 Graphs Faceted, Monthly STL TOTAL Breakage 
p = ggplot(breaks, aes(factor(Month), STL.Total))
p + geom_point(aes(colour=STL.Total, size=STL.Total)) + 
  theme(legend.position='none') + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Total STL Monthly Breakage",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="darkblue", high="yellow") 


# Cumulative STL TOTAL BREAKAGE
p = ggplot(breaks, aes(factor(Month), STL.Cumulative.By.Year, 
                        fill=factor(Year)))
p + geom_point(aes(fill=factor(Year), group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=STL.Cumulative.By.Year, colour=factor(Year),
                group=factor(Year))) +
  theme(legend.position='none') + 
  labs(title="Cumulative Total Breakage (STL) By Year",
       x="Month", y="Dollars ($)") +
  facet_wrap(~Year, nrow=1) +
  geom_vline(xintercept=12) +
  geom_hline(yintercept= 97644.01) + 
  scale_y_continuous(labels=dollar)


print('Cumsum by Year of just Col, Warehouse. First create cumulative sum of both.')
breaks = breaks %>% group_by(Year) %>% 
  mutate(Whse.Col.Breakage=cumsum(Warehouse.Breakage+Col.Breakage))
breaks = data.frame(breaks)

p = ggplot(breaks, aes(factor(Month), Whse.Col.Breakage, 
                        fill=factor(Year)))
p + geom_point(aes(fill=factor(Year), group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=Whse.Col.Breakage, colour=factor(Year),
                group=factor(Year))) +
  theme(legend.position='none') + 
  labs(title="Cumulative Breakage, STL Warehouse & Columbia",
       x="Month", y="Dollars ($)") +
  facet_wrap(~Year, nrow=1) +
  geom_vline(xintercept=12) +
  geom_hline(yintercept= 92098.95) +
  scale_y_continuous(labels=dollar)


print('Characterize distributions of breakage.')
g = ggplot(data=breaks, aes(x=Warehouse.Breakage))
one = g + geom_density(fill='red', alpha=0.4) +
  scale_y_continuous(labels=percent) + 
  labs(title='Distribution of Monthly Warehouse Breakage',
       x='Warehouse Breakage (Cases)', y='Density')
g = ggplot(data=breaks, aes(x=Col.Breakage))
two = g + geom_density(fill='green', alpha=0.4) +
  scale_y_continuous(labels=percent) + 
  labs(title='Distribution of Columbia\'s Monthly Breakage',
       x='Columbia Breakage (Cases)', y='Density')
g = ggplot(data=breaks, aes(x=Driver.Breakage))
three = g + geom_density(fill='blue', alpha=0.4) +
  scale_y_continuous(labels=percent) + 
  labs(title='Distribution of Monthly Driver Breakage',
       x='Driver Breakage (Cases)', y='Density')

grid.arrange(one, two, three, ncol=1)



# Gross unsaleable percent of revenue
# 3 Graphs Faceted, PERCENT OF SALES Monthly DRIVER BREAKAGE STL
library(scales)
p = ggplot(breaks, aes(factor(Month), Gross.Unsaleable.Percent.Revenue))
p + geom_point(aes(colour=Gross.Unsaleable.Percent.Revenue, 
                   size=Gross.Unsaleable.Percent.Revenue)) + 
  theme(legend.position='none') + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly STL Unsaleables (% of Sales)",
       x="Month", y="Percent of Sales") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="gray", high="black") +
  scale_y_continuous(labels=percent)



##################################################################################
# New part to determine the drivers (sizes) of breakage
setwd("C:/Users/pmwash/Desktop/R_Files/Data Input")
details = read.csv('breakage_detailed_history.csv', header=TRUE) 
details$Total.Cases = as.numeric(details$Total.Cases)
print('DO NOT CHANGE COLUMN NAMES!!!!')
head(details)
str(details)
details$Month = ordered(details$Month, levels=c('January','February','March',
                                                 'April','May','June','July',
                                                 'August','September','October',
                                                 'November', 'December'))

library(ggplot2)
g = ggplot(data=details, aes(x=Month, y=Total.Cases, group=Type))
g + geom_point(aes(size=Total.Cases, colour=Total.Cases)) + 
  facet_wrap(~Type, scales='free') + geom_smooth(colour='black', aes(group=Type)) +
  theme(axis.text.x=element_text(angle=90, hjust=1)) +
  labs(title='Breakage by Type, STL') + 
  scale_colour_gradient(low="darkblue", high="red") +
  theme(legend.position='none')

g = ggplot(data=details, aes(x=Month, y=Total.Cases))
g + geom_bar(stat='sum', position='fill', aes(fill=Type)) +
  theme(axis.text.x=element_text(angle=90, hjust=1), legend.position='bottom') +
  labs(title='Breakage by Product Type') +
  scale_y_continuous(labels=percent)

#




















################################################ KANSAS CITY
################################################ KANSAS CITY
################################################ KANSAS CITY
################################################ KANSAS CITY
################################################ KANSAS CITY
################################################ KANSAS CITY
################################################ KANSAS CITY
################################################ KANSAS CITY








print('This is for Kansas City. Check your RCOMP and be sure it is equal to 2.')

# HISTORY

library(ggplot2)
library(reshape2)
library(scales)

# Looking at breakage in more tidy format than the Breakage report
setwd("C:/Users/pmwash/Desktop/R_Files/Data Input")
breaks=read.csv("KC_BREAKAGE_REPORT.csv",header=TRUE)
breaks$Warehouse.Breakage = as.numeric(breaks$Warehouse.Breakage)
breaks$Driver.Breakage = as.numeric(breaks$Driver.Breakage)
breaks$Springfield.Breakage = as.numeric(breaks$Springfield.Breakage)
#breaks$Total.Breakage.KC = as.numeric(as.character(breaks$Total.Breakage.KC))
breaks$Cumulative.Sales.YTD = as.numeric(breaks$Cumulative.Sales.YTD)
breaks$Cumulative.Unsaleables.YTD = as.numeric(breaks$Cumulative.Unsaleables.YTD)
breaks$Cumulative.YTD.Breakage.Only = as.numeric(breaks$Cumulative.YTD.Breakage.Only)

breaks = breaks[!is.na(breaks$Year), ]
breaks = breaks[!is.na(breaks$Month), ]
headTail(breaks)

# 3 Graphs Faceted, Monthly WAREHOUSE Breakage STL PERCENT OF SALES
p = ggplot(breaks, aes(factor(Month), Whse.Break.Percent.Sales))
one = p + geom_point(aes(colour=Warehouse.Breakage, size=Warehouse.Breakage)) + 
  theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) +
  geom_smooth(aes(group=1), colour="black") +
  labs(title="Monthly Warehouse Breakage Kansas City % Sales",
       x="Month", y="Percent of Sales") + facet_wrap(~Year, nrow=2) +
  scale_colour_gradient(low="purple", high="orange") +
  scale_y_continuous(labels=percent)

p = ggplot(breaks, aes(factor(Month), Warehouse.Breakage))
two = p + geom_point(aes(colour=Warehouse.Breakage, size=Warehouse.Breakage)) + 
  theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) +
  geom_smooth(aes(group=1), colour="black") +
  labs(title="Monthly Warehouse Breakage Kansas City",
       x="Month", y="Dollars") + facet_wrap(~Year, nrow=2) +
  scale_colour_gradient(low="purple", high="orange") +
  scale_y_continuous(labels=dollar)
library(gridExtra)
grid.arrange(two,one,ncol=1)



#### DRIVER GRAPHS ####
# 3 Graphs Faceted, Monthly DRIVER Breakage STL
library(gridExtra)
p = ggplot(breaks, aes(factor(Month), Driver.Breakage))
driveDollars = p + geom_point(aes(colour=Driver.Breakage, size=Driver.Breakage)) + 
  theme(legend.position="none") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly Driver Breakage KC",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=2) +
  scale_colour_gradient(low="green", high="red")

# 3 Graphs Faceted, PERCENT OF SALES Monthly DRIVER BREAKAGE STL
library(scales)
p = ggplot(breaks, aes(factor(Month), Driver.Brk.Percent.Sales))
drivePercent = p + geom_point(aes(colour=Driver.Brk.Percent.Sales, 
                   size=Driver.Brk.Percent.Sales)) + 
  theme(legend.position="none") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly KC Driver Breakage (% of Sales)",
       x="Month", y="Percent of Sales") + facet_wrap(~Year, nrow=2) +
  scale_colour_gradient(low="green", high="red") +
  scale_y_continuous(labels=percent)
grid.arrange(driveDollars, drivePercent, nrow=2)



#### Springfield GRAPHS ####
# 3 Graphs Faceted, Monthly sprg Breakage 
library(dplyr)
pup = filter(breaks, Year >= 2009)
p = ggplot(pup, aes(factor(Month), Springfield.Breakage))
one = p + geom_point(aes(colour=Springfield.Breakage, 
                   size=Springfield.Breakage)) + 
  theme(legend.position="none") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Monthly Springfield Breakage",
       x="Month", y="Dollars") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="green", high="black") +
scale_y_continuous(labels=dollar)
p = ggplot(pup, aes(factor(Month), Sprgfld.Percent.Sales))
two = p + geom_point(aes(colour=Springfield.Breakage, 
                         size=Springfield.Breakage)) + 
  theme(legend.position="none") + geom_smooth(aes(group=1),
                                              colour="black") +
  labs(title="Monthly Springfield Breakage % Sales",
       x="Month", y="Percent of Sales") + facet_wrap(~Year, nrow=1) +
  scale_colour_gradient(low="green", high="black") +
  scale_y_continuous(labels=percent)
grid.arrange(one,two,ncol=1)




#### KC TOTAL BREAKGE GRAPHS ####
# 3 Graphs Faceted, Monthly STL TOTAL Breakage 
p = ggplot(breaks, aes(factor(Month), 
                        Total.KC.Breakage.Percent.Sales))
p + geom_point(aes(colour=Total.KC.Breakage.Percent.Sales, 
                   size=Total.KC.Breakage.Percent.Sales)) + 
  theme(legend.position="none") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Total KC Monthly Breakage+Unsaleables",
       x="Month", y="Percent of Sales") + facet_wrap(~Year, nrow=2) +
  scale_colour_gradient(low="darkblue", high="yellow") +
  scale_y_continuous(label=percent, limits=c(0, 0.008))


###
# 3 Graphs Faceted, Monthly STL TOTAL Breakage  USE THIS FOR TOTAL BRK W/O UNSLBLS
p = ggplot(breaks, aes(factor(Month), 
                        Total.Breakage.Only))
one = p + geom_point(aes(colour=Total.Breakage.Only, 
                   size=Total.Breakage.Only)) + 
  theme(legend.position="none") + geom_smooth(aes(group=1),
                                                colour="black") +
  labs(title="Total KC Monthly Breakage (Excluding Unsaleables)",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=2) +
  scale_colour_gradient(low="darkblue", high="yellow") +
  scale_y_continuous(label=dollar)

ttlBrk = breaks$Total.Breakage.Only
ttlSls = breaks$Dollars
breaks$Breakage.Only.Percent.Sales = round(ttlBrk / ttlSls, 4)
p = ggplot(breaks, aes(factor(Month), 
                        Breakage.Only.Percent.Sales))
two = p + geom_point(aes(colour=Breakage.Only.Percent.Sales, 
                         size=Total.Breakage.Only)) + 
  theme(legend.position="none") + geom_smooth(aes(group=1),
                                              colour="black") +
  labs(title="Total KC Monthly Breakage (Excluding Unsaleables) % Sales",
       x="Month", y="Dollars ($)") + facet_wrap(~Year, nrow=2) +
  scale_colour_gradient(low="darkblue", high="yellow") +
  scale_y_continuous(label=percent)
grid.arrange(one, two, ncol=1)




# CUM KC BREAKAGE
p = ggplot(breaks, aes(factor(Month), Cumulative.YTD.Breakage.Only, 
                        fill=factor(Year)))
p + geom_point(aes(fill=factor(Year), group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=Cumulative.YTD.Breakage.Only, colour=factor(Year),
                group=factor(Year))) +
  theme(legend.position="none") + 
  labs(title="Cumulative Total Breakage + Unsaleables (KC) By Year (Excluding Unsaleables)",
       x="Month", y="Dollars ($)") +
  facet_wrap(~Year, nrow=2) +
  geom_vline(xintercept=12) +
  geom_hline(yintercept= 77286.48) +
  scale_y_continuous(label=dollar) #, limits=c(0,500000))



# CUM KC TOTAL BREAKAGE AS PERCENT OF CUM SALES
p = ggplot(breaks, aes(factor(Month), Percent.Cumulative.Breakage.YTD, 
                        fill=factor(Year)))
withUnsaleables = p + geom_point(size=3, aes(fill=factor(Year), 
                   group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=Percent.Cumulative.Breakage.YTD, 
                colour=factor(Year),
                group=factor(Year))) +
  theme(legend.position="none") + 
  labs(title="KC: Percent Cumulative Breakage of Cumulative Sales YTD (INCLUDING Unsaleables)",
       x="Month", y="Percent of Cumulative Sales") +
  facet_wrap(~Year, nrow=2) +
  geom_vline(xintercept=12) +
  geom_hline(yintercept= 0.0042297) +
  scale_y_continuous(label=percent) #, limits=c(0,500000))
###
p = ggplot(breaks, aes(factor(Month), Percent.Cumulative.Breakage.Only.YTD, 
                        fill=factor(Year)))
withoutUnsaleables = p + geom_point(size=3, aes(fill=factor(Year),
                                      group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=Percent.Cumulative.Breakage.Only.YTD, 
                colour=factor(Year),
                group=factor(Year))) +
  theme(legend.position="none") + 
  labs(title="KC: Percent Cumulative Breakage of Cumulative Sales YTD (EXCLUDING Unsaleables)",
       x="Month", y="Percent of Cumulative Sales") +
  facet_wrap(~Year, nrow=2) +
  geom_vline(xintercept=12) +
  geom_hline(yintercept= 0.0004987) +
  scale_y_continuous(label=percent) #, limits=c(0,500000))
grid.arrange(withUnsaleables, withoutUnsaleables, nrow=2)


# Cum sales
p = ggplot(breaks, aes(factor(Month), Cumulative.Sales.YTD, 
                        fill=factor(Year)))
p + geom_point(aes(fill=factor(Year), group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=Cumulative.Sales.YTD, colour=factor(Year),
                group=factor(Year))) +
  theme(legend.position="none") + 
  labs(title="KC Cumulative Sales YTD",
       x="Month", y="Dollars ($)") +
  facet_wrap(~Year, nrow=2) +
  geom_vline(xintercept=12) +
  geom_hline(yintercept= 154966302) +
  scale_y_continuous(label=dollar) #, limits=c(0,500000))



# Cum UNSALEABLES
p = ggplot(breaks, aes(factor(Month), Cumulative.Unsaleables.YTD, 
                        fill=factor(Year)))
p + geom_point(aes(fill=factor(Year), group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=Cumulative.Unsaleables.YTD, colour=factor(Year),
                group=factor(Year))) +
  theme(legend.position="none") + 
  labs(title="KC Cumulative Unsaleables YTD",
       x="Month", y="Dollars ($)") +
  facet_wrap(~Year, nrow=2) +
  geom_vline(xintercept=12) +
  geom_hline(yintercept= 578181.0) +
  scale_y_continuous(label=dollar) #, limits=c(0,500000))



# Cum BREAKAGE ONLY
p = ggplot(breaks, aes(factor(Month), Cumulative.YTD.Breakage.Only, 
                        fill=factor(Year)))
withoutUnsaleables = p + geom_point(aes(fill=factor(Year), group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=Cumulative.YTD.Breakage.Only, colour=factor(Year),
                group=factor(Year))) +
  theme(legend.position="none") + 
  labs(title="Cumulative Breakage Excluding Unsaleables (KC) by Year",
       x="Month", y="Dollars ($)") +
  facet_wrap(~Year, nrow=2) +
  geom_vline(xintercept=12) +
  geom_hline(yintercept= 77286.48) +
  scale_y_continuous(label=dollar) #, limits=c(0,500000))

p = ggplot(breaks, aes(factor(Month), Cumulative.Breakage.YTD, 
                        fill=factor(Year)))
withUnsaleables = p + geom_point(aes(fill=factor(Year), group=factor(Year))) + 
  geom_line(aes(x=factor(Month), y=Cumulative.Breakage.YTD, colour=factor(Year),
                group=factor(Year))) +
  theme(legend.position="none") + 
  labs(title="Cumulative Breakage Including Unsaleables (KC) by Year",
       x="Month", y="Dollars ($)") +
  facet_wrap(~Year, nrow=2) +
  geom_vline(xintercept=12) +
  geom_hline(yintercept= 655467.2) +
  scale_y_continuous(label=dollar) #, limits=c(0,500000))
grid.arrange(withUnsaleables, withoutUnsaleables, nrow=2)













##################################################################################
# BY TYPE
setwd("C:/Users/pmwash/Desktop/R_Files/Data Input")
detail = read.csv('kc_breakage_byType.csv', header=TRUE) # taken from the monthly breakage report
detail$Month = factor(detail$Month, levels=c('January', 'February', 'March', 'April', 'May', 
                                              'June', 'July', 'August', 'September', 'October', 'November', 'December'))
detail$Brk.Excluding.Sales = detail$Total.Cases - detail$Sales.Code.2

headTail(detail)

g = ggplot(data=detail, aes(x=Month, y=Brk.Excluding.Sales, group=Type))
one = g + geom_point(aes(group=Type, size=Brk.Excluding.Sales)) + facet_wrap(~Type) +
  geom_smooth(aes(group=Type, colour=Type), se=F) +
  theme(legend.position='none', axis.text.x=element_text(angle=90, hjust=1)) +
  labs(title='KC Total Breakage by Type, Excluding Sales Brk.', y='Cases')
g = ggplot(data=detail, aes(x=Month, y=Sales.Code.2, group=Type))
two = g + geom_point(aes(group=Type, size=Sales.Code.2)) + facet_wrap(~Type) +
  geom_smooth(aes(group=Type, colour=Type), se=F) +
  theme(legend.position='none', axis.text.x=element_text(angle=90, hjust=1)) +
  labs(title='KC Sales Breakage by Type', y='Cases')
g = ggplot(data=detail, aes(x=Month, y=Total.Driver, group=Type))
three = g + geom_point(aes(group=Type, size=Total.Driver)) + facet_wrap(~Type) +
  geom_smooth(aes(group=Type, colour=Type), se=F) +
  theme(legend.position='none', axis.text.x=element_text(angle=90, hjust=1)) +
  labs(title='KC Total Driver Breakage by Type', y='Cases')
g = ggplot(data=detail, aes(x=Month, y=Warehouse, group=Type))
four = g + geom_point(aes(group=Type, size=Warehouse)) + facet_wrap(~Type) +
  geom_smooth(aes(group=Type, colour=Type), se=F) +
  theme(legend.position='none', axis.text.x=element_text(angle=90, hjust=1)) +
  labs(title='KC Total Warehouse Breakage by Type', y='Cases')
grid.arrange(one, two, three, four, ncol=2)



















