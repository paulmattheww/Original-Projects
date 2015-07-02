# File Pre-Processing 
  # Prior to running this script do the custom sort 
  # Sort by EmpSSN then by Relationship; custom sort Emp Sp Child
  # Delete redundant lines (eg. same person listed multiple times)

# Set working directory
setwd("C:/Users/pwashburn/Downloads")

# Read in data
Guardian<-read.csv("Guardian_Suntrup_06012015-06282015_Export.csv",
                   header=TRUE,stringsAsFactors=FALSE,na.strings="NA")

# Make all characters in Coventry object upper case
Guardian<-data.frame(lapply(Guardian, function(v) {
  if (is.character(v)) return(toupper(v))
  else return (v)
}))

# Remove dashes from SSN and Phone Numbers
Guardian$Employee.SSN<-gsub("-","",Guardian$Employee.SSN)
Guardian$Work.Phone<-gsub("-","",Guardian$Work.Phone)
Guardian$Home.Phone<-gsub("-","",Guardian$Home.Phone)

# Create new columns for filler 
col<-Guardian$Hourly.Rate
for(i in col)
    Guardian$Fill.1<- NA
    Guardian$Fill.2<- NA
    Guardian$Fill.3<- NA
    Guardian$Fill.4<- NA
    Guardian$Fill.5<- NA
    Guardian$Fill.6<- NA
    Guardian$Fill.7<- NA
    Guardian$Fill.8<- NA
Guardian$Fill.1<-ifelse(is.na(Guardian$Fill.1)," "," ")
Guardian$Fill.2<-ifelse(is.na(Guardian$Fill.2)," "," ")
Guardian$Fill.3<-ifelse(is.na(Guardian$Fill.3)," "," ")
Guardian$Fill.4<-ifelse(is.na(Guardian$Fill.4)," "," ")
Guardian$Fill.5<-ifelse(is.na(Guardian$Fill.5)," "," ")
Guardian$Fill.6<-ifelse(is.na(Guardian$Fill.6)," "," ")
Guardian$Fill.7<-ifelse(is.na(Guardian$Fill.7)," "," ")
Guardian$Fill.8<-ifelse(is.na(Guardian$Fill.8)," "," ")

# Add gender to Relationship per Guardian specifications
Guardian$Relationship..No.Codes.<-ifelse(Guardian$Relationship..No.Codes.=="EMPLOYEE","M",
       ifelse(Guardian$Relationship..No.Codes.=="SPOUSE" & Guardian$Gender == "M","H",
              ifelse(Guardian$Relationship..No.Codes.=="SPOUSE" & Guardian$Gender == "F","W",
                     ifelse(Guardian$Relationship..No.Codes.=="CHILD" & Guardian$Gender == "M","S","D"))))

# Replace periods in Address and City
Guardian$Home.Address.1<-gsub("\\.|/|\\-","",Guardian$Home.Address.1)
Guardian$City<-gsub("\\.|/|\\-","",Guardian$City)

# Hours per week get rid of NAs
Guardian$Hours.Per.Week<-ifelse(!is.na(Guardian$Hours.Per.Week),Guardian$Hours.Per.Week,"")

#### BELOW STILL NEEDS WORK
  # Transform Reason.for.Change column into Guardian codes; 
  # LA=Leave of Absence, MD=Member Death, TE=Terminated, AD=Adoption, BR=Birth, MR=Marriage, DI=Divorce, OT=Other, CB=Cobra, ST=State
Guardian$Reason.for.Change<-ifelse(Guardian$Reason.for.Change=="TERMINATION","TE",
                                   ifelse(Guardian$Reason.for.Change=="BIRTH","BR",
                                          ifelse(Guardian$Reason.for.Change=="MARRIAGE","MR",
                                                 ifelse(Guardian$Reason.for.Change=="DIVORCE","DI",
                                                        ifelse(Guardian$Reason.for.Change=="COBRA","CO","OT")))))

