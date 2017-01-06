
source('C:/Users/pmwash/Desktop/Project Management Tool/Project_Mgmt_Homebase/helper.R')
library(googleVis)
library(dplyr)
library(reshape2)
library(ggplot2)
library(plotly)
library(DT)

path = 'C:/Users/pmwash/Desktop/Project Management Tool/Project Data/Project Management Database.accdb'#driver = 'Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ='
DB = odbcConnectAccess2007(path)

## Project List to choose from
PROJECTS = sqlFetch(DB, sqtable='Projects')



## Prep first tab for Timeline gantt chart
EMPS = sqlFetch(DB, sqtable='Employees')
TASK = sqlFetch(DB, sqtable='Tasks')
TASK = TASK %>% filter(Cancelled != 1)

print('Get Task List and merge it with Employees')
the_task = TASK$`Task Short`
the_responsible = strsplit(as.character(TASK$`Responsible (R)`), ';')
MASTER_TASKLIST = data.frame(Task=rep(the_task, sapply(the_responsible, length)), Responsible=unlist(the_responsible))
MASTER_TASKLIST = merge(EMPS[,c('EmployeeID','Full Name')], MASTER_TASKLIST, by.x='EmployeeID', by.y='Responsible')
MASTER_TASKLIST$EmployeeID = NULL
tasklist_fields = c('Task Short','Start Date','End Date','Planned Completion','Value')
MASTER_TASKLIST = merge(MASTER_TASKLIST, TASK[,tasklist_fields], by.x='Task', by.y='Task Short')
rm(the_task, the_responsible)

MASTER_TASKLIST$`Start Date` = as.Date(MASTER_TASKLIST$`Start Date`, '%Y-%m-%d')
MASTER_TASKLIST$`End Date` = as.Date(MASTER_TASKLIST$`End Date`, '%Y-%m-%d')
MASTER_TASKLIST$`Planned Completion` = as.Date(MASTER_TASKLIST$`Planned Completion`, '%Y-%m-%d')


MASTER_TASKLIST = MASTER_TASKLIST %>% arrange(`Planned Completion`, `Start Date`)

options = list(timeline="{groupByRowLabel:true, colorByRowLabel:true}",
               backgroundColor='#ffd', 
               height=1000, width=1300)
TIMELINE_PLOT = gvisTimeline(data=MASTER_TASKLIST,
                        rowlabel = 'Task',
                        barlabel = 'Full Name',
                        start = 'Start Date',
                        end = 'Planned Completion',
                        options=options)
#plot(TIMELINE_PLOT)



## Project List to choose from
RISKS = sqlFetch(DB, sqtable='Risks')
RISKS = RISKS %>% arrange(desc(Value))

generate_risk_matrix = function(RISKS) {
  myData = matrix(c(2,2,3,3,3,1,2,2,3,3,1,1,2,2,3,1,1,2,2,2,1,1,1,1,2), 
              nrow = 5, 
              ncol = 5, 
              byrow = TRUE)
  rownames(myData) = c("5", "4", "3", "2", "1")
  colnames(myData) = c("1", "2", "3", "4", "5")  
  long_data = melt(myData)
  colnames(long_data) = c("Likelihood", "Consequence", "Value")
  
  long_data = mutate(long_data, Value = Consequence + Likelihood)
  
  r = RISKS[,c('Risk','Probability','Impact','Mitigation','Value')]
  
  myPalette = colorRampPalette(c('green', 'yellow', 'red', 'darkred'))
  
  g = ggplot(data=long_data, aes(x=Consequence, y=Likelihood, fill=Value))
  base_plot = g + geom_tile() +
    scale_fill_gradientn(colours = myPalette(3)) + 
    scale_x_continuous(breaks = 0:6, expand = c(0, 0)) +
    scale_y_continuous(breaks = 0:6, expand = c(0, 0)) +
    coord_fixed() +
    theme_bw() +
    theme(legend.position='none')
  
  final_plot = base_plot + 
    geom_point(data=r, position='jitter', 
               aes(x=Impact, y=Probability, size=Value)) + 
    geom_text(data=r, position='jitter', size=3, 
              aes(x=Impact, y=Probability, label=Risk)) 
  
  #final_plot = ggplotly(final_plot)
  
  return(final_plot)
}

RISK_PLOT = generate_risk_matrix(RISKS)



## Get decision points

DECISIONS = sqlFetch(DB, sqtable='Decisions')
DECISION_TABLE = DECISIONS[,c('Decision', 'Importance')]

lst = c(as.list(DECISIONS$`Decision Maker`))
str(lst)



# Better more clear gantt chart

TASK = TASK %>% arrange(`Planned Completion`, `Start Date`)
TASK$Sequence = 1:length(TASK$ID)

create_gantt = function(key, desc, start, end, done, neededBy){
  roadnet_planner = as.gantt(key=key, description=desc,
                             start=start, end=end, done=done) #, # done) #, NeededBy) #, done, neededBy)
  
  GANTT = plot(roadnet_planner,
           event.label='Today',
           event.time=as.character(Sys.Date()),
           time.lines.by="1 week",
           main='Major Tasks Remaining in Roadnet',
           col.done='green',
           col.notdone='gray',
           cex=1)
  
  print(GANTT)
}

#png('N:/2016 MB Projects/Roadnet/Planning/timeline.png', width = 1200, height = 800)



## Get task list
library(tidyr)
# add objective to this dataframe
TASK_TABLE = aggregate(`Full Name` ~ Task, data=MASTER_TASKLIST, FUN=paste0)
TASK_TABLE = data.frame(TASK_TABLE)
names(TASK_TABLE) = c('Task','Team Members')


odbcCloseAll()















shinyServer(function(input, output) {
  
  output$TIMELINE_PLOT = renderGvis({TIMELINE_PLOT})
  
  output$GANTT_PLOT = renderPlot({create_gantt(key=TASK$Sequence, desc=TASK$`Task Short`, start=TASK$`Start Date`,
                                               end=TASK$`Planned Completion`, done=(TASK$Done*100))})
  
  output$TASK_TABLE = renderTable({TASK_TABLE})
  
  output$RISK_PLOT = renderPlotly({RISK_PLOT})
  
  output$RISK_TABLE = renderTable({RISKS[, c('Risk','Mitigation')]})
  
  output$DECISION_TABLE = renderTable({DECISION_TABLE})
  
})































