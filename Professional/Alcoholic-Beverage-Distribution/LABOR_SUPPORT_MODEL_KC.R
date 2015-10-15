# Labor Support Model for KC



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
library(gdata)
library(stringr)


#############################################################################
#############################################################################
print("THIS PART IS FOR january 2015")
path <- "N:/Daily Report/2015/KC/Jan 2015"
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

january1$DATE <- as.character(strptime(str_extract(file_list[1], "(\\d+)-(\\d+)"), "%m-%d"))
january2$DATE <- as.character(strptime(str_extract(file_list[2], "(\\d+)-(\\d+)"), "%m-%d"))
january3$DATE <- as.character(strptime(str_extract(file_list[3], "(\\d+)-(\\d+)"), "%m-%d"))
january4$DATE <- as.character(strptime(str_extract(file_list[4], "(\\d+)-(\\d+)"), "%m-%d"))
january5$DATE <- as.character(strptime(str_extract(file_list[5], "(\\d+)-(\\d+)"), "%m-%d"))
january6$DATE <- as.character(strptime(str_extract(file_list[6], "(\\d+)-(\\d+)"), "%m-%d"))
january7$DATE <- as.character(strptime(str_extract(file_list[7], "(\\d+)-(\\d+)"), "%m-%d"))
january8$DATE <- as.character(strptime(str_extract(file_list[8], "(\\d+)-(\\d+)"), "%m-%d"))
january9$DATE <- as.character(strptime(str_extract(file_list[9], "(\\d+)-(\\d+)"), "%m-%d"))
january10$DATE <- as.character(strptime(str_extract(file_list[10], "(\\d+)-(\\d+)"), "%m-%d"))
january11$DATE <- as.character(strptime(str_extract(file_list[11], "(\\d+)-(\\d+)"), "%m-%d"))
january12$DATE <- as.character(strptime(str_extract(file_list[12], "(\\d+)-(\\d+)"), "%m-%d"))
january13$DATE <- as.character(strptime(str_extract(file_list[13], "(\\d+)-(\\d+)"), "%m-%d"))
january14$DATE <- as.character(strptime(str_extract(file_list[14], "(\\d+)-(\\d+)"), "%m-%d"))
january15$DATE <- as.character(strptime(str_extract(file_list[15], "(\\d+)-(\\d+)"), "%m-%d"))
january16$DATE <- as.character(strptime(str_extract(file_list[16], "(\\d+)-(\\d+)"), "%m-%d"))
january17$DATE <- as.character(strptime(str_extract(file_list[17], "(\\d+)-(\\d+)"), "%m-%d"))

january2015 <- rbind(january1, january2, january3, january4, january5, january6, january7, january8, 
                     january9, january10, january11, january12, january13, january14, january15, january16,
                     january17)
january2015 <- filter(january2015, Driver != "Totals:")
january2015$Month.Year <- "01-2015"
View(january2015)

setwd("C:/Users/pmwash/Desktop/R_Files")
# write.csv(january2015, "kc_january_backup_cases.csv")

rm(january1, january2, january3, january4, january5, january6, january7, january8, 
january9, january10, january11, january12, january13, january14, january15, january16,
january17)


#############################################################################
#############################################################################

print("THIS PART IS FOR february 2015")
path <- "N:/Daily Report/2015/KC/Feb 2015"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

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

february1$DATE <- as.character(strptime(str_extract(file_list[1], "(\\d+)-(\\d+)"), "%m-%d"))
february2$DATE <- as.character(strptime(str_extract(file_list[2], "(\\d+)-(\\d+)"), "%m-%d"))
february3$DATE <- as.character(strptime(str_extract(file_list[3], "(\\d+)-(\\d+)"), "%m-%d"))
february4$DATE <- as.character(strptime(str_extract(file_list[4], "(\\d+)-(\\d+)"), "%m-%d"))
february5$DATE <- as.character(strptime(str_extract(file_list[5], "(\\d+)-(\\d+)"), "%m-%d"))
february6$DATE <- as.character(strptime(str_extract(file_list[6], "(\\d+)-(\\d+)"), "%m-%d"))
february7$DATE <- as.character(strptime(str_extract(file_list[7], "(\\d+)-(\\d+)"), "%m-%d"))
february8$DATE <- as.character(strptime(str_extract(file_list[8], "(\\d+)-(\\d+)"), "%m-%d"))
february9$DATE <- as.character(strptime(str_extract(file_list[9], "(\\d+)-(\\d+)"), "%m-%d"))
february10$DATE <- as.character(strptime(str_extract(file_list[10], "(\\d+)-(\\d+)"), "%m-%d"))
february11$DATE <- as.character(strptime(str_extract(file_list[11], "(\\d+)-(\\d+)"), "%m-%d"))
february12$DATE <- as.character(strptime(str_extract(file_list[12], "(\\d+)-(\\d+)"), "%m-%d"))
february13$DATE <- as.character(strptime(str_extract(file_list[13], "(\\d+)-(\\d+)"), "%m-%d"))
february14$DATE <- as.character(strptime(str_extract(file_list[14], "(\\d+)-(\\d+)"), "%m-%d"))
february15$DATE <- as.character(strptime(str_extract(file_list[15], "(\\d+)-(\\d+)"), "%m-%d"))
february16$DATE <- as.character(strptime(str_extract(file_list[16], "(\\d+)-(\\d+)"), "%m-%d"))

february2015 <- rbind(february1, february2, february3, february4, february5, february6, february7, february8, 
                      february9, february10, february11, february12, february13, february14, february15, february16)
february2015 <- filter(february2015, Driver != "Totals:")
february2015$Month.Year <- "02-2015"
View(february2015)

setwd("C:/Users/pmwash/Desktop/R_Files")
# write.csv(february2015, "kc_februar_backup_cases.csv")

rm(february1, february2, february3, february4, february5, february6, february7, february8, 
      february9, february10, february11, february12, february13, february14, february15, february16)

#############################################################################
#############################################################################

print("THIS PART IS FOR march 2015")
path <- "N:/Daily Report/2015/KC/Mar 2015"
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
march18 <- readWorksheetFromFile(file_list[18], sheet=2, startCol=3)


