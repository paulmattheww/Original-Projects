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


strsplit(file_list[1], " ")
grep(pattern = "\\s\\d", x = file_list[1])
as.numeric(grepl(("[0-9]+"), file_list[1]))

library(stringr)
str_replace_all(file_list[1], "[^[:alnum:]]", " ")

unlist(strsplit(unlist(strsplit(file_list[1], split=" "))[3], split=".xls"))

january1 <- readWorksheetFromFile(file_list[1], sheet=2, startCol=3, colTypes='numeric')
january2 <- readWorksheetFromFile(file_list[2], sheet=2, startCol=3)
january3 <- readWorksheetFromFile(file_list[3], sheet=2, startCol=3)
january4 <- readWorksheetFromFile(file_list[4], sheet=2, startCol=3)
january5 <- readWorksheetFromFile(file_list[5], sheet=2, startCol=3)
january6 <- readWorksheetFromFile(file_list[6], sheet=2, startCol=3)
january7 <- readWorksheetFromFile(file_list[7], sheet=2, startCol=3)
january8 <- readWorksheetFromFile(file_list[8], sheet=2, startCol=3)
january9 <- readWorksheetFromFile(file_list[9], sheet=2, startCol=3)
january10 <- readWorksheetFromFile(file_list[10], sheet=2, startCol=3, colTypes='numeric')
january11 <- readWorksheetFromFile(file_list[11], sheet=2, startCol=3)
january12 <- readWorksheetFromFile(file_list[12], sheet=2, startCol=3)
january13 <- readWorksheetFromFile(file_list[13], sheet=2, startCol=3)
january14 <- readWorksheetFromFile(file_list[14], sheet=2, startCol=3)
january15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
january16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
january17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)

january1$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[1], split=" "))[3], split=".xls")), "%m-%d"))
january2$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[2], split=" "))[3], split=".xls")), "%m-%d"))
january3$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[3], split=" "))[3], split=".xls")), "%m-%d"))
january4$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[4], split=" "))[3], split=".xls")), "%m-%d")) 
january5$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[5], split=" "))[3], split=".xls")), "%m-%d"))
january6$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[6], split=" "))[3], split=".xls")), "%m-%d"))
january7$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[7], split=" "))[3], split=".xls")), "%m-%d")) 
january8$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[8], split=" "))[3], split=".xls")), "%m-%d")) 
january9$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[9], split=" "))[3], split=".xls")), "%m-%d"))
january10$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[10], split=" "))[3], split=".xls")), "%m-%d"))
january11$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[11], split=" "))[3], split=".xls")), "%m-%d"))
january12$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[12], split=" "))[3], split=".xls")), "%m-%d"))
january13$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[13], split=" "))[3], split=".xls")), "%m-%d"))
january14$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[14], split=" "))[3], split=".xls")), "%m-%d")) 
january15$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[15], split=" "))[3], split=".xls")), "%m-%d")) 
january16$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[16], split=" "))[3], split=".xls")), "%m-%d")) 
january17$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[17], split=" "))[3], split=".xls")), "%m-%d")) 

january2015 <- rbind(january1, january2, january3, january4, january5, january6, january7, january8, 
                     january9, january10, january11, january12, january13, january14, january15, january16,
                     january17)
january2015 <- filter(january2015, Driver != "Totals:")
january2015$Month.Year <- "01-2015"
View(january1)
# write.csv(january2015, "kc_january_backup.csv")

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

february1$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[1], split=" "))[3], split=".xls")), "%m-%d"))
february2$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[2], split=" "))[3], split=".xls")), "%m-%d"))
february3$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[3], split=" "))[3], split=".xls")), "%m-%d"))
february4$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[4], split=" "))[3], split=".xls")), "%m-%d")) 
february5$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[5], split=" "))[3], split=".xls")), "%m-%d"))
february6$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[6], split=" "))[3], split=".xls")), "%m-%d"))
february7$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[7], split=" "))[3], split=".xls")), "%m-%d")) 
february8$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[8], split=" "))[3], split=".xls")), "%m-%d")) 
february9$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[9], split=" "))[3], split=".xls")), "%m-%d"))
february10$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[10], split=" "))[3], split=".xls")), "%m-%d"))
february11$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[11], split=" "))[3], split=".xls")), "%m-%d"))
february12$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[12], split=" "))[3], split=".xls")), "%m-%d"))
february13$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[13], split=" "))[3], split=".xls")), "%m-%d"))
february14$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[14], split=" "))[3], split=".xls")), "%m-%d")) 
february15$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[15], split=" "))[3], split=".xls")), "%m-%d")) 
february16$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[16], split=" "))[3], split=".xls")), "%m-%d")) 

