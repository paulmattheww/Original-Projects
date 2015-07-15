# Read in data
setwd("C:/Users/pwashburn/Desktop/Input")
Coventry<-read.csv("07142015_Coventry_WestBros_Export.csv",
                   header=TRUE,stringsAsFactors=FALSE)

# Make all characters in Coventry object upper case
Coventry<-data.frame(lapply(Coventry, function(v) {
  if (is.character(v)) return(toupper(v))
  else return (v)
}))

# Remove dashes from SSN and Phone Numbers
Coventry$Social.Security.Number<-gsub("-","",Coventry$Social.Security.Number)
Coventry$Employee.SSN<-gsub("-","",Coventry$Employee.SSN)
Coventry$Work.Phone<-gsub("-","",Coventry$Work.Phone)
Coventry$Home.Phone<-gsub("-","",Coventry$Home.Phone)

# Replace periods in ClientName, Address and City
Coventry$Client.Name<-gsub("\\.|/|\\-","",Coventry$Client.Name)
Coventry$Home.Address.1<-gsub("\\.|/|\\-","",Coventry$Home.Address.1)
Coventry$City<-gsub("\\.|/|\\-","",Coventry$City)

# Replace Relationship..No.Codes. with Coventry standardized language 
Coventry$Relationship..No.Codes.<-ifelse(Coventry$Relationship..No.Codes.=="EMPLOYEE",15,ifelse(Coventry$Relationship..No.Codes.=="SPOUSE",8,7))

#### Below is not perfect, above works fine.

# Replace Change.Type with standardized Coventry language
Coventry$Change.Type<-ifelse(Coventry$Change.Type=="ENDING COVERAGE" & Coventry$Relationship..No.Codes.=="15","TS",ifelse(Coventry$Change.Type=="NEW ENROLLEE","NH","999"))

# Remove all Dates that are in the future

# Add today's date to Proc Dt field
dat<-Sys.Date()
Coventry$Proc.Dt<-format(dat,format="%m%d%Y")

# Re-format all dates dates to match mmddyyyy
print("Re-formatting dates to mmddyyyy. Make sure they are imported as short dates in Excel.")
dat<-Coventry$Date.of.Birth
dat<-as.Date(dat,"%m/%d/%Y")
Coventry$Date.of.Birth<-format(dat,format="%m%d%Y")

dat<-Coventry$Coverage.Termination.Date
dat<-as.Date(dat,"%m/%d/%Y")
Coventry$Coverage.Termination.Date<-format(dat,format="%m%d%Y")

dat<-Coventry$Hire.Date
dat<-as.Date(dat,"%m/%d/%Y")
Coventry$Hire.Date<-format(dat,format="%m%d%Y")

dat<-Coventry$Re.Hire.Date
dat<-as.Date(dat,"%m/%d/%Y")
Coventry$Re.Hire.Date<-format(dat,format="%m%d%Y")

# Create new blank columns for filler 
print("Creating filler columns.")
col<-Coventry$Middle.Initial
for(i in col)
    Coventry$FILLER<- NA
Coventry$FILLER<-ifelse(is.na(Coventry$FILLER)," "," ")

# Code Reason for Change column per Coventry specs
print("Coding Reason For Change column per Coventry specs.")
res<-Coventry$Reason.for.Change
rel<-Coventry$Relationship..No.Codes.
Coventry$Reason.for.Change<-ifelse(grepl("TERMINATION",res) & rel==15,"TS",
                                   ifelse(grepl("NEW HIRE",res),"NH",
                                          ifelse(grepl("OPEN ENROLLMENT",res),"OE",
                                                 ifelse(grepl("NEW GROUP",res),"NG",
                                                        ifelse(grepl("QUALIFYING EVENT",res),"QE",
                                                                     ifelse(grepl("TERMINATION",res) & rel<15,"TD",
                                                                            ifelse(grepl("NAME CHANGE",res),"NC",
                                                                                   ifelse(grepl("ADDRESS CHANGE",res),"AC",
                                                                                          ifelse(grepl("PCP",res),"PC","OT")))))))))


# Check Member Status and put into either CO, DE, or EL
print("Re-code member status per Coventry specs. Figure out what Cobra would be coded as, as well as deceased (neither are rep'd")
status<-Coventry$Employment.Status
Coventry$Employment.Status<-ifelse(status == 1,"EL"," ")

# Put columns in order
print("Ordering the columns per Guardian's specifications")
orderColumns <- c("Proc.Dt","Client.Name","FILLER","FILLER","Last.Name",
                  "First.Name","Middle.Initial","FILLER",
                  "Social.Security.Number","Employee.SSN","Gender",
                  "Date.of.Birth","Marital.Status..No.Codes.",
                  "Home.Address.1","FILLER","City","State","Zip",
                  "FILLER","FILLER","FILLER","FILLER",
                  "FILLER","FILLER","FILLER","FILLER",
                  "FILLER","FILLER","Cost.Tier.Effective.Date",
                  "Coverage.Termination.Date","Reason.for.Change",
                  "Medical.Group.Number","FILLER","Employment.Status",
                  "Relationship..No.Codes.","FILLER","FILLER","FILLER",
                  "Hire.Date","Tobacco.User..No.Codes.","Work.Email")
Coventry<-Coventry[,orderColumns]


# Write to CSV
write.csv(Coventry,file="output_Coventry.csv")



print("note, at least these fields must be selected for export
      Client Name	Medical Group Number	Last Name	First Name	Middle Initial	Employee SSN	Social Security Number	Gender	Date of Birth	Marital Status (No Codes)	Home Address 1	Home Address 2	City	State	Zip	Cost/Tier Effective Date	Coverage Termination Date	Reason for Change	Location Sub Code 1	Relationship (No Codes)	Employment Status	Hire Date	Tobacco User (No Codes)	Work Email	Work Phone	Home Phone	Re-Hire Date	Benefit Plan Name	Change Type
")













