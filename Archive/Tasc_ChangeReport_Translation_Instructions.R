---
title: "ChangeReport_Tasc_Translation_Instructions.Rmd"
author: "Paul M Washburn"
date: "July 20, 2015"
output: html_document
---

## Tasc Change Report Translation Script

### Data Pre-Processing.
For this script to work well, the input file must exhibit certain traits. 

1. The input file, which is the export from SBM, must be saved as a CSV file (NOT Excel).
2. Format all dates as mm/dd/yyyy, if they have not been formatted that way naturally via export.
3. Ensure all columns are accounted for coming out of Bswift
4. Ensure to pull Group Suffix 3, as well as all other necessary input columns. 
5. If the script fails at the "order columns" stage, this means that the input file did not have all the required columns exported from SBM. To fix this, you can always export ALL columns from SBM; the script will drop all unnecessary columns that were fed into it. 
6. BEFORE feeding in the CSV file, sort by Employee.SSN, then Relationship..No.Status. (custom sort of Employee, Spouse, Child), then First Name. This organizes the data for visual ease. You can write a macro to do this. 


Below, the setwd() command will tell R where the input file lives. Save the CSV export from SBM into the file path of your choice. The path of this folder must be put into the command below:
```{r}
setwd("C:/Users/pwashburn/Desktop/Input")
```

Export the data and save it to the above folder. Save these files with the following convention: "mmddyyyy_Tasc_COmpanyName_Export.csv". Read in the exported data from the above folder.
```{r}
print("Reading in the File.") 
Tasc<-read.csv("07142015_TascHRA_Pepsi_Export.csv",
                   header=TRUE,stringsAsFactors=FALSE,na.strings="NA")
```

Quick check to make sure data read in correctly. This command will tell you which columns were pulled in from SBM, their types, and give a quick example of their contents.
```{r}
str(Tasc)
```

### Data Manipulation per TASC's Requirements

The code in this section will change the data in format and coding. These simple changes take a lot of time to do by hand, and this will automate the process while taking out the human error. 

Tasc requires different language for Employees. Below, the code will change "Employee" to "Self" under the Relationship..No.Codes. 
```{r}
print("Changing 'Employee' to 'Self' per Tasc's requirements.")
rel<-Tasc$Relationship..No.Codes.
rel
Tasc$Relationship..No.Codes.<-ifelse(rel=="Employee","Self",rel)
rel<-Tasc$Relationship..No.Codes.
rel
```

Create column called Dependent Code per Tasc's requirements. 
```{r}
print("Coding dependent codes per Tasc's requirements.")
Tasc$Dependent.Code<-ifelse(rel=="Self","00",
                            ifelse(rel=="Spouse","01",
                                   ifelse(rel=="Child","02","03")))
Tasc$Dependent.Code<-formatC(Tasc$Dependent.Code,width=2,flag="0")
Tasc$Dependent.Code<-as.character(Tasc$Dependent.Code)
```

Tasc wants to know who is a full-time student and who is not. The following code will mark full time students as 0 or 1, per Tasc's requirements.
```{r}
stu<-Tasc$Full.Time.Student..No.Codes.
Tasc$Full.Time.Student..No.Codes.<-ifelse(stu=="Yes","1","0")
```

Further downstream in this script we will need a FILLER column to flesh out the spreadsheet to match its destination. This code will create new columns for filler.
```{r}
print("Creating filler columns.")
col<-Tasc$Coverage.Termination.Date
for(i in col)
    Tasc$FILLER<- NA
Tasc$FILLER<-ifelse(is.na(Tasc$FILLER)," "," ")
```

Change Tasc plan to either A or B. This data is contained in Group.Suffix.3.
```{r}
Tasc$Benefit.Plan.Name <- ifelse(grepl("PLANA",Tasc$Group.Suffix.3),"A",
                                 ifelse(grepl("PLANB",Tasc$Group.Suffix.3),"B"," "))
```

It is important to tell Tasc if someone has elected Cobra. The code below will populate "Cobra.Enrollment.Date" as a new column. 
```{r}
ben<-Tasc$Benefit.Class.Date
Tasc$Cobra.Enrollment.Date<-ifelse(Tasc$Employment.Status..No.Codes.=="COBRA",ben," ")
```

Replace Hire.Date column with Re.Hire.Date if it exists, if not then keep it as it is.
```{r}
print("Replace hire date with rehire date if it exists. Print of rehire date to be sure.")
dat<-as.character(Tasc$Hire.Date)
redat<-as.character(Tasc$Re.Hire.Date)
redat
Tasc$Hire.Date<-ifelse(is.na(redat),dat,redat)
```

The destination spreadsheet will be in the order as follows. This code will put the columns in same order as the Guardian spreadsheet so pasting will be OK. 
```{r}
print("Ordering the columns per Tasc's specifications")
orderColumns <- c("Dependent.Code","Relationship..No.Codes.","Employee.SSN",
                  "Social.Security.Number","Full.Time.Student..No.Codes.",
                  "FILLER","FILLER","Work.Email","Last.Name","First.Name",
                  "Middle.Initial","Home.Address.1","City","State","Zip",
                  "Home.Phone","Cell.Phone","Date.of.Birth","Gender",
                  "Hire.Date","Coverage.Effective.Date","FILLER",
                  "FILLER","FILLER","FILLER","FILLER",
                  "Coverage.Termination.Date","FILLER","Coverage.Amount.1",
                  "Employee.Cost","Employer.Cost","Benefit.Plan.Name",
                  "Cobra.Enrollment.Date") 
Tasc<-Tasc[, orderColumns]
```

For readability, this code will make all characters in the data frame upper case.
```{r}
print("Converting to Upper Case.")
Tasc<-data.frame(lapply(Tasc, function(v) {
    if (is.character(v)) return(toupper(v))
    else return (v)
}))
```

There are NA values in the Middle.Initial column. This code will replace NA values with nothing.
```{r}
print("Getting rid of NA in Middle Initials column. Print MI to be sure correct.")
mid<-Tasc$Middle.Initial
mid
Tasc$Middle.Initial<-ifelse(is.na(mid),"",mid)
```

The code below will write all the above changes to a CSV document contained in the folder that you selected. 
```{r}
print("Writing file to CSV.")
write.csv(Tasc,file="output_TASC.csv")
```



