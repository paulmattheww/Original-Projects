print('Building recount sheets for KC')

print('Specifying wave')
WAVE = 1
print('Change to M:/Inv2016/Recount Sheets')
setwd("M:/Inv2016/Recount Sheets")
print('Reading in Analysis & DataEntry tab to pass as arguments to build_recount_sheets() function')
analysis = read.xlsx('adapt_to_create_recount_sheets.xlsx', sheetName='Analysis')
entry = read.xlsx('adapt_to_create_recount_sheets.xlsx', sheetName='DataEntry')

build_recount_sheets = function(analysis, entry, wave) {
  print('Did you change the wave number prior to running this script?')
  library(XLConnect)
  library(dplyr)
  print('Creating absolute value of case difference, including bottles (using QPC)')
  analysis$Case.Diff.Incl.Btls = round(abs(analysis$Difference.Ttl.Btls) / analysis$QPC, 2)
  analysis = analysis[,c('Item..', 'description', 'Difference.CASE', 'Difference.COST', 'Wave', 'Case.Diff.Incl.Btls')]
  print('Filtering where differences are >= 3 cases or $300')
  recount_items = analysis %>% filter(abs(Difference.COST) >= 300 | Case.Diff.Incl.Btls >= 3)
  key_recount_items = recount_items[,c('Item..', 'description')]
  names(key_recount_items) = c('Item..', 'Description')
  print('Merging together analysis sheet filtered for 3cs/$300 with location entry sheet')
  recounts = merge(entry, key_recount_items, by='Item..')
  recounts = recounts[,c('Item..', 'QPC', 'bottle_size', 'Desc', 'Vintage', 'Loc', 'Case.Cnt.One', 'Btl.Cnt.One')]
  print('Splitting the dataset by item number for printing')
  recounts_split = split(recounts, recounts$Item..)
  setwd("M:/Inv2016/Recount Sheets")
  print('Printing separate items with locations to a single xlsm workbook')
  lapply(1:length(recounts_split), function(i) write.xlsx(recounts_split[[i]], 
                                                          file='recount_sheets.xlsm',
                                                          sheetName=paste0('Wave_', WAVE, '_Item_', i, '_ID_', names(recounts_split[i])), 
                                                          append=TRUE)) 
  print('Check to make sure that all files sheets were printed')
  print('When done save as... the recount sheets by wave')
  print('Items & their locations that need to be re-counted have been printed to recount_sheets.xlsm')
}

build_recount_sheets(analysis, entry, WAVE)




