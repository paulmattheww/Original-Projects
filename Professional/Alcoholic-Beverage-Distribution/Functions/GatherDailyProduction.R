production_summary = function(file_list) {
  library(XLConnect)
  library(stringr)
  library(tidyr)
  library(dplyr)
 
  NumFiles = length(file_list)
  for(i in 1:NumFiles){
    production = readWorksheetFromFile(file_list[i], sheet=2,
                                       startCol=3, endCol=19,
                                       startRow=1, endRow=79)
    production = production %>% filter(TTL.Cs.splt > 0)
    
    production$Date = as.character(strptime(str_extract(as.character(file_list[i]), "(\\d+)-(\\d+)"), "%m-%d"))
    substrRight <- function(x, n){
      substr(x, nchar(x)-n+1, nchar(x))
    }
    production$Date = substrRight(production$Date, 5)
    
    casesPerKeg = 6
    production$Kegs = round(production$TTL.Cs.splt / casesPerKeg, 1)
    
    temp = data.frame(production)
    output = if(!exists("output")){
      output = temp
    } else {
      rbind(output, temp)
    }
  }
  output
}


print('Gather January.')
dir <- "N:/Daily Report/2016/JAN"
setwd(dir)
file_list = list.files(dir)
file_list = file_list[3:9]
jan16 = production_summary(file_list)
