source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')
library(RODBC)
library(dplyr)
library(ggplot2)
library(plotly)
library(ggvis)
library(gridExtra)
library(car)


#Determine invoices per customer
as400_db = 'N:/Operations Intelligence/Data/Staging/STaging-Database.accdb'
as400_odbc = odbcConnectAccess2007(as400_db)

sls = sqlQuery(as400_odbc, "SELECT WSFILE002_MTC1CI.[#MIVDT], WSFILE002_MTC1CI.[#MIVND], WSFILE002_MTC1CI.[#MCUS#], WSFILE002_MTC1CI.[#MCUSY], 
                                    WSFILE002_MTC1CI.[#MEXT$], WSFILE002_MTC1CI.[#MQTYS], WSFILE002_MTC1CI.[#MQPC], WSFILE002_MTC1CI.[#MLIN#]
                            FROM WSFILE002_MTC1CI
                            WHERE ((WSFILE002_MTC1CI.[#MIVDT] BETWEEN 1150601 And 1160601) AND ((WSFILE002_MTC1CI.[#MTRCD])='B'));")

names(sls) = c('Date', 'Invoice', 'CustomerID', 'CustomerType', 'Ext$', 'QtySold', 'QPC', 'Line')
headTail(sls, 20)




invoices_per_customer_day = aggregate(Invoice ~ CustomerID + Date, data=sls, FUN=countUnique)
headTail(invoices_per_customer_day)

lines_per_customer_day = aggregate(Line ~ CustomerID + Date, data=sls, FUN=countUnique)

avg_invoices_per_customer_day = aggregate(Invoice ~ CustomerID, data=invoices_per_customer_day, FUN=countUnique)
avg_invoices_per_customer_day = avg_invoices_per_customer_day %>% arrange(desc(Invoice)); headTail(avg_invoices_per_customer_day)

avg_lines_per_customer_day = aggregate(Line ~ CustomerID, data=lines_per_customer_day, FUN=countUnique)
avg_lines_per_customer_day = avg_lines_per_customer_day %>% arrange(desc(Line)); headTail(avg_lines_per_customer_day)


#Summarize lines and invoices per day (avgs)
customer_invoice_summary = merge(avg_invoices_per_customer_day, avg_lines_per_customer_day, by='CustomerID', all=TRUE)
customer_invoice_summary = customer_invoice_summary %>% arrange(desc(Invoice))
headTail(customer_invoice_summary)







#Find avg service times by customer
kc_stops = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Integrating Data/Route-Stop-Time-KC/route_stop_kc.csv', header=TRUE)
head(kc_stops); tail(kc_stops)
kc_stops$Date = factor(as.character(strptime(kc_stops$Date, "%m/%d/%Y")))

avg_service_time_kc = aggregate(ServiceTime ~ CustomerID, data=kc_stops, FUN=function(x) round(mean(x)))



#Merge in KC stop data for comparison/statistics
kc_customers = merge(customer_invoice_summary, avg_service_time_kc, all.y=TRUE, by='CustomerID')
headTail(kc_customers)



#Merge in relevant customer information
as400_db = 'N:/Operations Intelligence/Data/Staging/STaging-Database.accdb'
as400_odbc = odbcConnectAccess2007(as400_db)
cus = sqlQuery(as400_odbc, "SELECT [CCUST#], [CCUSTN], [CCTYPE], [CSLYTD], [CONPRM] FROM WSFILE002_CUS2")
close(as400_odbc)

names(cus) = c('CustomerID', 'Customer', 'CustomerType', 'CasesYTD', 'OnPremise')
headTail(cus)


kc_customers = merge(kc_customers, cus, by='CustomerID', all.x=TRUE)
headTail(kc_customers)

prs = kc_customers[, c(2:4, 6:8)]
prs$CustomerType = factor(prs$CustomerType)


#Explore principal components
library(GGally)
ggpairs(prs, colour=prs$CustomerType)




#Categorize customers based on table in AS400
kc_customers = kc_customers %>% filter(ServiceTime < 300)
typ = kc_customers$CustomerType
kc_customers$CustomerType = ifelse(typ == 'A', 'Bar/Tavern', 
                                   ifelse(typ == 'C', 'Country Club', 
                                          ifelse(typ=='E', 'Transportation/Airline',
                                                 ifelse(typ=='G', 'Gambling', 
                                                        ifelse(typ=='J', 'Hotel/Motel',
                                                               ifelse(typ=='L', 'Restaurant', 
                                                                      ifelse(typ=='M', 'Military', 
                                                                             ifelse(typ=='N', 'Fine Dining',
                                                                                    ifelse(typ=='O', 'Internal', 
                                                                                           ifelse(typ=='P', 'Country/Western',
                                                                                                  ifelse(typ=='S', 'Package Store', 
                                                                                                         ifelse(typ=='T', 'Supermarket/Grocery',
                                                                                                                ifelse(typ=='V', 'Drug Store',
                                                                                                                       ifelse(typ=='Y', 'Convenience Store', 
                                                                                                                              ifelse(typ=='Z', 'Catering',
                                                                                                                                     ifelse(typ=='3', 'Night Club', 
                                                                                                                                            ifelse(typ=='5', 'Adult Entertainment', 
                                                                                                                                                   ifelse(typ=='6', 'Sports Bar', 
                                                                                                                                                          ifelse(typ=='I', 'Church', 
                                                                                                                                                                 ifelse(typ=='F', 'Membership Club', 
                                                                                                                                                                        ifelse(typ=='B', 'Mass Merchandiser', 
                                                                                                                                                                               ifelse(typ=='H', 'Fraternal Organization', 
                                                                                                                                                                                      ifelse(typ=='7', 'Sports Venue', 'OTHER')))))))))))))))))))))))

#filter(kc_customers, CustomerType=='Membership Club')
#filter(kc_customers, CustomerType=='Supermarket/Grocery')


typ = kc_customers$CustomerType
kc_customers$MembershipClub = ifelse(typ=='Membership Club', 1, 0)
kc_customers$GrocerySupermarket = ifelse(typ=='Supermarket/Grocery', 1, 0)





# check models for significance
model = lm(ServiceTime ~ Invoice, data=kc_customers)
model2 = lm(ServiceTime ~ Line, data=kc_customers)
model3 = lm(ServiceTime ~ CustomerType, data=kc_customers)
model4 = lm(ServiceTime ~ Line + MembershipClub + GrocerySupermarket, data=kc_customers)
summary(model)
summary(model2)
summary(model3)
summary(model4)




# validate model4 using training and test set
library(caret)
set.seed(123)
ind = sample(seq_len(nrow(kc_customers)), size=0.7*nrow(kc_customers))
training = kc_customers[ind, ]
testing = kc_customers[-ind, ]

training_model = lm(ServiceTime ~ Line + MembershipClub + GrocerySupermarket, data=kc_customers) #swapped back in kc_customers from training
summary(training_model)

predictive_model = function(line, membershipclub, grocerysupermarket) {
  intercept = 5.2328 #summary(training_model)$coefficients[1]
  beta_1 = 0.6899994 #summary(training_model)$coefficients[2]
  beta_2 = 111.1432 #summary(training_model)$coefficients[3]
  beta_3 = 5.758228 #summary(training_model)$coefficients[4]
  
  service_time = intercept + beta_1*line + beta_2*membershipclub + beta_3*grocerysupermarket
  service_time
}


testing$PredictedServiceTime = predictive_model(training_model, testing)
testing$Error = testing$PredictedServiceTime - testing$ServiceTime

hist(sqrt(testing$Error ** 2)); sqrt(testing$Error ** 2)






# Impute service time predictions back into Roadnet database using above equation and data 
library(RODBC)
roadnet_db = 'N:/Operations Intelligence/Data/Operations Database.accdb'
roadnet_odbc = odbcConnectAccess2007(roadnet_db)
customers = sqlQuery(roadnet_odbc, "SELECT * FROM Customers")
close(roadnet_odbc)


library(stringr)
customers$ShipFlag = str_pad(as.character(customers$ShipFlag), width=7, pad="0")

headTail(customer_invoice_summary); headTail(customers)
customers_new = merge(customers, customer_invoice_summary, by='CustomerID', all.x=TRUE); headTail(customers_new)


# Add in categories
as400_db = 'N:/Operations Intelligence/Data/Staging/STaging-Database.accdb'
as400_odbc = odbcConnectAccess2007(as400_db)
cus = sqlQuery(as400_odbc, "SELECT [CCUST#], [CCTYPE] FROM WSFILE002_CUS2")
close(as400_odbc)




customers_new$ServiceTimePredicted = predictive_model(line=customers_new$Line, membershipclub=customers_new, grocerysupermarket=)






















# histogram of n invoices per day by customer

# library(scales)
# ggplotly(ggplot(testing, aes(x=ServiceTime)) + geom_density(aes(fill=CustomerType)) + 
#            facet_wrap(MembershipClub ~ GrocerySupermarket)) 


kc_customers %>% ggvis(~Invoice) %>% 
  layer_histograms(
    width = input_slider(1, 10, step=1, value=3, label='Binwidth Adjustment (Number of Invoices/Day)'), fill := "#fff8dc") %>%
  add_axis("x", title = "Avg Number of Invoices per Day by Customer") %>%
  add_axis("y", title = "Bin Count") %>%
  add_axis("x", orient = "top", ticks = 0, title = "Avg Number of Invoices per Day by Customer, June 1, 2015 - June 1, 2016",
           properties = axis_props(
             axis = list(stroke = "white"),
             labels = list(fontSize = 14))) %>%
  set_options(width = 1000, height = 900)



kc_customers %>% ggvis(~Line) %>% 
  layer_histograms(
    width = input_slider(1, 10, step=1, value=3, label='Binwidth Adjustment (Number of Invoice Lines/Day)'), fill := "#58FAAC") %>%
  add_axis("x", title = "Avg Number of Invoice Lines per Day by Customer") %>%
  add_axis("y", title = "Bin Count") %>%
  add_axis("x", orient = "top", ticks = 0, title = "Avg Number of INVOICE LINES per Day by Customer, June 1, 2015 - June 1, 2016",
           properties = axis_props(
             axis = list(stroke = "white"),
             labels = list(fontSize = 14))) %>%
  set_options(width = 700, height = 600)




kc_customers %>% ggvis(~ServiceTime) %>% 
  layer_histograms(
    width = input_slider(1, 90, step=5, value=5, label='Binwidth Adjustment (Number of Service Minutes/Customer/Day)'), fill := "#F5A9BC") %>%
  add_axis("x", title = "Avg Number of Minutes to Service Customer per Day by Customer") %>%
  add_axis("y", title = "Bin Count") %>%
  add_axis("x", orient = "top", ticks = 0, title = "Avg Daily Service Time (Minutes) by Customer",
           properties = axis_props(
             axis = list(stroke = "white"),
             labels = list(fontSize = 14))) %>%
  set_options(width = 750, height = 600)




kc_customers %>% ggvis(x = ~Line, y = ~ServiceTime) %>% 
  layer_points(fill := "#58FAAC") %>%
  layer_smooths() %>%
  add_axis("x", title = "Avg Number of Invoice Lines per Day by Customer") %>%
  add_axis("y", title = "Avg Daily Service Time (Minutes)") %>%
  add_axis("x", orient = "top", ticks = 0, title = "Service Time as function of Avg Number of Invoice Lines/Customer/Day",
           properties = axis_props(
             axis = list(stroke = "white"),
             labels = list(fontSize = 14))) %>%
  set_options(width = 600, height = 600) 
 


kc_customers %>% ggvis(x = ~Invoice, y = ~ServiceTime) %>% 
  layer_points(fill := "#B4045F") %>%
  layer_smooths() %>%
  add_axis("x", title = "Avg Number of Invoices per Day by Customer") %>%
  add_axis("y", title = "Avg Daily Service Time (Minutes)") %>%
  add_axis("x", orient = "top", ticks = 0, title = "Service Time as function of Number of Invoices/Customer/Day",
           properties = axis_props(
             axis = list(stroke = "white"),
             labels = list(fontSize = 14))) %>%
  set_options(width = 600, height = 600) 




kc_customers %>% ggvis(x = ~CasesYTD, y = ~ServiceTime) %>% 
  layer_points(fill := "#F2F5A9") %>%
  layer_smooths() %>%
  add_axis("x", title = "YTD Cases Sold by Customer") %>%
  add_axis("y", title = "Avg Daily Service Time (Minutes)") %>%
  add_axis("x", orient = "top", ticks = 0, title = "Service Time as function of YTD Sales",
           properties = axis_props(
             axis = list(stroke = "white"),
             labels = list(fontSize = 14))) %>%
  set_options(width = 600, height = 600) 





a %>% ggvis(~Line, ~OnPremise, fill = ~Freq) %>% 
  layer_rects(width = band(), height = band()) %>%
  add_axis("x", title = "xxx") %>%
  add_axis("y", title = "xxx") %>%
  add_axis("x", orient = "top", ticks = 0, title = "xxxxx",
           properties = axis_props(
             axis = list(stroke = "white"),
             labels = list(fontSize = 14))) %>%
  set_options(width = 700, height = 600)



# %>%
#   add_tooltip(function(x) paste0("Wt: ", Invoice, "<br>"), "hover") 

  
  
  
  
  #add_tooltip(CustomerID, "hover")

odbcCloseAll()






















