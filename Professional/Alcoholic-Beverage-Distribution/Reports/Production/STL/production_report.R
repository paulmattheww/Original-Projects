
print('New Production Report 02242016')


print('Gather external utilities')
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)
library(zoo)
library(gridExtra)
library(lubridate)
library(reshape2)
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')
raw_data = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/Living Documents/Input Production Report/input_production_report.csv', header=TRUE)



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
  
  order = c('151_CASES.PER.MAN.HOUR', '103_TOTAL.CASES.', '104_.ST.LOUIS', '107_.KC.TRANSFER', '108_.COLUMBIA', '109_.CAPE', '106_.RED.BULL',
            '110_BOTTLES', '111_.ST.LOUIS', '112_.COLUMBIA', '113_.CAPE', '105_.KEGS', 
            
            '132_TOTAL.HOURS', '133_.SENIORITY', '134_.CASUAL', 
            '135_REGULAR.HOURS', '136_.SENIORITY', '137_.CASUAL',
            '138_OT.HOURS', '139_.SENIORITY', '140_.CASUAL', '141_TEMP.HOURS', '142_DRIVER.CHECK-IN.HOURS',
            '143_ABSENT.EMPLOYEES', '144_.SENIORITY', '145_.CASUAL',
            '147_TOTAL.EMPLOYEES.ON.HAND', '146_TOTAL.TEMPS.ON.HAND', '148_TOTAL.EMPLOYEES.WITH.TEMPS',
            '118_TOTAL.STLTRUCKS', '119_.CASE/SPLIT', '120_.KEG/OTHER', 
            '114_TOTAL.STOPS', '115_.ST.LOUIS', '116_.CAPE', '117_.COLUMBIA.(ONLY)',
            
            '40_CASE.SHORTS', '41_BOTTLE.SHORTS',
            '69_TOTAL.ERRORS', '67_RAW.CASE.ERRORS', '68_RAW.BOTTLE.ERRORS', 
            '62_.O/S.CASES', '63_.O/S.BOTTLES' , '64_MISPICK', '65_.CASE', '66_.BOTTLES',             
            #'67_RAW.CASE.ERRORS', '68_RAW.BOTTLE.ERRORS', 
            '149_COMPLETION.TIME:',
            #returns
            '56_STOP.RETURN.COUNT', 
            '57_INVOICE.TOTAL', '54_CASES', 
            '58_EMPTY.BOXES.RETURNED', '55_BOTTLES', 
            
            '76_C.LINE', '77_.O/S', '78_.MISPICK', '33_C.LINE.ERRORS', '3_C.CASES', '4_C.HOURS', 
            '125_CPMH.C', 
            '79_D.LINE', '80_.O/S', '81_.MISPICK', '34_D.LINE.ERRORS',  '5_D.CASES.', '6_D.HOURS',
            '126_CPMH.D',
            '82_E.LINE', '83_.O/S', '84_.MISPICK', '35_E.LINE.ERRORS', '7_E.CASES', '8_E.HOURS',
            '127_CPMH.E',
            '85_F.LINE', '86_.O/S', '87_.MISPICK', '36_F.LINE.ERRORS', '9_F.CASES.', '10_F.HOURS', '128_CPMH.F',
            '88_G.LINE', '89_.O/S', '90_.MISPICK', '37_G.LINE.ERRORS', '11_G.CASES.', '12_G.HOURS', '129_CPMH.G',
            '91_W.LINE', '92_.O/S', '93_.MISPICK', '38_WINE.ERRORS', '13_W.CASES', '14_W.HOURS',
            '94_H.', '95_.O/S', '96_.MISPICK', '17_UNKNOWN.CASES.', '18_UNKNOWN.CASES.HOURS',
            '97_KEG', '98_.O/S', '99_.MISPICK', '19_KEGS', '20_KEG.HOURS',
            
            '150_CASES.PER.MAN.HOUR.(OT.ADJUSTED)', '121_CASES.PER.HOUR', 
            '25_LOADING.HRS', '45_RESTOCK.HOURS.',
            
            '70_A.LINE', '71_.O/S', '72_.MISPICK', 
            '73_B.LINE', '74_.O/S', '75_.MISPICK', '32_BOTTLE.ERRORS', '21_B.PICK.BOTTLES', 
            '22_B.PICK.HOURS', '44_A-B.RESTOCK.CASES', '124_BPMH.B.BOTTLE',
            '122_BPMH.TOTAL', '123_BPMH.PTV', 
            '1_BOTTLE.HOURS', '2_PTV.PICK.HOURS',
            
            '23_NON.CONVEYABLE.', '24_PALLET.PICKS', '26_SORTER.RUN.TIME.(HOURS)',
            '27_NO.READS', '28_MULTI.READS', '29_JACKPOT.CASES',
            '31_JACKPOT.HAND.SCAN', '30_RECIRCULATION.CASES', '42_#.ID.GROUPS',
            '43_#.WAVES', '46_WAVE.PART.SUMMARY', '47_TOTAL.CASES', 
            '48_TOTAL.WAVES', '49_TOTAL.WAVE.PARTS', '50_AVG.CASES.PER.WAVE',
            '51_AVG.CASES/WAVE.PART', '52_AVG.WAVE.PARTS/WAVE', '53_%.REDUCTION.IN.PICK.CYCLES',
            
            '15_TOTAL.ODD.BALL', '16_TOTAL.ODD.BALL.HOURS', '39_ODD.BALL.ERRORS',
            '1_ODD.BALL.CASES.1', '2_ODD.BALL.HOURS.1', 
            '3_ODD.BALL.CASES.2', '4_ODD.BALL.HOURS.2',
            '5_ODD.BALL.CASES.3', '6_ODD.BALL.HOURS.3',
            '7_ODD.BALL.CASES.4', '8_ODD.BALL.CASES.4')
  
  tidy_data = raw_data 
  tidy_data$x = row.names(tidy_data)
  tidy_data$x = factor(row.names(tidy_data), levels=order)
  tidy_data = tidy_data %>% arrange(factor(row.names(raw_data), levels=order)) 
  
  tidy_data = tidy_data[c(1:151), ] 
  
  for_factor = tidy_data$x  #[c(1:143), c('x')]
  row.names(tidy_data) = factor(for_factor, levels=for_factor)
  
  tidy_data = tidy_data[, (names(tidy_data) != 'x')]
  colnames(tidy_data) = as.character(strptime(substrRight(colnames(tidy_data), 10), format='%Y-%m-%d'))
  
  t_tidy_data = data.frame(t(tidy_data))
  
  final_order = c('CPMH', 'CASES.TOTAL', 'CASES.STL', 'CASES.KC.TRANSFER', #
                  'CASES.COLUMBIA', 'CASES.CAPE', 'CASES.RED.BULL',
                  'BOTTLES.STL.REGION', 'BOTTLES.STL', 'BOTTLES.COLUMBIA', 'BOTTLES.CAPE',#
                  'KEGS.TOTAL.REGION',# 
                  
                  'TOTAL.HOURS', 'SENIORITY.HOURS', 'CASUAL.HOURS',# 
                  'REG.HOURS', 'SENIORITY.REG.HOURS', 'CASUAL.REG.HOURS',#
                  'OT.HOURS', 'SENIORITY.OT.HOURS', 'CASUAL.OT.HOURS', 'TEMP.HOURS', 'DRIVER.CHECK-IN.HOURS',#
                  'ABSENT.EMPS', 'SENIORITY.ABSENT.EMPS', 'CASUAL.ABSENT.EMPS',#
                  'TOTAL.EMPS.ON.HAND', 'TOTAL.TEMPS.ON.HAND', 'TOTAL.EMPS.TEMPS',#
                  
                  'TRUCKS.TOTAL', 'TRUCKS.PACKAGE', 'TRUCKS.KEG',# 
                  'STOPS.TOTAL', 'STOPS.STL', 'STOPS.CAPE', 'STOPS.COLUMBIA',#
                  
                  'CASE.SHORTS', 'BOTTLE.SHORTS',#
                  'TOTAL.ERRORS', 'RAW.CASE.ERRORS', 'RAW.BOTTLE.ERRORS',# 
                  'O/S.CASES', 'O/S.BOTTLES' , 'MISPICKS', 'MISPICK.CASES', 'MISPICK.BOTTLES',##             
                  #'RAW.CASE.ERRORS', 'RAW.BOTTLE.ERRORS',# 
                  'COMPLETION.TIME',#
                  
                  'RETURNS.X',# 
                  'RETURNS.INVOICE.TOTAL', 'RETURNS.CASES',# 
                  'RETURNS.BOXES', 'RETURNS.BOTTLES',# 
                  
                  'C.LINE.ERRORS', 'C.O/S', 'C.MISPICK', 'C.ERRORS', 'C.CASES', 'C.HOURS', 'CPMH.C',# 
                  'D.LINE.ERRORS', 'D.O/S', 'D.MISPICK', 'D.ERRORS', 'D.CASES', 'D.HOURS', 'CPMH.D',#
                  'E.LINE.ERRORS', 'E.O/S', 'E.MISPICK', 'E.ERRORS', 'E.CASES', 'E.HOURS', 'CPMH.E',#
                  'F.LINE.ERRORS', 'F.O/S', 'F.MISPICK', 'F.ERRORS', 'F.CASES', 'F.HOURS', 'CPMH.F',#
                  'G.LINE.ERRORS', 'G.O/S', 'G.MISPICK', 'G.ERRORS', 'G.CASES', 'G.HOURS', 'CPMH.G',#
                  'W.LINE.ERRORS', 'W.O/S', 'W.MISPICK', 'W.ERRORS', 'W.CASES', 'W.HOURS',#
                  'H.LINE.ERRORS', 'H.O/S', 'H.MISPICK', 'UNKNOWN.CASES.', 'UNKNOWN.CASES.HOURS',#
                  'KEG.ERRORS', 'KEG.O/S', 'KEG.MISPICK', 'KEGS.PRODUCED', 'KEG.HOURS',#
                  
                  'CPMH.OT.ADJUSTED', 'CASES.PER.HOUR',#
                  'LOADING.HOURS', 'RESTOCK.HOURS',#
                  
                  'A.LINE.ERRORS', 'A.O/S', 'A.MISPICK',# 
                  'B.LINE.ERRORS', 'B.O/S', 'B.MISPICK', 'BOTTLE.ERRORS',# 
                  'B.PICK.BOTTLES', 'B.PICK.HOURS', 'A-B.RESTOCK.CASES',# 
                  'BPMH.B.BOTTLE','BPMH.TOTAL', 'BPMH.PTV',#
                  'BOTTLE.HOURS', 'P2V.PICK.HOURS',
                  
                  'NON.CONVEYABLE', 'PALLET.PICKS', 'SORTER.RUN.TIME.(HOURS)',#
                  'NO.READS', 'MULTI.READS', 'JACKPOT.CASES',#
                  'JACKPOT.HAND.SCAN', 'RECIRCULATION.CASES', 'NUMBER.ID.GROUPS',#
                  'NUMBER.WAVES', 'WAVE.PART.SUMMARY', 'CONTECH.TOTAL.CASES',# 
                  'TOTAL.WAVES', 'TOTAL.WAVE.PARTS', 'AVG.CASES.PER.WAVE',#
                  'AVG.CASES/WAVE.PART', 'AVG.WAVE.PARTS/WAVE', '%.REDUCTION.IN.PICK.CYCLES',#
                  
                  'TOTAL.ODD.BALL', 'TOTAL.ODD.BALL.HOURS', 'ODD.BALL.ERRORS',#
                  'ODD.BALL.CASES.1', 'ODD.BALL.HOURS.1',#
                  'ODD.BALL.CASES.2', 'ODD.BALL.HOURS.2',#
                  'ODD.BALL.CASES.3', 'ODD.BALL.HOURS.3',#
                  'ODD.BALL.CASES.4', 'ODD.BALL.HOURS.4')#
  
  the_names = factor(final_order, levels=final_order)
  names(t_tidy_data) = factor(final_order, levels=final_order)
  
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
  
  t_tidy_data = t_tidy_data[,c(154, 1:153, 155)]
  
  t_tidy_data
}