february2015 <- rbind(february1, february2, february3, february4, february5, february6, february7, february8, 
                      february9, february10, february11, february12, february13, february14, february15, february16)
february2015 <- filter(february2015, Driver != "Totals:")
february2015$Month.Year <- "02-2015"
View(february2015)

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


march1$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[1], split=" "))[3], split=".xls")), "%m-%d"))
march2$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[2], split=" "))[3], split=".xls")), "%m-%d"))
march3$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[3], split=" "))[3], split=".xls")), "%m-%d"))
march4$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[4], split=" "))[3], split=".xls")), "%m-%d")) 
march5$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[5], split=" "))[3], split=".xls")), "%m-%d"))
march6$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[6], split=" "))[3], split=".xls")), "%m-%d"))
march7$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[7], split=" "))[3], split=".xls")), "%m-%d")) 
march8$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[8], split=" "))[3], split=".xls")), "%m-%d")) 
march9$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[9], split=" "))[3], split=".xls")), "%m-%d"))
march10$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[10], split=" "))[3], split=".xls")), "%m-%d"))
march11$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[11], split=" "))[3], split=".xls")), "%m-%d"))
march12$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[12], split=" "))[3], split=".xls")), "%m-%d"))
march13$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[13], split=" "))[3], split=".xls")), "%m-%d"))
march14$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[14], split=" "))[3], split=".xls")), "%m-%d")) 
march15$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[15], split=" "))[3], split=".xls")), "%m-%d")) 
march16$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[16], split=" "))[3], split=".xls")), "%m-%d")) 
march17$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[17], split=" "))[3], split=".xls")), "%m-%d")) 
march18$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[18], split=" "))[3], split=".xls")), "%m-%d")) 

march2015 <- rbind(march1, march2, march3, march4, march5, march6, march7, march8, 
                   march9, march10, march11, march12, march13, march14, march15, march16,
                   march17, march18)
march2015 <- filter(march2015, Driver != "Totals:")
march2015$Month.Year <- "03-2015"
View(march2015)

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

april1$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[1], split=" "))[3], split=".xls")), "%m-%d"))
april2$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[2], split=" "))[3], split=".xls")), "%m-%d"))
april3$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[3], split=" "))[3], split=".xls")), "%m-%d"))
april4$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[4], split=" "))[3], split=".xls")), "%m-%d")) 
april5$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[5], split=" "))[3], split=".xls")), "%m-%d"))
april6$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[6], split=" "))[3], split=".xls")), "%m-%d"))
april7$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[7], split=" "))[3], split=".xls")), "%m-%d")) 
april8$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[8], split=" "))[3], split=".xls")), "%m-%d")) 
april9$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[9], split=" "))[3], split=".xls")), "%m-%d"))
april10$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[10], split=" "))[3], split=".xls")), "%m-%d"))
april11$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[11], split=" "))[3], split=".xls")), "%m-%d"))
april12$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[12], split=" "))[3], split=".xls")), "%m-%d"))
april13$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[13], split=" "))[3], split=".xls")), "%m-%d"))
april14$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[14], split=" "))[3], split=".xls")), "%m-%d")) 
april15$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[15], split=" "))[3], split=".xls")), "%m-%d")) 
april16$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[16], split=" "))[3], split=".xls")), "%m-%d")) 
april17$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[17], split=" "))[3], split=".xls")), "%m-%d")) 

april2015 <- rbind(april1, april2, april3, april4, april5, april6, april7, april8, 
                   april9, april10, april11, april12, april13, april14, april15, april16,
                   april17)
april2015 <- filter(april2015, Driver != "Totals:")
april2015$Month.Year <- "04-2015"
View(april2015)

