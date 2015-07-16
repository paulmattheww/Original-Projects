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
Guardian<-read.csv("07142015_Guardian_Intox_Export.csv",
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
    Guardian$FILLER<- NA
    Guardian$FILLER<-ifelse(is.na(Guardian$FILLER)," "," ")
    

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
                                                        ifelse(Guardian$Reason.for.Change=="COBRA ACTIVATION","CO","OT")))))

# Add columns necessary
print("Adding columns to match Guardian spreadsheet.")
dat<-Guardian$Coverage.Effective.Date
dat<-as.character(dat)
type<-Guardian$Benefit.Plan.Type
amt<-as.character(Guardian$Coverage.Amount.1)
desc<-as.character(Guardian$Group.Suffix.4)

Guardian$Dental.Elected<-ifelse(type=="DENTAL","Y","N")
Guardian$Dental.Eff.Date<-ifelse(Guardian$Dental.Elected=="Y",dat," ")
Guardian$Dental.Description<-ifelse(Guardian$Dental.Elected=="Y",desc," ")

Guardian$Basic.Employee.Life.Elected<-ifelse(type=="BASIC EMPLOYEE LIFE" | type=="ACCIDENT TIER BASED","Y","N")
Guardian$Basic.Life.Eff.Date<-ifelse(Guardian$Basic.Employee.Life.Elected=="Y",dat," ")
Guardian$Basic.Life.Coverage.Amount<-ifelse(Guardian$Basic.Employee.Life.Elected=="Y",amt," ")
Guardian$Basic.Life.Description<-ifelse(Guardian$Basic.Employee.Life.Elected=="Y",desc," ")

Guardian$Voluntary.Employee.Life.Elected<-ifelse(type=="VOLUNTARY EMPLOYEE LIFE" | type=="VOLUNTARY SPOUSAL LIFE (INDIVIDUAL)","Y","N")
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
Guardian$Vision.Description<-ifelse(Guardian$Vision.Elected=="Y",desc," ")

Guardian$Cancer.Elected<-ifelse(type=="CANCER","Y","N")
Guardian$Cancer.Eff.Date<-ifelse(Guardian$Cancer.Elected=="Y",dat," ")
Guardian$Cancer.Descriptor<-ifelse(Guardian$Cancer.Elected =="Y",desc," ")

Guardian$STD.Elected<-ifelse(type=="SHORT TERM DISABILITY","Y","N")
Guardian$STD.Eff.Date<-ifelse(Guardian$STD.Elected=="Y",dat," ")
Guardian$STD.Coverage.Amount<-ifelse(Guardian$STD.Elected =="Y",amt," ")

# Combine spouse and child voluntary selections
spouse<-Guardian$Voluntary.Spousal.Life.Elected
kid<-Guardian$Voluntary.Child.Life.Elected
Guardian$Dep.Life.Selected<-ifelse(spouse == "Y" | kid == "Y", "Y", "N")

# Combine Dependent and Spouse effective dates using an or statement
Guardian$Dep.Life.Eff.Date<-ifelse(spouse == "Y" | kid == "Y",dat," ")


# Get rid of dates far in future 
#ifelse(Guardian$Coverage.Termination.Date > Sys.Date() + 5000, " ",Guardian$Coverage.Termination.Date)

# Remove NA values from Salary, ... 

# Change Time.Status..No.Codes. column A=Active, T=Terminated, R=Retired
print("Swapping codes for Time Status per Guardian's specs.")
Guardian$Time.Status..No.Codes.<-ifelse(Guardian$Time.Status..No.Codes.=="FULL TIME SALARY","A",
                                        ifelse(Guardian$Time.Status..No.Codes.=="PART TIME","A",
                                               ifelse(Guardian$Time.Status..No.Codes.=="TERMINATED","T","R")))

# Change Tobacco.User.Code {M, W, H, D, S} to {M, S, B, N} member spouse both neither
#####rel<-Guardian$Relationship..No.Codes.
#####ifelse(rel=="M" & Guardian$Tobacco.User..No.Codes.=="Y",)

# Populate "Cobra enrollment date" new column 
ben<-as.character(Guardian$Benefit.Class.Date)
Cobra.Enrollment.Date<-ifelse(Guardian$Reason.for.Change=="CO",ben," ")
Guardian<-cbind(Guardian,Cobra.Enrollment.Date)




