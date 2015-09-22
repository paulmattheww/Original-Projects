
library(xlsx)
library(dplyr)
library(plyr)
library(XLConnect)
library(rJava)
library(useful)










print("THIS PART IS FOR january 2014")
path <- "//majorbrands.com/STLcommon/Daily Report/2014/JAN"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

january1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
january2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
january3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
january4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
january5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
january6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
january7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
january8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
january9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
january10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
january11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
january12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
january13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
january14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
january15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
january16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
january17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)

january2014 <- rbind(january1, january2, january3, 
                      january4, january5, january6, 
                      january7, january8, january9, 
                      january10, january11, january12, 
                      january13, january14, january15, 
                      january16, january17)
january2014 <- filter(january2014, Driver != "Totals:")
january2014$Month.Year <- "01-2014"
#View(january2014)










print("THIS PART IS FOR february 2014")
path <- "//majorbrands.com/STLcommon/Daily Report/2014/FEB"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

february1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
february2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
february3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
february4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
february5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
february6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
february7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
february8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
february9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
february10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
february11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
february12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
february13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
february14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
february15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
february16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)

february2014 <- rbind(february1, february2, february3, 
                   february4, february5, february6, 
                   february7, february8, february9, 
                   february10, february11, february12, 
                   february13, february14, february15, 
                   february16)
february2014 <- filter(february2014, Driver != "Totals:")
february2014$Month.Year <- "02-2014"
#View(february2014)











print("THIS PART IS FOR march 2014")
path <- "//majorbrands.com/STLcommon/Daily Report/2014/MARCH"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

march1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
march2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
march3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
march4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
march5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
march6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
march7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
march8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
march9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
march10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
march11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
march12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
march13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
march14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
march15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
march16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)

march2014 <- rbind(march1, march2, march3, 
                 march4, march5, march6, 
                 march7, march8, march9, 
                 march10, march11, march12, 
                 march13, march14, march15, 
                 march16)
march2014 <- filter(march2014, Driver != "Totals:")
march2014$Month.Year <- "03-2014"
#View(march2014)









print("THIS PART IS FOR april 2014")
path <- "//majorbrands.com/STLcommon/Daily Report/2014/APR"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

april1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
april2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
april3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
april4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
april5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
april6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
april7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
april8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
april9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
april10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
april11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
april12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
april13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
april14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
april15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
april16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
april17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)
april18 <- readWorksheetFromFile(file_list[18], sheet=2, startCol=3)

april2014 <- rbind(april1, april2, april3, 
                 april4, april5, april6, 
                 april7, april8, april9, 
                 april10, april11, april12, 
                 april13, april14, april15, 
                 april16, april17, april18)
april2014 <- filter(april2014, Driver != "Totals:")
april2014$Month.Year <- "04-2014"
#View(april2014)









print("THIS PART IS FOR may 2014")
path <- "//majorbrands.com/STLcommon/Daily Report/2014/MAY"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

may1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
may2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
may3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
may4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
may5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
may6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
may7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
may8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
may9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
may10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
may11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
may12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
may13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
may14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
may15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
may16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
may17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)
may18 <- readWorksheetFromFile(file_list[18], sheet=2, startCol=3)

may2014 <- rbind(may1, may2, may3, 
                  may4, may5, may6, 
                  may7, may8, may9, 
                  may10, may11, may12, 
                  may13, may14, may15, 
                  may16, may17, may18)
may2014 <- filter(may2014, Driver != "Totals:")
may2014$Month.Year <- "05-2014"
#View(may2014)










print("THIS PART IS FOR june 2014")
path <- "//majorbrands.com/STLcommon/Daily Report/2014/JUNE"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

june1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
june2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
june3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
june4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
june5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
june6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
june7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
june8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
june9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
june10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
june11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
june12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
june13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
june14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
june15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
june16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
june17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)

june2014 <- rbind(june1, june2, june3, 
                  june4, june5, june6, 
                  june7, june8, june9, 
                  june10, june11, june12, 
                  june13, june14, june15, 
                  june16, june17)
