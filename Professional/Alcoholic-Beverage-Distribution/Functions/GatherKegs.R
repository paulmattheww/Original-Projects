print('Define function necessary to compile keg data from Daily Reports summary pages')
gather_kegs = function(file_list) {
  library(XLConnect)
  library(stringr)
  library(tidyr)
  NumFiles = length(file_list)
  for(i in 1:NumFiles){
    kegs = readWorksheetFromFile(file_list[i], sheet=1,
                                       startCol=4, endCol=5,
                                       startRow=7, endRow=7)
    kegs$Date = as.character(strptime(str_extract(as.character(file_list[i]), "(\\d+)-(\\d+)"), "%m-%d"))
    names(kegs) = c('Metric', 'Value', 'Date')
    
    
    temp = data.frame(rbind(kegs))
    output = if(!exists("output")){
      output = temp
    } else {
      rbind(output, temp)
    }
  }
  output
}
