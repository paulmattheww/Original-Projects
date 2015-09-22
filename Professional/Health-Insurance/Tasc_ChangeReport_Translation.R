
# Tasc FSA translation script 
print("
FIRST! make Sure that 
1. Dates are mm/dd/yyyy
2. Prepend Dependent code with a 0 as 0#
3. Ensure all columns are accounted for coming out of Bswift
4. ENSURE TO PULL GROUP SUFFIX 3 for the ben plan name
")

setwd("C:/Users/pwashburn/Desktop/Input")

# Read in data
print("Reading in the File.") 
Tasc<-read.csv("07142015_Tasc_WestBros_Export.csv",
                   header=TRUE,stringsAsFactors=FALSE,na.strings="NA")

# Sort the data by SSN and dependent SSN
#Tasc <- Tasc[order(Tasc$Employee.SSN,Tasc$Social.Security.Number),]

# Change "Employee" to "Self" under Relationship column
print("Changing 'Employee' to 'Self' per Tasc's requirements.")
rel<-Tasc$Relationship..No.Codes.
Tasc$Relationship..No.Codes.<-ifelse(rel=="Employee","Self",rel)
rel<-Tasc$Relationship..No.Codes.

# Create column called Dependent Code 
print("Coding dependent codes per Tasc's requirements.")
Tasc$Dependent.Code<-ifelse(rel=="Self","00",
                            ifelse(rel=="Spouse","01",
                                   ifelse(rel=="Child","02","03")))
Tasc$Dependent.Code<-formatC(Tasc$Dependent.Code,width=2,flag="0")
Tasc$Dependent.Code<-as.character(Tasc$Dependent.Code)

# Code student per Tasc's requirements
stu<-Tasc$Full.Time.Student..No.Codes.
Tasc$Full.Time.Student..No.Codes.<-ifelse(stu=="Yes","1","0")

# Create new columns for filler 
print("Creating filler columns.")
col<-Tasc$Termination.Date
for(i in col)
    Tasc$FILLER<- NA
Tasc$FILLER<-ifelse(is.na(Tasc$FILLER)," "," ")

# Change Tasc plan to either A or B (A is $1500 deductible, B is $2600 deductible)
Tasc$Benefit.Plan.Name <- ifelse(grepl("PLANA",Tasc$Group.Suffix.3),"A",
                                 ifelse(grepl("PLANB",Tasc$Group.Suffix.3),"B"," "))

# Populate "Cobra enrollment date" new column 
ben<-Tasc$Benefit.Class.Date
Tasc$Cobra.Enrollment.Date<-ifelse(Tasc$Employment.Status..No.Codes.=="COBRA",ben," ")






# If rehire date is not null then populate hire date with that date

# Delete coverage.termination.date past 5 years in future
#dat<-Tasc$Coverage.Termination.Date
#Tasc$Coverage.Termination.Date<-ifelse(dat > as.Date("1/1/2020")," ",dat)

# Put columns in same order as the Guardian spreadsheet
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




# Make all characters in Coventry object upper case
print("Converting to Upper Case.")
Tasc<-data.frame(lapply(Tasc, function(v) {
    if (is.character(v)) return(toupper(v))
    else return (v)
}))

# Write to CSV
print("Writing file to CSV.")
write.csv(Tasc,file="output_TASC.csv")




