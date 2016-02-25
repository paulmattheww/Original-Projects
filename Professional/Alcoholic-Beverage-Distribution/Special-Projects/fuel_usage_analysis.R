
print('Gather fuel data for 2014-2015 for Tom to hedge adequately')

print('Read in files necessary to do work')
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')
library(data.table)
library(ggplot2)
library(lubridate)
library(XLConnect)


print('QUERY OF AP PAID FILE FOR 1/1/14-12/31/15, HOGAN LEASING, MEMO FIELD FUEL as well as the rest of the data from years past')
hogan = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/Hogan Leasing Fuel Costs 2014 2015 Query.csv')
diesel = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/Diesel Tracking.csv')  # ; str(diesel) # make sure all are n umeric


format_diesel = function(diesel) {
  diesel$Names = paste0(diesel$X, sep=' - ', diesel$X.1)
  row.names(diesel) = sapply(diesel$Names, function(x) gsub('\\s+', '', x))
  diesel = diesel[, -c(1,2,112)] 
  
  t_diesel = data.frame(t(diesel)) # str(t_diesel)
  dates = row.names(t_diesel)
  t_diesel = data.frame(sapply(t_diesel[,c(1:27)], function(x) as.numeric(as.character(x))))
  row.names(t_diesel) = as.character(dates)
  
  t_diesel$Month = substrLeft(row.names(t_diesel), 3)
  t_diesel$Year = paste0('20', substrRight(row.names(t_diesel), 2))
  
  t_diesel = t_diesel %>% filter(Year == 2014 | Year == 2015)
  order = paste0(t_diesel$Year, sep='-', t_diesel$Month)
  row.names(t_diesel) = factor(order, levels=order)
  
  t_diesel = t_diesel[, -c(19:27)]
  t_diesel
}

clean_diesel = format_diesel(diesel); headTail(clean_diesel)




format_hogan = function(hogan) {
  h = hogan
  
  h$INVOICE.DATE = as400Date(h$INVOICE.DATE)
  h = h[, c('INVOICE.NUMBER', 'INVOICE.DATE', 'INVOICE.AMOUNT')]
  h$Year = substrLeft(h$INVOICE.DATE, 4)
  x = h$INVOICE.DATE
  h$Month = ifelse(month(x)==1, 'JAN',
                   ifelse(month(x)==2, 'FEB',
                          ifelse(month(x)==3, 'MAR',
                                 ifelse(month(x)==4, 'APR',
                                        ifelse(month(x)==5, 'MAY',
                                               ifelse(month(x)==6, 'JUN', 
                                                      ifelse(month(x)==7, 'JUL', 
                                                             ifelse(month(x)==8, 'AUG', 
                                                                    ifelse(month(x)==9, 'SEP', 
                                                                           ifelse(month(x)==10, 'OCT', 
                                                                                  ifelse(month(x)==11, 'NOV', 
                                                                                         ifelse(month(x)==12, 'DEC', 'XXXXXXXX'))))))))))))
  h$Month = factor(h$Month, levels=c('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
                                     'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'))
  clean_hogan = aggregate(INVOICE.AMOUNT ~ Month + Year, data=h, FUN=sum)         
  names(clean_hogan) = c('Month', 'Year', 'TOTALCOST.HOGAN')
  clean_hogan
}

clean_hogan = format_hogan(hogan)




combined = merge(clean_diesel, clean_hogan, by=c('Year', 'Month'))
combined$Month = factor(combined$Month, levels=c('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
                                          'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'))
combined = combined %>% arrange(Year, Month)





