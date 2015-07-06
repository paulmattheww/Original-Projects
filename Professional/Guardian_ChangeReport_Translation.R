# Sort the file by SSN, Relationship {Emp, Sp, Ch}, FirstName
print("Ensure that file has been custom sorted by the Guardian Sort macro in Excel.")

# File Pre-Processing 
  # Prior to running this script do the custom sort 
  # Sort by EmpSSN then by Relationship (custom sort Emp Sp Child), then by FirstName
  # Delete redundant lines (eg. same person listed multiple times)

# Set working directory
setwd("C:/Users/pwashburn/Desktop/Input")

# Read in data
print("Reading in the File.")
Guardian<-read.csv("06012015-06282015_IWDG_ChangeReport.csv",
                   header=TRUE,stringsAsFactors=FALSE,na.strings="NA")


# Make all characters in Coventry object upper case
print("Converting to Upper Case.")
Guardian<-data.frame(lapply(Guardian, function(v) {
  if (is.character(v)) return(toupper(v))
  else return (v)
}))

# Remove dashes from SSN and Phone Numbers
print("Removing dashes from SSN and phone numbers.")
Guardian$Employee.SSN<-gsub("-","",Guardian$Employee.SSN)
Guardian$Work.Phone<-gsub("-","",Guardian$Work.Phone)
Guardian$Home.Phone<-gsub("-","",Guardian$Home.Phone)

# Create new columns for filler 
print("Creating filler columns.")
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
    Guardian$Fill.9<- NA
    Guardian$Fill.10<- NA
    Guardian$Fill.11<- NA
Guardian$Fill.1<-ifelse(is.na(Guardian$Fill.1)," "," ")
Guardian$Fill.2<-ifelse(is.na(Guardian$Fill.2)," "," ")
Guardian$Fill.3<-ifelse(is.na(Guardian$Fill.3)," "," ")
Guardian$Fill.4<-ifelse(is.na(Guardian$Fill.4)," "," ")
Guardian$Fill.5<-ifelse(is.na(Guardian$Fill.5)," "," ")
Guardian$Fill.6<-ifelse(is.na(Guardian$Fill.6)," "," ")
Guardian$Fill.7<-ifelse(is.na(Guardian$Fill.7)," "," ")
Guardian$Fill.8<-ifelse(is.na(Guardian$Fill.8)," "," ")
Guardian$Fill.9<-ifelse(is.na(Guardian$Fill.6)," "," ")
Guardian$Fill.10<-ifelse(is.na(Guardian$Fill.7)," "," ")
Guardian$Fill.11<-ifelse(is.na(Guardian$Fill.8)," "," ")

# Add gender to Relationship per Guardian specifications
print("Adding gender to relationship column, coding to Guardian standards.")
Guardian$Relationship..No.Codes.<-ifelse(Guardian$Relationship..No.Codes.=="EMPLOYEE","M",
       ifelse(Guardian$Relationship..No.Codes.=="SPOUSE" & Guardian$Gender == "M","H",
              ifelse(Guardian$Relationship..No.Codes.=="SPOUSE" & Guardian$Gender == "F","W",
                     ifelse(Guardian$Relationship..No.Codes.=="CHILD" & Guardian$Gender == "M","S","D"))))

# Replace periods in Address and City
print("Replacing periods and dashes in Address and City.")
Guardian$Home.Address.1<-gsub("\\.|/|\\-","",Guardian$Home.Address.1)
Guardian$City<-gsub("\\.|/|\\-","",Guardian$City)

# Hours per week get rid of NAs
print("Rid NAs from Hours per Week.")
Guardian$Hours.Per.Week<-ifelse(!is.na(Guardian$Hours.Per.Week),Guardian$Hours.Per.Week,"")

# Transform Reason.for.Change column into Guardian codes; 
# LA=Leave of Absence, MD=Member Death, TE=Terminated, AD=Adoption, BR=Birth, MR=Marriage, DI=Divorce, OT=Other, CB=Cobra, ST=State
print("Coding reason per Guardian specs.")
Guardian$Reason.for.Change<-ifelse(Guardian$Reason.for.Change=="TERMINATION","TE",
                                   ifelse(Guardian$Reason.for.Change=="BIRTH","BR",
                                          ifelse(Guardian$Reason.for.Change=="MARRIAGE","MR",
                                                 ifelse(Guardian$Reason.for.Change=="DIVORCE","DI",
                                                        ifelse(Guardian$Reason.for.Change=="COBRA","CO","OT")))))

