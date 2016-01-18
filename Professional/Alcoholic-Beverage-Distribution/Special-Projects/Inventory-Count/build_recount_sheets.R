print('Filter by wave first since this will be iterated by wave; save wave number as object')
WAVE = 1
setwd("C:/Users/pmwash/Desktop/Projects/Inventory Count 2016")
analysis = read.xlsx('adapt_to_create_recount_sheets.xlsx', sheetName='Analysis')
entry = read.xlsx('adapt_to_create_recount_sheets.xlsx', sheetName='DataEntry')

build_recount_sheets = function(analysis, entry, wave) {
  print('Did you change the wave number prior to running this script?')
  library(xlsx)
  library(dplyr)
  analysis$Case.Diff.Incl.Btls = round(analysis$Difference.Ttl.Btls / analysis$CaseConv, 2)
  analysis = analysis[,c('item_number', 'description', 'Difference.CASE', 'Difference.COST', 'Wave', 'Case.Diff.Incl.Btls')]
  recount_items = analysis %>% filter(Difference.COST >= 300 | Case.Diff.Incl.Btls >= 3)
  key_recount_items = recount_items[,c('item_number', 'description')]
  names(key_recount_items) = c('Item..', 'Description')
  recounts = merge(entry, key_recount_items, by='Item..')
  recounts = recounts[,c('Item..', 'QPC', 'bottle_size', 'Desc', 'Vintage', 'Loc', 'CASE.COUNTED', 'BOTTLES.COUNTED')]
  recounts_split = split(recounts, recounts$Item..)
  setwd("C:/Users/pmwash/Desktop/R_Files/Data Output")
  print('Did you make sure all of the sheets except the formatting template are gone?')
  lapply(1:length(recounts_split), function(i) write.xlsx(recounts_split[[i]], 
                                                          file='recount_sheets.xlsm',
                                                          sheetName=paste0('Wave_', WAVE, '_Item_', i, '_ID_', names(recounts_split[i])), 
                                                          append=TRUE)) 
  print('Check to make sure that all files sheets were printed')
}

build_recount_sheets(analysis, entry, WAVE)
