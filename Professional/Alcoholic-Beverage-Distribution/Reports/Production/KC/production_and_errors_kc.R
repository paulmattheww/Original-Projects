
print('New Production Report 03032016')

print('(1) Open for_vba_production_gather.xlsm in ~/Data Input/Living Documents folder')
print('(2) Open ~/Disposable Documents/~/input_production_report.xlsx and make sure it is clear (keep cols)')
print('(3) Move over daily reports for month at hand AND house at hand')


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
# headTail(raw_data)


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
  
  t_tidy_data = t_tidy_data[,c(117, 1:116)]
  
  t_tidy_data
}

production = tidy_production_data(raw_data)
# headTail(production)

#write.csv(last_year, file='M:/Operations Intelligence/Monthly Reports/Production/Production History/KC Production Report Daily Data Archivex.csv')



append_archive_daily_data = function(production) {
  path = 'M:/Operations Intelligence/Monthly Reports/Production/Production History/KC Production Report Daily Data Archive.csv'
  
  history = read.csv(path, header=TRUE)
  names(history) = names(production)
  appended = rbind(history, production)
  
  write.csv(appended, path)
  
  appended
}


print('Delete first column from output csv document')
production_appended = append_archive_daily_data(production)
# If you must re-read it in without appending duplicates... 
# path = '//majorbrands.com/STLcommon/Operations Intelligence/Monthly Reports/Production/Production History/STL Production Report Daily Data Archive.csv'
# production_appended = read.csv(path, header=TRUE)




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


# good til here so far

