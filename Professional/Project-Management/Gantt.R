

## gantt template 



library(plan)
library('DiagrammeR')


Description = c('ROI analysis, negotiations & planning',
          'Finish gathering data from drivers', 
          'Input data into temporary DB', 
          'Transfer information to Roadnet', 
          'Consultant Interaction (period TBD)', 
          'Build necessary data bridges to/from Roadnet', 
          'Build necessary reports from Roadnet (if necessary)',
          'Testing period for dynamic routing; Optimize', 
          'Go Live')
Key = 1:length(Description)
Start = c('2016-03-15',
          '2016-05-15', 
          '2016-06-01',
          '2016-06-08',
          '2016-06-15',
          '2016-06-16',
          '2016-06-16',
          '2016-07-01',
          '2016-09-01')
End = c('2016-05-12',
          '2016-05-31', 
          '2016-06-07',
          '2016-06-15',
          '2016-08-01',
          '2016-06-30',
          '2016-07-15',
          '2016-08-31',
          '2016-09-09')
done = c(1, 0, 0, 
         0, 0, 0, 
         0, 0, 0)
neededBy = NULL
events = c('Sign Contract', 
           'Go Live!')
events_dates = c('2016-05-12', 
           '2016-09-01')

# roadnet_planner = cbind(Key, Description, Start, End)
# roadnet_planner$Done = NULL
# roadnet_planner$NeededBy = NULL
roadnet_planner = as.gantt(Key, Description, Start, End) #, done, neededBy)
dev.off()
plot(roadnet_planner, 
     event.label=events, 
     event.time=events_dates, 
     time.lines.by="1 week",
     main='Major Tasks Remaining in Roadnet',
     col.done='green', 
     col.notdone='lightblue',
     alpha=0.6,
     cex=1)









# disregard below, for learning
# 
# data(gantt)
# summary(gantt)
# plot(gantt)
# # Add a couple of event
# event.label <- c("Proposal", "AGU")
# event.time <- c("2008-01-28", "2008-12-10")
# plot(gantt, event.label=event.label,event.time=event.time, time.lines.by="1 week")
# 
# 





















