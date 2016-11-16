## Shipping Labor Prediction Model

library(dplyr)
library(ggplot2)
library(scales)

labor_model = 'C:/Users/pmwash/Desktop/Re-Engineered Reports/Projects/Shipping Labor Prediction Model/Labor Prediction Model Data.csv'

monthly_data = read.csv(labor_model, header=TRUE)
monthly_data = monthly_data %>% filter(Year %in% c(2015, 2016))


plot(monthly_data$Production.Days, monthly_data$Cases.Delivered)

print('Check production days')
p = ggplot(data=monthly_data, aes(x=Production.Days, y=Night.Ship.Hours, group=House))
p + geom_point(aes(colour=House)) + 
  facet_wrap(~House, scales='free') +
  geom_smooth(method='lm',aes(group=House)) +
  scale_y_continuous(labels=comma)


print('Check cases')
p = ggplot(data=monthly_data, aes(x=Cases.Delivered, y=Night.Ship.Hours, group=House))
p + geom_point(aes(colour=factor(Production.Days), size=Production.Days)) + 
  facet_wrap(~House, scales='free') +
  geom_smooth(method='lm',aes(group=House)) +
  scale_y_continuous(labels=comma) +
  scale_x_continuous(labels=comma)


print('Check the most intuitive model')
model = lm(Night.Ship.Hours ~ House + Cases.Delivered + Production.Days, data=monthly_data)
summary(model)


print('Check for collinearity')
summary(lm(Cases.Delivered ~ Production.Days, data=monthly_data))





print('Check all variables')
print('Check the most intuitive model')
model = lm(Night.Ship.Hours ~ Cases.Delivered +  House + Average.Stops.per.Day + Production.Days + Std.Cases.Sold, data=monthly_data, groups=House)
summary(model)



names(monthly_data)