rm(april1, april2, april3, april4, april5, april6, april7, april8, 
      april9, april10, april11, april12, april13, april14, april15, april16,
      april17)

#############################################################################
#############################################################################

print("THIS PART IS FOR may 2015")
path <- "N:/Daily Report/2015/KC/May 2015"
setwd(path)


file_list <- list.files() 
file_list
length(file_list)

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

may1$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[1], split=" "))[3], split=".xls")), "%m-%d"))
may2$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[2], split=" "))[3], split=".xls")), "%m-%d"))
may3$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[3], split=" "))[3], split=".xls")), "%m-%d"))
may4$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[4], split=" "))[3], split=".xls")), "%m-%d")) 
may5$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[5], split=" "))[3], split=".xls")), "%m-%d"))
may6$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[6], split=" "))[3], split=".xls")), "%m-%d"))
may7$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[7], split=" "))[3], split=".xls")), "%m-%d")) 
may8$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[8], split=" "))[3], split=".xls")), "%m-%d")) 
may9$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[9], split=" "))[3], split=".xls")), "%m-%d"))
may10$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[10], split=" "))[3], split=".xls")), "%m-%d"))
may11$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[11], split=" "))[3], split=".xls")), "%m-%d"))
may12$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[12], split=" "))[3], split=".xls")), "%m-%d"))
may13$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[13], split=" "))[3], split=".xls")), "%m-%d"))
may14$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[14], split=" "))[3], split=".xls")), "%m-%d")) 
may15$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[15], split=" "))[3], split=".xls")), "%m-%d")) 
may16$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[16], split=" "))[3], split=".xls")), "%m-%d")) 
may17$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[17], split=" "))[3], split=".xls")), "%m-%d")) 

may2015 <- rbind(may1, may2, may3, may4, may5, may6, may7, may8, 
                 may9, may10, may11, may12, may13, may14, may15, may16,
                 may17)
may2015 <- filter(may2015, Driver != "Totals:")
may2015$Month.Year <- "05-2015"
View(may2015)

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

june1$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[1], split=" "))[3], split=".xls")), "%m-%d"))
june2$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[2], split=" "))[3], split=".xls")), "%m-%d"))
june3$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[3], split=" "))[3], split=".xls")), "%m-%d"))
june4$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[4], split=" "))[3], split=".xls")), "%m-%d")) 
june5$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[5], split=" "))[3], split=".xls")), "%m-%d"))
june6$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[6], split=" "))[3], split=".xls")), "%m-%d"))
june7$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[7], split=" "))[3], split=".xls")), "%m-%d")) 
june8$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[8], split=" "))[3], split=".xls")), "%m-%d")) 
june9$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[9], split=" "))[3], split=".xls")), "%m-%d"))
june10$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[10], split=" "))[3], split=".xls")), "%m-%d"))
june11$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[11], split=" "))[3], split=".xls")), "%m-%d"))
june12$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[12], split=" "))[3], split=".xls")), "%m-%d"))
june13$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[13], split=" "))[3], split=".xls")), "%m-%d"))
june14$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[14], split=" "))[3], split=".xls")), "%m-%d")) 
june15$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[15], split=" "))[3], split=".xls")), "%m-%d")) 
june16$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[16], split=" "))[3], split=".xls")), "%m-%d")) 
june17$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[17], split=" "))[3], split=".xls")), "%m-%d")) 
june18$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[18], split=" "))[3], split=".xls")), "%m-%d")) 

june2015 <- rbind(june1, june2, june3, june4, june5, june6, june7, june8, 
                  june9, june10, june11, june12, june13, june14, june15, june16,
                  june17, june18)
june2015 <- filter(june2015, Driver != "Totals:")
june2015$Month.Year <- "06-2015"
View(june2015)

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