generate_moving_avgs = function(production_appended) {
  m = production_appended
  
  m = m %>% group_by(YEAR) %>%
    mutate(CPMH.10.DAY.MVG.AVG = rollmean(x=CPMH, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(CASES.TOTAL.10.DAY.MVG.AVG = rollmean(x=CASES.TOTAL, 10, align='right', fill=NA))
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

monthly_summary = aggregate_monthly_averages_totals(production_appended, report_month='-2')






write_analysis_to_file = function(production_appended, file_path) {
  p = production_appended
  row.names(p) = factor(p$DATE, levels=p$DATE)
  p$DATE = NULL
  
  monthly_summary = aggregate_monthly_averages_totals(p)
  
  write.xlsx(monthly_summary, file=file_path, sheet='Monthly Summary')
  write.xlsx(p, file=file_path, sheet='Raw Data', append=TRUE)
}

file_name = 'production_report_february_2016.xlsx'
file_path = paste0('C:/Users/pmwash/Desktop/R_files/Data Output/', file_name)

write_analysis_to_file(production_appended, file_path)





write_plots_to_file = function(production_appended, file_path, this_month=1) {
  setwd('C:/Users/pmwash/Desktop/R_files/Data Output/Plots')
  
  p = production_appended
  p$DATE = as.Date(strptime(p$DATE, format='%m/%d/%Y'))
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
  
  x = p[, c('DATE', 'YEAR.MONTH', 'C.CASES.10.DAY.MVG.AVG', 'D.CASES.10.DAY.MVG.AVG', 'E.CASES.10.DAY.MVG.AVG', 
            'F.CASES.10.DAY.MVG.AVG', 'G.CASES.10.DAY.MVG.AVG', 'W.CASES.10.DAY.MVG.AVG', 'TOTAL.ODD.BALL.10.DAY.MVG.AVG')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  l = ggplot(data=melted, aes(x=DATE, y=value, group=variable))
  one = l + geom_point(aes(group=YEAR.MONTH), size=0.5) +
    geom_line(aes(group=YEAR.MONTH), size=0.25) +
    facet_wrap(~variable, ncol=1, scales='free_y') +
    geom_smooth(aes(group=variable, colour=variable), se=FALSE) +
    theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1)) +
    scale_y_continuous(labels=comma) +
    labs(title='Case Production by Case Line', 
         x='Date', y='Cases Produced (10 Day Moving Avg)')
  
  x = p[, c('DATE', 'YEAR.MONTH', 'C.HOURS.10.DAY.MVG.AVG', 'D.HOURS.10.DAY.MVG.AVG', 'E.HOURS.10.DAY.MVG.AVG', 
            'F.HOURS.10.DAY.MVG.AVG', 'G.HOURS.10.DAY.MVG.AVG', 'W.HOURS.10.DAY.MVG.AVG', 'TOTAL.ODD.BALL.HOURS.10.DAY.MVG.AVG')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  l = ggplot(data=melted, aes(x=DATE, y=value, group=variable))
  two = l + geom_point(aes(group=YEAR.MONTH), size=0.5) +
    geom_line(aes(group=YEAR.MONTH), size=0.25) +
    facet_wrap(~variable, ncol=1, scales='free_y') +
    geom_smooth(aes(group=variable, colour=variable), se=FALSE) +
    theme(legend.position='none', axis.text.x=element_text(angle=90,hjust=1)) +
    scale_y_continuous(labels=comma) +
    labs(title='Hours Production by Case Line', 
         x='Date', y='Hours (10 Day Moving Avg)')
  
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
  
  x = p[, c('DATE', 'YEAR.MONTH', 'CASES.TOTAL.10.DAY.MVG.AVG', 'CPMH.10.DAY.MVG.AVG',
            'CASES.STL.10.DAY.MVG.AVG', 
            'CASES.COLUMBIA.10.DAY.MVG.AVG', 'CASES.KC.TRANSFER.10.DAY.MVG.AVG',
            'CASES.CAPE.10.DAY.MVG.AVG')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  o = ggplot(data=melted, aes(x=DATE, y=value, group=variable))
  o + geom_point(aes(group=YEAR.MONTH), fill='lightgreen', 
                 size=2, colour='black') +
    facet_wrap(~variable, scales='free_y', ncol=2) +
    geom_smooth(aes(group=variable), se=F, colour='black') + 
    geom_line(aes(group=variable, colour=variable), alpha=0.3) +
    scale_y_continuous(labels=comma) + 
    labs(title='Case Production Summary',
         x="Date") +
    theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) 
  
  dev.off()
  addPicture(image_name, sheet_name)
  saveWorkbook(wb, file_path)
  

  
  


  # Oddball Cs Hrs
  wb = loadWorkbook(file_path)
  image_name = 'Oddball_Cases_Hours.png'
  pic = system.file(image_name)
  sheet_name = createSheet(wb, image_name)
  
  jpeg(image_name, width=800, height=850) 
  
  mean_monthly = mean(p$TOTAL.ODD.BALL, na.rm=TRUE)
  o = ggplot(data=p, aes(x=YEAR.MONTH, y=TOTAL.ODD.BALL, group=YEAR.MONTH))
  one = o + geom_bar(stat='sum', aes(group=YEAR.MONTH), fill='lightblue', 
                     size=1, colour='black') + 
    theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) + 
    geom_smooth(size=1, se=F, aes(group=YEAR.MONTH)) +
    scale_y_continuous(labels=comma) + 
    labs(title='Total Oddball Cases by Month',
         x="Year/Month", y="Total Odd Ball Cases") +
    geom_hline(yintercept=mean_monthly, linetype="longdash") +
    geom_jitter()
  
  fixed = p %>% filter(TOTAL.ODD.BALL.HOURS < 100)
  mean_monthly = mean(fixed$TOTAL.ODD.BALL.HOURS, na.rm=TRUE)
  o = ggplot(data=fixed, aes(x=YEAR.MONTH, y=TOTAL.ODD.BALL.HOURS, group=YEAR.MONTH))
  two = o + geom_bar(stat='sum', aes(group=YEAR.MONTH), fill='lightgreen', 
                     size=1, colour='black') + 
    theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) + 
    geom_smooth(size=1, se=F, aes(group=YEAR.MONTH)) +
    scale_y_continuous(labels=comma) + 
    labs(title='Total Oddball Hours by Month',
         x="Year/Month", y="Total Odd Ball Hours") +
    geom_hline(yintercept=mean_monthly, linetype="longdash") +
    geom_jitter()
  grid.arrange(one, two, ncol=1)
  
  dev.off()
  
  addPicture(image_name, sheet_name)
  saveWorkbook(wb, file_path)
  
  
  
  
  # Hours Summary
  wb = loadWorkbook(file_path)
  image_name = 'Man_Hours.png'
  pic = system.file(image_name)
  sheet_name = createSheet(wb, image_name)
  
  jpeg(image_name, width=577, height=845) #, res=100) #, width=50, height=50, res=300)
    
  x = p[, c('DATE', 'YEAR.MONTH', 'TOTAL.HOURS.10.DAY.MVG.AVG', 'REG.HOURS.10.DAY.MVG.AVG', 'OT.HOURS.10.DAY.MVG.AVG')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  o = ggplot(data=melted, aes(x=DATE, y=value, group=variable))
  o + geom_point(aes(group=YEAR.MONTH), fill='lightgreen', 
                     size=2, colour='black') +
    facet_wrap(~variable, scales='free_y', ncol=1) +
    geom_smooth(aes(group=variable), se=F, colour='black') + 
    geom_line(aes(group=variable, colour=variable)) +
    scale_y_continuous(labels=comma) + 
    labs(title='Man Hours Summary',
         x="Year/Month", y="Man Hours") +
    theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1))
  
  dev.off()
  addPicture(image_name, sheet_name)
  saveWorkbook(wb, file_path)
  
  
  
  
  
  # Trucks Summary
  wb = loadWorkbook(file_path)
  image_name = 'Truck_Summary.png'
  pic = system.file(image_name)
  sheet_name = createSheet(wb, image_name)
  
  jpeg(image_name, width=900, height=700) #, res=100) #, width=50, height=50, res=300)
  
  x = p[, c('DATE', 'YEAR.MONTH', 'TRUCKS.TOTAL.10.DAY.MVG.AVG', 'TRUCKS.PACKAGE.10.DAY.MVG.AVG', 'TRUCKS.KEG.10.DAY.MVG.AVG',
            'STOPS.TOTAL.10.DAY.MVG.AVG')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  o = ggplot(data=melted, aes(x=DATE, y=value, group=variable))
  o + geom_point(aes(group=YEAR.MONTH), fill='lightgreen', 
                 size=2, colour='black') +
    facet_wrap(~variable, scales='free_y', ncol=2) +
    geom_smooth(aes(group=variable), se=F, colour='black') + 
    geom_line(aes(group=variable, colour=variable), alpha=0.3) +
    scale_y_continuous(labels=comma) + 
    labs(title='Trucks Summary',
         x="Date") +
    theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1))
  
  dev.off()
  addPicture(image_name, sheet_name)
  saveWorkbook(wb, file_path)


  
  
  
  # Ops Summary
  wb = loadWorkbook(file_path)
  image_name = 'Ops_Summary.png'
  pic = system.file(image_name)
  sheet_name = createSheet(wb, image_name)
  
  jpeg(image_name, width=1004, height=745) #, res=100) #, width=50, height=50, res=300)
  
  x = p[, c('DATE', 'YEAR.MONTH', 'NUMBER.WAVES.10.DAY.MVG.AVG', 'AVG.CASES.PER.WAVE.10.DAY.MVG.AVG',
            'SORTER.RUN.TIME..HOURS..10.DAY.MVG.AVG', 'JACKPOT.CASES.10.DAY.MVG.AVG',
            'NON.CONVEYABLE.10.DAY.MVG.AVG', 'PALLET.PICKS.10.DAY.MVG.AVG', 
            'LOADING.HOURS.10.DAY.MVG.AVG', 'RECIRCULATION.CASES.10.DAY.MVG.AVG', 
            'MULTI.READS.10.DAY.MVG.AVG', 'NO.READS.10.DAY.MVG.AVG')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  o = ggplot(data=melted, aes(x=DATE, y=value, group=variable))
  o + geom_point(aes(group=YEAR.MONTH), fill='lightgreen', 
                 size=2, colour='black') +
    facet_wrap(~variable, scales='free_y', ncol=2) +
    geom_smooth(aes(group=variable), se=F, colour='black') + 
    geom_line(aes(group=variable, colour=variable), alpha=0.3) +
    scale_y_continuous(labels=comma) + 
    labs(title='Operations Summary',
         x="Date") +
    theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) 
  
  dev.off()
  addPicture(image_name, sheet_name)
  saveWorkbook(wb, file_path)
  
  
  
  
  
  
  
  # Labor Summary
  wb = loadWorkbook(file_path)
  image_name = 'Labor_Summary.png'
  pic = system.file(image_name)
  sheet_name = createSheet(wb, image_name)
  
  jpeg(image_name, width=1004, height=745) #, res=100) #, width=50, height=50, res=300)
  
  x = p[, c('DATE', 'YEAR.MONTH', 'TOTAL.HOURS.10.DAY.MVG.AVG', 'TOTAL.EMPS.TEMPS.10.DAY.MVG.AVG', 
            'REG.HOURS.10.DAY.MVG.AVG', 'OT.HOURS.10.DAY.MVG.AVG')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  o = ggplot(data=melted, aes(x=DATE, y=value, group=variable))
  o + geom_point(aes(group=YEAR.MONTH), fill='lightgreen', 
                 size=2, colour='black') +
    facet_wrap(~variable, scales='free_y', ncol=2) +
    geom_smooth(aes(group=variable), se=F, colour='black') + 
    geom_line(aes(group=variable, colour=variable), alpha=0.3) +
    scale_y_continuous(labels=comma) + 
    labs(title='Labor Summary',
         x="Date") +
    theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) 
  
  dev.off()
  addPicture(image_name, sheet_name)
  saveWorkbook(wb, file_path)
  
  
  
  
  
  # Returns Summary
  wb = loadWorkbook(file_path)
  image_name = 'Returns_Summary.png'
  pic = system.file(image_name)
  sheet_name = createSheet(wb, image_name)
  
  jpeg(image_name, width=875, height=400) 
  
  x = p[, c('DATE', 'YEAR.MONTH', 'RETURNS.INVOICE.TOTAL.10.DAY.MVG.AVG', 'RETURNS.CASES.10.DAY.MVG.AVG')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  o = ggplot(data=melted, aes(x=DATE, y=value, group=variable))
  o + geom_point(aes(group=YEAR.MONTH), fill='lightgreen', 
                 size=2, colour='black') +
    facet_wrap(~variable, scales='free_y', ncol=2) +
    geom_smooth(aes(group=variable), se=F, colour='black') + 
    geom_line(aes(group=variable, colour=variable), alpha=0.3) +
    scale_y_continuous(labels=comma) + 
    labs(title='Returns Summary',
         x="Date") +
    theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) 
  
  dev.off()
  addPicture(image_name, sheet_name)
  saveWorkbook(wb, file_path)
  
  
  
  
  # Oddballs Summary
  wb = loadWorkbook(file_path)
  image_name = 'Oddball_Summary.png'
  pic = system.file(image_name)
  sheet_name = createSheet(wb, image_name)
  
  jpeg(image_name, width=924, height=1012) 
  
  fixed = p %>% filter(TOTAL.ODD.BALL.HOURS < 50 & ODD.BALL.HOURS.1 < 30)
  x = fixed[, c('DATE', 'YEAR.MONTH', 'ODD.BALL.CASES.1', 'ODD.BALL.HOURS.1',
            'ODD.BALL.CASES.2', 'ODD.BALL.HOURS.2',
            'ODD.BALL.CASES.3', 'ODD.BALL.HOURS.3',
            'ODD.BALL.CASES.4', 'ODD.BALL.HOURS.4')]
  melted = melt(x, c('DATE', 'YEAR.MONTH'))
  o = ggplot(data=melted, aes(x=DATE, y=value, group=variable))
  o + geom_point(aes(group=YEAR.MONTH), fill='lightgreen', 
                 size=2, colour='black') +
    facet_wrap(~variable, scales='free_y', ncol=2) +
    geom_smooth(aes(group=variable), se=F, colour='black') + 
    geom_line(aes(group=variable, colour=variable), alpha=0.3) +
    scale_y_continuous(labels=comma) + 
    labs(title='Oddball Summary',
         x="Date") +
    theme(legend.position="none", axis.text.x=element_text(angle=90,hjust=1)) 
  
  dev.off()
  addPicture(image_name, sheet_name)
  saveWorkbook(wb, file_path)
  
  
  print('Finished printing plots to file')
}

write_plots_to_file(production_appended, file_path, this_month=2)





print('Run VBA to format report')





print('Below is for STL moving files')

from = paste0("C:/Users/pmwash/Desktop/R_Files/Data Output/", file_name, sep='')
to = file_path = paste0("//majorbrands.com/STLcommon/Operations Intelligence/Monthly Reports/Production/", 'stl_', file_name, sep='')
moveRenameFile(from, to)







#write.csv(production, file='C:/Users/pmwash/Desktop/R_files/Data Input/Living Documents/STL Production Report Daily Data Archive.csv')