calculate_totals_avgs = function(combined) {
  cd = combined
  get_mean = function(col_name) round(mean(col_name, na.rm=TRUE), 2)
  get_sum = function(col_name) round(sum(col_name, na.rm=TRUE))
  
  avg_rpg_kc_quickfuel = get_mean(cd$RATEPERGALLON.KC.QUICKFUEL)
  avg_rpg_stl_quickfuel = get_mean(cd$RATEPERGALLON.STL.QUICKFUEL)
  avg_rpg_spg_quickfuel = get_mean(cd$RATEPERGALLON.SPG.QUICKFUEL)
  
  avg_rpg_stl_fuelman = get_mean(cd$RATEPERGALLON.STL.FUELMAN)
  avg_rpg_spg_fuelman = get_mean(cd$RATEPERGALLON.SPG.FUELMAN)
  
  avg_rpg_col_mfa = get_mean(cd$RATEPERGALLON.COL.MFAOILCO.)
  
  
  sum_gal_kc_quickfuel = get_sum(cd$GALLONSUSED.KC.QUICKFUEL)
  sum_gal_stl_quickfuel = get_sum(cd$GALLONSUSED.STL.QUICKFUEL)
  sum_gal_spg_quickfuel = get_sum(cd$GALLONSUSED.SPG.QUICKFUEL)
  
  sum_gal_stl_fuelman = get_sum(cd$GALLONSUSED.STL.FUELMAN)
  sum_gal_spg_fuelman = get_sum(cd$GALLONSUSED.SPG.FUELMAN)
  
  sum_gal_col_mfa = get_sum(cd$GALLONSUSED.COL.MFAOILCO.)
  
  sum_cost_hogan = get_sum(cd$TOTALCOST.HOGAN)
  
  tot = sum(sum_gal_kc_quickfuel, sum_gal_stl_quickfuel, sum_gal_spg_quickfuel,
            sum_gal_stl_fuelman, sum_gal_spg_fuelman, sum_gal_col_mfa)
  weighted_avg_fuel = round((avg_rpg_kc_quickfuel * (sum_gal_kc_quickfuel / tot)) +
    (avg_rpg_stl_quickfuel * (sum_gal_stl_quickfuel / tot)) +
    (avg_rpg_spg_quickfuel * (sum_gal_spg_quickfuel / tot)) +
    (avg_rpg_stl_fuelman * (sum_gal_stl_fuelman / tot)) +
    (avg_rpg_spg_fuelman * (sum_gal_spg_fuelman / tot)) + 
    (avg_rpg_col_mfa * (sum_gal_col_mfa / tot)), 2)
  
  sum_gal_hogan_inferred = round(sum_cost_hogan / weighted_avg_fuel)
  
  total_gallons_2014_2015 = sum(sum_gal_kc_quickfuel, sum_gal_stl_quickfuel, 
                                sum_gal_spg_quickfuel, sum_gal_stl_fuelman,
                                sum_gal_spg_fuelman, sum_gal_col_mfa,
                                sum_gal_hogan_inferred)
  
  
  key = c('Quickfuel.Avg.Gallon.Price.KC', 'Quickfuel.Avg.Gallon.Price.STL', 'Quickfuel.Avg.Gallon.Price.SPG', 
          'Fuelman.Avg.Gallon.Price.STL', 'Fuelman.Avg.Gallon.Price.SPG',
          'MFA.Avg.Gallon.Price.COL',
          '', 
          'Quickfuel.Gallons.KC', 'Quickfuel.Gallons.STL', 'Quickfuel.Gallons.SPG',
          'Fuelman.Gallons.STL', 'Fuelman.Gallons.SPG',
          'MFA.Gallons.COL',
          '',
          'Hogan.Cost', 'Hogan.Gallons.Inferred',
          '',
          'Total.Gallons.2014-2015', 'Weighted.Avg.Fuel.Cost')
  value = c(avg_rpg_kc_quickfuel, avg_rpg_stl_quickfuel, avg_rpg_spg_quickfuel, 
            avg_rpg_stl_fuelman, avg_rpg_spg_fuelman,
            avg_rpg_col_mfa,
            '',
            sum_gal_kc_quickfuel, sum_gal_stl_quickfuel, sum_gal_spg_quickfuel,
            sum_gal_stl_fuelman, sum_gal_spg_fuelman,
            sum_gal_col_mfa,
            '',
            sum_cost_hogan, sum_gal_hogan_inferred,
            '',
            total_gallons_2014_2015, weighted_avg_fuel)
  
  avgs_totals = data.frame(cbind(key, value))
  names(avgs_totals) = c('', 'Value')
  avgs_totals
  
}

summary = calculate_totals_avgs(combined)





wtd_avg_rpg = tail(summary$Value, 1)
wtd_avg_rpg #take this and input it into below
hogan_cost = combined$TOTALCOST.HOGAN

combined$GALLONS.HOGAN.INFERRED = round(hogan_cost / 2.53, 2)
combined$WEIGHTED.AVG.FUEL.COST.PER.GALLON = wtd_avg_rpg




make_aggregates = function(combined) {
  gal_quickfuel_kc = aggregate(GALLONSUSED.KC.QUICKFUEL ~ Year+ Month, data=combined, FUN=sum)
  gal_quickfuel_stl = aggregate(GALLONSUSED.STL.QUICKFUEL ~ Year+ Month, data=combined, FUN=sum)
  gal_quickfuel_spg = aggregate(GALLONSUSED.STL.QUICKFUEL ~ Year+ Month, data=combined, FUN=sum)
  
}











file_name = 'summary_fuel_usage_2014_2015.xlsx'
write.xlsx(summary, file=paste0('C:/Users/pmwash/Desktop/R_Files/Data Output/', file_name), sheetName='Fuel Usage Summary')
write.xlsx(combined, file=paste0('C:/Users/pmwash/Desktop/R_Files/Data Output/', file_name), sheetName='Tidy Data Set', append=TRUE)








total_hogan_fuel = sum(monthly_hogan$INVOICE.AMOUNT)
paste0('In 2014-2015 Hogan billed us for $', total_hogan_fuel, ' worth of fuel')























print('Check data by visualization')

g = ggplot(data=hogan, aes(x=MONTH.PAID, y=INVOICE.AMOUNT))
g + geom_boxplot() + facet_wrap(~YEAR.PAID)



g = ggplot(data=monthly_hogan, aes(x=MONTH.PAID, y=INVOICE.AMOUNT))
g + geom_point() + facet_wrap(~YEAR.PAID) + geom_line(aes(group=YEAR.PAID))

headTail(hogan)