july1$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[1], split=" "))[3], split=".xls")), "%m-%d"))
july2$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[2], split=" "))[3], split=".xls")), "%m-%d"))
july3$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[3], split=" "))[3], split=".xls")), "%m-%d"))
july4$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[4], split=" "))[3], split=".xls")), "%m-%d")) 
july5$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[5], split=" "))[3], split=".xls")), "%m-%d"))
july6$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[6], split=" "))[3], split=".xls")), "%m-%d"))
july7$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[7], split=" "))[3], split=".xls")), "%m-%d")) 
july8$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[8], split=" "))[3], split=".xls")), "%m-%d")) 
july9$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[9], split=" "))[3], split=".xls")), "%m-%d"))
july10$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[10], split=" "))[3], split=".xls")), "%m-%d"))
july11$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[11], split=" "))[3], split=".xls")), "%m-%d"))
july12$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[12], split=" "))[3], split=".xls")), "%m-%d"))
july13$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[13], split=" "))[3], split=".xls")), "%m-%d"))
july14$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[14], split=" "))[3], split=".xls")), "%m-%d")) 
july15$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[15], split=" "))[3], split=".xls")), "%m-%d")) 
july16$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[16], split=" "))[3], split=".xls")), "%m-%d")) 
july17$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[17], split=" "))[3], split=".xls")), "%m-%d")) 
july18$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[18], split=" "))[3], split=".xls")), "%m-%d")) 
july19$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[19], split=" "))[3], split=".xls")), "%m-%d")) 
july20$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[20], split=" "))[3], split=".xls")), "%m-%d")) 

july2015 <- rbind(july1, july2, july3, july4, july5, july6, july7, july8, 
                  july9, july10, july11, july12, july13, july14, july15, july16,
                  july17, july18, july19, july20)
july2015 <- filter(july2015, Driver != "Totals:")
july2015$Month.Year <- "07-2015"
View(july2015)

rm(july1, july2, july3, july4, july5, july6, july7, july8, 
      july9, july10, july11, july12, july13, july14, july15, july16,
      july17, july18, july19, july20)

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
august15 <- readWorksheetFromFile(file_list[15], sheet=2, startCol=3)
august16 <- readWorksheetFromFile(file_list[16], sheet=2, startCol=3)
august17 <- readWorksheetFromFile(file_list[17], sheet=2, startCol=3)

august1$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[1], split=" "))[3], split=".xls")), "%m-%d"))
august2$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[2], split=" "))[3], split=".xls")), "%m-%d"))
august3$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[3], split=" "))[3], split=".xls")), "%m-%d"))
august4$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[4], split=" "))[3], split=".xls")), "%m-%d")) 
august5$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[5], split=" "))[3], split=".xls")), "%m-%d"))
august6$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[6], split=" "))[3], split=".xls")), "%m-%d"))
august7$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[7], split=" "))[3], split=".xls")), "%m-%d")) 
august8$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[8], split=" "))[3], split=".xls")), "%m-%d")) 
august9$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[9], split=" "))[3], split=".xls")), "%m-%d"))
august10$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[10], split=" "))[3], split=".xls")), "%m-%d"))
august11$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[11], split=" "))[3], split=".xls")), "%m-%d"))
august12$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[12], split=" "))[3], split=".xls")), "%m-%d"))
august13$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[13], split=" "))[3], split=".xls")), "%m-%d"))
august14$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[14], split=" "))[3], split=".xls")), "%m-%d")) 
august15$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[15], split=" "))[3], split=".xls")), "%m-%d")) 
august16$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[16], split=" "))[3], split=".xls")), "%m-%d")) 
august17$DATE <- as.character(strptime(unlist(strsplit(unlist(strsplit(file_list[17], split=" "))[3], split=".xls")), "%m-%d")) 


august2015 <- rbind(august1, august2, august3, august4, august5, 
                    august6, august7, august8, august9, august10, 
                    august11, august12, august13, august14, august15, august16, august17)
august2015 <- filter(august2015, Driver != "Totals:")
august2015$Month.Year <- "08-2015"
View(august2015)

rm(august1, august2, august3, august4, august5, 
      august6, august7, august8, august9, august10, 
      august11, august12, august13, august14, august15, august16, august17)

####################################################################################
####################################################################################

# Compile files together spreadsheets one data frame and clean data
kcProduction2015 <- rbind(january2015, february2015, march2015,
                        april2015, may2015, june2015,
                        july2015, august2015)

# Sort data frame by date
kcProduction2015 <- kcProduction2015[order(kcProduction2015), ]

