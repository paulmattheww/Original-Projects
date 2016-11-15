print('pw_polines')
library(ggplot2)
library(plotly)
library(scales)
library(dplyr)
library(zoo)

print('Below comes from a python script that processes pw_polines query.')
poline_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/Summary By Month & Warehouse.csv', header=TRUE)



kpi_summary = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/Quarterly KPI Meeting Tracking.csv', header=TRUE)
kpi_summary$Month = factor(kpi_summary$Month, levels=c('January','February','March','April','May','June','July','August','September'))

kpi_summary = data.frame(kpi_summary %>% group_by(Year, House) %>%
  mutate(YTD_Cases= cumsum(Cases),  
         Cases_3_Month_Rolling_Avg=rollapply(Cases, width=3, FUN=mean, align='right', na.rm=T, fill=NA),
         Cases_6_Month_Rolling_Avg=rollapply(Cases, width=6, FUN=mean, align='right', na.rm=T, fill=NA),
         YTD_Breakage=cumsum(Breakage), 
         Breakage_3_Month_Rolling_Avg=rollapply(Breakage, width=3, FUN=mean, align='right', na.rm=T, fill=NA),
         Breakage_6_Month_Rolling_Avg=rollapply(Breakage, width=6, FUN=mean, align='right', na.rm=T, fill=NA),
         YTD_Stops=cumsum(Total.Stops),
         Stops_3_Month_Rolling_Avg=rollapply(Total.Stops, width=3, FUN=mean, align='right', na.rm=T, fill=NA),
         Stops_6_Month_Rolling_Avg=rollapply(Total.Stops, width=6, FUN=mean, align='right', na.rm=T, fill=NA),
         YTD_Night_Hours=cumsum(Night.Ship.Hours),
         Night_Hours_3_Month_Rolling_Avg=rollapply(Night.Ship.Hours, width=3, FUN=mean, align='right', na.rm=T, fill=NA),
         Night_Hours_6_Month_Rolling_Avg=rollapply(Night.Ship.Hours, width=6, FUN=mean, align='right', na.rm=T, fill=NA),
         CPMH_3_Month_Rolling_Avg=rollapply(CPMH...Adjusted, width=3, FUN=mean, align='right', na.rm=T, fill=NA),
         CPMH_6_Month_Rolling_Avg=rollapply(CPMH...Adjusted, width=6, FUN=mean, align='right', na.rm=T, fill=NA)))

poline_summary = data.frame(poline_summary %>% group_by(Year_Received, Warehouse) %>%
  mutate(YTD_PO_Lines= cumsum(PO_Lines),  
         PO_Lines_3_Month_Rolling_Avg=rollapply(PO_Lines, width=3, FUN=mean, align='right', na.rm=T, fill=NA),
         PO_Lines_6_Month_Rolling_Avg=rollapply(PO_Lines, width=6, FUN=mean, align='right', na.rm=T, fill=NA),
         YTD_Cases_Received= cumsum(Cases_Received),  
         Cases_Received_3_Month_Rolling_Avg=rollapply(Cases_Received, width=3, FUN=mean, align='right', na.rm=T, fill=NA),
         Cases_Received_6_Month_Rolling_Avg=rollapply(Cases_Received, width=6, FUN=mean, align='right', na.rm=T, fill=NA),
         YTD_Weight_Received= cumsum(Weight),  
         Weight_3_Month_Rolling_Avg=rollapply(Weight, width=3, FUN=mean, align='right', na.rm=T, fill=NA),
         Weight_6_Month_Rolling_Avg=rollapply(Weight, width=6, FUN=mean, align='right', na.rm=T, fill=NA)))



month = poline_summary$Month_Received
poline_summary$Month_Received = ifelse(month==1, 'January',
                                       ifelse(month==2,'February',
                                              ifelse(month==3,'March',
                                                     ifelse(month==4,'April',
                                                            ifelse(month==5,'May',
                                                                   ifelse(month==6,'June',
                                                                          ifelse(month==7,'July',
                                                                                 ifelse(month==8,'August',
                                                                                        'September'))))))))
poline_summary$Month_Received = factor(poline_summary$Month_Received, levels=c('January','February','March','April','May','June','July','August','September'))


head(poline_summary)
head(kpi_summary)


combined = merge(poline_summary, kpi_summary, by.x=c('Month_Received','Warehouse'),
                 by.y=c('Month','House'), all=TRUE)
head(combined)


correlation_matrix = kpi_summary[, c(4:8)]#combined[, c(4:8, 19:24)]
correlation_matrix = cor(correlation_matrix)

head(correlation_matrix)
names(kpi_summary)


library(Deducer)
library(GGally)

ggcorplot(cor.mat=correlation_matrix, line.method='lm', type='points')





panel.cor <- function(x, y, digits=2, cex.cor)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits=digits)[1]
  test <- cor.test(x,y)
  Signif <- ifelse(round(test$p.value,3)<0.050,"Significant at\n p < 0.050",paste("p=",round(test$p.value,3)))  
  text(0.5, 0.25, paste("r=",txt))
  text(.5, .75, Signif)
}