march1$DATE <- as.character(strptime(str_extract(file_list[1], "(\\d+)-(\\d+)"), "%m-%d"))
march2$DATE <- as.character(strptime(str_extract(file_list[2], "(\\d+)-(\\d+)"), "%m-%d"))
march3$DATE <- as.character(strptime(str_extract(file_list[3], "(\\d+)-(\\d+)"), "%m-%d"))
march4$DATE <- as.character(strptime(str_extract(file_list[4], "(\\d+)-(\\d+)"), "%m-%d"))
march5$DATE <- as.character(strptime(str_extract(file_list[5], "(\\d+)-(\\d+)"), "%m-%d"))
march6$DATE <- as.character(strptime(str_extract(file_list[6], "(\\d+)-(\\d+)"), "%m-%d"))
march7$DATE <- as.character(strptime(str_extract(file_list[7], "(\\d+)-(\\d+)"), "%m-%d"))
march8$DATE <- as.character(strptime(str_extract(file_list[8], "(\\d+)-(\\d+)"), "%m-%d"))
march9$DATE <- as.character(strptime(str_extract(file_list[9], "(\\d+)-(\\d+)"), "%m-%d"))
march10$DATE <- as.character(strptime(str_extract(file_list[10], "(\\d+)-(\\d+)"), "%m-%d"))
march11$DATE <- as.character(strptime(str_extract(file_list[11], "(\\d+)-(\\d+)"), "%m-%d"))
march12$DATE <- as.character(strptime(str_extract(file_list[12], "(\\d+)-(\\d+)"), "%m-%d"))
march13$DATE <- as.character(strptime(str_extract(file_list[13], "(\\d+)-(\\d+)"), "%m-%d"))
march14$DATE <- as.character(strptime(str_extract(file_list[14], "(\\d+)-(\\d+)"), "%m-%d"))
march15$DATE <- as.character(strptime(str_extract(file_list[15], "(\\d+)-(\\d+)"), "%m-%d"))
march16$DATE <- as.character(strptime(str_extract(file_list[16], "(\\d+)-(\\d+)"), "%m-%d"))
march17$DATE <- as.character(strptime(str_extract(file_list[17], "(\\d+)-(\\d+)"), "%m-%d"))
march18$DATE <- as.character(strptime(str_extract(file_list[18], "(\\d+)-(\\d+)"), "%m-%d"))

march2015 <- rbind(march1, march2, march3, march4, march5, march6, march7, march8, 
                   march9, march10, march11, march12, march13, march14, march15, march16,
                   march17, march18)
march2015 <- filter(march2015, Driver != "Totals:")
march2015$Month.Year <- "03-2015"
View(march2015)

setwd("C:/Users/pmwash/Desktop/R_Files")
# write.csv(march2015, "kc_march_backup_cases.csv")

rm(march1, march2, march3, march4, march5, march6, march7, march8, 
      march9, march10, march11, march12, march13, march14, march15, march16,
      march17, march18)

#############################################################################
#############################################################################

print("THIS PART IS FOR april 2015")
path <- "N:/Daily Report/2015/KC/April 2015"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

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


april1$DATE <- as.character(strptime(str_extract(file_list[1], "(\\d+)-(\\d+)"), "%m-%d"))
april2$DATE <- as.character(strptime(str_extract(file_list[2], "(\\d+)-(\\d+)"), "%m-%d"))
april3$DATE <- as.character(strptime(str_extract(file_list[3], "(\\d+)-(\\d+)"), "%m-%d"))
april4$DATE <- as.character(strptime(str_extract(file_list[4], "(\\d+)-(\\d+)"), "%m-%d"))
april5$DATE <- as.character(strptime(str_extract(file_list[5], "(\\d+)-(\\d+)"), "%m-%d"))
april6$DATE <- as.character(strptime(str_extract(file_list[6], "(\\d+)-(\\d+)"), "%m-%d"))
april7$DATE <- as.character(strptime(str_extract(file_list[7], "(\\d+)-(\\d+)"), "%m-%d"))
april8$DATE <- as.character(strptime(str_extract(file_list[8], "(\\d+)-(\\d+)"), "%m-%d"))
april9$DATE <- as.character(strptime(str_extract(file_list[9], "(\\d+)-(\\d+)"), "%m-%d"))
april10$DATE <- as.character(strptime(str_extract(file_list[10], "(\\d+)-(\\d+)"), "%m-%d"))
april11$DATE <- as.character(strptime(str_extract(file_list[11], "(\\d+)-(\\d+)"), "%m-%d"))
april12$DATE <- as.character(strptime(str_extract(file_list[12], "(\\d+)-(\\d+)"), "%m-%d"))
april13$DATE <- as.character(strptime(str_extract(file_list[13], "(\\d+)-(\\d+)"), "%m-%d"))
april14$DATE <- as.character(strptime(str_extract(file_list[14], "(\\d+)-(\\d+)"), "%m-%d"))
april15$DATE <- as.character(strptime(str_extract(file_list[15], "(\\d+)-(\\d+)"), "%m-%d"))
april16$DATE <- as.character(strptime(str_extract(file_list[16], "(\\d+)-(\\d+)"), "%m-%d"))
april17$DATE <- as.character(strptime(str_extract(file_list[17], "(\\d+)-(\\d+)"), "%m-%d"))
april18$DATE <- as.character(strptime(str_extract(file_list[18], "(\\d+)-(\\d+)"), "%m-%d"))

april2015 <- rbind(april1, april2, april3, april4, april5, april6, april7, april8, 
                   april9, april10, april11, april12, april13, april14, april15, april16,
                   april17)
april2015 <- filter(april2015, Driver != "Totals:")
april2015$Month.Year <- "04-2015"
View(april2015)

setwd("C:/Users/pmwash/Desktop/R_Files")
# write.csv(april2015, "kc_april_backup_cases.csv")

rm(april1, april2, april3, april4, april5, april6, april7, april8, 
      april9, april10, april11, april12, april13, april14, april15, april16,
      april17, april18)

#############################################################################
#############################################################################

print("THIS PART IS FOR may 2015")
path <- "N:/Daily Report/2015/KC/May 2015"
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


may1$DATE <- as.character(strptime(str_extract(file_list[1], "(\\d+)-(\\d+)"), "%m-%d"))
may2$DATE <- as.character(strptime(str_extract(file_list[2], "(\\d+)-(\\d+)"), "%m-%d"))
may3$DATE <- as.character(strptime(str_extract(file_list[3], "(\\d+)-(\\d+)"), "%m-%d"))
may4$DATE <- as.character(strptime(str_extract(file_list[4], "(\\d+)-(\\d+)"), "%m-%d"))
may5$DATE <- as.character(strptime(str_extract(file_list[5], "(\\d+)-(\\d+)"), "%m-%d"))
may6$DATE <- as.character(strptime(str_extract(file_list[6], "(\\d+)-(\\d+)"), "%m-%d"))
may7$DATE <- as.character(strptime(str_extract(file_list[7], "(\\d+)-(\\d+)"), "%m-%d"))
may8$DATE <- as.character(strptime(str_extract(file_list[8], "(\\d+)-(\\d+)"), "%m-%d"))
may9$DATE <- as.character(strptime(str_extract(file_list[9], "(\\d+)-(\\d+)"), "%m-%d"))
may10$DATE <- as.character(strptime(str_extract(file_list[10], "(\\d+)-(\\d+)"), "%m-%d"))
may11$DATE <- as.character(strptime(str_extract(file_list[11], "(\\d+)-(\\d+)"), "%m-%d"))
may12$DATE <- as.character(strptime(str_extract(file_list[12], "(\\d+)-(\\d+)"), "%m-%d"))
may13$DATE <- as.character(strptime(str_extract(file_list[13], "(\\d+)-(\\d+)"), "%m-%d"))
may14$DATE <- as.character(strptime(str_extract(file_list[14], "(\\d+)-(\\d+)"), "%m-%d"))
may15$DATE <- as.character(strptime(str_extract(file_list[15], "(\\d+)-(\\d+)"), "%m-%d"))
may16$DATE <- as.character(strptime(str_extract(file_list[16], "(\\d+)-(\\d+)"), "%m-%d"))
may17$DATE <- as.character(strptime(str_extract(file_list[17], "(\\d+)-(\\d+)"), "%m-%d"))