june2014 <- filter(june2014, Driver != "Totals:")
june2014$Month.Year <- "06-2014"
#View(june2014)









print("THIS PART IS FOR july 2014")
path <- "//majorbrands.com/STLcommon/Daily Report/2014/JULY"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

july1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
july2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
july3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
july4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
july5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
july6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
july7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
july8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
july9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
july10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
july11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
july12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
july13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
july14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
july15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
july16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
july17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)
july18 <- readWorksheetFromFile(file_list[18], sheet=2, startCol=3)

july2014 <- rbind(july1, july2, july3, 
                     july4, july5, july6, 
                     july7, july8, july9, 
                     july10, july11, july12, 
                     july13, july14, july15, 
                     july16, july17, july18)
july2014 <- filter(july2014, Driver != "Totals:")
july2014$Month.Year <- "07-2014"
#View(july2014)









print("THIS PART IS FOR august 2014")
path <- "//majorbrands.com/STLcommon/Daily Report/2014/AUGUST"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

august1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
august2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
august3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
august4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
august5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
august6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
august7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
august8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
august9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
august10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
august11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
august12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
august13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
august14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
august15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
august16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
august17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)

august2014 <- rbind(august1, august2, august3, august4, august5, august6, august7, august8, 
                       august9, august10, august11, august12, august13, august14, august15, august16,
                       august17)
august2014 <- filter(august2014, Driver != "Totals:")
august2014$Month.Year <- "08-2014"
#View(august2014)











print("THIS PART IS FOR september 2014")
path <- "//majorbrands.com/STLcommon/Daily Report/2014/SEPTEMBER"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

september1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
september2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
september3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
september4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
september5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
september6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
september7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
september8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
september9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
september10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
september11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
september12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
september13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
september14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
september15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
september16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
september17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)

september2014 <- rbind(september1, september2, september3, september4, september5, september6, september7, september8, 
                      september9, september10, september11, september12, september13, september14, september15, september16,
                      september17)
september2014 <- filter(september2014, Driver != "Totals:")
september2014$Month.Year <- "09-2014"
#View(september2014)











print("THIS PART IS FOR october 2014")
path <- "//majorbrands.com/STLcommon/Daily Report/2014/OCTOBER"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

october1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
october2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
october3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
october4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
october5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
october6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
october7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
october8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
october9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
october10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
october11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
october12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
october13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
october14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
names(october14) <- names(october13)
october15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
october16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
october17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)
october18 <- readWorksheetFromFile(file_list[18], sheet=2, startCol=3)
october19 <- readWorksheetFromFile(file_list[19], sheet=2, startCol=3)

october2014 <- rbind(october1, october2, october3, 
                     october4, october5, october6, 
                     october7, october8, october9, 
                     october10, october11, october12, 
                     october13, october14, october15, 
                     october16, october17, october18, 
                     october19)
october2014 <- filter(october2014, Driver != "Totals:")
october2014$Month.Year <- "10-2014"
#View(october2014)









print("THIS PART IS FOR november 2014")
path <- "//majorbrands.com/STLcommon/Daily Report/2014/NOVEMBER"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

november1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
november2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
november3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
november4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
november5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
november6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
november7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
november8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
november9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
november10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
november11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
november12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
november13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
november14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
november15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
november16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
november17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)
november18 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
november19 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
november20 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
november21 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)

november2014 <- rbind(november1, november2, november3, november4, november5, november6, november7, november8, 
                      november9, november10, november11, november12, november13, november14, november15, november16,
                      november17, november18, november19, november20, november21)
november2014 <- filter(november2014, Driver != "Totals:")
november2014$Month.Year <- "11-2014"
#View(november2014)












print("THIS PART IS FOR december 2014")
path <- "//majorbrands.com/STLcommon/Daily Report/2014/DECEMBER"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

december1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
december2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
december3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
december4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
december5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
december6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
december7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
december8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
december9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
december10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
december11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
december12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
december13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
december14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
december15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
december16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
december17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)
december18 <- readWorksheetFromFile(file_list[18], sheet=2, startCol=3)
december19 <- readWorksheetFromFile(file_list[19], sheet=2, startCol=3)
december20 <- readWorksheetFromFile(file_list[20], sheet=2, startCol=3)
december21 <- readWorksheetFromFile(file_list[21], sheet=2, startCol=3)

