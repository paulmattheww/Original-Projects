
# ROADNET PLANNING MASTER

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


refresh_data = function() {
  edges = read.xlsx(file='C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Planning Data/master_planning_roadnet.xlsx', 
                    sheetName='edges', header=TRUE)
  nodes = read.xlsx(file='C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Planning Data/master_planning_roadnet.xlsx', 
                    sheetName='nodes_w_types', header=TRUE)
  tasks = read.xlsx(file='C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Planning Data/master_planning_roadnet.xlsx',
                    sheetName='nodes_w_types', header=TRUE)
  tasks = filter(tasks, type == 'Task')
  players = read.xlsx(file='C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Planning Data/master_planning_roadnet.xlsx',
                      sheetName='nodes_w_types', header=TRUE)
  players = filter(players, type != 'Task')
}
# refresh_data()


# DETAILED TASK PLANNING


events = c('TODAY')
events_dates = c(as.character(Sys.Date()))


head(tasks)
dev.off()
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

png('N:/2016 MB Projects/Roadnet/Planning/timeline.png', width = 1200, height = 800)
create_gantt(key=tasks$key, desc=tasks$label, start=tasks$start, 
             end=tasks$end, done=tasks$done, events=events, event_dates=event_dates)
dev.off()








# list of tasks and players

order_players = players$label
order_tasks = unique(tasks$label)


tasks_ppl = merge(tasks, edges, by.x='nodes', by.y='to', all=TRUE)

tasks_ppl = filter(tasks_ppl, done < 100)
tasks_ppl = tasks_ppl[, c('label', 'initials', 'rel', 'end')]
tasks_ppl$rel = factor(tasks_ppl$rel, levels=c('R', 'A', 'C', '_'))
tasks_ppl$initials = factor(tasks_ppl$initials, levels=order_players)
tasks_ppl$label = factor(tasks_ppl$label, levels=order_tasks)

library(tidyr)
tasks_ppl = spread(tasks_ppl, initials, rel, fill='_')
tasks_ppl = arrange(tasks_ppl, end)
row.names(tasks_ppl) = tasks_ppl$label
tasks_ppl$label = NULL


library(htmlTable)

htmlTable(tasks_ppl)





library(xtable)

# print(xtable(tasks_ppl, caption='x', label=NULL))




View(tasks_ppl)







# HIGH LEVEL TIMELINE PLANNING
planning = read.xlsx(file='C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Planning Data/master_planning_roadnet.xlsx',
                     sheetName='timeline_highlevel', header=TRUE)


events = c('Sign Contract', 
           'Go Live!')
events_dates = c('2016-05-12', 
                 '2016-09-01')


roadnet_planner = as.gantt(planning$Key, planning$Description, 
                           planning$Start, planning$End,
                           planning$Done) #, planning$NeededBy) #, done, neededBy)
dev.off()
plot(roadnet_planner, 
     event.label=events, 
     event.time=events_dates, 
     time.lines.by="1 week",
     main='Major Tasks Remaining in Roadnet',
     # col.done='green',
     col.notdone='lightgreen',
     cex=1)





# TASKS





# select for department
#nodes = filter(nodes, department == 'OPS' | department == '')

refresh_data()

nodes_w_types = create_nodes(nodes = nodes$nodes,
                             type = nodes$type,
                             label = nodes$label,
                             style = nodes$style, 
                             shape = nodes$shape,
                             #fillcolor = nodes$fillcolor,
                             cex.bold = nodes$fontbold
) 

edges = create_edges(from = edges$from,
                     to = edges$to,
                     rel = edges$rel,
                     width = edges$width,
                     cex.bold = edges$fontbold
)




g_att = c('layout = neato', #neato dot twopi circo visNetwork
          'overlap = FALSE', 
          'outputorder = edgesfirst')

output_graph = create_graph(nodes_df = nodes_w_types,
                            edges_df = edges,
                            graph_attrs = g_att,
                            node_attrs = "fontname = Helvetica",
                            edge_attrs = "color = gray20"
  )

render_graph(graph = output_graph, width=1200, height=1500,
             output = 'visNetwork')#, layout=dot)  