may2015 <- rbind(may1, may2, may3, may4, may5, may6, may7, may8, 
                 may9, may10, may11, may12, may13, may14, may15, may16,
                 may17)
may2015 <- filter(may2015, Driver != "Totals:")
may2015$Month.Year <- "05-2015"
View(may2015)

setwd("C:/Users/pmwash/Desktop/R_Files")
# write.csv(may2015, "kc_may_backup_cases.csv")

rm(may1, may2, may3, may4, may5, may6, may7, may8, 
      may9, may10, may11, may12, may13, may14, may15, may16,
      may17)

#############################################################################
#############################################################################

print("THIS PART IS FOR june 2015")
path <- "N:/Daily Report/2015/KC/June 2015"
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


june1$DATE <- as.character(strptime(str_extract(file_list[1], "(\\d+)-(\\d+)"), "%m-%d"))
june2$DATE <- as.character(strptime(str_extract(file_list[2], "(\\d+)-(\\d+)"), "%m-%d"))
june3$DATE <- as.character(strptime(str_extract(file_list[3], "(\\d+)-(\\d+)"), "%m-%d"))
june4$DATE <- as.character(strptime(str_extract(file_list[4], "(\\d+)-(\\d+)"), "%m-%d"))
june5$DATE <- as.character(strptime(str_extract(file_list[5], "(\\d+)-(\\d+)"), "%m-%d"))
june6$DATE <- as.character(strptime(str_extract(file_list[6], "(\\d+)-(\\d+)"), "%m-%d"))
june7$DATE <- as.character(strptime(str_extract(file_list[7], "(\\d+)-(\\d+)"), "%m-%d"))
june8$DATE <- as.character(strptime(str_extract(file_list[8], "(\\d+)-(\\d+)"), "%m-%d"))
june9$DATE <- as.character(strptime(str_extract(file_list[9], "(\\d+)-(\\d+)"), "%m-%d"))
june10$DATE <- as.character(strptime(str_extract(file_list[10], "(\\d+)-(\\d+)"), "%m-%d"))
june11$DATE <- as.character(strptime(str_extract(file_list[11], "(\\d+)-(\\d+)"), "%m-%d"))
june12$DATE <- as.character(strptime(str_extract(file_list[12], "(\\d+)-(\\d+)"), "%m-%d"))
june13$DATE <- as.character(strptime(str_extract(file_list[13], "(\\d+)-(\\d+)"), "%m-%d"))
june14$DATE <- as.character(strptime(str_extract(file_list[14], "(\\d+)-(\\d+)"), "%m-%d"))
june15$DATE <- as.character(strptime(str_extract(file_list[15], "(\\d+)-(\\d+)"), "%m-%d"))
june16$DATE <- as.character(strptime(str_extract(file_list[16], "(\\d+)-(\\d+)"), "%m-%d"))
june17$DATE <- as.character(strptime(str_extract(file_list[17], "(\\d+)-(\\d+)"), "%m-%d"))
june18$DATE <- as.character(strptime(str_extract(file_list[18], "(\\d+)-(\\d+)"), "%m-%d"))

june2015 <- rbind(june1, june2, june3, june4, june5, june6, june7, june8, 
                  june9, june10, june11, june12, june13, june14, june15, june16,
                  june17, june18)
june2015 <- filter(june2015, Driver != "Totals:")
june2015$Month.Year <- "06-2015"
View(june2015)

setwd("C:/Users/pmwash/Desktop/R_Files")
# write.csv(june2015, "kc_june_backup_cases.csv")

rm(june1, june2, june3, june4, june5, june6, june7, june8, 
      june9, june10, june11, june12, june13, june14, june15, june16,
      june17, june18)

#############################################################################
#############################################################################

print("THIS PART IS FOR july 2015")
path <- "N:/Daily Report/2015/KC/July 2015"
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
july21 <- readWorksheetFromFile(file_list[21], sheet=2, startCol=3)

july1$DATE <- as.character(strptime(str_extract(file_list[1], "(\\d+)-(\\d+)"), "%m-%d"))
july2$DATE <- as.character(strptime(str_extract(file_list[2], "(\\d+)-(\\d+)"), "%m-%d"))
july3$DATE <- as.character(strptime(str_extract(file_list[3], "(\\d+)-(\\d+)"), "%m-%d"))
july4$DATE <- as.character(strptime(str_extract(file_list[4], "(\\d+)-(\\d+)"), "%m-%d"))
july5$DATE <- as.character(strptime(str_extract(file_list[5], "(\\d+)-(\\d+)"), "%m-%d"))
july6$DATE <- as.character(strptime(str_extract(file_list[6], "(\\d+)-(\\d+)"), "%m-%d"))
july7$DATE <- as.character(strptime(str_extract(file_list[7], "(\\d+)-(\\d+)"), "%m-%d"))
july8$DATE <- as.character(strptime(str_extract(file_list[8], "(\\d+)-(\\d+)"), "%m-%d"))
july9$DATE <- as.character(strptime(str_extract(file_list[9], "(\\d+)-(\\d+)"), "%m-%d"))
july10$DATE <- as.character(strptime(str_extract(file_list[10], "(\\d+)-(\\d+)"), "%m-%d"))
july11$DATE <- as.character(strptime(str_extract(file_list[11], "(\\d+)-(\\d+)"), "%m-%d"))
july12$DATE <- as.character(strptime(str_extract(file_list[12], "(\\d+)-(\\d+)"), "%m-%d"))
july13$DATE <- as.character(strptime(str_extract(file_list[13], "(\\d+)-(\\d+)"), "%m-%d"))
july14$DATE <- as.character(strptime(str_extract(file_list[14], "(\\d+)-(\\d+)"), "%m-%d"))
july15$DATE <- as.character(strptime(str_extract(file_list[15], "(\\d+)-(\\d+)"), "%m-%d"))
july16$DATE <- as.character(strptime(str_extract(file_list[16], "(\\d+)-(\\d+)"), "%m-%d"))
july17$DATE <- as.character(strptime(str_extract(file_list[17], "(\\d+)-(\\d+)"), "%m-%d"))
july18$DATE <- as.character(strptime(str_extract(file_list[18], "(\\d+)-(\\d+)"), "%m-%d"))
july19$DATE <- as.character(strptime(str_extract(file_list[19], "(\\d+)-(\\d+)"), "%m-%d"))
july20$DATE <- as.character(strptime(str_extract(file_list[20], "(\\d+)-(\\d+)"), "%m-%d"))
july21$DATE <- as.character(strptime(str_extract(file_list[21], "(\\d+)-(\\d+)"), "%m-%d"))

