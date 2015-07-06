# Read in data
Coventry<-read.csv("INPUT_TEST.csv",
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

# Check Member Status and put into either CO, DE, or EL


# Write to CSV
write.csv(Coventry,file="OUTPUT_CoVENTRY.csv")

















