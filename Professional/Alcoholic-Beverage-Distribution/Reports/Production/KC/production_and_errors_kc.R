
print('(1) Open for_vba_production_gather.xlsm in ~/Data Input/Living Documents folder')
print('(2) Open ~/Disposable Documents/~/input_production_report.xlsx and make sure it is clear (keep cols)')
print('(3) Move over daily reports for month at hand AND house at hand')

#move from formal location to reporting location
print('CHANGE MONTH IN FILE PATH')
from_loc = c('M:/Share/Daily Report KC/2016/August 2016/.')
org_files = list.files(from_loc, full.names=TRUE)

to_loc = c('C:/Users/pmwash/Desktop/Disposable Docs/Production Data/.')
file.copy(from=org_files, 
          to=to_loc)



print('Gather external utilities')
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)
library(zoo)
library(gridExtra)
library(lubridate)
library(reshape2)
library(stringr)
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')
raw_data = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/Input Files for Reports/Production/KC/input_production_report_kc.csv', header=TRUE)
headTail(raw_data)


print('Prepare the data')
tidy_production_data = function(raw_data) {
  r = raw_data
  
  r = data.frame(r %>% separate(Date, into=c('Date', 'X'), sep='\\.'))
  r$Date = as.character(strptime(str_extract(r$Date, '[0-9]+-[0-9]+$'), format='%m-%d'))
  
  r = r[,c(1:3, 5)]
  r$Key = paste0(r$Index, sep='_', r$Key)
  r = r[,-c(4)]
  
  r = reshape(r, 
              timevar = 'Date',
              idvar = 'Key', 
              direction = 'wide')
  
  row.names(r) = toupper(as.character(r[,1]))
  r = r[-c(1), ]
  r = r[, -c(1)]
  
  row.names(r) = sapply(row.names(r), function(x)gsub('\\s+', '.',x))
  names(r) = str_extract(as.character(names(r)), '[0-9]+-[0-9]+-[0-9]+')
  #r = r[, -c(105)]
  
  tidy_data = r 
  
  t_tidy_data = data.frame(t(tidy_data))
  
  the_names = c('BOTTLE.HOURS', 'C.100.CASES', 'C.100.HOURS', 'C.200.CASES', 'C.200.HOURS', 
                'C.300/400.CASES', 'C.300/400.HOURS', 'W.CASES', 'W.HOURS', 'R.ODD.BALL', 
                'R.ODDBALL.HOURS', 'UNKNOWN.CASES', 'UNKNOWN.HOURS', 'ODD.BALL.BOTTLES', 'ODD.BALL.BOTTLE.HOURS',
                'NON.CONVEYABLE', 'PALLET.PICKS', 'LOADING.HOURS', 'SORTER.RUN.TIME.HOURS', 'NO.READS', 
                'MULTI.READS', 'JACKPOT.CASES', 'JACKPOT.HAND.SCAN', 'C.100.ERRORS', 'C.200.ERRORS', 
                'C.300/400.ERRORS', 'R.ERRORS', 'WINE.ERRORS', 'CASE.SHORTS', 'BOTTLE.SHORTS', 
                'NO.ID.GROUPS', 'NUMBER.WAVES', 'SPRINGFIELD.PALLETS', 'SPRINGFIELD.BINS', 'COMPLETION.TIME', 
                'CPMH.OT.ADJUSTED', 'CPMH', 'PRODUCTION->', 'CASES.TOTAL', 'CASES.KC', 
                'CASES.STL.TRANSFER', 'PALLET.PULLS', 'CASES.SPRINGFIELD', 'BOTTLES', 'BOTTLES.KC',
                'BOTTLES.SPRINGFIELD', 'STOPS.KC.TOTAL', 'STOPS.SPRINGFIELD', 'TRUCKS.KC.TOTAL', 'TRUCKS.SPRINGFIELD', 
                'CASES.PER.HOUR', 'BPMH', 'C.100.CPMH', 'C.200.CPMH', 'C.300/400.CPMH', 
                'R.CPMH', 'X1', 'X2', 'HOURS.NIGHTLY', 'HOURS.TOTAL', 
                'HOURS.SENIORITY', 'HOURS.CASUAL', 'REGULAR.HOURS', 'REGULAR.HOURS.SENIORITY', 'REGULAR.HOURS.CASUAL', 
                'OT.HOURS', 'OT.HOURS.SENIORITY', 'OT.HOURS.CASUAL', 'TEMP.HOURS', 'ABSENT.EMPLOYEES',
                'ABSENT.EMPLOYEES.SENIORITY', 'ABSENT.EMPLOYEES.CASUAL', 'TEMPS.ON.HAND', 'EMPS.ON.HAND', 'EMPS.TEMPS.ON.HAND', 
                'RETURNS->', 'RETURNS.CASES', 'RETURNS.BOTTLES', 'X3', 'OVER.SHORT->',
                'OVERS.TOTAL', 'SHORTS.TOTAL', 'OVER.SHORT.CASES', 'OVER.SHORT.BOTTLES', 'MISPICKS.TOTAL',
                'MISPICK.CASES', 'MISPICK.BOTTLES', 'TOTAL.RAW.CASE.ERRORS', 'TOTAL.RAW.BOTTLE.ERRORS', 'ERRORS.TOTAL',
                'ERRORS.B.LINE', 'OVER.SHORT.B.LINE', 'MISPICK.B.LINE', 'ERRORS.C.100', 'OVER.SHORT.C.100',
                'MISPICK.C.100', 'ERRORS.C.200', 'OVER.SHORT.C.200', 'MISPICK.C.200', 'ERRORS.C.300/400',
                'OVER.SHORT.C.300/400', 'MISPICK.C.300/400', 'ERRORS.R.LINE', 'OVER.SHORT.R.LINE', 'MISPICK.R.LINE',
                'ERRORS.WINE.ROOM', 'OVER.SHORT.WINE.ROOM', 'MISPICK.WINE.ROOM', 'ERRORS.KEG.ROOM', 'OVER.SHORT.KEG.ROOM', 
                'MISPICK.KEG.ROOM', 'ERRORS.LOCKUP', 'OVER.SHORT.LOCKUP', 'MISPICK.OVER.SHORT')
  
  the_names = factor(the_names, levels=the_names)
  names(t_tidy_data) = the_names
  
  
  
  
  dat = row.names(t_tidy_data)
  
  t_tidy_data = data.frame(sapply(t_tidy_data, function(x) as.numeric(as.character(x))))
  
  row.names(t_tidy_data) = dat 
  t_tidy_data$MONTH = month = month(dat)
  t_tidy_data$YEAR = year(dat)
  t_tidy_data$DATE = dat
  t_tidy_data$SEASON = ifelse(month==1 | month==2 |month==3, "Winter", 
                              ifelse(month==4 | month==5 | month==6, "Spring",
                                     ifelse(month==7 | month==8 | month==9, "Summer",
                                            ifelse(month==10 | month==11 | month==12, "Fall", ""))))
  row.names(t_tidy_data) = NULL
  t_tidy_data$NA. = NULL
  
  t_tidy_data = t_tidy_data[,c(117, 1:116)]
  
  t_tidy_data
}