july2015 <- rbind(july1, july2, july3, july4, july5, july6, july7, july8, 
                  july9, july10, july11, july12, july13, july14, july15, july16,
                  july17, july18, july19, july20, july21)
july2015 <- filter(july2015, Driver != "Totals:")
july2015$Month.Year <- "07-2015"
View(july2015)


setwd("C:/Users/pmwash/Desktop/R_Files")
# write.csv(july2015, "kc_july_backup_cases.csv")


rm(july1, july2, july3, july4, july5, july6, july7, july8, 
      july9, july10, july11, july12, july13, july14, july15, july16,
      july17, july18, july19, july20, july21)

#############################################################################
#############################################################################

print("THIS PART IS FOR august 2015")
path <- "N:/Daily Report/2015/KC/August 2015"
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
#august15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
august16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
august17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)

august1$DATE <- as.character(strptime(str_extract(file_list[1], "(\\d+)-(\\d+)"), "%m-%d"))
august2$DATE <- as.character(strptime(str_extract(file_list[2], "(\\d+)-(\\d+)"), "%m-%d"))
august3$DATE <- as.character(strptime(str_extract(file_list[3], "(\\d+)-(\\d+)"), "%m-%d"))
august4$DATE <- as.character(strptime(str_extract(file_list[4], "(\\d+)-(\\d+)"), "%m-%d"))
august5$DATE <- as.character(strptime(str_extract(file_list[5], "(\\d+)-(\\d+)"), "%m-%d"))
august6$DATE <- as.character(strptime(str_extract(file_list[6], "(\\d+)-(\\d+)"), "%m-%d"))
august7$DATE <- as.character(strptime(str_extract(file_list[7], "(\\d+)-(\\d+)"), "%m-%d"))
august8$DATE <- as.character(strptime(str_extract(file_list[8], "(\\d+)-(\\d+)"), "%m-%d"))
august9$DATE <- as.character(strptime(str_extract(file_list[9], "(\\d+)-(\\d+)"), "%m-%d"))
august10$DATE <- as.character(strptime(str_extract(file_list[10], "(\\d+)-(\\d+)"), "%m-%d"))
august11$DATE <- as.character(strptime(str_extract(file_list[11], "(\\d+)-(\\d+)"), "%m-%d"))
august12$DATE <- as.character(strptime(str_extract(file_list[12], "(\\d+)-(\\d+)"), "%m-%d"))
august13$DATE <- as.character(strptime(str_extract(file_list[13], "(\\d+)-(\\d+)"), "%m-%d"))
august14$DATE <- as.character(strptime(str_extract(file_list[14], "(\\d+)-(\\d+)"), "%m-%d"))
#august15$DATE <- as.character(strptime(str_extract(file_list[15], "(\\d+)-(\\d+)"), "%m-%d"))
august16$DATE <- as.character(strptime(str_extract(file_list[16], "(\\d+)-(\\d+)"), "%m-%d"))
august17$DATE <- as.character(strptime(str_extract(file_list[17], "(\\d+)-(\\d+)"), "%m-%d"))


august2015 <- rbind(august1, august2, august3, august4, august5, 
                    august6, august7, august8, august9, august10, 
                    august11, august12, august13, august14, august16, august17)
august2015 <- filter(august2015, Driver != "Totals:")
august2015$Month.Year <- "08-2015"
View(august2015)


setwd("C:/Users/pmwash/Desktop/R_Files")
# write.csv(august2015, "kc_august_backup_cases.csv")


rm(august1, august2, august3, august4, august5, 
      august6, august7, august8, august9, august10, 
      august11, august12, august13, august14, august16, august17)

####################################################################################
####################################################################################

# Compile files together spreadsheets one data frame and clean data
kcProduction2015 <- rbind(january2015, february2015, march2015,
                        april2015, may2015, june2015,
                        july2015, august2015)

View(kcProduction2015)

rm(january2015, february2015, march2015,
      april2015, may2015, june2015,
      july2015, august2015)




# Sort data frame by date
kcProduction2015 <- kcProduction2015[order(kcProduction2015$DATE), ]

kcProduction2015$Month.Year <- as.factor(kcProduction2015$Month.Year)
#levels(kcProduction2015$Month.Year)

kcProduction2015 <- kcProduction2015[,c(48:49,1:47)]

kcProduction2015$Year <- 
  substr(kcProduction2015$Month.Year, 4, 7)
kcProduction2015$Month <-
  substr(kcProduction2015$Month.Year, 0, 2)



#avg <- mean(kcProduction2015$TTL.Cs.splt, na.rm=T)
#sd <- sd(kcProduction2015$TTL.Cs.splt, na.rm=T)
#cutoff <- avg + 5*sd
#kcProduction2015 <- filter(kcProduction2015, TTL.Cs.splt > cutoff)


kcProduction2015$INDEX <- paste(kcProduction2015$DATE, kcProduction2015$Driver, 
                                kcProduction2015$TTL.Cs.splt, sep="_")
test1 <- kcProduction2015[!duplicated(kcProduction2015$INDEX),]






View(kcProduction2015)

setwd("C:/Users/pmwash/Desktop/R_Files")
# write.csv(kcProduction2015, "kcProduction2015_backup_labormodel.csv")





####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################


# Gather info on KC number of employees and hours per night 

##########################################################
# january ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################
# january ################################################
##########################################################
##########################################################
##########################################################
##########################################################
##########################################################


print("COMPILING HOURS WORKED FOR JANUARY")

# Set working directory
path <- "N:/Daily Report/2015/KC/Jan 2015"
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
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January1 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January1$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))


