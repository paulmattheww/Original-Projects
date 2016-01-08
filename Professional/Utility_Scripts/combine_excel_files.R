dir <- "N:/Daily Report/2015/SEPT"
unite = function(dir) {
  library(XLConnect)
  setwd(dir)
  file_list = list.files(path=dir, pattern="(^[~$])*\\.xlsx$",
                         full.names=TRUE)
  NumFiles = length(file_list)
  for(i in 1:NumFiles){
    production = readWorksheetFromFile(file_list[i], sheet=1,
                                        startCol=4, endCol=5,
                                        startRow=4, endRow=31)
    nightlyHours = readWorksheetFromFile(file_list[i], sheet=1,
                                          startCol=4, endCol=5,
                                          startRow=33, endRow=53)
    names(production) = c('Metric', 'Value')
    names(nightlyHours) = c('Metric', 'Value')
    output = rbind(output, production, nightlyHours)
  }
  output
}
unite(dir)