production = tidy_production_data(raw_data)
production = production %>% arrange(DATE)
headTail(production)

#write.csv(last_year, file='M:/Operations Intelligence/Monthly Reports/Production/Production History/KC Production Report Daily Data Archivex.csv')


print('DELETE FIRST COLUMN DO NOT DO BY HAND ANYMORE')
append_archive_daily_data = function(production) {
path = 'M:/Operations Intelligence/Monthly Reports/Production/Production History/KC Production Report Daily Data Archive.csv'
library(dplyr)

history = read.csv(path, header=TRUE)
history = history %>% arrange(as.Date(DATE, '%m/%d/%Y'))
names(history) = names(production)
appended = rbind(history, production)
appended = appended %>% arrange(as.Date(DATE, '%m/%d/%Y'))

write.csv(appended, path, row.names=FALSE)

appended
}


print('Delete first column from output csv document')
production_appended = append_archive_daily_data(production)

# If you must re-read it in without appending duplicates... 
# path = 'M:/Operations Intelligence/Monthly Reports/Production/Production History/KC Production Report Daily Data Archive.csv'
# production_appended = read.csv(path, header=TRUE)
headTail(production_appended, 20)



generate_cumsums = function(production_appended) {
  p = data.frame(production_appended)
  
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.CASES.TOTAL=cumsum(CASES.TOTAL))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.CASES.KC=cumsum(CASES.KC))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.CASES.STL.TRANSFER=cumsum(CASES.STL.TRANSFER))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.CASES.SPRINGFIELD=cumsum(CASES.SPRINGFIELD))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.BOTTLES=cumsum(BOTTLES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.BOTTLES.KC=cumsum(BOTTLES.KC))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.BOTTLES.SPRINGFIELD=cumsum(BOTTLES.SPRINGFIELD))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.HOURS.TOTAL=cumsum(HOURS.TOTAL))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.REGULAR.HOURS=cumsum(REGULAR.HOURS))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.OT.HOURS=cumsum(OT.HOURS))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.ABSENT.EMPS=cumsum(ABSENT.EMPLOYEES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.STOPS.KC.TOTAL=cumsum(STOPS.KC.TOTAL))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.STOPS.SPRINGFIELD=cumsum(STOPS.SPRINGFIELD))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.ERRORS.TOTAL=cumsum(ERRORS.TOTAL))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.RETURNS.CASES=cumsum(RETURNS.CASES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.RETURNS.BOTTLES=cumsum(RETURNS.BOTTLES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.C.100.CASES=cumsum(C.100.CASES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.C.200.CASES=cumsum(C.200.CASES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.C.300.400.CASES=cumsum(C.300.400.CASES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.W.CASES=cumsum(W.CASES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.R.ODD.BALL.CASES=cumsum(R.ODD.BALL))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.UNKNOWN.CASES=cumsum(UNKNOWN.CASES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.NON.CONVEYABLE.CASES=cumsum(NON.CONVEYABLE))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.PALLET.PICKS.CASES=cumsum(PALLET.PICKS))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.JACKPOT.CASES=cumsum(JACKPOT.CASES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.JACKPOT.HAND.SCAN=cumsum(JACKPOT.HAND.SCAN))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.NUMBER.WAVES=cumsum(NUMBER.WAVES))
  
  p = data.frame(p)
  
  p
}


production_appended = generate_cumsums(production_appended)





generate_moving_avgs = function(production_appended) {
  m = production_appended
  
  m = m %>% group_by(YEAR) %>%
    mutate(CPMH.10.DAY.MVG.AVG = rollmean(x=CPMH, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(CASES.KC.10.DAY.MVG.AVG = rollmean(x=CASES.KC, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(CASES.STL.TRANSFER.10.DAY.MVG.AVG = rollmean(x=CASES.STL.TRANSFER, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(CASES.SPRINGFIELD.10.DAY.MVG.AVG = rollmean(x=CASES.SPRINGFIELD, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(BOTTLES.10.DAY.MVG.AVG = rollmean(x=BOTTLES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(HOURS.TOTAL.10.DAY.MVG.AVG = rollmean(x=HOURS.TOTAL, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(REGULAR.HOURS.10.DAY.MVG.AVG = rollmean(x=REGULAR.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(OT.HOURS.10.DAY.MVG.AVG = rollmean(x=OT.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(EMPS.TEMPS.ON.HAND.10.DAY.MVG.AVG = rollmean(x=EMPS.TEMPS.ON.HAND, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(TRUCKS.KC.TOTAL.10.DAY.MVG.AVG = rollmean(x=TRUCKS.KC.TOTAL, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(COMPLETION.TIME.10.DAY.MVG.AVG = rollmean(x=COMPLETION.TIME, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(RETURNS.CASES.10.DAY.MVG.AVG = rollmean(x=RETURNS.CASES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(C.100.CASES.10.DAY.MVG.AVG = rollmean(x=C.100.CASES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(C.100.HOURS.10.DAY.MVG.AVG = rollmean(x=C.100.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(C.100.CPMH.10.DAY.MVG.AVG = rollmean(x=C.100.CPMH, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(C.200.CASES.10.DAY.MVG.AVG = rollmean(x=C.200.CASES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(C.200.HOURS.10.DAY.MVG.AVG = rollmean(x=C.200.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(C.200.CPMH.10.DAY.MVG.AVG = rollmean(x=C.200.CPMH, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(C.300.400.CASES.10.DAY.MVG.AVG = rollmean(x=C.300.400.CASES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(C.300.400.HOURS.10.DAY.MVG.AVG = rollmean(x=C.300.400.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(C.300.400.CPMH.10.DAY.MVG.AVG = rollmean(x=C.300.400.CPMH, 10, align='right', fill=NA))
  

  m = m %>% group_by(YEAR) %>%
    mutate(W.CASES.10.DAY.MVG.AVG = rollmean(x=W.CASES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(W.HOURS.10.DAY.MVG.AVG = rollmean(x=W.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(LOADING.HOURS.10.DAY.MVG.AVG = rollmean(x=LOADING.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(NON.CONVEYABLE.10.DAY.MVG.AVG = rollmean(x=NON.CONVEYABLE, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(PALLET.PICKS.10.DAY.MVG.AVG = rollmean(x=PALLET.PICKS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(SORTER.RUN.TIME.HOURS.10.DAY.MVG.AVG = rollmean(x=SORTER.RUN.TIME.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(NO.READS.10.DAY.MVG.AVG = rollmean(x=NO.READS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(MULTI.READS.10.DAY.MVG.AVG = rollmean(x=MULTI.READS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(JACKPOT.CASES.10.DAY.MVG.AVG = rollmean(x=JACKPOT.CASES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(JACKPOT.HAND.SCAN.10.DAY.MVG.AVG = rollmean(x=JACKPOT.HAND.SCAN, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(NUMBER.ID.GROUPS.10.DAY.MVG.AVG = rollmean(x=NO.ID.GROUPS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(NUMBER.WAVES.10.DAY.MVG.AVG = rollmean(x=NUMBER.WAVES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(ODD.BALL.BOTTLES.10.DAY.MVG.AVG = rollmean(x=ODD.BALL.BOTTLES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(ODD.BALL.BOTTLE.HOURS.10.DAY.MVG.AVG = rollmean(x=ODD.BALL.BOTTLE.HOURS, 10, align='right', fill=NA))
  
  m = data.frame(m)
  
  m
}

production_appended = generate_moving_avgs(production_appended)
#production_appended = production_appended[c(1:373),]
tail(production_appended,30)




aggregate_monthly_averages_totals = function(production_appended, report_month='-2') {
  t = production_appended
  
  
  t_melt = melt(t, id=c('MONTH', 'YEAR'))  
  t_melt$value = as.numeric(as.character(t_melt$value))
  
  t_sums = dcast(t_melt, MONTH + YEAR ~ variable, function(x) round(sum(x, na.rm=TRUE), 2))
  
  #   #check
  #   check = t_melt %>% filter(variable=='CASES.TOTAL' & YEAR==2016)
  #   sum(check$value)
  
  colnames(t_sums) = sapply(colnames(t_sums), function(x) paste0('SUM.', x))
  row.names(t_sums) = paste0(as.character(t_sums$SUM.YEAR), sep='-', as.character(t_sums$SUM.MONTH))
  
  t_sums = t_sums[, c('SUM.CASES.TOTAL', 'SUM.BOTTLES', 'SUM.MISPICKS.TOTAL', 
                      'SUM.ERRORS.TOTAL', 'SUM.OVER.SHORT.CASES', 'SUM.OVER.SHORT.B.LINE', 
                      'SUM.HOURS.TOTAL', 'SUM.OT.HOURS', 'SUM.R.ODDBALL.HOURS',
                      'SUM.RETURNS.CASES', 'SUM.R.ODD.BALL')]
  names(t_sums) = c('CASES', 'BOTTLES', 'MISPICKS', 
                    'ERRORS', 'O.S.CASES', 'O.S.BOTTLES', 
                    'MAN.HOURS', 'OVERTIME.HOURS', 'ODD.BALL.HOURS',
                    'CASES.RETURNED', 'ODD.BALL.CASES')
  
  
  t_avgs = dcast(t_melt, MONTH +  YEAR ~ variable, function(x) round(mean(x, na.rm=TRUE), 4))
  colnames(t_avgs) = sapply(colnames(t_avgs), function(x) paste0('AVG.', x))
  row.names(t_avgs) = paste0(as.character(t_avgs$AVG.YEAR), sep='-', as.character(t_avgs$AVG.MONTH))
  
  t_avgs = t_avgs[, c('AVG.CPMH.OT.ADJUSTED', 'AVG.CPMH', 'AVG.CASES.TOTAL', 
                      'AVG.EMPS.TEMPS.ON.HAND', 'AVG.R.ODD.BALL', 'AVG.BOTTLES', 'AVG.R.ODDBALL.HOURS')]
  names(t_avgs) = c('CPMH.OT.ADJ', 'CPMH', 'AVG.CASES', 
                    'AVG.EMPLOYEES.ON.HAND', 'AVG.ODD.BALL.CASES', 'AVG.BOTTLES', 'AVG.ODD.BALL.HOURS')
  
  t_combined = cbind(t_sums, t_avgs)
  order = c('CASES', 'AVG.CASES', 'BOTTLES', 'AVG.BOTTLES', 
            'CPMH', 'CPMH.OT.ADJ', 'MAN.HOURS', 'AVG.EMPLOYEES.ON.HAND',
            'ERRORS', 'MISPICKS' , 'O.S.CASES', 'O.S.BOTTLES', 
            'ODD.BALL.CASES', 'AVG.ODD.BALL.CASES', 'ODD.BALL.HOURS', 'AVG.ODD.BALL.HOURS')
  t_combined = t_combined[, order]
  
  t_combined = t_combined[which(substrRight(row.names(t_combined), 2) %in% report_month), ]
  
  T_combined = data.frame(t(t_combined))
  names(T_combined) = c('EOM.2015', 'EOM.2016')
  
  this = T_combined$EOM.2016
  last = T_combined$EOM.2015
  T_combined$PERCENT.CHANGE = round((this - last) / last, 4)
  T_combined = T_combined[, c(2, 1, 3)]
  
  T_combined
}





print('CHANGE THE MONTH BELOW!!!')
library(lubridate)
last_month = month(Sys.Date()) - 1
this_month_summary = paste0('-', as.character(last_month)); this_month_summary   #'-5'


monthly_summary = aggregate_monthly_averages_totals(production_appended, report_month=this_month_summary)


file_name = 'YTD 2016 Production Summary through September.xlsx'
file_path = paste0('C:/Users/pmwash/Desktop/R_files/Data Output/', file_name)
file_path


jan = aggregate_monthly_averages_totals(production_appended, report_month='-1')
feb = aggregate_monthly_averages_totals(production_appended, report_month='-2')
mar = aggregate_monthly_averages_totals(production_appended, report_month='-3')
apr = aggregate_monthly_averages_totals(production_appended, report_month='-4')
may = aggregate_monthly_averages_totals(production_appended, report_month='-5')
jun = aggregate_monthly_averages_totals(production_appended, report_month='-6')
jul = aggregate_monthly_averages_totals(production_appended, report_month='-7')
aug = aggregate_monthly_averages_totals(production_appended, report_month='-8')
sep = aggregate_monthly_averages_totals(production_appended, report_month='-9')

write.xlsx(jan, file=file_path, sheet='January')
write.xlsx(feb, file=file_path, sheet='February', append=TRUE)
write.xlsx(mar, file=file_path, sheet='March', append=TRUE)
write.xlsx(apr, file=file_path, sheet='April', append=TRUE)
write.xlsx(may, file=file_path, sheet='May', append=TRUE)
write.xlsx(jun, file=file_path, sheet='June', append=TRUE)
write.xlsx(jul, file=file_path, sheet='July', append=TRUE)
write.xlsx(aug, file=file_path, sheet='August', append=TRUE)
write.xlsx(sep, file=file_path, sheet='September', append=TRUE)
write.xlsx(production_appended, file=file_path, sheet='Raw Data', append=TRUE)

# Run VBA



print('Below is for STL moving files')

from = paste0("C:/Users/pmwash/Desktop/R_Files/Data Output/", file_name, sep='')
to = file_path = paste0("M:/Operations Intelligence/Monthly Reports/Production/", file_name, sep='')
moveRenameFile(from, to)

















this_month = month(Sys.Date()) - 1; this_month  # 6

write_plots_to_file = function(production_appended, file_path, this_month=3) {
  setwd('C:/Users/pmwash/Desktop/R_files/Data Output/Plots')
  
  p = production_appended
  p$DATE = as.character(strptime(p$DATE, format='%m/%d/%Y'))
  dotm = as.numeric(as.character(substrRight(p$DATE, 2)))
  p$DOTM = dotm
  p$INDEX = 1:length(p$DATE)
  
  ym = as.character(paste0(p$YEAR, '-', p$MONTH))
  p$YEAR.MONTH = suppressWarnings(factor(ym, levels=ym))
  
  p_this_month = filter(p, MONTH==this_month)
  
  
  
  # Cases by Line
  wb = loadWorkbook(file_path)
  
  image_name = 'Cases_By_Line.png'
  pic = system.file(image_name)
  sheet_name = createSheet(wb, image_name)
  
  jpeg(image_name, width=745, height=1012) 
  
  library(maptools)
  
  x = p[, c('DATE', 'YEAR.MONTH', 'C.100.CASES', 'C.200.CASES', 'C.300.400.CASES', 
            'W.CASES', 'R.ODD.BALL', 'ODD.BALL.BOTTLES')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  l = ggplot(data=melted, aes(x=YEAR.MONTH, y=value, group=variable))
  one = l + geom_point(aes(group=YEAR.MONTH), size=0.1, alpha=0.2) +
    geom_boxplot(aes(group=YEAR.MONTH), alpha=0.5) +
    facet_wrap(~variable, ncol=1, scales='free_y') +
    geom_smooth(aes(group=variable, colour=variable), se=FALSE, size=1.25, alpha=0.5, span=0.2) +
    theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1)) +
    scale_y_continuous(labels=comma) +
    labs(title='Daily Case Production by Case Line', 
         x='Date', y='Cases Produced by Line')
  
  x = p[, c('DATE', 'YEAR.MONTH', 'C.100.HOURS', 'C.200.HOURS', 'C.300.400.HOURS', 
            'W.HOURS', 'R.ODDBALL.HOURS', 'ODD.BALL.BOTTLE.HOURS')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  l = ggplot(data=melted, aes(x=YEAR.MONTH, y=value, group=variable))
  two = l + geom_point(aes(group=YEAR.MONTH), size=0.1, alpha=0.2) +
    geom_boxplot(aes(group=YEAR.MONTH), alpha=0.5) +
    facet_wrap(~variable, ncol=1, scales='free_y') +
    geom_smooth(aes(group=variable, colour=variable), se=FALSE, size=1.25, alpha=0.5, span=0.2) +
    theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1)) +
    scale_y_continuous(labels=comma) +
    labs(title='Daily Production Hours by Case Line', 
         x='Date', y='Production Hours') 
  
  #grid.arrange(one, two, ncol=2)
  
  suppressWarnings(grid.arrange(one, two, ncol=2))
  dev.off()
  
  addPicture(image_name, sheet_name)
  saveWorkbook(wb, file_path)
  
  
  
  
  # Case Production Summary
  wb = loadWorkbook(file_path)
  image_name = 'Case_Production_Summary.png'
  pic = system.file(image_name)
  sheet_name = createSheet(wb, image_name)
  
  jpeg(image_name, width=1004, height=745) #, res=100) #, width=50, height=50, res=300)
  
  x = p[, c('DATE', 'YEAR.MONTH', 'CASES.TOTAL',
            'CASES.KC.10.DAY.MVG.AVG', 
            'CASES.SPRINGFIELD.10.DAY.MVG.AVG', 'CASES.STL.TRANSFER.10.DAY.MVG.AVG',
            'CPMH.10.DAY.MVG.AVG', 'CPMH.OT.ADJUSTED')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  o = ggplot(data=melted, aes(x=YEAR.MONTH, y=value, group=variable))
  o + geom_boxplot(aes(group=YEAR.MONTH, fill=variable), alpha=0.5) +
    facet_wrap(~variable, scales='free_y', ncol=2) +
    geom_smooth(aes(group=variable), se=F, colour='black', span=0.5) + 
    scale_y_continuous(labels=comma) + 
    labs(title='Daily Case Production Summary',
         x="Date") +
    theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) +
    geom_jitter(alpha=0.3, size=0.1)
  
  dev.off()
  addPicture(image_name, sheet_name)
  saveWorkbook(wb, file_path)
  

  
  


  
  
  
  
  
  # Hours Summary
  wb = loadWorkbook(file_path)
  image_name = 'Man_Hours.png'
  pic = system.file(image_name)
  sheet_name = createSheet(wb, image_name)
  
  jpeg(image_name, width=577, height=845) #, res=100) #, width=50, height=50, res=300)
    
  x = p[, c('DATE', 'YEAR.MONTH', 'HOURS.TOTAL.10.DAY.MVG.AVG', 'REGULAR.HOURS.10.DAY.MVG.AVG', 'OT.HOURS.10.DAY.MVG.AVG')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  o = ggplot(data=melted, aes(x=YEAR.MONTH, y=value, group=variable))
  o + geom_boxplot(aes(group=YEAR.MONTH, fill=variable), alpha=0.5) +
    facet_wrap(~variable, scales='free_y', ncol=1) +
    geom_smooth(aes(group=variable), se=F, colour='black',span=0.5) + 
    scale_y_continuous(labels=comma) + 
    labs(title='Daily Man Hours Summary',
         x="Year/Month", y="Man Hours") +
    theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) +
    geom_jitter(alpha=0.3, size=0.1)
  
  dev.off()
  addPicture(image_name, sheet_name)
  saveWorkbook(wb, file_path)
  
  
  
  
  
  # Trucks Summary
  wb = loadWorkbook(file_path)
  image_name = 'Truck_Summary.png'
  pic = system.file(image_name)
  sheet_name = createSheet(wb, image_name)
  
  jpeg(image_name, width=900, height=700) #, res=100) #, width=50, height=50, res=300)
  
  x = p[, c('DATE', 'YEAR.MONTH', 'TRUCKS.KC.TOTAL', 
            'TRUCKS.SPRINGFIELD', 'STOPS.KC.TOTAL', 'STOPS.SPRINGFIELD')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  o = ggplot(data=melted, aes(x=value, group=variable))
  o + geom_density(aes(group=variable, fill=variable), alpha=0.5) +
    facet_wrap(~variable, scales='free', ncol=1) +
    scale_y_continuous(labels=comma) + 
    labs(title='Distribution of Daily Trucks and Stops',
         x="Daily Count of Trucks or Stops") +
    theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) +
    geom_rug(aes(group=variable))
  
  dev.off()
  addPicture(image_name, sheet_name)
  saveWorkbook(wb, file_path)


  
  
  
  # Ops Summary
  wb = loadWorkbook(file_path)
  image_name = 'Ops_Summary.png'
  pic = system.file(image_name)
  sheet_name = createSheet(wb, image_name)
  
  jpeg(image_name, width=1004, height=745) #, res=100) #, width=50, height=50, res=300)
  
  x = p[, c('DATE', 'YEAR.MONTH', 'NUMBER.WAVES', 
            'SORTER.RUN.TIME.HOURS', 'JACKPOT.CASES', 'JACKPOT.HAND.SCAN',
            'NON.CONVEYABLE', 'YTD.NON.CONVEYABLE.CASES',
            'PALLET.PICKS', 'LOADING.HOURS',  
            'MULTI.READS', 'NO.READS')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  o = ggplot(data=melted, aes(x=DATE, y=value, group=variable))
  o = o + geom_point(aes(group=YEAR.MONTH), fill='lightgreen', 
                 size=2, colour='black') +
    facet_wrap(~variable, scales='free_y', ncol=2) +
    geom_smooth(aes(group=variable, colour=variable), se=FALSE) + 
    geom_line(aes(group=variable, colour=variable), alpha=0.3) +
    scale_y_continuous(labels=comma) + 
    labs(title='Operations Summary',
         x="Date") +
    theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) 
  o
  library(plotly)
  #ggplotly(o)
  
  dev.off()
  addPicture(image_name, sheet_name)
  saveWorkbook(wb, file_path)
  
  
  
  
  
  
  
  # Labor Summary
  wb = loadWorkbook(file_path)
  image_name = 'Labor_Summary.png'
  pic = system.file(image_name)
  sheet_name = createSheet(wb, image_name)
  
  jpeg(image_name, width=1004, height=745) #, res=100) #, width=50, height=50, res=300)
  
  x = p[, c('DATE', 'YEAR.MONTH', 'HOURS.TOTAL.10.DAY.MVG.AVG', 'EMPS.TEMPS.ON.HAND.10.DAY.MVG.AVG', 
            'REGULAR.HOURS.10.DAY.MVG.AVG', 'OT.HOURS.10.DAY.MVG.AVG')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  o = ggplot(data=melted, aes(x=YEAR.MONTH, y=value, group=variable))
  o = o + geom_boxplot(aes(group=YEAR.MONTH), fill='lightgreen', 
                 size=.3, colour='black') +
    facet_wrap(~variable, scales='free_y', ncol=2) +
    geom_smooth(aes(group=variable), se=F, colour='black') + 
    geom_line(aes(group=variable, colour=variable), alpha=0.3) +
    scale_y_continuous(labels=comma) + 
    labs(title='Labor Summary',
         x="Date") +
    theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) +
    geom_jitter()
  o
  
  
  dev.off()
  addPicture(image_name, sheet_name)
  saveWorkbook(wb, file_path)
  
  

  
  print('Finished printing plots to file')
}

write_plots_to_file(production_appended, file_path, this_month=this_month)





print('Run VBA to format report')





print('Below is for STL moving files')

from = paste0("C:/Users/pmwash/Desktop/R_Files/Data Output/", file_name, sep='')
# M:\Operations Intelligence\Monthly Reports\Production
to = file_path = paste0("M:/Operations Intelligence/Monthly Reports/Production/", 'kc_', file_name, sep='')
moveRenameFile(from, to)







#write.csv(production, file='C:/Users/pmwash/Desktop/R_files/Data Input/Living Documents/STL Production Report Daily Data Archive.csv')