print("Combined dataset for this day is below.")
head(January1)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January2 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January2$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January2)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January3 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January3$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January3)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January4 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January4$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January4)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January5 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January5$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January5)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January6 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January6$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January6)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January7 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January7$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January7)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January8 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January8$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January8)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January9 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January9$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January9)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January10 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January10$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January10)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January11 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January11$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January11)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January12 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January12$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January12)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January13 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January13$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January13)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January14 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January14$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January14)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January15 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January15$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January15)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January16 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January16$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January16)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[17]
file
hoursSeniorJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorJanuary$DATE <- file
head(hoursSeniorJanuary, 3)

hoursCasualJanuary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualJanuary$DATE <- file
head(hoursCasualJanuary, 3)
# Combine the two datasets and format the date
January17 <- rbind(hoursSeniorJanuary, hoursCasualJanuary)
January17$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(January17)
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
head(compiled)
tail(compiled)
swd <- setwd("C:/Users/pmwash/Desktop/R_Files")
#write.csv(compiled, "compiled_KC_backup_january.csv")

rm(January1, January2, January3,
      January4, January5, January6,
      January7, January8, January9,
      January10, January11, January12,
      January13, January14, January15,
      January16, January17)


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
path <- "N:/Daily Report/2015/KC/Feb 2015"
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
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february1 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february1$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february1)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february2 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february2$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february2)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february3 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february3$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february3)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february4 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february4$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february4)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february5 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february5$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february5)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february6 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february6$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february6)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february7 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february7$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february7)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february8 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february8$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february8)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february9 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february9$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february9)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february10 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february10$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february10)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february11 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february11$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february11)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february12 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february12$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february12)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february13 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february13$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february13)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february14 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february14$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february14)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february15 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february15$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february15)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSeniorfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=7, endRow=29, 
                                            startCol=1, endCol=7)
hoursSeniorfebruary$DATE <- file
head(hoursSeniorfebruary, 3)

hoursCasualfebruary <- readWorksheetFromFile(file, sheet=5, 
                                            startRow=33, endRow=63, 
                                            startCol=1, endCol=7)
hoursCasualfebruary$DATE <- file
head(hoursCasualfebruary, 3)
# Combine the two datasets and format the date
february16 <- rbind(hoursSeniorfebruary, hoursCasualfebruary)
february16$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(february16)
#############################
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
head(compiled)
tail(compiled)

rm(february1, february2, february3,
      february4, february5, february6,
      february7, february8, february9,
      february10, february11, february12,
      february13, february14, february15,
      february16)

swd
#write.csv(compiled, "compiled_KC_backup_february.csv")

###########################################################################
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
path <- "N:/Daily Report/2015/KC/Mar 2015"
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
file <- file_list[1]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march1 <- rbind(hoursSeniormarch, hoursCasualmarch)
march1$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march1)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march2 <- rbind(hoursSeniormarch, hoursCasualmarch)
march2$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march2)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march3 <- rbind(hoursSeniormarch, hoursCasualmarch)
march3$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march3)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march4 <- rbind(hoursSeniormarch, hoursCasualmarch)
march4$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march4)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march5 <- rbind(hoursSeniormarch, hoursCasualmarch)
march5$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march5)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march6 <- rbind(hoursSeniormarch, hoursCasualmarch)
march6$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march6)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march7 <- rbind(hoursSeniormarch, hoursCasualmarch)
march7$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march7)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march8 <- rbind(hoursSeniormarch, hoursCasualmarch)
march8$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march8)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march9 <- rbind(hoursSeniormarch, hoursCasualmarch)
march9$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march9)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march10 <- rbind(hoursSeniormarch, hoursCasualmarch)
march10$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march10)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march11 <- rbind(hoursSeniormarch, hoursCasualmarch)
march11$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march11)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march12 <- rbind(hoursSeniormarch, hoursCasualmarch)
march12$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march12)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march13 <- rbind(hoursSeniormarch, hoursCasualmarch)
march13$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march13)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march14 <- rbind(hoursSeniormarch, hoursCasualmarch)
march14$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march14)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march15 <- rbind(hoursSeniormarch, hoursCasualmarch)
march15$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march15)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march16 <- rbind(hoursSeniormarch, hoursCasualmarch)
march16$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march16)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[17]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=29, 
                                          startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=33, endRow=63, 
                                          startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march17 <- rbind(hoursSeniormarch, hoursCasualmarch)
march17$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march17)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[18]
file
hoursSeniormarch <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=29, 
                                          startCol=1, endCol=7)
hoursSeniormarch$DATE <- file
head(hoursSeniormarch, 3)

hoursCasualmarch <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=33, endRow=63, 
                                          startCol=1, endCol=7)
hoursCasualmarch$DATE <- file
head(hoursCasualmarch, 3)
# Combine the two datasets and format the date
march18 <- rbind(hoursSeniormarch, hoursCasualmarch)
march18$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(march18)
#############################
##########################################################
##########################################################
##########################################################
##########################################################
paste("There SHOULD be", prodDays, "iterations for this month.")
march <- rbind(march1, march2, march3,
                  march4, march5, march6,
                  march7, march8, march9,
                  march10, march11, march12,
                  march13, march14, march15,
                  march16, march17, march18)
compiled <- rbind(compiled, march)
head(compiled)
tail(compiled)
swd
#write.csv(compiled, "compiled_KC_backup_march.csv")

rm(march1, march2, march3,
      march4, march5, march6,
      march7, march8, march9,
      march10, march11, march12,
      march13, march14, march15,
      march16, march17, march18)

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
path <- "N:/Daily Report/2015/KC/April 2015"
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
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april1 <- rbind(hoursSeniorapril, hoursCasualapril)
april1$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april1)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april2 <- rbind(hoursSeniorapril, hoursCasualapril)
april2$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april2)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april3 <- rbind(hoursSeniorapril, hoursCasualapril)
april3$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april3)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april4 <- rbind(hoursSeniorapril, hoursCasualapril)
april4$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april4)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april5 <- rbind(hoursSeniorapril, hoursCasualapril)
april5$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april5)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april6 <- rbind(hoursSeniorapril, hoursCasualapril)
april6$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april6)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april7 <- rbind(hoursSeniorapril, hoursCasualapril)
april7$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april7)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april8 <- rbind(hoursSeniorapril, hoursCasualapril)
april8$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april8)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april9 <- rbind(hoursSeniorapril, hoursCasualapril)
april9$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april9)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april10 <- rbind(hoursSeniorapril, hoursCasualapril)
april10$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april10)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april11 <- rbind(hoursSeniorapril, hoursCasualapril)
april11$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april11)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april12 <- rbind(hoursSeniorapril, hoursCasualapril)
april12$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april12)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april13 <- rbind(hoursSeniorapril, hoursCasualapril)
april13$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april13)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april14 <- rbind(hoursSeniorapril, hoursCasualapril)
april14$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april14)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april15 <- rbind(hoursSeniorapril, hoursCasualapril)
april15$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april15)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april16 <- rbind(hoursSeniorapril, hoursCasualapril)
april16$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april16)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[17]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=29, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=33, endRow=63, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april17 <- rbind(hoursSeniorapril, hoursCasualapril)
april17$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april17)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[18]
file
hoursSeniorapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=7, endRow=29, 
                                          startCol=1, endCol=7)