panel.smooth<-function (x, y, col = "blue", bg = NA, pch = 18, 
                        cex = 0.8, col.smooth = "red", span = 2/3, iter = 3, ...) 
{
  points(x, y, pch = pch, col = col, bg = bg, cex = cex)
  ok <- is.finite(x) & is.finite(y)
  if (any(ok)) 
    lines(stats::lowess(x[ok], y[ok], f = span, iter = iter), 
          col = col.smooth, ...)
}

panel.hist <- function(x, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col="cyan", ...)
}


stl = kpi_summary %>% filter(House=='STL')
stl = stl[, c(4:8)]
pairs(stl, lower.panel=panel.smooth, diag.panel=panel.hist, upper.panel=panel.cor, main='KPI Correlations in STL')


kc = kpi_summary %>% filter(House=='KC')
kc = kc[, c(4:8)]
pairs(kc, lower.panel=panel.smooth, diag.panel=panel.hist, upper.panel=panel.cor, main='KPI Correlations in KC')





scatterplotMatrix(stl, groups=TRUE, by.groups=TRUE)
scatterplotMatrix(kc, groups=TRUE, by.groups=TRUE)






#POLINES
p = ggplot(data=poline_summary, aes(x=factor(Month_Received), y=PO_Lines, group=Year_Received))
p + geom_point(aes(colour=Warehouse)) +
  geom_line(aes(colour=Warehouse)) +
  geom_line(aes(y=PO_Lines_3_Month_Rolling_Avg), colour='black', size=1, alpha=0.7) +
  geom_line(aes(y=PO_Lines_6_Month_Rolling_Avg), colour='red', size=1.75, alpha=0.7) +
  facet_grid(Warehouse ~ Year_Received, scales='free_y') +
  theme(legend.position='none', axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title='PO Lines Received by Month w/ 3-and-6-Month Rolling Averages', x='Month', y='PO Lines') +
  scale_y_continuous(labels=comma)

#POLINES YTD
p = ggplot(data=poline_summary, aes(x=factor(Month_Received), y=YTD_PO_Lines, group=Warehouse))
p + geom_line(aes(y=YTD_PO_Lines, colour=Warehouse), size=1, alpha=0.7) +
  geom_point(size=2, colour='black') +
  facet_wrap(~ Year_Received, scales='free_y') +
  theme(legend.position='bottom', axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title='YTD PO Lines Received', x='Month', y='PO Lines') +
  scale_y_continuous(labels=comma)






#POLINES
p = ggplot(data=poline_summary, aes(x=factor(Month_Received), y=Weight, group=Year_Received))
p + geom_point(aes(colour=Warehouse)) +
  geom_line(aes(colour=Warehouse)) +
  geom_line(aes(y=Weight_3_Month_Rolling_Avg), colour='black', size=1, alpha=0.7) +
  geom_line(aes(y=Weight_6_Month_Rolling_Avg), colour='red', size=1.75, alpha=0.7) +
  facet_grid(Warehouse ~ Year_Received, scales='free_y') +
  theme(legend.position='none', axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title='Weight (lbs) Received by Month w/ 3-and-6-Month Rolling Averages', x='Month', y='Pounds (lbs)') +
  scale_y_continuous(labels=comma)

#YTD_Cases_Received
p = ggplot(data=poline_summary, aes(x=factor(Month_Received), y=YTD_Cases_Received, group=Warehouse))
p + geom_line(aes(y=YTD_Cases_Received, colour=Warehouse), size=1, alpha=0.7) +
  geom_point(size=2, colour='black') +
  facet_wrap(~ Year_Received, scales='free_y') +
  theme(legend.position='bottom', axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title='YTD Cases Received', x='Month', y='Cases Received') +
  scale_y_continuous(labels=comma)







#WEIGHT
p = ggplot(data=poline_summary, aes(x=factor(Month_Received), y=Cases_Received, group=Year_Received))
p + geom_point(aes(colour=Warehouse)) +
  geom_line(aes(colour=Warehouse)) +
  geom_line(aes(y=Cases_Received_3_Month_Rolling_Avg), colour='black', size=1, alpha=0.7) +
  geom_line(aes(y=Cases_Received_6_Month_Rolling_Avg), colour='red', size=1.75, alpha=0.7) +
  facet_grid(Warehouse ~ Year_Received, scales='free_y') +
  theme(legend.position='none', axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title='Cases Received by Month w/ 3-and-6-Month Rolling Averages', x='Month', y='Cases Received') +
  scale_y_continuous(labels=comma)









#CASES
p = ggplot(data=kpi_summary, aes(x=factor(Month), y=Cases, group=Year))
p + geom_point(aes(colour=House)) +
  geom_line(aes(colour=House)) +
  geom_line(aes(y=Cases_3_Month_Rolling_Avg), colour='black', size=1, alpha=0.7) +
  geom_line(aes(y=Cases_6_Month_Rolling_Avg), colour='red', size=1.75, alpha=0.7) +
  facet_grid(House ~ Year, scales='free_y') +
  theme(legend.position='none', axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title='Case Production w/ 3-and-6-Month Rolling Averages', x='Month', y='Cases') +
  scale_y_continuous(labels=comma)