december2014 <- rbind(december1, december2, december3, december4, december5, december6, december7, december8, 
                     december9, december10, december11, december12, december13, december14, december15, december16,
                     december17, december18, december19, december20, december21)
december2014 <- filter(december2014, Driver != "Totals:")
december2014$Month.Year <- "12-2014"
#View(december2014)









print("THIS PART IS FOR january 2015")
path <- "//majorbrands.com/STLcommon/Daily Report/2015/JAN"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

january1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
january2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
january3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
january4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
january5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
january6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
january7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
january8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
january9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
january10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
january11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
january12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
january13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
january14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
january15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
january16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
january17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)

january2015 <- rbind(january1, january2, january3, january4, january5, january6, january7, january8, 
                 january9, january10, january11, january12, january13, january14, january15, january16,
                 january17)
january2015 <- filter(january2015, Driver != "Totals:")
january2015$Month.Year <- "01-2015"
#View(january2015)







print("THIS PART IS FOR february 2015")
path <- "//majorbrands.com/STLcommon/Daily Report/2015/FEB"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

february1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
february2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
february3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
february4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
february5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
february6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
february7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
february8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
february9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
february10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
february11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
february12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
february13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
february14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
february15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
february16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)

february2015 <- rbind(february1, february2, february3, february4, february5, february6, february7, february8, 
                 february9, february10, february11, february12, february13, february14, february15, february16)
february2015 <- filter(february2015, Driver != "Totals:")
february2015$Month.Year <- "02-2015"
#View(february2015)









print("THIS PART IS FOR march 2015")
path <- "//majorbrands.com/STLcommon/Daily Report/2015/MAR"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

march1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
march2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
march3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
march4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
march5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
march6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
march7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
march8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
march9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
march10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
march11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
march12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
march13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
march14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
march15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
march16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
march17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)


march2015 <- rbind(march1, march2, march3, march4, march5, march6, march7, march8, 
                  march9, march10, march11, march12, march13, march14, march15, march16,
                  march17)
march2015 <- filter(march2015, Driver != "Totals:")
march2015$Month.Year <- "03-2015"
#View(march2015)







print("THIS PART IS FOR april 2015")
path <- "//majorbrands.com/STLcommon/Daily Report/2015/APRIL"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

april1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
april2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
april3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
april4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
april5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
april6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
april7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
april8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
april9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
april10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
april11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
april12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
april13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
april14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
april15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
april16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
april17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)
april18 <- readWorksheetFromFile(file_list[18], sheet=2, startCol=3)


april2015 <- rbind(april1, april2, april3, april4, april5, april6, april7, april8, 
                 april9, april10, april11, april12, april13, april14, april15, april16,
                 april17, april18)
april2015 <- filter(april2015, Driver != "Totals:")
april2015$Month.Year <- "04-2015"
#View(april2015)







print("THIS PART IS FOR may 2015")
path <- "//majorbrands.com/STLcommon/Daily Report/2015/MAY"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

may1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
may2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
may3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
may4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
may5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
may6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
may7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
may8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
may9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
may10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
may11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
may12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
may13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
may14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
may15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
may16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
may17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)

may2015 <- rbind(may1, may2, may3, may4, may5, may6, may7, may8, 
                  may9, may10, may11, may12, may13, may14, may15, may16,
                  may17)
may2015 <- filter(may2015, Driver != "Totals:")
may2015$Month.Year <- "05-2015"
#View(may2015)





print("THIS PART IS FOR JUNE 2015")
path <- "//majorbrands.com/STLcommon/Daily Report/2015/JUNE"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

june1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
june2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
june3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
june4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
june5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
june6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
june7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
june8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
june9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
june10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
june11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
june12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
june13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
june14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
june15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
june16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
june17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)
june18 <- readWorksheetFromFile(file_list[18], sheet=2, startCol=3)