# Sankey plot 

edges = read.xlsx(file='C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Planning Data/master_planning_roadnet.xlsx', 
                  sheetName='edges', header=TRUE)

order_players = players$node
order_tasks = unique(tasks$label)
df = edges


sankey_df = function(df, colsource='source', coltarget='target', colvalue='value') {
  library(dplyr)
  
  sankey.df = subset(df, select=c(colsource, coltarget, colvalue))
  colnames(sankey.df) = c('source', 'target', 'value')
  
  sankey.df$source = factor(sankey.df$source, levels=order_players)
  sankey.df$target = factor(sankey.df$target, levels=order_tasks)
  sankey.df = arrange(sankey.df, source)
  
  sankey.df
}

df = sankey_df(df=edges, colsource='from', coltarget='tolabel', colvalue='value')
names(df) = c('target', 'source', 'value')
# df$source = factor(df$source, levels=order_players)
# df$target = factor(df$target, levels=order_tasks)
df = df %>% arrange(target)



sankey_plot = function(df, title) {
  library(rCharts)
  
  sankeyPlot <- rCharts$new()

  #We also need to point to an HTML template page
  sankeyPlot$setLib('http://timelyportfolio.github.io/rCharts_d3_sankey')

  sankeyPlot$set(
    data = df,
    nodeWidth = 25,
    nodePadding = 10,
    layout = 32,
    width = 900,
    height = 1100,
    labelFormat = ".1%",
    title=title
  )
  
  sankeyPlot
  
}

#dev.off()
s = sankey_plot(df, title='Team Member/Task Relationships')
s

library(caTools)
library(png)

dev.off()
write.gif(s, 'test_plot.gif')






head(edges)






# Chord diagram




















edge_count = count_edges(output_graph)


edges = get_edges(graph_nodes_edges,
                  edge_attr = "rel",
                  match = "rel_a",
                  return_type = "list") #df vector












































# library(grDevices)
# library(plotrix)
# 
# d_format = '%Y/%m/%d'
# 
# planning = read.xlsx(file='C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Planning Data/master_planning_roadnet.xlsx',
#                      sheetName='roadnet_gantt', header=TRUE)
# 
# planning$Start = as.POSIXct(planning$Start, d_format)
# planning$End = as.POSIXct(planning$End, d_format)
# 
# months = seq(as.Date("2016/03/01", "%Y/%m/%d"), by="month", length.out=6)
# monthslab = format(months, format="%b")
# 
# vgridpos = as.POSIXct(months, format=d_format)
# vgridlab = monthslab
# 
# 
# gantt_info = list(labels = planning$Description,
#                   starts = planning$Start, 
#                   ends = planning$End,
#                   format = '%Y-%m-%d', 
#                   priorities = planning$Priority)
# 
# colors = colorRampPalette(c('lightgreen', 'blue'))
# 
# time_frame = as.POSIXct(c('2016/3/10', '2016/9/5'), 
#                         format=d_format)
# 
# gantt.chart(gantt_info, 
#             taskcolors=colors(2), 
#             xlim = time_frame, 
#             main = 'Roadnet Timeline',
#             priority.legend = TRUE,
#             hgrid = TRUE,
#             # vgridlab = FALSE,
#             # vgridlab=vgridlab,
#             vgrid.format="%b",
#             border.col = 'black',
#             xlab = '')  
#             #,
#             #vgrid=TRUE)
#             #vgridpos=vgridpos,vgridlab=vgridlab,hgrid=TRUE)
# 



























# edges = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Planning Data/edges.csv', header=TRUE)
# nodes = read.csv('C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Planning Data/nodes_w_types.csv', header=TRUE)
# 
















