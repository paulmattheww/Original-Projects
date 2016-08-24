
## Re-upload incorrect service times
library(stringr)

times = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/re-upload_service_times.csv',header=TRUE)
times = times[,c('CustomerID', 'Customer', 'ServiceTimePredicted')]

service_times = as.character(times$ServiceTimePredicted)

min = round(as.numeric(sapply(strsplit(service_times, "\\."), `[[`, 1)))
hrs = ifelse(min > 59, str_pad(floor(min/60),width = 2, 
                               side='left', pad='0'), '00')
min = as.character(min - (floor(min/60) * 60))
min = str_pad(min, width=2, side='left', pad='0')

sec = floor((as.numeric(str_extract(service_times, '[0-9]+$'))))
sec = as.numeric(floor(sec/100 * 60))
sec = str_pad(sec, width=2, side='left', pad='0')


times$ServiceTime = hhmmss = ifelse(is.na(hrs) == TRUE, '', paste0(hrs, ':', min, ':', sec))


head(times)
write.csv(times, 'N:/2016 MB Projects/Roadnet/Data/Data Uploads to RNA/updated_service_times.csv', row.names=F)
