#######################################################################################
######## COMPILE PRODUCTION DATA ######################################################
#######################################################################################
#######################################################################################
######## COMPILE PRODUCTION DATA ######################################################
#######################################################################################
#######################################################################################
######## COMPILE PRODUCTION DATA ######################################################
#######################################################################################
#######################################################################################
######## COMPILE PRODUCTION DATA ######################################################
#######################################################################################
#######################################################################################
######## COMPILE PRODUCTION DATA ######################################################
#######################################################################################
#######################################################################################
######## COMPILE PRODUCTION DATA ######################################################
#######################################################################################
#######################################################################################
######## COMPILE PRODUCTION DATA ######################################################
#######################################################################################
#######################################################################################
######## COMPILE PRODUCTION DATA ######################################################
#######################################################################################
#######################################################################################
######## COMPILE PRODUCTION DATA ######################################################
#######################################################################################
#######################################################################################
######## COMPILE PRODUCTION DATA ######################################################
#######################################################################################
#######################################################################################
######## COMPILE PRODUCTION DATA ######################################################
#######################################################################################
#######################################################################################
######## COMPILE PRODUCTION DATA ######################################################
#######################################################################################
#######################################################################################
######## COMPILE PRODUCTION DATA ######################################################
#######################################################################################
#######################################################################################
######## COMPILE PRODUCTION DATA ######################################################
#######################################################################################






library(xlsx)
library(dplyr)
library(plyr)
library(XLConnect)
library(rJava)
library(useful)



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

january1$DATE <- as.character(strptime(file_list[1], "%m-%d")) 
january2$DATE <- as.character(strptime(file_list[2], "%m-%d")) 
january3$DATE <- as.character(strptime(file_list[3], "%m-%d")) 
january4$DATE <- as.character(strptime(file_list[4], "%m-%d")) 
january5$DATE <- as.character(strptime(file_list[5], "%m-%d")) 
january6$DATE <- as.character(strptime(file_list[6], "%m-%d")) 
january7$DATE <- as.character(strptime(file_list[7], "%m-%d")) 
january8$DATE <- as.character(strptime(file_list[8], "%m-%d")) 
january9$DATE <- as.character(strptime(file_list[9], "%m-%d")) 
january10$DATE <- as.character(strptime(file_list[10], "%m-%d")) 
january11$DATE <- as.character(strptime(file_list[11], "%m-%d")) 
january12$DATE <- as.character(strptime(file_list[12], "%m-%d")) 
january13$DATE <- as.character(strptime(file_list[13], "%m-%d")) 
january14$DATE <- as.character(strptime(file_list[14], "%m-%d")) 
january15$DATE <- as.character(strptime(file_list[15], "%m-%d")) 
january16$DATE <- as.character(strptime(file_list[16], "%m-%d")) 
january17$DATE <- as.character(strptime(file_list[17], "%m-%d")) 

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

february1$DATE <- as.character(strptime(file_list[1], "%m-%d")) 
february2$DATE <- as.character(strptime(file_list[2], "%m-%d")) 
february3$DATE <- as.character(strptime(file_list[3], "%m-%d")) 
february4$DATE <- as.character(strptime(file_list[4], "%m-%d")) 
february5$DATE <- as.character(strptime(file_list[5], "%m-%d")) 
february6$DATE <- as.character(strptime(file_list[6], "%m-%d")) 
february7$DATE <- as.character(strptime(file_list[7], "%m-%d")) 
february8$DATE <- as.character(strptime(file_list[8], "%m-%d")) 
february9$DATE <- as.character(strptime(file_list[9], "%m-%d")) 
february10$DATE <- as.character(strptime(file_list[10], "%m-%d")) 
february11$DATE <- as.character(strptime(file_list[11], "%m-%d")) 
february12$DATE <- as.character(strptime(file_list[12], "%m-%d")) 
february13$DATE <- as.character(strptime(file_list[13], "%m-%d")) 
february14$DATE <- as.character(strptime(file_list[14], "%m-%d")) 
february15$DATE <- as.character(strptime(file_list[15], "%m-%d")) 
february16$DATE <- as.character(strptime(file_list[16], "%m-%d")) 

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

march2$DATE <- as.character(strptime(file_list[2], "%m-%d")) 
march3$DATE <- as.character(strptime(file_list[3], "%m-%d")) 
march4$DATE <- as.character(strptime(file_list[4], "%m-%d")) 
march5$DATE <- as.character(strptime(file_list[5], "%m-%d")) 
march6$DATE <- as.character(strptime(file_list[6], "%m-%d")) 
march7$DATE <- as.character(strptime(file_list[7], "%m-%d")) 
march8$DATE <- as.character(strptime(file_list[8], "%m-%d")) 
march9$DATE <- as.character(strptime(file_list[9], "%m-%d")) 
march10$DATE <- as.character(strptime(file_list[10], "%m-%d")) 
march11$DATE <- as.character(strptime(file_list[11], "%m-%d")) 
march12$DATE <- as.character(strptime(file_list[12], "%m-%d")) 
march13$DATE <- as.character(strptime(file_list[13], "%m-%d")) 
march14$DATE <- as.character(strptime(file_list[14], "%m-%d")) 
march15$DATE <- as.character(strptime(file_list[15], "%m-%d")) 
march16$DATE <- as.character(strptime(file_list[16], "%m-%d")) 
march17$DATE <- as.character(strptime(file_list[17], "%m-%d")) 