hoursSeniorapril$DATE <- file
head(hoursSeniorapril, 3)

hoursCasualapril <- readWorksheetFromFile(file, sheet=5, 
                                          startRow=33, endRow=63, 
                                          startCol=1, endCol=7)
hoursCasualapril$DATE <- file
head(hoursCasualapril, 3)
# Combine the two datasets and format the date
april18 <- rbind(hoursSeniorapril, hoursCasualapril)
april18$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(april18)
#############################
##########################################################
##########################################################
##########################################################
##########################################################
paste("There SHOULD be", prodDays, "iterations for this month.")
april <- rbind(april1, april2, april3,
                  april4, april5, april6,
                  april7, april8, april9,
                  april10, april11, april12,
                  april13, april14, april15,
                  april16, april17, april18)
compiled <- rbind(compiled, april)
head(compiled)
tail(compiled)
swd
#write.csv(compiled, "compiled_KC_backup_april.csv")

rm(april1, april2, april3,
      april4, april5, april6,
      april7, april8, april9,
      april10, april11, april12,
      april13, april14, april15,
      april16, april17, april18)

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
path <- "N:/Daily Report/2015/KC/May 2015"
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
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may1 <- rbind(hoursSeniormay, hoursCasualmay)
may1$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may1)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may2 <- rbind(hoursSeniormay, hoursCasualmay)
may2$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may2)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may3 <- rbind(hoursSeniormay, hoursCasualmay)
may3$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may3)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may4 <- rbind(hoursSeniormay, hoursCasualmay)
may4$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may4)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may5 <- rbind(hoursSeniormay, hoursCasualmay)
may5$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may5)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may6 <- rbind(hoursSeniormay, hoursCasualmay)
may6$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may6)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may7 <- rbind(hoursSeniormay, hoursCasualmay)
may7$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may7)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may8 <- rbind(hoursSeniormay, hoursCasualmay)
may8$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may8)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may9 <- rbind(hoursSeniormay, hoursCasualmay)
may9$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may9)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may10 <- rbind(hoursSeniormay, hoursCasualmay)
may10$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may10)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may11 <- rbind(hoursSeniormay, hoursCasualmay)
may11$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may11)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may12 <- rbind(hoursSeniormay, hoursCasualmay)
may12$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may12)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may13 <- rbind(hoursSeniormay, hoursCasualmay)
may13$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may13)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may14 <- rbind(hoursSeniormay, hoursCasualmay)
may14$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may14)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may15 <- rbind(hoursSeniormay, hoursCasualmay)
may15$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may15)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may16 <- rbind(hoursSeniormay, hoursCasualmay)
may16$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may16)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[17]
file
hoursSeniormay <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=7, endRow=29, 
                                        startCol=1, endCol=7)
hoursSeniormay$DATE <- file
head(hoursSeniormay, 3)

hoursCasualmay <- readWorksheetFromFile(file, sheet=5, 
                                        startRow=33, endRow=63, 
                                        startCol=1, endCol=7)
hoursCasualmay$DATE <- file
head(hoursCasualmay, 3)
# Combine the two datasets and format the date
may17 <- rbind(hoursSeniormay, hoursCasualmay)
may17$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(may17)
#############################
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
head(compiled)
tail(compiled)
swd
#write.csv(compiled, "compiled_KC_backup_may.csv")

rm(may1, may2, may3,
      may4, may5, may6,
      may7, may8, may9,
      may10, may11, may12,
      may13, may14, may15,
      may16, may17)

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
path <- "N:/Daily Report/2015/KC/June 2015"
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
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june1 <- rbind(hoursSeniorjune, hoursCasualjune)
june1$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june1)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june2 <- rbind(hoursSeniorjune, hoursCasualjune)
june2$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june2)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june3 <- rbind(hoursSeniorjune, hoursCasualjune)
june3$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june3)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june4 <- rbind(hoursSeniorjune, hoursCasualjune)
june4$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june4)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june5 <- rbind(hoursSeniorjune, hoursCasualjune)
june5$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june5)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june6 <- rbind(hoursSeniorjune, hoursCasualjune)
june6$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june6)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june7 <- rbind(hoursSeniorjune, hoursCasualjune)
june7$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june7)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june8 <- rbind(hoursSeniorjune, hoursCasualjune)
june8$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june8)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june9 <- rbind(hoursSeniorjune, hoursCasualjune)
june9$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june9)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june10 <- rbind(hoursSeniorjune, hoursCasualjune)
june10$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june10)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june11 <- rbind(hoursSeniorjune, hoursCasualjune)
june11$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june11)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june12 <- rbind(hoursSeniorjune, hoursCasualjune)
june12$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june12)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june13 <- rbind(hoursSeniorjune, hoursCasualjune)
june13$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june13)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june14 <- rbind(hoursSeniorjune, hoursCasualjune)
june14$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june14)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june15 <- rbind(hoursSeniorjune, hoursCasualjune)
june15$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june15)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june16 <- rbind(hoursSeniorjune, hoursCasualjune)
june16$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june16)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[17]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=29, 
                                         startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=33, endRow=63, 
                                         startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june17 <- rbind(hoursSeniorjune, hoursCasualjune)
june17$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june17)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[18]
file
hoursSeniorjune <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=29, 
                                         startCol=1, endCol=7)
hoursSeniorjune$DATE <- file
head(hoursSeniorjune, 3)

hoursCasualjune <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=33, endRow=63, 
                                         startCol=1, endCol=7)
hoursCasualjune$DATE <- file
head(hoursCasualjune, 3)
# Combine the two datasets and format the date
june18 <- rbind(hoursSeniorjune, hoursCasualjune)
june18$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(june18)
#############################
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
head(compiled)
tail(compiled)
swd
#write.csv(compiled, "compiled_KC_backup_june.csv")

rm(june1, june2, june3,
      june4, june5, june6,
      june7, june8, june9,
      june10, june11, june12,
      june13, june14, june15,
      june16, june17, june18)

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
path <- "N:/Daily Report/2015/KC/July 2015"
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
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july1 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july1$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july1)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july2 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july2$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july2)
#############################
#############################           
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july3 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july3$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july3)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july4 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july4$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july4)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july5 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july5$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july5)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july6 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july6$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july6)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july7 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july7$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july7)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july8 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july8$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july8)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july9 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july9$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july9)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july10 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july10$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july10)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july11 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july11$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july11)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july12 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july12$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july12)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july13 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july13$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july13)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july14 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july14$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july14)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july15 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july15$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july15)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july16 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july16$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july16)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[17]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=29, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=33, endRow=63, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july17 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july17$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july17)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[18]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=29, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=33, endRow=63, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july18 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july18$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july18)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[19]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=29, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=33, endRow=63, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july19 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july19$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july19)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[20]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=29, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=33, endRow=63, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july20 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july20$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july20)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[21]
file
hoursSeniorjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=7, endRow=29, 
                                         startCol=1, endCol=7)