june2015 <- rbind(june1, june2, june3, june4, june5, june6, june7, june8, 
                  june9, june10, june11, june12, june13, june14, june15, june16,
                  june17, june18)
june2015 <- filter(june2015, Driver != "Totals:")
june2015$Month.Year <- "06-2015"
#View(june2015)






print("THIS PART IS FOR july 2015")
path <- "//majorbrands.com/STLcommon/Daily Report/2015/JULY"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

july1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
july2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
july3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
july4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
july5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
july6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
july7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
july8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
july9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
july10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
july11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
july12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
july13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
july14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
july15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
july16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
july17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)
july18 <- readWorksheetFromFile(file_list[18], sheet=2, startCol=3)
july19 <- readWorksheetFromFile(file_list[19], sheet=2, startCol=3)
july20 <- readWorksheetFromFile(file_list[20], sheet=2, startCol=3)

july2015 <- rbind(july1, july2, july3, july4, july5, july6, july7, july8, 
                  july9, july10, july11, july12, july13, july14, july15, july16,
                  july17, july18, july19, july20)
july2015 <- filter(july2015, Driver != "Totals:")
july2015$Month.Year <- "07-2015"
#View(july2015)





print("THIS PART IS FOR august 2015")
path <- "//majorbrands.com/STLcommon/Daily Report/2015/AUG"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

august1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3)
august2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
august3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
august4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
august5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
august6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
august7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
august8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
august9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
august10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3)
august11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
august12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
august13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
august14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
august15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
august16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)

august2015 <- rbind(august1, august2, august3, august4, august5, 
                    august6, august7, august8, august9, august10, 
                    august11, august12, august13, august14, august15, august16)
august2015 <- filter(august2015, Driver != "Totals:")
august2015$Month.Year <- "08-2015"
#View(august2015)































# Compile files together nnto one data frame --- ADD OTHERS AS TIME GOES ON

productionHistory <- rbind(january2014, february2014, march2014, 
                           april2014, may2014, june2014, 
                           july2014, august2014, september2014, 
                           october2014, november2014, december2014,
                           january2015, february2015, march2015,
                           april2015, may2015, june2015,
                           july2015, august2015)

productionHistory$Driver <- as.factor(productionHistory$Driver)
print("MAKE SURE THERE IS ONE NAME FOR EACH DRIVER/ROUTE")
levels(productionHistory$Driver)

productionHistory$Month.Year <- as.factor(productionHistory$Month.Year)
levels(productionHistory$Month.Year)

productionHistory <- tbl_df(productionHistory)

productionHistory <- productionHistory[,c(42,1:41)]

productionHistory$Driver <- filter(productionHistory, Driver != "0"
                                   | Driver != "COLUMBIA"
                                   | Driver != "COL FLR STOCK"
                                   | Driver != "KC TRANSFER"
                                   | Driver != "KANSAS CITY"
                                   | Driver != "MAJOR BRANDS"
                                   | Driver != "maj'or brands"
                                   | Driver != "MB KEGS"
                                   | Driver != "POS"
                                   | Driver != "POS/EVENT"
                                   | Driver != "PRIORITIES"
                                   | Driver != "PRIORITY"
                                   | Driver != "RED BULL"
                                   | Driver != "SAMPLES"
                                   | Driver != "STL WILL CALL"
                                   | Driver != "St Louis Sales Take"
                                   | Driver != "WILL CALL"
                                   | Driver != "GLOBE"
                                   | Driver != "GLOBE DRUG"
                                   | Driver != "PALLETIZE & STAGE"
                                   | Driver != "SATURDAY"
                                   | Driver != "SCOTTISH GAMES")


productionHistory$Year <- 
  substr(productionHistory$Month.Year, 4, 7)
productionHistory$Month <-
  substr(productionHistory$Month.Year, 0, 2)


View(productionHistory)


setwd("C:/Users/pmwash/Desktop/R_Files")


write.csv(productionHistory, file="ProductionHistory.csv")

write(productionHistory, file="ProductionHistory.txt")



