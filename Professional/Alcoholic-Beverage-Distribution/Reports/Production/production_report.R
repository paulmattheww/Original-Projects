
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
            '67_RAW.CASE.ERRORS', '68_RAW.BOTTLE.ERRORS', '149_COMPLETION.TIME:',
            #returns
            '56_STOP.RETURN.COUNT', '57_INVOICE.TOTAL', '54_CASES', 
            '58_EMPTY.BOXES.RETURNED', '55_BOTTLES', 
            
            '76_C.LINE', '77_.O/S', '78_.MISPICK', '33_C.LINE.ERRORS', '125_CPMH.C', 
            '79_D.LINE', '80_.O/S', '81_.MISPICK', '34_D.LINE.ERRORS', '126_CPMH.D',
            '82_E.LINE', '83_.O/S', '84_.MISPICK', '35_E.LINE.ERRORS', '127_CPMH.E',
            '85_F.LINE', '86_.O/S', '87_.MISPICK', '36_F.LINE.ERRORS', '9_F.CASES.', '10_F.HOURS', '128_CPMH.F',
            '88_G.LINE', '89_.O/S', '90_.MISPICK', '37_G.LINE.ERRORS', '11_G.CASES.', '12_G.HOURS', '129_CPMH.G',
            '91_W.LINE', '92_.O/S', '93_.MISPICK', '38_WINE.ERRORS', '13_W.CASES', '14_W.HOURS',
            '94_H.', '95_.O/S', '96_.MISPICK', '17_UNKNOWN.CASES.', '18_UNKNOWN.CASES.HOURS',
            '97_KEG', '98_.O/S', '99_.MISPICK', '19_KEGS', '20_KEG.HOURS',
            
            '150_CASES.PER.MAN.HOUR.(OT.ADJUSTED)', '121_CASES.PER.HOUR', 
            '25_LOADING.HRS', '45_RESTOCK.HOURS',
            
            '70_A.LINE', '71_.O/S', '72_.MISPICK', 
            '73_B.LINE', '74_.O/S', '75_.MISPICK', '32_BOTTLE.ERRORS', '21_B.PICK.BOTTLES', 
            '22_B.PICK.HOURS', '44_A-B.RESTOCK.CASES', '124_BPMH.B.BOTTLE',
            '122_BPMH.TOTAL', '123_BPMH.PTV', 
            
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
  
  tidy_data = tidy_data[c(1:142), ] 
  
  row.names(tidy_data) = tidy_data$x
  tidy_data = tidy_data[, (names(tidy_data) != 'x')]
  colnames(tidy_data) = as.character(strptime(substrRight(colnames(tidy_data), 10), format='%Y-%m-%d'))
  
  t_tidy_data = data.frame(t(tidy_data))
  
  final_order = c('CPMH', 'CASES.TOTAL', 'CASES.STL', 'CASES.KC.TRANSFER', 
                  'CASES.COLUMBIA', 'CASES.CAPE', 'CASES.RED.BULL',
                  'BOTTLES.STL.REGION', 'BOTTLES.STL', 'BOTTLES.COLUMBIA', 'BOTTLES.CAPE', 
                  'KEGS.TOTAL.REGION', 
                  
                  'TOTAL.HOURS', 'SENIORITY.HOURS', 'CASUAL.HOURS', 
                  'REG.HOURS', 'SENIORITY.REG.HOURS', 'CASUAL.REG.HOURS',
                  'OT.HOURS', 'SENIORITY.OT.HOURS', 'CASUAL.OT.HOURS', 'TEMP.HOURS', 'DRIVER.CHECK-IN.HOURS',
                  'ABSENT.EMPS', 'SENIORITY.ABSENT.EMPS', 'CASUAL.ABSENT.EMPS',
                  'TOTAL.EMPS.ON.HAND', 'TOTAL.TEMPS.ON.HAND', 'TOTAL.EMPS.TEMPS',
                  
                  'TRUCKS.TOTAL', 'TRUCKS.PACKAGE', 'TRUCKS.KEG', 
                  'STOPS.TOTAL', 'STOPS.STL', 'STOPS.CAPE', 'STOPS.COLUMBIA',
                  
                  'CASE.SHORTS', 'BOTTLE.SHORTS',
                  'TOTAL.ERRORS', 'RAW.CASE.ERRORS', 'RAW.BOTTLE.ERRORS', 
                  'O/S.CASES', 'O/S.BOTTLES' , 'MISPICKS', 'MISPICK.CASES', 'MISPICK.BOTTLES',             
                  'RAW.CASE.ERRORS', 'RAW.BOTTLE.ERRORS', 
                  'COMPLETION.TIME',
                  #returns
                  'RETURNS.X', 
                  'RETURNS.INVOICE.TOTAL', 'RETURNS.CASES', 
                  'RETURNS.BOXES', 'RETURNS.BOTTLES', 
                  
                  'C.LINE.ERRORS', 'C.O/S', 'C.MISPICK', 'C.ERRORS', 'CPMH.C', 
                  'D.LINE.ERRORS', 'D.O/S', 'D.MISPICK', 'D.ERRORS', 'CPMH.D',
                  'E.LINE.ERRORS', 'E.O/S', 'E.MISPICK', 'E.ERRORS', 'CPMH.E',
                  'F.LINE.ERRORS', 'F.O/S', 'F.MISPICK', 'F.ERRORS', 'F.CASES.', 'F.HOURS', 'CPMH.F',
                  'G.LINE.ERRORS', 'G.O/S', 'G.MISPICK', 'G.ERRORS', 'G.CASES.', 'G.HOURS', 'CPMH.G',
                  'W.LINE.ERRORS', 'W.O/S', 'W.MISPICK', 'W.ERRORS', 'W.CASES', 'W.HOURS',
                  'H.LINE.ERRORS', 'H.O/S', 'H.MISPICK', 'UNKNOWN.CASES.', 'UNKNOWN.CASES.HOURS',
                  'KEG.ERRORS', 'KEG.O/S', 'KEG.MISPICK', 'KEGS.PRODUCED', 'KEG.HOURS',
                  
                  'CPMH.OT.ADJUSTED', 'CASES.PER.HOUR', 
                  'LOADING.HOURS', 'RESTOCK.HOURS',
                  
                  'A.LINE.ERRORS', 'A.O/S', 'A.MISPICK', 
                  'B.LINE.ERRORS', 'B.O/S', 'B.MISPICK', 'BOTTLE.ERRORS', 
                  'B.PICK.BOTTLES', 'B.PICK.HOURS', 'A-B.RESTOCK.CASES', 
                  'BPMH.B.BOTTLE','BPMH.TOTAL', 'BPMH.PTV', 
                  
                  'NON.CONVEYABLE.', 'PALLET.PICKS', 'SORTER.RUN.TIME.(HOURS)',
                  'NO.READS', 'MULTI.READS', 'JACKPOT.CASES',
                  'JACKPOT.HAND.SCAN', 'RECIRCULATION.CASES', 'NUMBER.ID.GROUPS',
                  'NUMBER.WAVES', 'WAVE.PART.SUMMARY', 'CONTECH.TOTAL.CASES', 
                  'TOTAL.WAVES', 'TOTAL.WAVE.PARTS', 'AVG.CASES.PER.WAVE',
                  'AVG.CASES/WAVE.PART', 'AVG.WAVE.PARTS/WAVE', '%.REDUCTION.IN.PICK.CYCLES',
                  
                  'TOTAL.ODD.BALL', 'TOTAL.ODD.BALL.HOURS', 'ODD.BALL.ERRORS',
                  'ODD.BALL.CASES.1', 'ODD.BALL.HOURS.1', 
                  'ODD.BALL.CASES.2', 'ODD.BALL.HOURS.2',
                  'ODD.BALL.CASES.3', 'ODD.BALL.HOURS.3',
                  'ODD.BALL.CASES.4', 'ODD.BALL.HOURS.4')
  
  
  xx = as.character(names(t_tidy_data))
  xx = sapply(xx, function(x)gsub('X', '',x))
  ifelse(!(xx %in% order), xx, '')
  
  
  
  names(t_tidy_data) = make.unique(factor(as.character(final_order), levels=final_order))
  t_tidy_data = subset(t_tidy_data, select= c(1:145))
  t_tidy_data = tbl_df(t_tidy_data)
  
  
  #row.names(raw_data) = as.character(strptime(substrRight(rownames(raw_data), 10), format='%Y-%m-%d'))
  
  
  print(t_tidy_data)
}






headTail(check)


headTail(raw_data)




#for figuring it out
x <- data.frame(x=rep(c("red","blue","green"),each=4), y=rep(letters[1:4],3), value.1 = 1:12, value.2 = 13:24)
x %>%
  gather(Var, val, starts_with("value")) %>% 
  unite(Var1,Var, y) 






