#CASES YTD
p = ggplot(data=kpi_summary, aes(x=factor(Month), y=YTD_Cases, group=House))
p + geom_line(aes(y=YTD_Cases, colour=House), size=1, alpha=0.7) +
  geom_point(size=2, colour='black') +
  facet_wrap(~ Year, scales='free_y') +
  theme(legend.position='bottom', axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title='YTD Case Production', x='Month', y='Cumulative Cases') +
  scale_y_continuous(labels=comma)









#BREAKAGE
p = ggplot(data=kpi_summary, aes(x=factor(Month), y=Breakage, group=Year))
p + geom_point(aes(colour=House)) +
  geom_line(aes(colour=House)) +
  geom_line(aes(y=Breakage_3_Month_Rolling_Avg), colour='black', size=1, alpha=0.7) +
  geom_line(aes(y=Breakage_6_Month_Rolling_Avg), colour='red', size=1.75, alpha=0.7) +
  facet_grid(House ~ Year, scales='free_y') +
  theme(legend.position='none', axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title='Breakage w/ 3-and-6-Month Rolling Averages', x='Month', y='Dollars Broken by Warehouse & Drivers') +
  scale_y_continuous(labels=dollar)

#BREAKAGE YTD
p = ggplot(data=kpi_summary, aes(x=factor(Month), y=YTD_Breakage, group=Year))
p + geom_line(aes(y=YTD_Breakage, colour=House), size=1, alpha=0.7) +
  geom_point(size=2, colour='black') +
  facet_grid(House ~ Year) +
  theme(legend.position='none', axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title='YTD Warehouse/Driver Breakage', x='Month', y='Dollars Broken by Warehouse & Drivers') +
  scale_y_continuous(labels=dollar)







#STOPS
p = ggplot(data=kpi_summary, aes(x=factor(Month), y=Total.Stops, group=Year))
p + geom_point(aes(colour=House)) +
  geom_line(aes(colour=House)) +
  geom_line(aes(y=Stops_3_Month_Rolling_Avg), colour='black', size=1, alpha=0.7) +
  geom_line(aes(y=Stops_6_Month_Rolling_Avg), colour='red', size=1.75, alpha=0.7) +
  facet_grid(House ~ Year, scales='free_y') +
  theme(legend.position='none', axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title='Avg Stops/mo w/ 3-and-6-month Rolling Averages', x='Month', y='Stops') +
  scale_y_continuous(labels=comma)

#STOPS YTD
p = ggplot(data=kpi_summary, aes(x=factor(Month), y=YTD_Stops, group=Year))
p + geom_line(aes(y=YTD_Stops, colour=House), size=1, alpha=0.7) +
  geom_point(size=2, colour='black') +
  facet_grid(House ~ Year) +
  theme(legend.position='none', axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title='YTD Stops', x='Month', y='Cumulative Stops') +
  scale_y_continuous(labels=comma)








#CPMH
p = ggplot(data=kpi_summary, aes(x=factor(Month), y=CPMH...Adjusted, group=Year))
p + geom_point(aes(colour=House)) +
  geom_line(aes(colour=House)) +
  geom_line(aes(y=CPMH_3_Month_Rolling_Avg), colour='black', size=1, alpha=0.7) +
  geom_line(aes(y=CPMH_6_Month_Rolling_Avg), colour='red', size=1.75, alpha=0.7) +
  facet_grid(House ~ Year, scales='free_y') +
  theme(legend.position='none', axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title='Avg Cases per Man Hour w/ 3-and-6-month Rolling Averages', x='Month', y='CPMH') +
  scale_y_continuous(labels=comma)








#HOURS
p = ggplot(data=kpi_summary, aes(x=factor(Month), y=Night.Ship.Hours, group=Year))
p + geom_point(aes(colour=House)) +
  geom_line(aes(colour=House)) +
  geom_line(aes(y=Night_Hours_3_Month_Rolling_Avg), colour='black', size=1, alpha=0.7) +
  geom_line(aes(y=Night_Hours_6_Month_Rolling_Avg), colour='red', size=1.75, alpha=0.7) +
  facet_grid(House ~ Year, scales='free_y') +
  theme(legend.position='none', axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title='Avg Nightly Hours per Day w/ 3-and-6-month Rolling Averages', x='Month', y='Hours') +
  scale_y_continuous(labels=comma)

#HOURS YTD
p = ggplot(data=kpi_summary, aes(x=factor(Month), y=YTD_Night_Hours, group=Year))
p + geom_line(aes(y=YTD_Night_Hours, colour=House), size=1, alpha=0.7) +
  geom_point(size=2, colour='black') +
  facet_grid(House ~ Year, scales='free_y') +
  theme(legend.position='none', axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title='YTD Night Hours', x='Month', y='Cumulative Hours') +
  scale_y_continuous(labels=comma)






head(kpi_summary)