hoursSeniorjuly$DATE <- file
head(hoursSeniorjuly, 3)

hoursCasualjuly <- readWorksheetFromFile(file, sheet=5, 
                                         startRow=33, endRow=63, 
                                         startCol=1, endCol=7)
hoursCasualjuly$DATE <- file
head(hoursCasualjuly, 3)
# Combine the two datasets and format the date
july21 <- rbind(hoursSeniorjuly, hoursCasualjuly)
july21$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(july21)
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
                  july19, july20, july21)

compiled <- rbind(compiled, july)
head(compiled)
tail(compiled)
#write.csv(compiled, "compiled_KC_backup_july.csv")

rm(july1, july2, july3,
      july4, july5, july6,
      july7, july8, july9,
      july10, july11, july12,
      july13, july14, july15,
      july16, july17, july18,
      july19, july20, july21)


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
path <- "N:/Daily Report/2015/KC/August 2015"
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
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august1 <- rbind(hoursSenioraugust, hoursCasualaugust)
august1$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august1)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[2]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august2 <- rbind(hoursSenioraugust, hoursCasualaugust)
august2$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august2)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[3]
file 
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august3 <- rbind(hoursSenioraugust, hoursCasualaugust)
august3$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august3)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[4]
file 
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august4 <- rbind(hoursSenioraugust, hoursCasualaugust)
august4$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august4)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[5]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august5 <- rbind(hoursSenioraugust, hoursCasualaugust)
august5$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august5)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[6]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august6 <- rbind(hoursSenioraugust, hoursCasualaugust)
august6$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august6)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[7]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august7 <- rbind(hoursSenioraugust, hoursCasualaugust)
august7$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august7)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[8]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august8 <- rbind(hoursSenioraugust, hoursCasualaugust)
august8$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august8)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[9]
file 
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august9 <- rbind(hoursSenioraugust, hoursCasualaugust)
august9$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august9)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[10]
file 
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august10 <- rbind(hoursSenioraugust, hoursCasualaugust)
august10$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august10)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[11]
file 
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august11 <- rbind(hoursSenioraugust, hoursCasualaugust)
august11$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august11)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[12]
file 
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august12 <- rbind(hoursSenioraugust, hoursCasualaugust)
august12$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august12)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[13]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august13 <- rbind(hoursSenioraugust, hoursCasualaugust)
august13$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august13)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[14]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august14 <- rbind(hoursSenioraugust, hoursCasualaugust)
august14$DATE <- 
  as.character(strptime(august14$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
head(august14)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[15]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august15 <- rbind(hoursSenioraugust, hoursCasualaugust)
august15$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august15)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[16]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=7, endRow=29, 
                                             startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                             startRow=33, endRow=63, 
                                             startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august16 <- rbind(hoursSenioraugust, hoursCasualaugust)
august16$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august16)
#############################
#############################
# Gather Casual & Senior hours
file <- file_list[17]
file
hoursSenioraugust <- readWorksheetFromFile(file, sheet=5, 
                                           startRow=7, endRow=29, 
                                           startCol=1, endCol=7)
hoursSenioraugust$DATE <- file
head(hoursSenioraugust, 3)

hoursCasualaugust <- readWorksheetFromFile(file, sheet=5, 
                                           startRow=33, endRow=63, 
                                           startCol=1, endCol=7)
hoursCasualaugust$DATE <- file
head(hoursCasualaugust, 3)
# Combine the two datasets and format the date
august17 <- rbind(hoursSenioraugust, hoursCasualaugust)
august17$DATE <- 
  as.character(strptime(str_extract(file, "(\\d+)-(\\d+)"), "%m-%d"))

print("Combined dataset for this day is below.")
head(august17)
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
                  august16, august17)
head(august)
tail(august)
compiled <- rbind(compiled, august)
head(compiled)
tail(compiled)
swd
#write.csv(compiled, "MAIN_BACKUP_kc_LABOR_MODEL.csv")

rm(august1, august2, august3,
      august4, august5, august6,
      august7, august8, august9,
      august10, august11, august12,
      august13, august14, august15,
      august16, august17)

# compiled remove dduplicates
compiled$INDEX <- as.character(paste(compiled$NAME, compiled$DATE, sep="_"))
duplicated(compiled$INDEX)
test <- compiled[!duplicated(compiled$INDEX),]






########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ Gather Inflow of Cases to Inventory #######
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ Gather Inflow of Cases to Inventory #######
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ Gather Inflow of Cases to Inventory #######
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ Gather Inflow of Cases to Inventory #######
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ Gather Inflow of Cases to Inventory #######
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ Gather Inflow of Cases to Inventory #######



setwd("C:/Users/pmwash/Desktop/R_Files")
kc.inflows <- read.csv('inventory_inflow_kc.csv', header=TRUE)
kc.inflows$DATE <- as.character(strptime(kc.inflows$DATE, format="%m/%d/%y"))



#### CLEAN UP & AGGREGATE THE DATA ##################################
#####################################################################
#####################################################################
#####################################################################
#####################################################################
#### CLEAN UP & AGGREGATE THE DATA ##################################
#####################################################################
#####################################################################
#####################################################################
#####################################################################
#### CLEAN UP & AGGREGATE THE DATA ##################################
#####################################################################
#####################################################################
#####################################################################
#####################################################################
#### CLEAN UP & AGGREGATE THE DATA ##################################
#####################################################################
#####################################################################
#####################################################################
#####################################################################
#### CLEAN UP & AGGREGATE THE DATA ##################################
#####################################################################
#####################################################################
#####################################################################
#####################################################################
#### CLEAN UP & AGGREGATE THE DATA ##################################
#####################################################################
#####################################################################
#####################################################################
#####################################################################

# filter out bad values
library(dplyr)
compiled <- filter(compiled, HRS.WORKED.1 > 0)
compiled <- filter(compiled, !is.na(DATE))

# manipulate dates
library(lubridate)
compiled$MONTH <- month(compiled$DATE)
compiled <- compiled[order(compiled$DATE),]