# Change Time.Status..No.Codes. column A=Active, T=Terminated, R=Retired
Guardian$Time.Status..No.Codes.<-ifelse(Guardian$Time.Status..No.Codes.=="FULL TIME SALARY","A",
       ifelse(Guardian$Time.Status..No.Codes.=="PART TIME","A",
              ifelse(Guardian$Time.Status..No.Codes.=="TERMINATED","T","R")))

# Drop all columns that are not necessary and arrange by Guardian standards
  # This part is good only through Termination Date; columns got shuffled for some reason
GuardianDf<-data.frame(Guardian)
keeps<-names(GuardianDf) %in% c("Employee.SSN","Last.Name","First.Name","Middle.Initial","Relationship..No.Codes.",
                                "Date.of.Birth","Gender","Marital.Status","Fill.1","Fill.2","Home.Address.1","City","State",
                                "Zip","Work.Email","Work.Phone","Hire.Date","Hours.Per.Week","Employment.Status..No.Codes.",
                                "Termination.Date","Reason.for.Change","Fill.3","Salary","Location","Tobacco.User..No.Codes.",
                                "Fill.4","Fill.5","Fill.6","Fill.7","Fill.8","Benefit.Plan.Type","Coverage.Effective.Date",
                                "Benefit.Class.Name")     ##ARE THERE ANYMORE WE NEED TO KEEP?
GuardianDf<-GuardianDf[keeps]

# Change Employment.Status..No.Codes. to format that Guardian wants 
  # A=Active; T=Terminated= R=Retired
GuardianDf$Employment.Status..No.Codes.<- ifelse(GuardianDf$Employment.Status..No.Codes.=="ACTIVE","A",
       ifelse(GuardianDf$Employment.Status..No.Codes.=="RETIRED","R","T"))

# Create columns that turn the type of policy into a factor-like Y or N field per Guardian's requirements
  # Add Effective Date after each policy
dat<-GuardianDf$Coverage.Effective.Date
dat<-as.character(dat)
type<-GuardianDf$Benefit.Plan.Type

GuardianDf$Dental.Elected<-ifelse(type=="DENTAL","Y","N")
GuardianDf$Dental.Eff.Date<-ifelse(GuardianDf$Dental.Elected=="Y",dat," ")

GuardianDf$Basic.Employee.Life.Elected<-ifelse(GuardianDf$Benefit.Plan.Type=="BASIC EMPLOYEE LIFE","Y","N")
GuardianDf$Basic.Life.Eff.Date<-ifelse(GuardianDf$Basic.Employee.Life.Elected=="Y",dat," ")

GuardianDf$Voluntary.Child.Life.Elected<-ifelse(GuardianDf$Benefit.Plan.Type=="VOLUNTARY CHILD LIFE","Y","N")
GuardianDf$Vol.Child.Life.Eff.Date<-ifelse(GuardianDf$Voluntary.Child.Life.Elected=="Y",dat," ")

# Marital status codes don't matter for Guardian
dat<-GuardianDf$Marital.Status
for(i in dat)
    GuardianDf$Marital.Status<- NA
GuardianDf$Marital.Status<-ifelse(is.na(GuardianDf$Marital.Status)," "," ")

# Get rid of unnecessary NA values in various columns 
GuardianDf$Work.Phone<-ifelse(is.na(GuardianDf$Work.Phone)," "," ")


#### View(GuardianDf,"TEST")
#### TURN PLAN TYPES INTO COLUMNS --> to be continued

# Write to CSV
write.csv(GuardianDf,file="guardianOutput.csv")
#library(xlsx)
#write.xlsx(GuardianDf,"Guardian_ChgReport_Output.xlsx")


#### STILL NEED TO CONSOLIDATE ROWS IF THE SAME NAME APPEARS MORE THAN ONCE WITHOUT DEPENDENTS
    # Highlight the 2nd through Nth row with duplicate first last and relationship code in Yellow
    # Copy over the coverage dates and check Y or N for the coverages elected
    # Delete the yellow columns
    # Write =if() loops in Excel under all life types -- in future copy directly into script
    # Then query the elections (Y or N) and input the volume and effective date 