# Add columns necessary
print("Adding columns to match Guardian spreadsheet.")
dat<-Guardian$Coverage.Effective.Date
dat<-as.character(dat)
type<-Guardian$Benefit.Plan.Type
amt<-as.character(Guardian$Coverage.Amount.1)

Guardian$Dental.Elected<-ifelse(type=="DENTAL","Y","N")
Guardian$Dental.Eff.Date<-ifelse(Guardian$Dental.Elected=="Y",dat," ")

Guardian$Basic.Employee.Life.Elected<-ifelse(type=="BASIC EMPLOYEE LIFE" | type=="ACCIDENT TIER BASED","Y","N")
Guardian$Basic.Life.Eff.Date<-ifelse(Guardian$Basic.Employee.Life.Elected=="Y",dat," ")
Guardian$Basic.Life.Coverage.Amount<-ifelse(Guardian$Basic.Employee.Life.Elected=="Y",amt," ")

Guardian$Voluntary.Employee.Life.Elected<-ifelse(type=="VOLUNTARY EMPLOYEE LIFE","Y","N")
Guardian$Voluntary.Employee.Life.Eff.Date<-ifelse(Guardian$Voluntary.Employee.Life.Elected=="Y",dat," ")
Guardian$Voluntary.Employee.Life.Coverage.Amount<-ifelse(Guardian$Voluntary.Employee.Life.Elected=="Y",amt," ")

Guardian$Voluntary.Spousal.Life.Elected<-ifelse(type=="VOLUNTARY SPOUSAL LIFE","Y","N")
Guardian$Voluntary.Spousal.Life.Eff.Date<-ifelse(Guardian$Voluntary.Spousal.Life.Elected=="Y",dat," ")
Guardian$Voluntary.Spousal.Life.Coverage.Amount<-ifelse(Guardian$Voluntary.Spousal.Life.Elected=="Y",amt," ")

Guardian$Voluntary.Child.Life.Elected<-ifelse(type=="VOLUNTARY CHILD LIFE","Y","N")
Guardian$Vol.Child.Life.Eff.Date<-ifelse(Guardian$Voluntary.Child.Life.Elected=="Y",dat," ")
Guardian$Voluntary.Child.Life.Coverage.Amount<-ifelse(Guardian$Voluntary.Child.Life.Elected=="Y",amt," ")

Guardian$Vision.Elected<-ifelse(type=="VISION","Y","N")
Guardian$Vision.Eff.Date<-ifelse(Guardian$Vision.Elected=="Y",dat," ")

Guardian$Cancer.Elected<-ifelse(type=="CANCER","Y","N")
Guardian$Cancer.Eff.Date<-ifelse(Guardian$Cancer.Elected=="Y",dat," ")

# Change Time.Status..No.Codes. column A=Active, T=Terminated, R=Retired
print("Swapping codes for Time Status per Guardian's specs.")
Guardian$Time.Status..No.Codes.<-ifelse(Guardian$Time.Status..No.Codes.=="FULL TIME SALARY","A",
       ifelse(Guardian$Time.Status..No.Codes.=="PART TIME","A",
              ifelse(Guardian$Time.Status..No.Codes.=="TERMINATED","T","R")))





# Create new data frame from Guardian object
# Drop all columns that are not necessary 
print("Dropping unnecessary columns and saving to new data frame.")
GuardianDf<-data.frame(Guardian)
keeps<-names(GuardianDf) %in% c("Employee.SSN","Last.Name","First.Name","Middle.Initial","Relationship..No.Codes.",
                                "Date.of.Birth","Gender","Marital.Status","Fill.1","Fill.2","Home.Address.1","City","State",
                                "Zip","Work.Email","Work.Phone","Hire.Date","Hours.Per.Week","Employment.Status..No.Codes.",
                                "Termination.Date","Reason.for.Change","Fill.3","Salary","Fill.9","Fill.10","Location","Tobacco.User..No.Codes.",
                                "Fill.4","Fill.5","Fill.6","Fill.7","Fill.8","Dental.Elected","Dental.Eff.Date","Fill.11","Vision.Elected","Vision.Eff.Date",
                                "Basic.Employee.Life.Elected","Basic.Life.Eff.Date","Voluntary.Child.Life.Elected",
                                "Vol.Child.Life.Eff.Date","Benefit.Plan.Type","Coverage.Effective.Date","Benefit.Class.Name",
                                "Cancer.Elected","Cancer.Eff.Date","Voluntary.Spousal.Life.Elected",
                                "Voluntary.Spousal.Life.Eff.Date","Voluntary.Spousal.Life.Coverage.Amount",
                                "Voluntary.Employee.Life.Elected","Voluntary.Employee.Life.Eff.Date",
                                "Voluntary.Employee.Life.Coverage.Amount","Voluntary.Spousal.Life.Coverage.Amount",
                                "Voluntary.Child.Life.Coverage.Amount","Basic.Life.Coverage.Amount")      ##ARE THERE ANYMORE WE NEED TO KEEP?
