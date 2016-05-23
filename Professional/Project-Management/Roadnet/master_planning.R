
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

library(plotrix)



planning = read.xlsx(file='C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Planning Data/master_planning_roadnet.xlsx', 
          sheetName='roadnet_gantt', header=TRUE)
edges = read.xlsx(file='C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Planning Data/master_planning_roadnet.xlsx', 
                     sheetName='edges', header=TRUE)
nodes_w_types = read.xlsx(file='C:/Users/pmwash/Desktop/Roadnet Implementation/Data/Planning Data/master_planning_roadnet.xlsx', 
                     sheetName='nodes_w_types', header=TRUE)

planning$Start = as.character(as.POSIXct(planning$Start, '%Y/%m/%d'))
planning$End = as.character(as.POSIXct(planning$End, '%Y/%m/%d'))



# TIMELINE PLANNING
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
     col.done='green',
     col.notdone='lightblue',
     cex=1)





# TASKS

# select for department
#nodes = filter(nodes, department == 'OPS' | department == '')


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




output_graph = 
  create_graph(nodes_df = nodes_w_types,
               edges_df = edges,
               graph_attrs = "layout = neato",
               node_attrs = "fontname = Helvetica",
               edge_attrs = "color = gray20"
               )

render_graph(graph = output_graph, 
             # output = 'forcedDirection')
             output = 'visNetwork')  
             #output = 'visNetwork')

# ,
#              node_attrs = "fontname = Helvetica",
#              edge_attrs = c("color = black", "arrowsize = 2"))

edge_count = count_edges(output_graph)


edges = get_edges(graph_nodes_edges,
          edge_attr = "rel",
          match = "rel_a",
          return_type = "list") #df vector
































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























