dir <- "N:/Daily Report/2015/SEPT"
unite = function(dir) {
  library(XLConnect)
  library(stringr)
  setwd(dir)
  file_list = list.files(path=dir, pattern="(^[~$])*\\.xlsx$",
                         full.names=TRUE)
  NumFiles = length(file_list)
  for(i in 1:NumFiles){
    production = readWorksheetFromFile(file_list[i], sheet=1,
                                        startCol=4, endCol=5,
                                        startRow=4, endRow=31)
    production$Date = as.character(strptime(str_extract(as.character(file_list[i]), "(\\d+)-(\\d+)"), "%m-%d"))
    nightlyHours = readWorksheetFromFile(file_list[i], sheet=1,
                                          startCol=4, endCol=5,
                                          startRow=33, endRow=53)
    nightlyHours$Date = as.character(strptime(str_extract(as.character(file_list[i]), "(\\d+)-(\\d+)"), "%m-%d"))
    names(production) = c('Metric', 'Value', 'Date')
    names(nightlyHours) = c('Metric', 'Value', 'Date')
    temp = data.frame(rbind(production, nightlyHours))
    output = if(!exists("output")){
      output = temp
    } else {
      rbind(output, temp)
    }
  }
  output
}
unite(dir)
