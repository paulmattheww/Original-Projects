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
    names(production) = c('Metric', 'Value', 'Date')
    
    nightlyHours = readWorksheetFromFile(file_list[i], sheet=1,
                                          startCol=4, endCol=5,
                                          startRow=33, endRow=53)
    nightlyHours$Date = as.character(strptime(str_extract(as.character(file_list[i]), "(\\d+)-(\\d+)"), "%m-%d"))
    names(nightlyHours) = c('Metric', 'Value', 'Date')
    
    returns <- readWorksheetFromFile(file_list[i], sheet=1,
                                     startCol=1, endCol=2,
                                     startRow=4, endRow=9)
    returns$Date = as.character(strptime(str_extract(as.character(file_list[i]), "(\\d+)-(\\d+)"), "%m-%d"))
    names(returns) = c('Metric', 'Value', 'Date')
    
    overShort <- readWorksheetFromFile(file_list[i], sheet=1,
                                       startCol=1, endCol=2,
                                       startRow=10, endRow=50)
    overShort$Date = as.character(strptime(str_extract(as.character(file_list[i]), "(\\d+)-(\\d+)"), "%m-%d"))
    names(overShort) = c('Metric', 'Value', 'Date')
    
    contechWaves <- readWorksheetFromFile(file_list[i], sheet=1,
                                          startCol=9, endCol=10,
                                          startRow=4, endRow=58)
    contechWaves$Date = as.character(strptime(str_extract(as.character(file_list[i]), "(\\d+)-(\\d+)"), "%m-%d"))
    names(contechWaves) = c('Metric', 'Value', 'Date')
    
    oddballs <- readWorksheetFromFile(file_list[i], sheet=1,
                                      startCol=12, endCol=13,
                                      startRow=18, endRow=26)
    oddballs$Date = as.character(strptime(str_extract(as.character(file_list[i]), "(\\d+)-(\\d+)"), "%m-%d"))
    names(oddballs) = c('Metric', 'Value', 'Date')
    
    temp = data.frame(rbind(production, nightlyHours, returns))
    output = if(!exists("output")){
      output = temp
    } else {
      rbind(output, temp)
    }
  }
  output
}
unite(dir)