# gather hourly information & NUMBER OF EMPLOYEES
kc.night.hours <- aggregate(HRS.WORKED.1 ~ DATE, test, FUN=sum)
names(kc.night.hours) <- c("DATE", "TOTAL.HOURS.WORKED")
kc.avg.night.hours <- aggregate(HRS.WORKED.1 ~ DATE, test, FUN=mean)
names(kc.avg.night.hours) <- c("DATE", "AVG.HOURS.WORKED")
kc.employees.per.night <- aggregate(HRS.WORKED.1 ~ DATE, test, FUN=length)

# cases of std cases produced per day at kc
cases.produced.kc <- kcProduction2015
cases.produced.kc <- aggregate(TTL.Cs.splt ~ DATE, data=test1, FUN=sum)

# quick check 
max(cases.produced.kc$TTL.Cs.splt)


# Read in data on production by type of case (kc and stl, be sure to segregate)
setwd("C:/Users/pmwash/Desktop/R_Files")
cases.file <- "labor_model_cases_produced_KC_STL_by_type.xlsx"

#
beerCases <- readWorksheetFromFile(cases.file, sheet=1, 
                                   startRow=1, startCol=1)
beer.cases.kc <- filter(beerCases, WAREHOUSE == "KANSAS CITY")
###

wineCases <- readWorksheetFromFile(cases.file, sheet=3, 
                                   startRow=1, startCol=1)
wine.cases.kc <- filter(wineCases, WAREHOUSE == "KANSAS CITY")
###

liquorCases <- readWorksheetFromFile(cases.file, sheet=2, 
                                     startRow=1, startCol=1)
liquor.cases.kc <- filter(liquorCases, WAREHOUSE == "KANSAS CITY")
#
naCases <- readWorksheetFromFile(cases.file, sheet=4, 
                                 startRow=1, startCol=1)
na.cases.kc <- filter(naCases, WAREHOUSE == "KANSAS CITY")
###
all.cases.kc <- merge(beer.cases.kc, wine.cases.kc, by=c("DATE", "WAREHOUSE"))
all.cases.kc <- merge(all.cases.kc, liquor.cases.kc, by=c("DATE", "WAREHOUSE"))
all.cases.kc <- merge(all.cases.kc, na.cases.kc, by=c("DATE", "WAREHOUSE"))
all.cases.kc$DATE <- as.character(strptime(all.cases.kc$DATE, "%Y-%m-%d"))
### ### ### ###


# Compile total bottles 
total.bottles.kc <- aggregate(Btls ~ DATE, data=kcProduction2015, FUN=sum)
names(total.bottles.kc) <- c("DATE", "BOTTLES.KC")



#setwd(home)
#write.csv(compiled, "compiled_labormodel_kc.csv")

########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ MERGE DATA IN DAY OBSERVATION UNITS #######
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ MERGE DATA IN DAY OBSERVATION UNITS #######
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ MERGE DATA IN DAY OBSERVATION UNITS #######
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ MERGE DATA IN DAY OBSERVATION UNITS #######
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ MERGE DATA IN DAY OBSERVATION UNITS #######
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ MERGE DATA IN DAY OBSERVATION UNITS #######
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ MERGE DATA IN DAY OBSERVATION UNITS #######


omega.kc <- kc.night.hours
omega.kc <- merge(omega.kc, kc.avg.night.hours, by="DATE")
omega.kc <- merge(omega.kc, kc.inflows, by="DATE")
omega.kc <- merge(omega.kc, cases.produced.kc, by="DATE") 
omega.kc <- merge(omega.kc, kc.employees.per.night, by="DATE")
omega.kc <- merge(omega.kc, all.cases.kc, by="DATE")
omega.kc <- merge(omega.kc, total.bottles.kc, by="DATE")

#names(omega.kc) <- c("DATE", "TOTAL.HOURS.WORKED", "AVG.HOURS.WORKED", "INVENTORY.INFLOWS",
                     #"TOTAL.CASES.PRODUCED.KC", "NUMBER.OF.EMPLOYEES")

View(omega.kc)
head(omega.kc)
tail(omega.kc)
str(omega.kc)

#setwd("C:/Users/pmwash/Desktop/R_Files")
#write.csv(omega.kc, "OMEGA_BACKUP_KC.csv")

omega.kc$WEEKDAY <- wday(omega.kc$DATE, label=TRUE)
omega.kc <- filter(omega.kc, TOTAL.CASES.PRODUCED.KC > 6000)


omega.kc$MONTH <- month(omega.kc$DATE, label=F)
month <- omega.kc$MONTH

# Derive seasons from months
library(lubridate)
omega.kc$SEASON <- ifelse(month==1 | month==2 |month==3, "Winter", 
                       ifelse(month==4 | month==5 | month==6, "Spring",
                              ifelse(month==7 | month==8 | month==9, "Summer",
                                     ifelse(month==10 | month==11 | month==12, "Fall", ""))))


# If needed only!
#omega.kc <- read.csv("OMEGA_BACKUP_KC.csv", header=TRUE)
head(omega.kc)




########################################################################################################
########################################################################################################
############################################## FIT A MODEL #############################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################## FIT A MODEL #############################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################## FIT A MODEL #############################################
########################################################################################################
########################################################################################################



# Regression model on total cases alone
fit <- lm(TOTAL.HOURS.WORKED ~ TOTAL.CASES.PRODUCED.KC, data=omega.kc)
summary(fit)


# Try treating cases as individual groups
fit <- lm(TOTAL.HOURS.WORKED ~ BEER.STD.CASES + WINE.STD.CASES + LIQUOR.STD.CASES + NA.STD.CAESS, data=omega.kc)
summary(fit)


# Try cases and bottles ... adds only .25% explanatory power
fit <- lm(TOTAL.HOURS.WORKED ~ TOTAL.CASES.PRODUCED.KC + BOTTLES.KC, data=omega.kc)
summary(fit)



# Add in inventory inflows  ... adds no explanatory power
fit <- lm(TOTAL.HOURS.WORKED ~ TOTAL.CASES.PRODUCED.KC + INVENTORY.INFLOWS, data=omega.kc)
summary(fit)




plot(omega.kc$TOTAL.HOURS.WORKED ~ omega.kc$TOTAL.CASES.PRODUCED.KC)
plot(omega.kc$INVENTORY.INFLOWS ~ omega.kc$TOTAL.CASES.PRODUCED.KC)
g <- ggplot(data=omega.kc, aes(x=TOTAL.CASES.PRODUCED.KC, y=TOTAL.HOURS.WORKED))
g + geom_point() + geom_smooth(aes(group=1), method="lm", se=T)









outliers <- filter(omega.kc, TOTAL.CASES.PRODUCED.KC > 15000)



########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ GRAPHICS ##################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ GRAPHICS ##################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ GRAPHICS ##################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
########################################################################################################
############################################################ GRAPHICS ##################################
















