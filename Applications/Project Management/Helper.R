if (Sys.getenv("JAVA_HOME")!="")
  Sys.setenv(JAVA_HOME="")
library(RODBC)
library(shiny)
library(rJava)
library(plan)
library(xlsx)
library(DiagrammeR)
library(magrittr)
library(igraph)
library(network) 
library(sna)
library(ndtv)
library(dplyr)
library(grDevices)
library(plotrix)
library(plotly)
library(plotrix)
library(dplyr)
library(stats)
library(ggplot2)
library(scales)
library(RColorBrewer)
library(ggthemes)
library(reshape2)

create_gantt = function(key, desc, start, end, done, events, event_dates){
  roadnet_planner = as.gantt(key=key, description=desc,
                             start=start, end=end, done=done) #, # done) #, NeededBy) #, done, neededBy)
  
  x = plot(roadnet_planner,
           event.label=events,
           event.time=events_dates,
           time.lines.by="1 week",
           main='Major Tasks Remaining in Roadnet',
           col.done='green',
           col.notdone='gray',
           cex=1)
  
  print(x)
}