# Description = c('ROI analysis, negotiations & planning',
#           'Finish gathering data from drivers', 
#           'Input data into temporary DB', 
#           'Transfer information to Roadnet', 
#           'Consultant Interaction (period TBD)', 
#           'Build necessary data bridges to/from Roadnet', 
#           'Build necessary reports from Roadnet (if necessary)',
#           'Testing period for dynamic routing; Optimize', 
#           'Go Live')
# Key = 1:length(Description)
# Start = c('2016-03-15',
#           '2016-05-15', 
#           '2016-06-01',
#           '2016-06-08',
#           '2016-06-15',
#           '2016-06-16',
#           '2016-06-16',
#           '2016-07-01',
#           '2016-09-01')
# End = c('2016-05-12',
#           '2016-05-31', 
#           '2016-06-07',
#           '2016-06-15',
#           '2016-08-01',
#           '2016-06-30',
#           '2016-07-15',
#           '2016-08-31',
#           '2016-09-09')
# done = c(1, 0, 0, 
#          0, 0, 0, 
#          0, 0, 0)
# neededBy = NULL
# 
# gantt_data = as.data.frame(cbind(Key, Description, Start, End, done))
# 
# 
# write.csv(gantt_data, 'C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Planning Data/roadnet_gantt.csv')


# Name = c('Carrie Ward',#1
#          'Mary Goodman',#2
#          'Paul Washburn', #3
#          'Rick Ade',#4
#          'Rich Stewart',#5
#          'Verne Horne', #6
#          'Randy Simpson',#7
#          'Joe Luna',#8
#          'Paul Cunningham',#9
#          'Jeff Elliott',#10
#          'Kevin Gagen',#11
#          'Bill Schwein',#12
#          'Don Hercher',#13
#          'Bob Kloeppinger',#14
#          'Marissa Arlin',#15
#          'Tony Perri',#16
#          'Tom West' #,#17
#          )
# # color_people = c("grey",
# #                  "grey",
# #                  "lightgreen",
# #                  "lightgreen",
# #                  "blue",
# #                  "blue",
# #                  "blue",
# #                  "blue",
# #                  "blue",
# #                  "blue",
# #                  "blue",
# #                  "blue",
# #                  "blue",
# #                  "blue",
# #                  "blue",
# #                  "blue")
# # shape_people = c("circle", 
# #                  "circle",
# #                  "circle",
# #                  "circle",
# #                  "circle",
# #                  "circle",
# #                  "circle",
# #                  "circle",
# #                  "circle",
# #                  "circle",
# #                  "circle",
# #                  "circle",
# #                  "circle",
# #                  "circle",
# #                  "circle",
# #                  "circle")
# Role = c('Steering Committee',
#          'Steering Committee',
#          'Project Manager', 
#          'Project Manager',
#          'Project Contributor',
#          'Project Contributor', 
#          'Project Contributor',
#          'Key Project Contributor',
#          'Key Project Contributor',
#          'Project Contributor',
#          'Project Contributor',
#          'Project Contributor',
#          'Project Contributor',
#          'Project Contributor',
#          'Project Contributor',
#          'Project Contributor',
#          'Hogan Manager')
# MemberID = 1:length(Name)
# 
# 
# Task = c('Work with drivers to get quality data', #1
#           'Clear strategy for data input after drivers', 
#           'Input data from forms',
#           'Work with Omnitracs')
# 
# # color_tasks = c("yellow",
# #                 "yellow",
# #                 "yellow")
# # shape_tasks = c("rectangle",
# #                 "rectangle",
# #                 "rectangle")
# TaskType = c('Task', 
#              'Task', 
#              'Task',
#              'Key Task')
# 
# 
# raw_nodes = c(Name, Task)
# raw_types = c(Role, TaskType)
# # raw_colors = c(color_people, color_tasks)
# # raw_shapes = c(shape_people, shape_tasks)
# 
# 
# 
# 
# from = c('Verne Horne', 'Tony Perri', 'Rich Stewart', 'Don Hercher', 
#          'Paul Cunningham', 'Joe Luna', 'Rick Ade', 'Tom West', #1 #verne rich tony don paul joe rick twest
#          'Paul Washburn', 
#          'Paul Washburn', 
#          'Paul Washburn', 'Rick Ade')
# to = c('Work with drivers to get quality data',#verne rich tony don paul joe rick twest
#        'Work with drivers to get quality data',
#        'Work with drivers to get quality data',
#        'Work with drivers to get quality data',
#        'Work with drivers to get quality data',
#        'Work with drivers to get quality data',
#        'Work with drivers to get quality data',
#        'Work with drivers to get quality data', #1
#        'Clear strategy for data input after drivers', 
#        'Input data from forms',
#        'Schedule Omnitracs', 'Schedule Omnitracs'
#        )
# # rel = c("rel_a", "rel_a", "rel_b",
# #         "rel_c", "rel_b", "rel_a")


