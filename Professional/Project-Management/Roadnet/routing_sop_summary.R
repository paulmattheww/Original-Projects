

# SOP Process Mapping
library(xlsx)
require(googleVis)

stl_router_process = read.xlsx(file='C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Planning Data/master_planning_roadnet.xlsx', 
                               sheetName='sop', header=TRUE)



timeline_stl = gvisTimeline(data = stl_router_process,
                            rowlabel = 'ProcessName', 
                            barlabel = 'Activity',
                            start = 'Start',
                            end = 'Finish',
                            options = list(
                              width = 1600,
                              height = 900
                            ))
timeline_stl_list = gvisTable(stl_router_process[, c('Sequence',
                                                     'Activity', 
                                                     'ProcessName',
                                                     'Actor')],
                              options = list(
                                width = '1500px'
                              ))

plot(timeline_stl)
plot(timeline_stl_list)


cat(timeline_stl$html$chart, file='N:/2016 MB Projects/Roadnet/TaskVisualizer/SOP Planning/stl_routing_timeline.html')
cat(timeline_stl_list$html$chart, file='N:/2016 MB Projects/Roadnet/TaskVisualizer/SOP Planning/stl_routing_checklist.html')















