production = tidy_production_data(raw_data)
#write.csv(production, file='C:/Users/pmwash/Desktop/R_files/Data Input/Living Documents/STL Production Report Daily Data Archive.csv')


append_archive_daily_data = function(production) {
  path = '//majorbrands.com/STLcommon/Operations Intelligence/Monthly Reports/Production/Production History/STL Production Report Daily Data Archive.csv'
  
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
    mutate(YTD.CASES.STL=cumsum(CASES.STL))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.CASES.KC.TRANSFER=cumsum(CASES.KC.TRANSFER))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.CASES.COLUMBIA=cumsum(CASES.COLUMBIA))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.CASES.CAPE=cumsum(CASES.CAPE))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.BOTTLES.STL.REGION=cumsum(BOTTLES.STL.REGION))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.BOTTLES.STL=cumsum(BOTTLES.STL))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.BOTTLES.COLUMBIA=cumsum(BOTTLES.COLUMBIA))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.BOTTLES.CAPE=cumsum(BOTTLES.CAPE))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.KEGS.TOTAL.REGION=cumsum(KEGS.TOTAL.REGION))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.TOTAL.HOURS=cumsum(TOTAL.HOURS))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.REG.HOURS=cumsum(REG.HOURS))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.OT.HOURS=cumsum(OT.HOURS))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.ABSENT.EMPS=cumsum(ABSENT.EMPS))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.STOPS.TOTAL=cumsum(STOPS.TOTAL))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.STOPS.STL=cumsum(STOPS.STL))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.STOPS.CAPE=cumsum(STOPS.CAPE))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.STOPS.COLUMBIA=cumsum(STOPS.COLUMBIA))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.TOTAL.ERRORS=cumsum(TOTAL.ERRORS))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.RETURNS.INVOICE.TOTAL=cumsum(RETURNS.INVOICE.TOTAL))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.C.CASES=cumsum(C.CASES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.D.CASES=cumsum(D.CASES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.E.CASES=cumsum(E.CASES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.F.CASES=cumsum(F.CASES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.G.CASES=cumsum(G.CASES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.ODD.BALL.CASES=cumsum(TOTAL.ODD.BALL))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.NON.CONVEYABLE.CASES=cumsum(NON.CONVEYABLE))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.PALLET.PICKS.CASES=cumsum(PALLET.PICKS))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.SORTER.RUN.TIME..HOURS.=cumsum(SORTER.RUN.TIME..HOURS.))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.NO.READS=cumsum(NO.READS))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.MULTI.READS=cumsum(MULTI.READS))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.JACKPOT.CASES=cumsum(JACKPOT.CASES))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.JACKPOT.HAND.SCAN=cumsum(JACKPOT.HAND.SCAN))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.NO.READS=cumsum(NO.READS))
  p = p %>% group_by(YEAR) %>% 
    mutate(YTD.RECIRCULATION.CASES=cumsum(RECIRCULATION.CASES))
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
    mutate(CASES.TOTAL.10.DAY.MVG.AVG = rollmean(x=CASES.TOTAL, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(CASES.STL.10.DAY.MVG.AVG = rollmean(x=CASES.STL, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(CASES.KC.TRANSFER.10.DAY.MVG.AVG = rollmean(x=CASES.KC.TRANSFER, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(CASES.COLUMBIA.10.DAY.MVG.AVG = rollmean(x=CASES.COLUMBIA, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(CASES.CAPE.10.DAY.MVG.AVG = rollmean(x=CASES.CAPE, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(BOTTLES.STL.REGION.10.DAY.MVG.AVG = rollmean(x=BOTTLES.STL.REGION, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(KEGS.TOTAL.REGION.10.DAY.MVG.AVG = rollmean(x=KEGS.TOTAL.REGION, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(TOTAL.HOURS.10.DAY.MVG.AVG = rollmean(x=TOTAL.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(REG.HOURS.10.DAY.MVG.AVG = rollmean(x=REG.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(OT.HOURS.10.DAY.MVG.AVG = rollmean(x=OT.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(TOTAL.EMPS.TEMPS.10.DAY.MVG.AVG = rollmean(x=TOTAL.EMPS.TEMPS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(TRUCKS.TOTAL.10.DAY.MVG.AVG = rollmean(x=TRUCKS.TOTAL, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(TRUCKS.PACKAGE.10.DAY.MVG.AVG = rollmean(x=TRUCKS.PACKAGE, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(TRUCKS.KEG.10.DAY.MVG.AVG = rollmean(x=TRUCKS.KEG, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(STOPS.TOTAL.10.DAY.MVG.AVG = rollmean(x=STOPS.TOTAL, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(COMPLETION.TIME.10.DAY.MVG.AVG = rollmean(x=COMPLETION.TIME, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(RETURNS.INVOICE.TOTAL.10.DAY.MVG.AVG = rollmean(x=RETURNS.INVOICE.TOTAL, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(RETURNS.CASES.10.DAY.MVG.AVG = rollmean(x=RETURNS.CASES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(C.CASES.10.DAY.MVG.AVG = rollmean(x=C.CASES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(C.HOURS.10.DAY.MVG.AVG = rollmean(x=C.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(CPMH.C.10.DAY.MVG.AVG = rollmean(x=CPMH.C, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(D.CASES.10.DAY.MVG.AVG = rollmean(x=D.CASES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(D.HOURS.10.DAY.MVG.AVG = rollmean(x=D.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(CPMH.D.10.DAY.MVG.AVG = rollmean(x=CPMH.D, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(E.CASES.10.DAY.MVG.AVG = rollmean(x=E.CASES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(E.HOURS.10.DAY.MVG.AVG = rollmean(x=E.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(CPMH.E.10.DAY.MVG.AVG = rollmean(x=CPMH.E, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(F.CASES.10.DAY.MVG.AVG = rollmean(x=F.CASES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(F.HOURS.10.DAY.MVG.AVG = rollmean(x=F.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(CPMH.F.10.DAY.MVG.AVG = rollmean(x=CPMH.F, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(G.CASES.10.DAY.MVG.AVG = rollmean(x=G.CASES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(G.HOURS.10.DAY.MVG.AVG = rollmean(x=G.HOURS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(CPMH.G.10.DAY.MVG.AVG = rollmean(x=CPMH.G, 10, align='right', fill=NA))
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
    mutate(SORTER.RUN.TIME..HOURS..10.DAY.MVG.AVG = rollmean(x=SORTER.RUN.TIME..HOURS., 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(NO.READS.10.DAY.MVG.AVG = rollmean(x=NO.READS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(MULTI.READS.10.DAY.MVG.AVG = rollmean(x=MULTI.READS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(JACKPOT.CASES.10.DAY.MVG.AVG = rollmean(x=JACKPOT.CASES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(JACKPOT.HAND.SCAN.10.DAY.MVG.AVG = rollmean(x=JACKPOT.HAND.SCAN, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(RECIRCULATION.CASES.10.DAY.MVG.AVG = rollmean(x=RECIRCULATION.CASES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(NUMBER.ID.GROUPS.10.DAY.MVG.AVG = rollmean(x=NUMBER.ID.GROUPS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(NUMBER.WAVES.10.DAY.MVG.AVG = rollmean(x=NUMBER.WAVES, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(TOTAL.WAVE.PARTS.10.DAY.MVG.AVG = rollmean(x=TOTAL.WAVE.PARTS, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(AVG.CASES.PER.WAVE.10.DAY.MVG.AVG = rollmean(x=AVG.CASES.PER.WAVE, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(TOTAL.ODD.BALL.10.DAY.MVG.AVG = rollmean(x=TOTAL.ODD.BALL, 10, align='right', fill=NA))
  m = m %>% group_by(YEAR) %>%
    mutate(TOTAL.ODD.BALL.HOURS.10.DAY.MVG.AVG = rollmean(x=TOTAL.ODD.BALL.HOURS, 10, align='right', fill=NA))
  
  m = data.frame(m)
  
  m
}

production_appended = generate_moving_avgs(production_appended)





aggregate_monthly_averages_totals = function(production_appended, report_month='JANUARY') {
  t = production_appended
  
  
  t_melt = melt(t, id=c('MONTH', 'YEAR'))  
  t_melt$value = as.numeric(t_melt$value)
  
  t_sums = dcast(t_melt, MONTH + YEAR ~ variable, function(x) round(sum(x, na.rm=TRUE), 2))
  
  #   #check
  #   check = t_melt %>% filter(variable=='CASES.TOTAL' & YEAR==2016)
  #   sum(check$value)
  
  colnames(t_sums) = sapply(colnames(t_sums), function(x) paste0('SUM.', x))
  row.names(t_sums) = paste0(as.character(t_sums$SUM.YEAR), sep='-', as.character(t_sums$SUM.MONTH))
  
  t_sums = t_sums[, c('SUM.CASES.TOTAL', 'SUM.BOTTLES.STL.REGION', 'SUM.MISPICKS', 
                      'SUM.TOTAL.ERRORS', 'SUM.O.S.CASES', 'SUM.O.S.BOTTLES', 
                      'SUM.TOTAL.HOURS', 'SUM.OT.HOURS', 'SUM.TOTAL.ODD.BALL.HOURS',
                      'SUM.RETURNS.CASES', 'SUM.TOTAL.ODD.BALL')]
  names(t_sums) = c('CASES', 'BOTTLES', 'MISPICKS', 
                    'ERRORS', 'O.S.CASES', 'O.S.BOTTLES', 
                    'MAN.HOURS', 'OVERTIME.HOURS', 'ODD.BALL.HOURS',
                    'CASES.RETURNED', 'ODD.BALL.CASES')
  
  
  t_avgs = dcast(t_melt, MONTH +  YEAR ~ variable, function(x) round(mean(x, na.rm=TRUE), 4))
  colnames(t_avgs) = sapply(colnames(t_avgs), function(x) paste0('AVG.', x))
  row.names(t_avgs) = paste0(as.character(t_avgs$AVG.YEAR), sep='-', as.character(t_avgs$AVG.MONTH))
  
  t_avgs = t_avgs[, c('AVG.CPMH.OT.ADJUSTED', 'AVG.CPMH', 'AVG.CASES.TOTAL', 
                      'AVG.TOTAL.EMPS.TEMPS', 'AVG.TOTAL.ODD.BALL', 'AVG.BOTTLES.STL.REGION', 'AVG.TOTAL.ODD.BALL.HOURS')]
  names(t_avgs) = c('CPMH.OT.ADJ', 'CPMH', 'AVG.CASES', 
                    'AVG.EMPLOYEES.ON.HAND', 'AVG.ODD.BALL.CASES', 'AVG.BOTTLES', 'AVG.ODD.BALL.HOURS')
  
  t_combined = cbind(t_sums, t_avgs)
  order = c('CASES', 'AVG.CASES', 'BOTTLES', 'AVG.BOTTLES', 
            'CPMH', 'CPMH.OT.ADJ', 'MAN.HOURS', 'AVG.EMPLOYEES.ON.HAND',
            'ERRORS', 'MISPICKS' , 'O.S.CASES', 'O.S.BOTTLES', 
            'ODD.BALL.CASES', 'AVG.ODD.BALL.CASES', 'ODD.BALL.HOURS', 'AVG.ODD.BALL.HOURS')
  t_combined = t_combined[, order]
  
  this_month = '-1'
  t_combined = t_combined[which(substrRight(row.names(t_combined), 2) %in% this_month), ]
  
  T_combined = data.frame(t(t_combined))
  names(T_combined) = c('EOM.2015', 'EOM.2016')
  
  this = T_combined$EOM.2016
  last = T_combined$EOM.2015
  T_combined$PERCENT.CHANGE = round((this - last) / last, 4)
  T_combined = T_combined[, c(2, 1, 3)]
  
  T_combined
}

monthly_summary = aggregate_monthly_averages_totals(production_appended)






write_analysis_to_file = function(production_appended, file_path) {
  p = production_appended
  row.names(p) = factor(p$DATE, levels=p$DATE)
  p$DATE = NULL
  
  monthly_summary = aggregate_monthly_averages_totals(p)
  
  write.xlsx(monthly_summary, file=file_path, sheet='Monthly Summary')
  write.xlsx(p, file=file_path, sheet='Raw Data', append=TRUE)
}

file_name = 'production_report_january_2016.xlsx'
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
  
  jpeg(image_name, width=800, height=1000) 
  
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
  

  
  


  # Oddball Summary
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
         x="Year/Month", y="Total Odd Ball cASES") +
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
  
  print('Finished printing plots to file')
}



print('Below is for STL moving files')

from = paste0("C:/Users/pmwash/Desktop/R_Files/Data Output/", file_name, sep='')
to = file_path = paste0("//majorbrands.com/STLcommon/Operations Intelligence/Monthly Reports/Production/", 'stl_', file_name, sep='')
moveRenameFile(from, to)







#write.csv(production, file='C:/Users/pmwash/Desktop/R_files/Data Input/Living Documents/STL Production Report Daily Data Archive.csv')