# nodes_w_types = 
#   create_nodes(nodes = raw_nodes,
#                type = raw_types,
#                label=TRUE,
#                style = "filled") #, #,
#color = raw_colors,
#shape = raw_shapes)

# edges_out = cbind(from, to)
# write.csv(edges_out, 'C:/Users/pmwash/Desktop/R_files/Data Output/edges.csv', row.names=FALSE)
# write.csv(nodes_w_types, 'C:/Users/pmwash/Desktop/R_files/Data Output/nodes_w_types.csv', row.names=FALSE)
































nodes <-
  create_nodes(
    nodes = nodes_w_types,
    label = TRUE,
    type = "lower",
    style = "filled",
    color = "aqua",
    shape = c("circle", "circle",
              "rectangle", "rectangle"),
    data = c(3.5, 2.6, 9.4, 2.7)
  ); nodes

edges <-
  create_edges(
    from = c("a", "b", "c"),
    to = c("d", "c", "a"),
    rel = "leading_to"
  ); edges

graph <-
  create_graph(
    nodes_df = nodes,
    edges_df = edges,
    node_attrs = "fontname = Helvetica",
    edge_attrs = c("color = blue",
                   "arrowsize = 2")
  ); graph

graph %>% render_graph()



mermaid("
        graph TD
        a[gamma]-->c(normal1)
        b[omega2]-->c(normal1)
        c-->d[lambda]
        e[c]-->g(invGamma1)
        f[d]-->g(invGamma1)
        g-->h[phi2]
        d-->k(normal2)
        h-->k(normal2)
        k-->l[mu]
        m[psi]-->o(invGamma2)
        n[delta]-->o(invGamma2)
        o(invGamma2)-->p[tau2]
        l-->q(normal3)
        p-->q(normal3)
        q-->r[theta]
        r-->t(normal4)
        s[sigma2]-->t(normal4)
        t-->u>y]
        ")





# grViz("
# digraph neato {
#       
#       graph [layout = neato]
#       
#       node [shape = circle,
#       style = filled,
#       color = grey,
#       label = '']
#       
#       node [fillcolor = red]
#       a
#       
#       node [fillcolor = green]
#       Carrie Ward Mary Goodman Paul Washburn 
#       Rick Ade
#       Rich Stewart
#       Verne Horne 
#       Randy Simpson
#       Joe Luna
#       Paul Cunningham
#       Jeff Elliott
#       Kevin Gagen
#       Bill Schwein
#       Don Hercher
#       Bob Kloeppinger
#       Marissa Arlin
#       
#       node [fillcolor = orange]
#       
#       edge [color = grey]
#       a -> {b c d}
#       b -> {e f g h i j}
#       c -> {k l m n o p}
#       d -> {q r s t u v}
#       }")



graph <-
  create_graph() %>%
  set_graph_name("software_projects") %>%
  set_global_graph_attr("graph",
                        "output",
                        "visNetwork") %>%
  add_nodes_from_table(
    system.file("examples/contributors.csv",
                package = "DiagrammeR"),
    set_type = "person",
    label_col = "name") %>%
  add_nodes_from_table(
    system.file("examples/projects.csv",
                package = "DiagrammeR"),
    set_type = "project",
    label_col = "project") %>%
  add_edges_from_table(
    system.file("examples/projects_and_contributors.csv",
                package = "DiagrammeR"),
    from_col = "contributor_name",
    from_mapping = "name",
    to_col = "project_name",
    to_mapping = "project",
    rel_col = "contributor_role")

graph %>% render_graph























data(gantt)
summary(gantt)
plot(gantt)
# Add a couple of event
event.label <- c("Proposal", "AGU")
event.time <- c("2008-01-28", "2008-12-10")
plot(gantt, event.label=event.label,event.time=event.time, time.lines.by="1 week")