march2015 <- rbind(march2, march3, march4, march5, march6, march7, march8, 
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

april2$DATE <- as.character(strptime(file_list[2], "%m-%d")) 
april3$DATE <- as.character(strptime(file_list[3], "%m-%d")) 
april4$DATE <- as.character(strptime(file_list[4], "%m-%d")) 
april5$DATE <- as.character(strptime(file_list[5], "%m-%d")) 
april6$DATE <- as.character(strptime(file_list[6], "%m-%d")) 
april7$DATE <- as.character(strptime(file_list[7], "%m-%d")) 
april8$DATE <- as.character(strptime(file_list[8], "%m-%d")) 
april9$DATE <- as.character(strptime(file_list[9], "%m-%d")) 
april10$DATE <- as.character(strptime(file_list[10], "%m-%d")) 
april11$DATE <- as.character(strptime(file_list[11], "%m-%d")) 
april12$DATE <- as.character(strptime(file_list[12], "%m-%d")) 
april13$DATE <- as.character(strptime(file_list[13], "%m-%d")) 
april14$DATE <- as.character(strptime(file_list[14], "%m-%d")) 
april15$DATE <- as.character(strptime(file_list[15], "%m-%d")) 
april16$DATE <- as.character(strptime(file_list[16], "%m-%d")) 
april17$DATE <- as.character(strptime(file_list[17], "%m-%d")) 
april18$DATE <- as.character(strptime(file_list[18], "%m-%d")) 


april2015 <- rbind(april2, april3, april4, april5, april6, april7, april8, 
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

may1$DATE <- as.character(strptime(file_list[1], "%m-%d")) 
may2$DATE <- as.character(strptime(file_list[2], "%m-%d")) 
may3$DATE <- as.character(strptime(file_list[3], "%m-%d")) 
may4$DATE <- as.character(strptime(file_list[4], "%m-%d")) 
may5$DATE <- as.character(strptime(file_list[5], "%m-%d")) 
may6$DATE <- as.character(strptime(file_list[6], "%m-%d")) 
may7$DATE <- as.character(strptime(file_list[7], "%m-%d")) 
may8$DATE <- as.character(strptime(file_list[8], "%m-%d")) 
may9$DATE <- as.character(strptime(file_list[9], "%m-%d")) 
may10$DATE <- as.character(strptime(file_list[10], "%m-%d")) 
may11$DATE <- as.character(strptime(file_list[11], "%m-%d")) 
may12$DATE <- as.character(strptime(file_list[12], "%m-%d")) 
may13$DATE <- as.character(strptime(file_list[13], "%m-%d")) 
may14$DATE <- as.character(strptime(file_list[14], "%m-%d")) 
may15$DATE <- as.character(strptime(file_list[15], "%m-%d")) 
may16$DATE <- as.character(strptime(file_list[16], "%m-%d")) 
may17$DATE <- as.character(strptime(file_list[17], "%m-%d")) 

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

june1$DATE <- as.character(strptime(file_list[1], "%m-%d")) 
june2$DATE <- as.character(strptime(file_list[2], "%m-%d")) 
june3$DATE <- as.character(strptime(file_list[3], "%m-%d")) 
june4$DATE <- as.character(strptime(file_list[4], "%m-%d")) 
june5$DATE <- as.character(strptime(file_list[5], "%m-%d")) 
june6$DATE <- as.character(strptime(file_list[6], "%m-%d")) 
june7$DATE <- as.character(strptime(file_list[7], "%m-%d")) 
june8$DATE <- as.character(strptime(file_list[8], "%m-%d")) 
june9$DATE <- as.character(strptime(file_list[9], "%m-%d")) 
june10$DATE <- as.character(strptime(file_list[10], "%m-%d")) 
june11$DATE <- as.character(strptime(file_list[11], "%m-%d")) 
june12$DATE <- as.character(strptime(file_list[12], "%m-%d")) 
june13$DATE <- as.character(strptime(file_list[13], "%m-%d")) 
june14$DATE <- as.character(strptime(file_list[14], "%m-%d")) 
june15$DATE <- as.character(strptime(file_list[15], "%m-%d")) 
june16$DATE <- as.character(strptime(file_list[16], "%m-%d")) 
june17$DATE <- as.character(strptime(file_list[17], "%m-%d")) 
june18$DATE <- as.character(strptime(file_list[18], "%m-%d")) 

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

july1$DATE <- as.character(strptime(file_list[1], "%m-%d")) 
july2$DATE <- as.character(strptime(file_list[2], "%m-%d")) 
july3$DATE <- as.character(strptime(file_list[3], "%m-%d")) 
july4$DATE <- as.character(strptime(file_list[4], "%m-%d")) 
july5$DATE <- as.character(strptime(file_list[5], "%m-%d")) 
july6$DATE <- as.character(strptime(file_list[6], "%m-%d")) 
july7$DATE <- as.character(strptime(file_list[7], "%m-%d")) 
july8$DATE <- as.character(strptime(file_list[8], "%m-%d")) 
july9$DATE <- as.character(strptime(file_list[9], "%m-%d")) 
july10$DATE <- as.character(strptime(file_list[10], "%m-%d")) 
july11$DATE <- as.character(strptime(file_list[11], "%m-%d")) 
july12$DATE <- as.character(strptime(file_list[12], "%m-%d")) 
july13$DATE <- as.character(strptime(file_list[13], "%m-%d")) 
july14$DATE <- as.character(strptime(file_list[14], "%m-%d")) 
july15$DATE <- as.character(strptime(file_list[15], "%m-%d")) 
july16$DATE <- as.character(strptime(file_list[16], "%m-%d")) 
july17$DATE <- as.character(strptime(file_list[17], "%m-%d")) 
july18$DATE <- as.character(strptime(file_list[18], "%m-%d")) 
july19$DATE <- as.character(strptime(file_list[19], "%m-%d")) 
july20$DATE <- as.character(strptime(file_list[20], "%m-%d")) 

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

august1$DATE <- as.character(strptime(file_list[1], "%m-%d")) 
august2$DATE <- as.character(strptime(file_list[2], "%m-%d")) 
august3$DATE <- as.character(strptime(file_list[3], "%m-%d")) 
august4$DATE <- as.character(strptime(file_list[4], "%m-%d")) 
august5$DATE <- as.character(strptime(file_list[5], "%m-%d")) 
august6$DATE <- as.character(strptime(file_list[6], "%m-%d")) 
august7$DATE <- as.character(strptime(file_list[7], "%m-%d")) 
august8$DATE <- as.character(strptime(file_list[8], "%m-%d")) 
august9$DATE <- as.character(strptime(file_list[9], "%m-%d")) 
august10$DATE <- as.character(strptime(file_list[10], "%m-%d")) 
august11$DATE <- as.character(strptime(file_list[11], "%m-%d")) 
august12$DATE <- as.character(strptime(file_list[12], "%m-%d")) 
august13$DATE <- as.character(strptime(file_list[13], "%m-%d")) 
august14$DATE <- as.character(strptime(file_list[14], "%m-%d")) 
august15$DATE <- as.character(strptime(file_list[15], "%m-%d")) 
august16$DATE <- as.character(strptime(file_list[16], "%m-%d")) 


august2015 <- rbind(august1, august2, august3, august4, august5, 
                    august6, august7, august8, august9, august10, 
                    august11, august12, august13, august14, august15, august16)
august2015 <- filter(august2015, Driver != "Totals:")
august2015$Month.Year <- "08-2015"
#View(august2015)






setwd("C:/Users/pmwash/Desktop/R_Files")





# Compile files together spreadsheets one data frame and clean data
production2015 <- rbind(january2015, february2015, march2015,
                           april2015, may2015, june2015,
                           july2015, august2015)

production2015$Month.Year <- as.factor(production2015$Month.Year)
levels(production2015$Month.Year)

production2015 <- production2015[,c(42,1:41)]

production2015$Year <- 
  substr(production2015$Month.Year, 4, 7)
production2015$Month <-
  substr(production2015$Month.Year, 0, 2)


View(production2015)
write.csv(production2015, file="PRODUCTION2015_01-08_DAILYREPORT.csv")


#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################
#######################################################################################
######## COMPILE INORMATION ON HOURS WORKED ###########################################
#######################################################################################

##########################################################
# JANUARY ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# JANUARY ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################

print("COMPILING HOURS WORKED FOR JANUARY")

# Set working directory
path <- "//majorbrands.com/STLcommon/Daily Report/2015/JAN"
setwd(path)
library(XLConnect)
library(plyr)

# Gather file names for january
file_list <- list.files()
file_list
prodDays <- length(file_list)
paste("There will be", prodDays, "iterations for this month.")


#############################
# Gather Casual & Senior hours
file <- file_list[1]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                                   startRow=35, endRow=75, 
                                                   startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January1 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January1$DATE <- 
  as.character(strptime(January1$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January1
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January2 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January2$DATE <- 
  as.character(strptime(January2$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January2
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January3 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January3$DATE <- 
  as.character(strptime(January3$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January3
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January4 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January4$DATE <- 
  as.character(strptime(January4$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January4
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January5 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January5$DATE <- 
  as.character(strptime(January5$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January5
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January6 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January6$DATE <- 
  as.character(strptime(January6$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January6
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January7 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January7$DATE <- 
  as.character(strptime(January7$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January7
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January8 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January8$DATE <- 
  as.character(strptime(January8$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January8
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January9 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January9$DATE <- 
  as.character(strptime(January9$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January9
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January10 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January10$DATE <- 
  as.character(strptime(January10$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January10
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January11 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January11$DATE <- 
  as.character(strptime(January11$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January11
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January12 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January12$DATE <- 
  as.character(strptime(January12$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January12
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January13 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January13$DATE <- 
  as.character(strptime(January13$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January13
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January14 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January14$DATE <- 
  as.character(strptime(January14$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January14
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January15 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January15$DATE <- 
  as.character(strptime(January15$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January15
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January16 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January16$DATE <- 
  as.character(strptime(January16$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January16
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[17]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January17 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January17$DATE <- 
  as.character(strptime(January17$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
January17
##########################################################
##########################################################
##########################################################
##########################################################
paste("There SHOULD be", prodDays, "iterations for this month.")
january <- rbind(January1, January2, January3,
                 January4, January5, January6,
                 January7, January8, January9,
                 January10, January11, January12,
                 January13, January14, January15,
                 January16, January17)
compiled <- rbind(january)
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# february ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# february ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################

print("COMPILING HOURS WORKED FOR february")

# Set working directory
path <- "//majorbrands.com/STLcommon/Daily Report/2015/FEB"
setwd(path)
library(XLConnect)
library(plyr)

# Gather file names for february
file_list <- list.files()
file_list
prodDays <- length(file_list)
paste("There will be", prodDays, "iterations for this month.")


#############################
# Gather Casual & Senior hours
file <- file_list[1]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february1 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february1$DATE <- 
  as.character(strptime(february1$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february1
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february2 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february2$DATE <- 
  as.character(strptime(february2$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february2
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february3 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february3$DATE <- 
  as.character(strptime(february3$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february3
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february4 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february4$DATE <- 
  as.character(strptime(february4$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february4
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february5 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february5$DATE <- 
  as.character(strptime(february5$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february5
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february6 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february6$DATE <- 
  as.character(strptime(february6$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february6
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february7 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february7$DATE <- 
  as.character(strptime(february7$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february7
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february8 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february8$DATE <- 
  as.character(strptime(february8$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february8
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february9 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february9$DATE <- 
  as.character(strptime(february9$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february9
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february10 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february10$DATE <- 
  as.character(strptime(february10$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february10
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february11 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february11$DATE <- 
  as.character(strptime(february11$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february11
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february12 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february12$DATE <- 
  as.character(strptime(february12$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february12
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february13 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february13$DATE <- 
  as.character(strptime(february13$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february13
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february14 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february14$DATE <- 
  as.character(strptime(february14$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february14
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february15 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february15$DATE <- 
  as.character(strptime(february15$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february15
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february16 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february16$DATE <- 
  as.character(strptime(february16$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february16
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[17]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=30, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=35, endRow=75, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february17 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february17$DATE <- 
  as.character(strptime(february17$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
february17
##########################################################
##########################################################
##########################################################
##########################################################
paste("There SHOULD be", prodDays, "iterations for this month.")
february <- rbind(february1, february2, february3,
                 february4, february5, february6,
                 february7, february8, february9,
                 february10, february11, february12,
                 february13, february14, february15,
                 february16)
compiled <- rbind(compiled, february)
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# march ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# march ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################

print("COMPILING HOURS WORKED FOR march")

# Set working directory
path <- "//majorbrands.com/STLcommon/Daily Report/2015/MAR"
setwd(path)
library(XLConnect)
library(plyr)

# Gather file names for march
file_list <- list.files()
file_list
prodDays <- length(file_list)
paste("There will be", prodDays, "iterations for this month.")


#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march2 <- rbind(hoursSeniormarch, hoursCasualmarch)
march2$DATE <- 
  as.character(strptime(march2$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march2
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march3 <- rbind(hoursSeniormarch, hoursCasualmarch)
march3$DATE <- 
  as.character(strptime(march3$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march3
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march4 <- rbind(hoursSeniormarch, hoursCasualmarch)
march4$DATE <- 
  as.character(strptime(march4$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march4
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march5 <- rbind(hoursSeniormarch, hoursCasualmarch)
march5$DATE <- 
  as.character(strptime(march5$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march5
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march6 <- rbind(hoursSeniormarch, hoursCasualmarch)
march6$DATE <- 
  as.character(strptime(march6$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march6
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march7 <- rbind(hoursSeniormarch, hoursCasualmarch)
march7$DATE <- 
  as.character(strptime(march7$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march7
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march8 <- rbind(hoursSeniormarch, hoursCasualmarch)
march8$DATE <- 
  as.character(strptime(march8$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march8
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march9 <- rbind(hoursSeniormarch, hoursCasualmarch)
march9$DATE <- 
  as.character(strptime(march9$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march9
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march10 <- rbind(hoursSeniormarch, hoursCasualmarch)
march10$DATE <- 
  as.character(strptime(march10$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march10
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march11 <- rbind(hoursSeniormarch, hoursCasualmarch)
march11$DATE <- 
  as.character(strptime(march11$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march11
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march12 <- rbind(hoursSeniormarch, hoursCasualmarch)
march12$DATE <- 
  as.character(strptime(march12$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march12
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march13 <- rbind(hoursSeniormarch, hoursCasualmarch)
march13$DATE <- 
  as.character(strptime(march13$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march13
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march14 <- rbind(hoursSeniormarch, hoursCasualmarch)
march14$DATE <- 
  as.character(strptime(march14$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march14
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march15 <- rbind(hoursSeniormarch, hoursCasualmarch)
march15$DATE <- 
  as.character(strptime(march15$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march15
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march16 <- rbind(hoursSeniormarch, hoursCasualmarch)
march16$DATE <- 
  as.character(strptime(march16$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march16
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[17]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=30, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=35, endRow=75, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march17 <- rbind(hoursSeniormarch, hoursCasualmarch)
march17$DATE <- 
  as.character(strptime(march17$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march17
##########################################################
#############################
# Gather Casual & Senior hours
file <- file_list[18]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march18<- rbind(hoursSeniormarch, hoursCasualmarch)
march18$DATE <- 
  as.character(strptime(march18$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march18
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[19]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march19 <- rbind(hoursSeniormarch, hoursCasualmarch)
march19$DATE <- 
  as.character(strptime(march19$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
march19
#############################
##########################################################
##########################################################
##########################################################
paste("There SHOULD be", prodDays, "iterations for this month.")
march <- rbind(march2, march3,
                  march4, march5, march6,
                  march7, march8, march9,
                  march10, march11, march12,
                  march13, march14, march15,
                  march16, march17, march18, march19)
compiled <- rbind(compiled, march)
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# april ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# april ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################

print("COMPILING HOURS WORKED FOR april")

# Set working directory
path <- "//majorbrands.com/STLcommon/Daily Report/2015/APRIL"
setwd(path)
library(XLConnect)
library(plyr)

# Gather file names for april
file_list <- list.files()
file_list
prodDays <- length(file_list)
paste("There will be", prodDays, "iterations for this month.")

#############################
# Gather Casual & Senior hours
file <- file_list[1]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april1 <- rbind(hoursSeniorapril, hoursCasualapril)
april1$DATE <- 
  as.character(strptime(april1$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april1
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april2 <- rbind(hoursSeniorapril, hoursCasualapril)
april2$DATE <- 
  as.character(strptime(april2$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april2
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april3 <- rbind(hoursSeniorapril, hoursCasualapril)
april3$DATE <- 
  as.character(strptime(april3$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april3
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april4 <- rbind(hoursSeniorapril, hoursCasualapril)
april4$DATE <- 
  as.character(strptime(april4$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april4
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april5 <- rbind(hoursSeniorapril, hoursCasualapril)
april5$DATE <- 
  as.character(strptime(april5$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april5
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april6 <- rbind(hoursSeniorapril, hoursCasualapril)
april6$DATE <- 
  as.character(strptime(april6$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april6
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april7 <- rbind(hoursSeniorapril, hoursCasualapril)
april7$DATE <- 
  as.character(strptime(april7$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april7
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april8 <- rbind(hoursSeniorapril, hoursCasualapril)
april8$DATE <- 
  as.character(strptime(april8$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april8
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april9 <- rbind(hoursSeniorapril, hoursCasualapril)
april9$DATE <- 
  as.character(strptime(april9$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april9
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april10 <- rbind(hoursSeniorapril, hoursCasualapril)
april10$DATE <- 
  as.character(strptime(april10$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april10
#############################
#############################
#################################### APRIL 15 EXCLUDED FROM ANALYSIS! #########################
#################################### APRIL 15 EXCLUDED FROM ANALYSIS! #########################
#################################### APRIL 15 EXCLUDED FROM ANALYSIS! #########################
#################################### APRIL 15 EXCLUDED FROM ANALYSIS! #########################
#################################### APRIL 15 EXCLUDED FROM ANALYSIS! #########################
#################################### APRIL 15 EXCLUDED FROM ANALYSIS! #########################
#################################### APRIL 15 EXCLUDED FROM ANALYSIS! #########################
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april12 <- rbind(hoursSeniorapril, hoursCasualapril)
april12$DATE <- 
  as.character(strptime(april12$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april12
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april13 <- rbind(hoursSeniorapril, hoursCasualapril)
april13$DATE <- 
  as.character(strptime(april13$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april13
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april14 <- rbind(hoursSeniorapril, hoursCasualapril)
april14$DATE <- 
  as.character(strptime(april14$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april14
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april15 <- rbind(hoursSeniorapril, hoursCasualapril)
april15$DATE <- 
  as.character(strptime(april15$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april15
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april16 <- rbind(hoursSeniorapril, hoursCasualapril)
april16$DATE <- 
  as.character(strptime(april16$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april16
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[17]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april17 <- rbind(hoursSeniorapril, hoursCasualapril)
april17$DATE <- 
  as.character(strptime(april17$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april17
##########################################################
#############################
# Gather Casual & Senior hours
file <- file_list[18]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april18<- rbind(hoursSeniorapril, hoursCasualapril)
april18$DATE <- 
  as.character(strptime(april18$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april18
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[19]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april19 <- rbind(hoursSeniorapril, hoursCasualapril)
april19$DATE <- 
  as.character(strptime(april19$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
april19
#############################
##########################################################
##########################################################
##########################################################
paste("There SHOULD be", prodDays, "iterations for this month.")
april <- rbind(april1, april2, april3,
               april4, april5, april6,
               april7, april8, april9,
               april10, april11, april12,
               april13, april14, april15,
               april16, april17, april18, april19)
compiled <- rbind(compiled, april)
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# may ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# may ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################

print("COMPILING HOURS WORKED FOR may")

# Set working directory
path <- "//majorbrands.com/STLcommon/Daily Report/2015/MAY"
setwd(path)
library(XLConnect)
library(plyr)

# Gather file names for may
file_list <- list.files()
file_list
prodDays <- length(file_list)
paste("There will be", prodDays, "iterations for this month.")

#############################
# Gather Casual & Senior hours
file <- file_list[1]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may1 <- rbind(hoursSeniormay, hoursCasualmay)
may1$DATE <- 
  as.character(strptime(may1$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may1
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may2 <- rbind(hoursSeniormay, hoursCasualmay)
may2$DATE <- 
  as.character(strptime(may2$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may2
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may3 <- rbind(hoursSeniormay, hoursCasualmay)
may3$DATE <- 
  as.character(strptime(may3$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may3
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may4 <- rbind(hoursSeniormay, hoursCasualmay)
may4$DATE <- 
  as.character(strptime(may4$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may4
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may5 <- rbind(hoursSeniormay, hoursCasualmay)
may5$DATE <- 
  as.character(strptime(may5$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may5
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may6 <- rbind(hoursSeniormay, hoursCasualmay)
may6$DATE <- 
  as.character(strptime(may6$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may6
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may7 <- rbind(hoursSeniormay, hoursCasualmay)
may7$DATE <- 
  as.character(strptime(may7$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may7
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may8 <- rbind(hoursSeniormay, hoursCasualmay)
may8$DATE <- 
  as.character(strptime(may8$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may8
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may9 <- rbind(hoursSeniormay, hoursCasualmay)
may9$DATE <- 
  as.character(strptime(may9$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may9
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may10 <- rbind(hoursSeniormay, hoursCasualmay)
may10$DATE <- 
  as.character(strptime(may10$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may10
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may11 <- rbind(hoursSeniormay, hoursCasualmay)
may11$DATE <- 
  as.character(strptime(may11$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may11
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may12 <- rbind(hoursSeniormay, hoursCasualmay)
may12$DATE <- 
  as.character(strptime(may12$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may12
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may13 <- rbind(hoursSeniormay, hoursCasualmay)
may13$DATE <- 
  as.character(strptime(may13$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may13
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may14 <- rbind(hoursSeniormay, hoursCasualmay)
may14$DATE <- 
  as.character(strptime(may14$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may14
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may15 <- rbind(hoursSeniormay, hoursCasualmay)
may15$DATE <- 
  as.character(strptime(may15$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may15
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may16 <- rbind(hoursSeniormay, hoursCasualmay)
may16$DATE <- 
  as.character(strptime(may16$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may16
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[17]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=30, 
                                          startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=35, endRow=75, 
                                          startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may17 <- rbind(hoursSeniormay, hoursCasualmay)
may17$DATE <- 
  as.character(strptime(may17$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
may17
##########################################################
##########################################################
##########################################################
##########################################################
paste("There SHOULD be", prodDays, "iterations for this month.")
may <- rbind(may1, may2, may3,
               may4, may5, may6,
               may7, may8, may9,
               may10, may11, may12,
               may13, may14, may15,
               may16, may17)
compiled <- rbind(compiled, may)
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# june ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# june ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################

print("COMPILING HOURS WORKED FOR june")

# Set working directory
path <- "//majorbrands.com/STLcommon/Daily Report/2015/JUNE"
setwd(path)
library(XLConnect)
library(plyr)

# Gather file names for june
file_list <- list.files()
file_list
prodDays <- length(file_list)
paste("There will be", prodDays, "iterations for this month.")

#############################
# Gather Casual & Senior hours
file <- file_list[1]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june1 <- rbind(hoursSeniorjune, hoursCasualjune)
june1$DATE <- 
  as.character(strptime(june1$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june1
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june2 <- rbind(hoursSeniorjune, hoursCasualjune)
june2$DATE <- 
  as.character(strptime(june2$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june2
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june3 <- rbind(hoursSeniorjune, hoursCasualjune)
june3$DATE <- 
  as.character(strptime(june3$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june3
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june4 <- rbind(hoursSeniorjune, hoursCasualjune)
june4$DATE <- 
  as.character(strptime(june4$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june4
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june5 <- rbind(hoursSeniorjune, hoursCasualjune)
june5$DATE <- 
  as.character(strptime(june5$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june5
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june6 <- rbind(hoursSeniorjune, hoursCasualjune)
june6$DATE <- 
  as.character(strptime(june6$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june6
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june7 <- rbind(hoursSeniorjune, hoursCasualjune)
june7$DATE <- 
  as.character(strptime(june7$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june7
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june8 <- rbind(hoursSeniorjune, hoursCasualjune)
june8$DATE <- 
  as.character(strptime(june8$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june8
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june9 <- rbind(hoursSeniorjune, hoursCasualjune)
june9$DATE <- 
  as.character(strptime(june9$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june9
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june10 <- rbind(hoursSeniorjune, hoursCasualjune)
june10$DATE <- 
  as.character(strptime(june10$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june10
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june11 <- rbind(hoursSeniorjune, hoursCasualjune)
june11$DATE <- 
  as.character(strptime(june11$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june11
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june12 <- rbind(hoursSeniorjune, hoursCasualjune)
june12$DATE <- 
  as.character(strptime(june12$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june12
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june13 <- rbind(hoursSeniorjune, hoursCasualjune)
june13$DATE <- 
  as.character(strptime(june13$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june13
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june14 <- rbind(hoursSeniorjune, hoursCasualjune)
june14$DATE <- 
  as.character(strptime(june14$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june14
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june15 <- rbind(hoursSeniorjune, hoursCasualjune)
june15$DATE <- 
  as.character(strptime(june15$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june15
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june16 <- rbind(hoursSeniorjune, hoursCasualjune)
june16$DATE <- 
  as.character(strptime(june16$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june16
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[17]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=30, 
                                        startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=35, endRow=75, 
                                        startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june17 <- rbind(hoursSeniorjune, hoursCasualjune)
june17$DATE <- 
  as.character(strptime(june17$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june17
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[18]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june18 <- rbind(hoursSeniorjune, hoursCasualjune)
june18$DATE <- 
  as.character(strptime(june18$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june18
##########################################################
##########################################################
##########################################################
##########################################################
paste("There SHOULD be", prodDays, "iterations for this month.")
june <- rbind(june1, june2, june3,
             june4, june5, june6,
             june7, june8, june9,
             june10, june11, june12,
             june13, june14, june15,
             june16, june17, june18)
compiled <- rbind(compiled, june)
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# july ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# july ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################

print("COMPILING HOURS WORKED FOR july")

# Set working directory
path <- "//majorbrands.com/STLcommon/Daily Report/2015/JULY"
setwd(path)
library(XLConnect)
library(plyr)

# Gather file names for july
file_list <- list.files()
file_list
prodDays <- length(file_list)
paste("There will be", prodDays, "iterations for this month.")

#############################
# Gather Casual & Senior hours
file <- file_list[1]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july1 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july1$DATE <- 
  as.character(strptime(july1$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july1
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july2 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july2$DATE <- 
  as.character(strptime(july2$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july2
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july3 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july3$DATE <- 
  as.character(strptime(july3$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july3
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july4 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july4$DATE <- 
  as.character(strptime(july4$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july4
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july5 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july5$DATE <- 
  as.character(strptime(july5$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july5
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july6 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july6$DATE <- 
  as.character(strptime(july6$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july6
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july7 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july7$DATE <- 
  as.character(strptime(july7$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july7
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july8 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july8$DATE <- 
  as.character(strptime(july8$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july8
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july9 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july9$DATE <- 
  as.character(strptime(july9$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july9
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july10 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july10$DATE <- 
  as.character(strptime(july10$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july10
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july11 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july11$DATE <- 
  as.character(strptime(july11$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july11
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july12 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july12$DATE <- 
  as.character(strptime(july12$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july12
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july13 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july13$DATE <- 
  as.character(strptime(july13$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july13
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july14 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july14$DATE <- 
  as.character(strptime(july14$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july14
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july15 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july15$DATE <- 
  as.character(strptime(july15$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july15
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july16 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july16$DATE <- 
  as.character(strptime(july16$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july16
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[17]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july17 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july17$DATE <- 
  as.character(strptime(july17$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july17
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[18]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july18 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july18$DATE <- 
  as.character(strptime(july18$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july18
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[19]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july19 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july19$DATE <- 
  as.character(strptime(july19$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july19
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[20]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july20 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july20$DATE <- 
  as.character(strptime(july20$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july20
#############################
##########################################################
##########################################################
##########################################################
##########################################################
paste("There SHOULD be", prodDays, "iterations for this month.")
july <- rbind(july1, july2, july3,
              july4, july5, july6,
              july7, july8, july9,
              july10, july11, july12,
              july13, july14, july15,
              july16, july17, july18,
              july19, july20)
compiled <- rbind(compiled, july)
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# august ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# august ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################

print("COMPILING HOURS WORKED FOR august")

# Set working directory
path <- "//majorbrands.com/STLcommon/Daily Report/2015/AUG"
setwd(path)
library(XLConnect)
library(plyr)

# Gather file names for august
file_list <- list.files()
file_list
prodDays <- length(file_list)
paste("There will be", prodDays, "iterations for this month.")

#############################
# Gather Casual & Senior hours
file <- file_list[1]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august1 <- rbind(hoursSenioraugust, hoursCasualaugust)
august1$DATE <- 
  as.character(strptime(august1$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august1
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august2 <- rbind(hoursSenioraugust, hoursCasualaugust)
august2$DATE <- 
  as.character(strptime(august2$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august2
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august3 <- rbind(hoursSenioraugust, hoursCasualaugust)
august3$DATE <- 
  as.character(strptime(august3$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august3
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august4 <- rbind(hoursSenioraugust, hoursCasualaugust)
august4$DATE <- 
  as.character(strptime(august4$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august4
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august5 <- rbind(hoursSenioraugust, hoursCasualaugust)
august5$DATE <- 
  as.character(strptime(august5$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august5
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august6 <- rbind(hoursSenioraugust, hoursCasualaugust)
august6$DATE <- 
  as.character(strptime(august6$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august6
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august7 <- rbind(hoursSenioraugust, hoursCasualaugust)
august7$DATE <- 
  as.character(strptime(august7$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august7
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august8 <- rbind(hoursSenioraugust, hoursCasualaugust)
august8$DATE <- 
  as.character(strptime(august8$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august8
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august9 <- rbind(hoursSenioraugust, hoursCasualaugust)
august9$DATE <- 
  as.character(strptime(august9$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august9
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august10 <- rbind(hoursSenioraugust, hoursCasualaugust)
august10$DATE <- 
  as.character(strptime(august10$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august10
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august11 <- rbind(hoursSenioraugust, hoursCasualaugust)
august11$DATE <- 
  as.character(strptime(august11$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august11
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august12 <- rbind(hoursSenioraugust, hoursCasualaugust)
august12$DATE <- 
  as.character(strptime(august12$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august12
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august13 <- rbind(hoursSenioraugust, hoursCasualaugust)
august13$DATE <- 
  as.character(strptime(august13$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august13
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august14 <- rbind(hoursSenioraugust, hoursCasualaugust)
august14$DATE <- 
  as.character(strptime(august14$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august14
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august15 <- rbind(hoursSenioraugust, hoursCasualaugust)
august15$DATE <- 
  as.character(strptime(august15$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august15
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=30, 
                                         startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=35, endRow=75, 
                                         startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august16 <- rbind(hoursSenioraugust, hoursCasualaugust)
august16$DATE <- 
  as.character(strptime(august16$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august16
#############################
#############################
##########################################################
##########################################################
##########################################################
##########################################################
paste("There SHOULD be", prodDays, "iterations for this month.")
august <- rbind(august1, august2, august3,
              august4, august5, august6,
              august7, august8, august9,
              august10, august11, august12,
              august13, august14, august15,
              august16)
compiled <- rbind(compiled, august)
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################

View(production2015)
View(compiled)

setwd("C:/Users/pmwash/Desktop/R_Files")

write.csv(compiled, "CompiledData_LaborSupportModel.csv")
write.csv(production2015, "Production2015_LaborSupportModel.csv")

####################################################################################################################
####################################################################################################################
############################################################################### AGGREGATE DATA #####################
####################################################################################################################
####################################################################################################################
####################################################################################################################
############################################################################### AGGREGATE DATA #####################
####################################################################################################################
####################################################################################################################
####################################################################################################################
############################################################################### AGGREGATE DATA #####################
####################################################################################################################
####################################################################################################################
####################################################################################################################
############################################################################### AGGREGATE DATA #####################
####################################################################################################################
####################################################################################################################
####################################################################################################################
############################################################################### AGGREGATE DATA #####################
####################################################################################################################
####################################################################################################################
####################################################################################################################
############################################################################### AGGREGATE DATA #####################
####################################################################################################################
####################################################################################################################
####################################################################################################################
############################################################################### AGGREGATE DATA #####################
####################################################################################################################
####################################################################################################################
####################################################################################################################
############################################################################### AGGREGATE DATA #####################
####################################################################################################################
####################################################################################################################
####################################################################################################################
############################################################################### AGGREGATE DATA #####################
####################################################################################################################
####################################################################################################################
####################################################################################################################
############################################################################### AGGREGATE DATA #####################
####################################################################################################################
####################################################################################################################
####################################################################################################################
############################################################################### AGGREGATE DATA #####################
####################################################################################################################
####################################################################################################################
####################################################################################################################
############################################################################### AGGREGATE DATA #####################
####################################################################################################################
####################################################################################################################
####################################################################################################################
############################################################################### AGGREGATE DATA #####################
####################################################################################################################
####################################################################################################################
####################################################################################################################
############################################################################### AGGREGATE DATA #####################
####################################################################################################################


# Aggregate cases by day for 2015
cases2015 <- production2015[,c("DATE","TTL.CS.STL")]
cases2015 <- aggregate(TTL.CS.STL ~ DATE, data=cases2015, FUN=sum)

# Aggregate hours worked  
hours2015 <- aggregate(HRS.WORKED ~ DATE, data=compiled, FUN=sum)

# Aggregate number of employees (using count and length)
employees2015 <- aggregate(as.character(END.TIME) ~ DATE, 
                           data=compiled, FUN=length)

colnames(employees2015) <- c("DATE", "NUMBER.OF.EMPLOYEES")
employees2015$WEEKDAY <- weekdays(as.Date(employees2015$DATE))
facets <- c("Monday", "Tuesday", "Wednesday", "Thursday")
employees2015$WEEKDAY <- factor(employees2015$WEEKDAY, levels=facets)

# Aggregate OT and regular hours 
otHours2015 <- aggregate(O.T.HOURS ~ DATE, data=compiled, FUN=sum)
regHours2015 <- aggregate(REG.TIME ~ DATE, data=compiled, FUN=sum)

# Read in inventory data for 2015 from Marissa A.
inventory2015 <- read.csv("InventoryData.csv", header=TRUE)
date <- inventory2015$Date <- as.Date(inventory2015$Date, format="%m/%d/%Y")
library(lubridate)
inventory2015$Year <- year(date)
inventory2015$Month <- month(date)
inventory2015 <- filter(inventory2015, Year == 2015)
stlInventory <- inventory2015[, c("Date", "Month", "STL.Cases.Total")]
names(stlInventory) <- c("DATE", "MONTH", "CASES.INVENTORY.STL")
stlInventory$WEEKDAY <- weekdays(stlInventory$DATE)
stlInventory <- filter(stlInventory, WEEKDAY != "Friday" |
                         WEEKDAY != "Saturday" | WEEKDAY != "Sunday")
stlInventory <- stlInventory[,c(1, 3)]
stlInventory$DATE <- as.character(stlInventory$DATE)
stlInventory <- filter(stlInventory, CASES.INVENTORY.STL != "#REF" |
                         CASES.INVENTORY.STL != "0")


# Gather data for keg sales from Diver; negative numbers 999 have been backed out
setwd("C:/Users/pmwash/Desktop/R_Files")
beerKegs <- readWorksheetFromFile("Kegs2015.xlsx", sheet=1, startCol=1)
beerKegs$DATE <- as.character(strptime(beerKegs$DATE, "%Y-%m-%d"))
ciderKegs <- readWorksheetFromFile("Kegs2015.xlsx", sheet=2, startCol=1)
ciderKegs$DATE <- as.character(strptime(ciderKegs$DATE, "%Y-%m-%d"))


# Gather data on daily breakage from CABREAKAGE query as400
breakage2015 <- read.csv("2015_breakage.csv", header=TRUE)
breakage2015 <- breakage2015[, c("DATE", "CASES.BROKEN")]
breakage2015$DATE <- as.character(breakage2015$DATE)
breakage2015 <- aggregate(CASES.BROKEN ~ DATE, data=breakage2015, FUN=sum)


# Read in INVENTORY INFLOWS PER DAY data for STL from Tina's; pre-compiled
inflows <- read.csv("STL_InventoryInflows.csv", header=TRUE)
inflows$DATE <- as.character(strptime(inflows$DATE, "%m/%d/%Y"))





##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
######################################### MERGE DATASETS BY DATE #############################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
######################################### MERGE DATASETS BY DATE #############################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
######################################### MERGE DATASETS BY DATE #############################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
######################################### MERGE DATASETS BY DATE #############################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
######################################### MERGE DATASETS BY DATE #############################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
######################################### MERGE DATASETS BY DATE #############################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
######################################### MERGE DATASETS BY DATE #############################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
######################################### MERGE DATASETS BY DATE #############################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
######################################### MERGE DATASETS BY DATE #############################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
######################################### MERGE DATASETS BY DATE #############################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
######################################### MERGE DATASETS BY DATE #############################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
######################################### MERGE DATASETS BY DATE #############################################################

setwd("C:/Users/pmwash/Desktop/R_Files")
#### IN CASE YOU GO ASTRAY, YOUR PAST SELF HAS GOT YOUR BACK, BRO.
#OMEGA <- read.csv("OMEGA_BACKUP.csv", header=TRUE)
####

# Merge these variables by Date
OMEGA <- merge(cases2015, employees2015, by="DATE")
OMEGA <- merge(OMEGA, hours2015, by="DATE")
OMEGA <- merge(OMEGA, otHours2015, by="DATE")
OMEGA <- merge(OMEGA, regHours2015, by="DATE")
OMEGA <- merge(OMEGA, stlInventory, by="DATE") #, all=T)
OMEGA <- merge(OMEGA, beerKegs, by="DATE")
OMEGA <- merge(OMEGA, ciderKegs, by="DATE")
OMEGA <- merge(OMEGA, breakage2015, by="DATE")
OMEGA <- merge(OMEGA, inflows, by="DATE")
View(OMEGA)


# Format Inventory as number
#OMEGA$INVENTORY.STL <- as.numeric(OMEGA$INVENTORY.STL)

# Derive percentage OT 
OMEGA$PERCENT.OT <- OMEGA$O.T.HOURS / (OMEGA$O.T.HOURS + OMEGA$REG.TIME)


  

# Derive months from dates
library(lubridate)
OMEGA$WEEKDAY <- weekdays(as.Date(OMEGA$DATE))
OMEGA$WEEKDAY <- factor(OMEGA$WEEKDAY, levels=c("Monday", "Tuesday",
                                                "Wednesday", "Thursday",
                                                "Friday", "Sunday"))
OMEGA <- filter(OMEGA, OMEGA$WEEKDAY != "Friday" & OMEGA$WEEKDAY != "Sunday")
OMEGA$MONTH <- month(OMEGA$DATE, label=F)
month <- OMEGA$MONTH

# Derive seasons from months
library(lubridate)
OMEGA$SEASON <- ifelse(month==1 | month==2 |month==3, "Winter", 
       ifelse(month==4 | month==5 | month==6, "Spring",
              ifelse(month==7 | month==8 | month==9, "Summer",
                     ifelse(month==10 | month==11 | month==12, "Fall", ""))))


# Extract day of the month, then if >
library(chron)
days <- OMEGA$DAY.OF.MONTH <- as.numeric(days(OMEGA$DATE))

OMEGA$END.OF.MONTH <- ifelse(days > 19, "End of Month", "Not End of Month")


# Derive Hours per employee per day
OMEGA$HOURS.PER.DAY <- OMEGA$HRS.WORKED / OMEGA$NUMBER.OF.EMPLOYEES


# Derive Cases per man hour & cases per employee
OMEGA$CPMH.STL <- OMEGA$TTL.CS.STL / OMEGA$HRS.WORKED
OMEGA$CASES.PER.EMPLOYEE.PER.DAY <- OMEGA$TTL.CS.STL / OMEGA$NUMBER.OF.EMPLOYEES


# Derive inventory per employee
OMEGA$CASES.INVENTORY.PER.EMPLOYEE <- OMEGA$CASES.INVENTORY.STL / OMEGA$NUMBER.OF.EMPLOYEES


# Derive total sold of keg data
OMEGA$TOTAL.KEGS <- OMEGA$BEER.KEGS + OMEGA$CIDER.KEGS
OMEGA$TOTAL.KEG.CASES <- OMEGA$STD.CASES.BEER.KEGS + OMEGA$STD.CASES.CIDER.KEGS
OMEGA$TOTAL.STL.CASES <- OMEGA$TOTAL.KEG.CASES + OMEGA$TTL.CS.STL
OMEGA$ACTUAL.CPMH <- OMEGA$TOTAL.STL.CASES / OMEGA$HRS.WORKED



OMEGA$INVENTORY.STL.PRIOR.DAY <- c(rep(NA,1), head(as.numeric(as.character(OMEGA$CASES.INVENTORY.STL)), -1))
OMEGA$CASES.SOLD.YESTERDAY <- c(rep(NA,1), head(as.character(OMEGA$TOTAL.STL.CASES)), -1)
yest <- OMEGA$CASES.SOLD.YESTERDAY
OMEGA$CASES.SOLD.YESTERDAY <- ifelse(yest == -1, NA, yest)
#OMEGA$CASES.BROKEN.YESTERDAY <- c(rep(NA,1), head(as.character(OMEGA$CASES.BROKEN)), -1)


library(binhf)
OMEGA$CASES.BROKEN.YESTERDAY <- shift(OMEGA$CASES.BROKEN, 1L)
OMEGA$CASES.SOLD.YESTERDAY <- shift(OMEGA$TOTAL.STL.CASES, 1L)




# Derive how many cases were received into inventory
# OHtoday = OHyest + INyest - OUTyest - BRKyest
onHandToday <- as.numeric(as.character(OMEGA$CASES.INVENTORY.STL))
onHandYesterday <- as.numeric(as.character(OMEGA$INVENTORY.STL.PRIOR.DAY))
casesOutYesterday <- as.numeric(as.character(OMEGA$CASES.SOLD.YESTERDAY))
breakageYesterday <- as.numeric(as.character(OMEGA$CASES.BROKEN.YESTERDAY))

inYesterday <- onHandToday + casesOutYesterday + breakageYesterday - onHandYesterday
OMEGA$INVENTORY.INFLOW.NET.RETURNS <- shift(inYesterday, -1L)
OMEGA <- filter(OMEGA, INVENTORY.INFLOW.NET.RETURNS > 0)
OMEGA$NET.CHANGE.INVENTORY <- onHandToday - onHandYesterday


#check work above
inYesterday
ohToday <- onHandYesterday + inYesterday - casesOutYesterday - breakageYesterday#VALIDATED! #INVALIDATED WITH DERICK WHITE

head(OMEGA)




#write.csv(OMEGA, file="OMEGA_BACKUP.csv")
View(OMEGA)

#head(OMEGA)
#names(OMEGA)
#OMEGA <- OMEGA[, -c(32,26,25,23)]

#### IN CASE YOU GO ASTRAY, YOUR PAST SELF HAS GOT YOUR BACK, BRO.
#setwd("C:/Users/pmwash/Desktop/R_Files")
#OMEGA <- read.csv("OMEGA_BACKUP.csv", header=TRUE)
####

  

##############################################################################################################################
##############################################################################################################################
###########################APPENDIX OF GRAPHICS ETC ##########################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
###########################APPENDIX OF GRAPHICS ETC ##########################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
###########################APPENDIX OF GRAPHICS ETC ##########################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
###########################APPENDIX OF GRAPHICS ETC ##########################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
###########################APPENDIX OF GRAPHICS ETC ##########################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
###########################APPENDIX OF GRAPHICS ETC ##########################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
###########################APPENDIX OF GRAPHICS ETC ##########################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
###########################APPENDIX OF GRAPHICS ETC ##########################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
###########################APPENDIX OF GRAPHICS ETC ##########################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################


g <- ggplot(data=OMEGA, aes(x=NUMBER.OF.EMPLOYEES))
g + geom_histogram(binwidth=2, stat="bin")# + facet_wrap(~MONTH)

g <- ggplot(data=OMEGA, aes(x=SEASON, y=NUMBER.OF.EMPLOYEES))
g + geom_boxplot() + facet_wrap(~WEEKDAY, drop=TRUE, nrow=1) +
  theme(axis.text.x=element_text(angle=90, hjust=1)) +
  geom_smooth(aes(group=WEEKDAY))

g <- ggplot(data=OMEGA, aes(x=WEEKDAY, y=NUMBER.OF.EMPLOYEES)) 
g + geom_boxplot() + facet_wrap(~SEASON) +
  scale_x_discrete(limits=c("Monday","Tuesday","Wednesday","Thursday")) 


# 4 facets by weekday of y No of emp and x Ttl cases stl
g <- ggplot(data=OMEGA, aes(x=TTL.CS.STL, y=NUMBER.OF.EMPLOYEES)) 
g + geom_point(size=5, aes(colour=WEEKDAY)) + 
  facet_wrap(~SEASON, ncol=1) + 
  geom_smooth(method="lm", se=FALSE, size=1, 
              aes(group=WEEKDAY, colour=WEEKDAY)) +
  labs(title="Linear Model, Total Night Employees by Total Cases STL",
       x="Total Cases STL", y="Total Number of Employees per Night") +
  theme(legend.position="bottom")




# Look at graph end of month see if pattern exists
g <- ggplot(data=OMEGA, aes(x=DAY.OF.MONTH, y=HRS.WORKED)) 
g + geom_point(size=5, aes(colour=END.OF.MONTH)) + 
  facet_wrap(~SEASON, nrow=1) + 
  geom_smooth(method="lm", se=FALSE, size=1, colour='black',
              aes(group=END.OF.MONTH)) +
  labs(title="Number of Hours Worked by Season & Stage in the Month ",
       x="Day of the Month (1-31)", y="Total Number of Hours WOrked per Night") +
  theme(legend.position="bottom")

##

# Look at same data using season and weekday as facets
g <- ggplot(data=OMEGA, aes(x=DAY.OF.MONTH, y=NUMBER.OF.EMPLOYEES)) 
g + geom_point(size=5, aes(colour=END.OF.MONTH)) + 
  facet_wrap(WEEKDAY~SEASON, ncol=3) + 
  geom_smooth(method="lm", se=FALSE, size=1, colour='black',
              aes(group=END.OF.MONTH)) +
  labs(title="Number of Nightly Employees by Day of the Month, Faceted by Season & Weekday ",
       x="Day of the Month (1-31)", y="Total Number of Employees per Night") +
  theme(legend.position="bottom")


# Look at graph end of month see if pattern exists
g <- ggplot(data=OMEGA, aes(x=TTL.CS.STL, y=NUMBER.OF.EMPLOYEES)) 
g + geom_point(size=5, aes(colour=END.OF.MONTH)) + 
  facet_wrap(~SEASON, nrow=1) + 
  geom_smooth(method="lm", se=FALSE, size=1, 
              aes(group=END.OF.MONTH, colour=END.OF.MONTH)) +
  labs(title="Number of Nightly Employees by Season & Stage in the Month ",
       x="Number of Cases STL", y="Total Number of Employees per Night") +
  theme(legend.position="bottom")

# Hours per Day plot with facets for months, hline added for avg
meanHrsPerDay <- mean(OMEGA$HOURS.PER.DAY, na.rm=TRUE)
g <- ggplot(data=OMEGA, aes(x=DAY.OF.MONTH, y=HOURS.PER.DAY))
g + geom_boxplot(aes(group=MONTH), alpha=0.1, fill="yellow") +
  geom_point() + facet_wrap(~MONTH, nrow=1) + 
  geom_smooth(aes(group=MONTH), colour="black", size=1) +
  geom_hline(aes(yintercept=meanHrsPerDay)) +
  annotate("text", x=15, y=5, label="Avg = 7.84") +
  labs(title="Hours Per Employee Per Night (by Month)", x="Day of the Month", 
       y="Hours Per Day") 
  



# Simple regression nightly hrs worked per day ~ total cases stl
library(plyr)
library(ggthemes)
r2 <- summary(lm(OMEGA$HRS.WORKED ~ OMEGA$TTL.CS.STL))$r.squared
g <- ggplot(data=OMEGA, aes(x=TTL.CS.STL, y=HRS.WORKED))
one <- g + geom_point(aes(colour=ACTUAL.CPMH, size=HRS.WORKED)) + 
  geom_smooth(method="lm", se=F, colour="black") +
  annotate("text", x=16250, y=325, label=paste("R-Squared", round(r2,3))) +
  labs(title="Hours Worked as a function of Total Cases STL",
       x="Total Cases STL", y="Hours Worked Per Night") +
  theme(legend.position='none')
library(plyr)
library(ggthemes)
r2 <- summary(lm(OMEGA$NUMBER.OF.EMPLOYEES ~ OMEGA$TTL.CS.STL))$r.squared
g <- ggplot(data=OMEGA, aes(x=TTL.CS.STL, y=NUMBER.OF.EMPLOYEES))
two <- g + geom_point(aes(colour=ACTUAL.CPMH, size=HRS.WORKED)) + 
  geom_smooth(method="lm", se=F, colour="black") +
  annotate("text", x=16750, y=50, label=paste("R-Squared", round(r2,3))) +
  labs(title="Number of Employees as a function of Total Cases STL",
       x="Total Cases STL", y="Number of Employees") +
  theme(legend.position='none')
library(plyr)
library(ggthemes)
r2 <- summary(lm(OMEGA$HRS.WORKED ~ OMEGA$ACTUAL.CPMH))$r.squared
g <- ggplot(data=OMEGA, aes(x=ACTUAL.CPMH, y=HRS.WORKED))
three <- g + geom_point(aes(colour=ACTUAL.CPMH, size=HRS.WORKED)) + 
  geom_smooth(method="lm", se=F, colour="black") +
  annotate("text", x=35, y=300, label=paste("R-Squared", round(r2,3))) +
  labs(title="Hours Worked as a function of CPMH",
       x="CPMH", y="Hours Worked per Night") +
  theme(legend.position='none')
library(plyr)
library(ggthemes)
r2 <- summary(lm(OMEGA$NUMBER.OF.EMPLOYEES ~ OMEGA$ACTUAL.CPMH))$r.squared
g <- ggplot(data=OMEGA, aes(x=ACTUAL.CPMH, y=NUMBER.OF.EMPLOYEES))
four <- g + geom_point(aes(colour=ACTUAL.CPMH, size=HRS.WORKED)) + 
  geom_smooth(method="lm", se=F, colour="black") +
  annotate("text", x=35, y=50, label=paste("R-Squared", round(r2,3))) +
  labs(title="Number of Employees as a function of CPMH",
       x="CPMH", y="Number of Employees") +
  theme(legend.position='none')
library(gridExtra)
grid.arrange(one, three, two, four, nrow=2, ncol=2)


# CPMH simple linear model as f(total cases stl), size and colour=hrs worked
simpleModel <- lm(OMEGA$ACTUAL.CPMH ~ OMEGA$TOTAL.STL.CASES)
slope <- summary(simpleModel)$coefficients[2]
sd <- summary(simpleModel)$coefficients[4]
r2 <- summary(lm(OMEGA$ACTUAL.CPMH ~ OMEGA$TOTAL.STL.CASES))$r.squared
g <- ggplot(data=OMEGA, aes(x=OMEGA$TOTAL.STL.CASES, y=OMEGA$ACTUAL.CPMH))
g + geom_boxplot(colour="grey", alpha=0.4,
  aes(group=WEEKDAY, fill=WEEKDAY)) +
  geom_point(aes(size=HRS.WORKED, colour=HRS.WORKED)) + 
  geom_smooth(colour="black", method="lm", se=F) + 
  annotate("text", x=16250, y=27.5, 
           label=paste("R-squared =", round(r2,4))) +
  labs(title="CPMH as a function of Total Cases (STL)",
       x="Keg Adjusted Total Cases", y="Adjusted CPMH (for Kegs)") +
  theme(legend.position="bottom") +
  scale_colour_gradient(low="green", high="red") 


# Percent OT hours by weekday and season, boxplot; outliers isolated
library(scales)
g <- ggplot(data=OMEGA, aes(x=factor(SEASON), y=PERCENT.OT))
g + geom_boxplot(aes(group=SEASON, fill=factor(SEASON))) +
  scale_y_continuous(labels=percent) +
  labs(title="Percent Overtime Hrs of Total Hours", x="SEASON",
       y="Percent Overtime Hours of Total Hours") +
  geom_hline(y=.2) + facet_wrap(~WEEKDAY, nrow=1)
daysOver15PercentOT <- filter(OMEGA, PERCENT.OT > .15) 



# P value matrix 
correl <- OMEGA[, c(4:5, 7:10, 13, 15:33)]
correl <- correl[, -c(23,26)]

correl <- round(cor(correl), 2)
names(correl)

cor.mtest <- function(mat, ...) {
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat <- matrix(NA, n, n)
  diag(p.mat) <- 0
  for (i in 1:(n-1)) {
    for(j in (i + 1):n) {
      tmp <- cor.test(mat[, i], mat[, j], ...)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
    }
  }
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  p.mat
}
p.mat <- cor.mtest(correl)
corrplot(p.mat, sig.level=0.05)



# Correlation matrix with ellipses
library(gridExtra)
chart.Correlation(correl, histogram=TRUE, pch=19)
library(corrplot)
library(RColorBrewer)
corrplot.mixed(correl, 
         tl.cex=0.4,
         order="hclust",
         col=brewer.pal(n=10, name="RdYlGn"),
         tl.col="black", 
         tl.srt=45,
         bg="grey",
         sig.level=0.05,
         insig="blank",
         upper="ellipse")


corrplot(correl, 
               addrect=2,
               method="ellipse",
               type="upper",
               tl.cex=0.6,
               order="hclust",
               col=brewer.pal(n=10, name="RdYlGn"),
               tl.col="black", 
               tl.srt=45,
               bg="grey",
               sig.level=0.05,
               insig="blank")



# Hours per night by total cases per night by season
summary(lm(HRS.WORKED ~ TOTAL.STL.CASES + SEASON, data=OMEGA))
g <- ggplot(data=OMEGA, aes(x=TOTAL.STL.CASES, y=HRS.WORKED))
g + geom_point(aes(colour=SEASON)) + 
  geom_smooth(method="lm", se=F, aes(group=SEASON)) +
  facet_wrap(~SEASON) +
  labs(title="Hours Worked as a funciton of Total Cases (STL)",
       x="Total Cases STL", y="Night Hours Worked STL") +
  theme(legend.position="bottom")



# Number of employees histogram
g <- ggplot(data=OMEGA, aes(x=NUMBER.OF.EMPLOYEES))
g + geom_histogram(stat="bin", binwidth=1.5, fill="lightblue", colour="red") +
  labs(title="Histogram of Number of Night Employees per Evening",
       x="Bins of Number of Employees",  y="Count")



# Histogram of CPMH
g <- ggplot(data=OMEGA, aes(x=ACTUAL.CPMH))
g + geom_histogram(binwidth=3, colour="orange", fill="brown") +
  labs(title="Histogram of Keg Adjusted CPMH", 
       x="Keg Adjusted CPMH (bin width = 3)") +
  geom_vline(xintercept=c(32.54, 35.39, 37.52)) +
  annotate("text", x=28, y=30, 
label="25th percentile is 32.5") +
  annotate("text", x=35, y=32, label="50th percentile is 35.4") +
  annotate("text", x=43, y=30, label="75th percentile is 37.5")

quantile(OMEGA$ACTUAL.CPMH, c(.25, .5, .75, .95))[1]


# Plot net changes in inventory by day, facet by month
g <- ggplot(data=OMEGA, aes(x=DAY.OF.MONTH, y=NET.CHANGE.INVENTORY))
g + geom_point() + facet_wrap(~MONTH, nrow=1) + geom_smooth(aes(group=MONTH))


############################################################################



##################################################################################################
##################################################################################################
##################################################################################################
######################## FIT A LINEAR MODEL ######################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
######################## FIT A LINEAR MODEL ######################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
######################## FIT A LINEAR MODEL ######################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
######################## FIT A LINEAR MODEL ######################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
######################## FIT A LINEAR MODEL ######################################################
##################################################################################################
##################################################################################################

## the leading model is below ###########################
bestFit <- lm(HRS.WORKED ~ TOTAL.STL.CASES + CASES.RECEIVED, data=OMEGA)
summary(bestFit)
library(fmsb)
VIF(bestFit) # Want VIF less than 4
g <- ggplot(data=OMEGA, aes(y=CASES.RECEIVED, x=TOTAL.STL.CASES))
g + geom_point() + geom_smooth(method="lm")
summary(lm(TOTAL.STL.CASES ~ CASES.RECEIVED, data=OMEGA))$r.squared
#########################################################


summary(lm(HRS.WORKED ~ TOTAL.STL.CASES + INVENTORY.INFLOW.NET.RETURNS, data=OMEGA))
summary(lm(TTL.CS.STL ~ SEASON, data=OMEGA))
qplot(data=OMEGA, y=TTL.CS.STL, x=INVENTORY.STL, geom="point")

summary(lm(HRS.WORKED ~ TTL.CS.STL + TOTAL.KEGS, data=OMEGA))
qplot(data=OMEGA, y=NUMBER.OF.EMPLOYEES, x=TTL.CS.STL, geom="smooth", method="lm")

summary(lm(HRS.WORKED ~ TOTAL.STL.CASES + ACTUAL.CPMH, data=OMEGA))
qplot(data=OMEGA, y=HRS.WORKED, x=TOTAL.STL.CASES, geom="point")

summary(lm(ACTUAL.CPMH ~ TOTAL.STL.CASES, data=OMEGA))
qplot(data=OMEGA, y=ACTUAL.CPMH, x=TOTAL.STL.CASES, geom="point", colour=NUMBER.OF.EMPLOYEES)


summary(lm(ACTUAL.CPMH ~ TOTAL.STL.CASES + INVENTORY.INFLOW.NET.RETURNS, data=OMEGA))

summary(lm(ACTUAL.CPMH ~ CASES.INVENTORY.PER.EMPLOYEE, data=OMEGA))
qplot(data=OMEGA, x=CASES.INVENTORY.PER.EMPLOYEE, y=ACTUAL.CPMH, geom="point")

summary(lm(CASES.BROKEN ~ HRS.WORKED, data=OMEGA))


names(OMEGA)
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
########################################### DEAD CODE ############################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
########################################### DEAD CODE ############################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
########################################### DEAD CODE ############################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
########################################### DEAD CODE ############################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
########################################### DEAD CODE ############################################

library(gplots)
col <- c(seq(-1,0, length=100),
         seq(0,0.8, length=100),
         seq(0.8,1 length=100))
my_palette <- colorRampPalette(c("red", "yellow", "green"))
heatmap.2(x=as.matrix(correl),
          margins=c(19,9),
          cellnote=correl,
          main="Correlation Matrix",
          notecol="black",
          density.info="none",
          trace="none",
          col=my_palette,
          dendrogram="row")


library(corrplot)
library(RColorBrewer)
corrplot(correl, 
         method="ellipse",
         type="upper",
         tl.cex=0.6,
         order="hclust",
         col=brewer.pal(n=10, name="RdYlGn"),
         tl.col="black", 
         tl.srt=45,
         bg="grey",
         sig.level=0.05)


library(d3heatmap)
d3heatmap(correl, scale="column",
          dendrogram="none",
          color=scales::col_quantile("Greens", NULL, 5))







# Remove all files 
# rm(list=ls())