kcProduction2015$Month.Year <- as.factor(kcProduction2015$Month.Year)
levels(kcProduction2015$Month.Year)

kcProduction2015 <- kcProduction2015[,c(42,1:41)]

kcProduction2015$Year <- 
  substr(kcProduction2015$Month.Year, 4, 7)
kcProduction2015$Month <-
  substr(kcProduction2015$Month.Year, 0, 2)


View(kcProduction2015)
write.csv(kcProduction2015, file="kcProduction2015_01-08_DAILYREPORT.csv")





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
compiled <- rbind(comiplied, april)
head(compiled)
tail(compiled)
swd
#write.csv(compiled, "compiled_KC_backup_april.csv")


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
                  may16)
compiled <- rbind(compiled, may)
head(compiled)
tail(compiled)
#write.csv(compiled, "compiled_KC_backup_may.csv")


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
  as.character(strptime(june1$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june1
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
  as.character(strptime(june2$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june2
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
  as.character(strptime(june3$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june3
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
  as.character(strptime(june4$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june4
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
  as.character(strptime(june5$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june5
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
  as.character(strptime(june6$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june6
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
  as.character(strptime(june7$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june7
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
  as.character(strptime(june8$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june8
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
  as.character(strptime(june9$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june9
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
  as.character(strptime(june10$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june10
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
  as.character(strptime(june11$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june11
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
  as.character(strptime(june12$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june12
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
  as.character(strptime(june13$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june13
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
  as.character(strptime(june14$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june14
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
  as.character(strptime(june15$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june15
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
  as.character(strptime(june16$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
june16
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
                  june16)
compiled <- rbind(compiled, june)
head(compiled)
tail(compiled)
#write.csv(compiled, "compiled_KC_backup_june.csv")



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
  as.character(strptime(july1$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july1
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
  as.character(strptime(july2$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july2
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
  as.character(strptime(july3$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july3
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
  as.character(strptime(july4$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july4
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
  as.character(strptime(july5$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july5
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
  as.character(strptime(july6$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july6
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
  as.character(strptime(july7$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july7
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
  as.character(strptime(july8$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july8
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
  as.character(strptime(july9$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july9
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
  as.character(strptime(july10$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july10
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
  as.character(strptime(july11$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july11
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
  as.character(strptime(july12$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july12
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
  as.character(strptime(july13$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july13
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
  as.character(strptime(july14$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july14
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
  as.character(strptime(july15$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july15
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
  as.character(strptime(july16$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
july16
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
                  july16)
compiled <- rbind(compiled, july)
head(compiled)
tail(compiled)
#write.csv(compiled, "compiled_KC_backup_july.csv")



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
  as.character(strptime(august1$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august1
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
  as.character(strptime(august2$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august2
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
  as.character(strptime(august3$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august3
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
  as.character(strptime(august4$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august4
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
  as.character(strptime(august5$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august5
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
  as.character(strptime(august6$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august6
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
  as.character(strptime(august7$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august7
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
  as.character(strptime(august8$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august8
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
  as.character(strptime(august9$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august9
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
  as.character(strptime(august10$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august10
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
  as.character(strptime(august11$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august11
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
  as.character(strptime(august12$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august12
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
  as.character(strptime(august13$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august13
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
august14
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
  as.character(strptime(august15$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august15
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
  as.character(strptime(august16$DATE, "%m-%d"))

print("Combined dataset for this day is below.")
august16
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
head(compiled)
tail(compiled)
#write.csv(compiled, "compiled_KC_backup_august.csv")



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

library(xlsx)
path = "N:/Pending Shipments"
setwd(path)
wb <- loadWorkbook("Pending Shipments.xlsx")
sheets <- getSheets(wb)



list.files(path, pattern="\\.xlsx$", full.names=TRUE)

for(i in 1:length(file.names)){
  file <- read.table(file.names[i],header=TRUE, sep=";", stringsAsFactors=FALSE)
  out.file <- rbind(out.file, file)
}


for (i in 1:length(filenames)){
  tmp<-loadWorkbook(file.path(filenames[i],sep=""))
  lst<- readWorksheet(tmp, 
                      sheet = getSheets(tmp), startRow=5, startCol=1, header=TRUE)}




