GuardianDf<-GuardianDf[keeps]

# Put columns in same order as the Guardian spreadsheet
print("Ordering the columns per Guardian's specifications")
orderColumns <- c("Employee.SSN","Last.Name","First.Name","Middle.Initial","Relationship..No.Codes.",
                  "Date.of.Birth","Gender","Marital.Status","Fill.1","Fill.2","Home.Address.1","City","State",
                  "Zip","Work.Email","Work.Phone","Hire.Date","Hours.Per.Week","Employment.Status..No.Codes.",
                  "Termination.Date","Reason.for.Change","Fill.3","Salary",
                  "Fill.9","Fill.10","Location","Tobacco.User..No.Codes.",
                  "Fill.4","Fill.5","Fill.6","Fill.7","Fill.8","Dental.Elected","Dental.Eff.Date","Fill.11",
                  "Fill.1","Fill.2","Vision.Elected","Vision.Eff.Date","Fill.3",
                  "Fill.4","Basic.Employee.Life.Elected","Fill.5","Basic.Life.Coverage.Amount","Fill.6","Fill.6",
                  "Voluntary.Employee.Life.Elected","Voluntary.Employee.Life.Coverage.Amount",
                  "Voluntary.Employee.Life.Eff.Date","Voluntary.Child.Life.Elected","Fill.7","Voluntary.Spousal.Life.Elected",
                  "Voluntary.Spousal.Life.Coverage.Amount","Voluntary.Child.Life.Coverage.Amount",
                  "Voluntary.Spousal.Life.Eff.Date","Vol.Child.Life.Eff.Date","Fill.7",
                  "Fill.8","Fill.9","Fill.10","Fill.11","Fill.1","Fill.2","Fill.3","Fill.4",
                  "Fill.5","Basic.Life.Eff.Date","Fill.6","Fill.7","Fill.8","Fill.9",
                  "Fill.10","Fill.11","Fill.1","Fill.2","Fill.3","Fill.4","Fill.5","Fill.6","Fill.7",
                  "Cancer.Elected","Fill.8","Cancer.Eff.Date","Benefit.Plan.Type","Coverage.Effective.Date","Benefit.Class.Name",
                  "Benefit.Plan.Type","Coverage.Effective.Date","Benefit.Class.Name") 
GuardianDf <- GuardianDf[, orderColumns]

# Change Employment.Status..No.Codes. to format that Guardian wants 
  # A=Active; T=Terminated= R=Retired
print("Coding employment status to Guardian specs.")
GuardianDf$Employment.Status..No.Codes.<- ifelse(GuardianDf$Employment.Status..No.Codes.=="ACTIVE","A",
       ifelse(GuardianDf$Employment.Status..No.Codes.=="RETIRED","R","T"))

# Marital status codes don't matter for Guardian
print("Getting rid of NA values in Marital Status.")
dat<-GuardianDf$Marital.Status
for(i in dat)
    GuardianDf$Marital.Status<- NA
GuardianDf$Marital.Status<-ifelse(is.na(GuardianDf$Marital.Status)," "," ")

# Get rid of unnecessary NA values in various columns 
print("More NAs gettin' gone.")
GuardianDf$Work.Phone<-ifelse(is.na(GuardianDf$Work.Phone)," "," ")

# Create an Index for the dataset
print("Creating an index for the dataset.")
GuardianDf$Index<-paste(GuardianDf$Relationship..No.Codes.,GuardianDf$First.Name,GuardianDf$Last.Name,GuardianDf$Date.of.Birth,sep="_")

# Fix gender if it was all female it will all show up as False now
GuardianDf$Gender<-ifelse(GuardianDf$Gender == "FALSE" & GuardianDf$Gender != "F", "F","M")


# View(GuardianDf,"TEST")




# Write to CSV
print("Writing file to CSV.")
write.csv(GuardianDf,file="OUTPUT-GUARDIAN-CHANGEREPORT.csv")








print("STILL NEED TO CONSOLIDATE ROWS IF THE SAME NAME APPEARS MORE THAN ONCE WITHOUT DEPENDENTS
Highlight the 2nd through Nth row with duplicate first last and relationship code in Yellow
Copy over the coverage dates and check Y or N for the coverages elected 
Delete the yellow columns
Write =if() loops in Excel under all life types -- in future copy directly into script
Then query the elections (Y or N) and input the volume and effective date" )


