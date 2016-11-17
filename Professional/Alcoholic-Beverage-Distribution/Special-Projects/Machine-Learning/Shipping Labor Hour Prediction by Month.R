## Shipping Labor Prediction Model

library(dplyr)
library(ggplot2)
library(scales)
library(caret)
library(plotly)

labor_model = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Projects/Shipping Labor Prediction Model/Labor Prediction Model Data.csv'

monthly_data_all = read.csv(labor_model, header=TRUE)
monthly_data = monthly_data %>% filter(Year %in% c(2015, 2016))

# control = trainControl(method="repeatedcv", number=10, repeats=3)
# train(Night.Ship.Hours~., data=monthly_data, method="lvq", preProcess="scale", trControl=control)
# importance = varImp()



head(monthly_data_all)
tail(monthly_data)





print('Plot the model we are testing for Labor Hours @ Night')
p = ggplot(data=monthly_data, aes(x=Cases.Delivered, y=Night.Ship.Hours, group=House))
p + geom_point(aes(colour=factor(OND), size=Production.Days)) + 
  facet_wrap(~House, scales='free') +
  geom_smooth(method='lm',aes(group=House)) +
  scale_y_continuous(labels=comma) +
  scale_x_continuous(labels=comma) +
  theme(legend.position='bottom')


print('Check the most intuitive model')
model = lm(Night.Ship.Hours ~ House + Cases.Delivered + Production.Days + OND, data=monthly_data)
summary(model)










# QTY DEMANDED MODEL OF STD CASES SOLD AS FN OF GP HOUSE AND PRODUCTION DAY S
demand_model = lm(Std.Cases.Sold ~ Mark.Up + House + Production.Days, data=monthly_data_all) #Gross.Proft..Percent
summary(demand_model)

summary(demand_model)$coefficients[2]


print('Plot the demand model as fn of house and GP%')
p = ggplot(data=monthly_data_all, aes(x=Mark.Up, y=Std.Cases.Sold, group=House, label=Month))
DEMAND_PLOT = p + geom_point(aes(colour=factor(Oct_Dec), size=Production.Days)) + 
  facet_wrap(~House, scales='free') +
  geom_smooth(method='lm',aes(group=House), alpha=0.5, colour='black', se=F) +
  scale_y_continuous(labels=comma) +
  scale_x_continuous(labels=percent) +
  theme(legend.position='bottom') +
  labs(title='Demand (Std Cases) as a function of % Mark-up on Cost & Production Days')
ggplotly(DEMAND_PLOT)









# PRODUCTION MODEL AS FN OF CASES SOLD
production_model = lm(Cases.Delivered ~ Std.Cases.Sold, data=monthly_data) #Gross.Proft..Percent
summary(production_model)

p = ggplot(data=monthly_data, aes(x=Std.Cases.Sold, y=Cases.Delivered, group=House, label=Month))
PRODUCTION_PLOT = p + geom_point(aes(colour=factor(Oct_Dec), size=Production.Days)) + 
  facet_wrap(~House, scales='free') +
  geom_smooth(method='lm',aes(group=House), alpha=0.5, colour='black', se=F) +
  scale_y_continuous(labels=comma) +
  scale_x_continuous(labels=comma) +
  theme(legend.position='bottom') +
  labs(title='Case Production as a function of Cases Sold')
ggplotly(PRODUCTION_PLOT)








print('Check collinearity')
summary(lm(Gross.Proft..Percent ~ House + Production.Days, data=monthly_data))
summary(lm(Production.Days ~ House + Gross.Proft..Percent, data=monthly_data))


print('Check all other factors')
summary(lm(Cases.Delivered ~ House + Average.Stops.per.Day + Production.Days + OND, data=monthly_data))
















# Below were just checks for statistical verazity



print('Check production days')
p = ggplot(data=monthly_data, aes(x=Production.Days, y=Night.Ship.Hours, group=House))
p + geom_point(aes(colour=House)) + 
  facet_wrap(~House, scales='free') +
  geom_smooth(method='lm',aes(group=House)) +
  scale_y_continuous(labels=comma)




print('Check for collinearity')
summary(lm(Cases.Delivered ~ Production.Days, data=monthly_data))



head(monthly_data)
stl = monthly_data %>% filter(House=='STL')
pairs(stl[,c(5:9,12:15)])




print('Check all variables')
print('Check the most intuitive model')
model = lm(Night.Ship.Hours ~ Cases.Delivered +  House + Average.Stops.per.Day + Production.Days + Std.Cases.Sold, data=monthly_data, groups=House)
summary(model)



head(monthly_data)