### Data manipulation done above this line, below is formatting etc
# Create new data frame from Guardian object
# Drop all columns that are not necessary 
print("Dropping unnecessary columns and saving to new data frame.")
GuardianDf<-data.frame(Guardian)
keeps<-names(GuardianDf) %in% c("Employee.SSN","Last.Name","First.Name","Middle.Initial","Relationship..No.Codes.",
                                "Date.of.Birth","Gender","Marital.Status","FILLER","Home.Address.1","City","State",
                                "Zip","Work.Email","Work.Phone","Hire.Date","Hours.Per.Week","Employment.Status..No.Codes.",
                                "Coverage.Termination.Date","Reason.for.Change","Salary",
                                "Location","Tobacco.User..No.Codes.",
                                "Dental.Elected","Dental.Eff.Date","Vision.Elected","Vision.Eff.Date",
                                "Basic.Employee.Life.Elected","Basic.Life.Eff.Date","Voluntary.Child.Life.Elected",
                                "Vol.Child.Life.Eff.Date","Benefit.Plan.Type","Coverage.Effective.Date","Benefit.Class.Name",
                                "Cancer.Elected","Cancer.Eff.Date","Voluntary.Spousal.Life.Elected",
                                "Voluntary.Spousal.Life.Eff.Date","Voluntary.Spousal.Life.Coverage.Amount",
                                "Voluntary.Employee.Life.Elected","Voluntary.Employee.Life.Eff.Date",
                                "Voluntary.Employee.Life.Coverage.Amount","Voluntary.Spousal.Life.Coverage.Amount",
                                "Voluntary.Child.Life.Coverage.Amount","Basic.Life.Coverage.Amount","Benefit.Class.SubCode1",
                                "Group.Suffix.4","Dental.Description","Benefit.Class.SubCode1","Benefit.Class.Code",
                                "Vision.Description","Basic.Life.Description","Dep.Life.Selected",
                                "Dep.Life.Eff.Date","Cancer.Descriptor","Cobra.Enrollment.Date",
                                "STD.Elected","STD.Eff.Date","STD.Coverage.Amount")      ##ARE THERE ANYMORE WE NEED TO KEEP?
GuardianDf<-GuardianDf[keeps]

# Put columns in same order as the Guardian spreadsheet
print("Ordering the columns per Guardian's specifications")
orderColumns <- c("Employee.SSN","Last.Name","First.Name","Middle.Initial",
                  "Relationship..No.Codes.",
                  "Date.of.Birth","Gender","Marital.Status","FILLER","FILLER",
                  "Home.Address.1","City","State",
                  "Zip","Work.Email","Work.Phone","Hire.Date",
                  "Hours.Per.Week","Employment.Status..No.Codes.",
                  "Coverage.Termination.Date","Reason.for.Change","FILLER","Salary",
                  "FILLER","Benefit.Class.Code","Location",
                  "Tobacco.User..No.Codes.",
                  "FILLER","FILLER","FILLER","FILLER","FILLER",
                  "Dental.Elected","Dental.Eff.Date","Dental.Description",
                  "FILLER","FILLER","Vision.Elected","Vision.Eff.Date","Vision.Description",
                  "FILLER","Basic.Employee.Life.Elected","Basic.Life.Description",
                  "Basic.Life.Coverage.Amount","Basic.Life.Eff.Date","FILLER","FILLER",
                  "Voluntary.Employee.Life.Elected","Voluntary.Employee.Life.Coverage.Amount",
                  "Voluntary.Employee.Life.Eff.Date","FILLER","Dep.Life.Selected","FILLER",
                  "Voluntary.Spousal.Life.Coverage.Amount","Voluntary.Child.Life.Coverage.Amount","Dep.Life.Eff.Date",
                  "FILLER","FILLER","FILLER","FILLER","FILLER","FILLER",
                  "FILLER","FILLER","FILLER",
                  "FILLER","FILLER","FILLER","FILLER","FILLER","FILLER",
                  "FILLER","FILLER","FILLER","FILLER","FILLER","FILLER","FILLER","FILLER",
                  "Cancer.Elected","Cancer.Descriptor","Cancer.Eff.Date",
                  "Benefit.Plan.Type","Coverage.Effective.Date","Benefit.Class.Name",
                  "Benefit.Class.SubCode1","Group.Suffix.4","Vision.Description",
                  "Dep.Life.Selected","Cobra.Enrollment.Date",
                  "STD.Elected","STD.Coverage.Amount","STD.Eff.Date") 
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
write.csv(GuardianDf,file="output_Guardian.csv")








print("STILL NEED TO CONSOLIDATE ROWS IF THE SAME NAME APPEARS MORE THAN ONCE WITHOUT DEPENDENTS
      Highlight the 2nd through Nth row with duplicate first last and relationship code in Yellow
      Copy over the coverage dates and check Y or N for the coverages elected 
      Delete the yellow columns
      Write =if() loops in Excel under all life types -- in future copy directly into script
      Then query the elections (Y or N) and input the volume and effective date" )


