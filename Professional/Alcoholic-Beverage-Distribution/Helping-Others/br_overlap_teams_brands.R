# 6-8-16 ven ndiagram of teams and brands overlap


library(VennDiagram)
library(dplyr)
source('C:/Users/pmwash/Desktop/R_files/Data Input/Helper.R')



teams_brands = read.csv('C:/Users/pmwash/Desktop/R_files/Data Input/bilbo_overlap_teams_brands.csv', header=TRUE)
headTail(teams_brands)
overlap = teams_brands[, c('Supplier', 'Director', 'Sales.District.Manager', 'Brand', 'Team', 'Revenue')]
headTail(overlap, 50)

# olap_matrix = function(X, prob=F) {
#   tt <- table( c(X[,-ncol(X)]), c(X[,-1]) )
#   if(prob) tt <- tt / rowSums(tt)
#   tt
# }
# 
# p_m = olap_matrix(overlap)
# headTail(p_m)








sankey_df = function(df, colsource='source', coltarget='target', colvalue='value') {
  library(dplyr)
  
  sankey.df = subset(df, select=c(colsource, coltarget, colvalue))
  colnames(sankey.df) = c('source', 'target', 'value')
  
  sankey.df = arrange(sankey.df, desc(value))
  
  sankey.df
}

n_teams_brand = aggregate(Team ~ Brand, data=teams_brands, FUN=countUnique)
names(n_teams_brand) = c('Brand', 'Number.Teams.Brand') 
n_teams_brand = n_teams_brand %>% arrange(desc(Number.Teams.Brand)) %>%
  filter(Number.Teams.Brand > 2); head(n_teams_brand, 50)
order_brands = n_teams_brand$Brand


overlap = overlap[overlap$Brand %in% order_brands, ]
overlap$Brand = factor(overlap$Brand, levels=order_brands)
overlap = arrange(overlap, Brand); head(overlap)
df = sankey_df(df=overlap, colsource='Team', coltarget='Brand', colvalue='Revenue')
df = df %>% filter(value > 0)

headTail(df, 5)


sankey_plot = function(df, title) {
  library(rCharts)
  
  sankeyPlot <- rCharts$new()
  
  #We also need to point to an HTML template page
  sankeyPlot$setLib('http://timelyportfolio.github.io/rCharts_d3_sankey')
  
  sankeyPlot$set(
    data = df,
    nodeWidth = 30,
    nodePadding = 8,
    layout = 32,
    width = 1000,
    height = 10000,
    labelFormat = ".2%",
    title=title
  )
  
  sankeyPlot
  
}

s = sankey_plot(df=df, title='Team-Brand Intersections')
print(s)

























######### R&D
library(treemap)
library(data.tree)
df = overlap; headTail(df)

df$pathString = paste('Whole Company',
                      df$Team, 
                      df$Director,
                      df$Supplier, 
                      df$Brand,
                      sep='/')
# df$pathString = paste('Whole Company',
#                       df$target, 
#                       df$source, 
#                       sep='/')

the_nodes = as.Node(df)
# plot(the_nodes)





# ToDataFrameNetwork(df)
# 
# 
# n1 = unique(df$source)
# n2 = unique(df$target)


#the_nodes = paste(n1, n2); the_nodes[1:10]
library(reshape2)
x_df = df[, c('Team', 'Brand', 'Revenue')]
x_df = melt(x_df, measure.var=c('Team', 'Brand'))
x = unique(df[, c('Team', 'Brand')])
nodes = unique(x_df$value)

head(x_df, 50)

library(DiagrammeR)

nodes_w_types = create_nodes(nodes = nodes,
                             #type = nodes$type,
                             label = nodes
                             # style = nodes$style, 
                             # shape = nodes$shape,
                             #fillcolor = nodes$fillcolor,
                             # cex.bold = nodes$fontbold
) 
head(nodes_w_types)

head(df)
edges = create_edges(from = df$Team,
                     to = df$Supplier,
                     rel = df$Revenue
                     # width = edges$width,
                     # cex.bold = edges$fontbold
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

render_graph(graph = output_graph,# width=1200, height=1500,
             output = 'visNetwork')#, layout=dot)  















n_brands_total = countUnique(teams_brands$Brand)

n_brands_team = aggregate(Brand ~ Team, data=teams_brands, FUN=countUnique)
names(n_brands_team) = c('Team', 'Brands')
n_brands_team = n_brands_team %>% arrange(desc(Brands)); head(n_brands_team)
n_brands_team$Percent.Brands = round(n_brands_team$Brands / n_brands_total, 4)




n_teams_brand = aggregate(Team ~ Brand, data=teams_brands, FUN=countUnique)
names(n_teams_brand) = c('Brand', 'Number.Teams.Brand') 
n_teams_brand = n_teams_brand %>% arrange(desc(Number.Teams.Brand)); headTail(n_teams_brand, 50)
n_teams_brand = n_teams_brand %>% filter(Number.Teams.Brand > 2)
keep_brands = n_teams_brand$Brand

#####
head(teams_brands)
tb = teams_brands[teams_brands$Brand %in%  keep_brands,]
tb = tb %>% filter(Revenue > 0)
tb = tb %>% filter(Supplier != 'MISC & DISCONT\'D ITEMS   800999 (999)')
head(tb)



head(tb)
library(Matrix)
mat = spMatrix(nrow=length(unique(tb$Supplier)),
               # nrow=length(unique(tb$Brand)),
               ncol=length(unique(tb$Team)),
               i = as.numeric(factor(tb$Supplier)),
               # i = as.numeric(factor(tb$Brand)),
               j = as.numeric(factor(tb$Team)),
               x = rep(1, length(as.numeric(tb$Supplier))))
               # x = rep(1, length(as.numeric(tb$Brand))))
# row.names(mat) = levels(factor(tb$Brand))
row.names(mat) = levels(factor(tb$Supplier))
colnames(mat) = levels(factor(tb$Team))
headTail(mat, 50)

# get percentages of whole matrix
p_mat = mat / diag(mat)
head(p_mat, 30)

library(ggplot2)
library(gplots)
library(ggdendro)



# to get the one-mode rep of ties between entities, multiply the matrix by its transpose
a_row = tcrossprod(mat) #mat %*% t(mat) #matrix multiplier

# a_row is now a one mode matrix formed by the row entities
# now we need a one mode matrix formed by the column entities
a_teams = tcrossprod(t(mat)) # or t(mat) %*% mat


headTail(a_row); headTail(a_teams)


library(igraph)
# graph_i = graph.incidence(a_col)
graph_i = graph.adjacency(a_teams, mode = 'undirected')
graph_i = simplify(graph_i)

graph_i_olap = a_teams / diag(a_teams)
graph_i_olap_g = graph.incidence(graph_i_olap)
graph_i_olap_g = simplify(graph_i_olap_g, remove.multiple=TRUE, remove.loops=TRUE)

# set edge attributes
egam <- (E(graph_i_olap_g)$weight+.1)/max(E(graph_i_olap_g)$weight+.1)
E(graph_i_olap_g)$color <- rgb(.5,.5,0,egam)
E(graph_i_olap_g)$weight = count.multiple(graph_i_olap_g)

# set vertex attributes
team_adjacency = graph.adjacency(graph_i_olap, weighted=T)
V(graph_i_olap_g)$degree = degree(team_adjacency)
V(graph_i_olap_g)$color = rgb(1, 0, .5)
V(graph_i_olap_g)$label = V(graph_i_olap_g)$name
V(graph_i_olap_g)
V(graph_i_olap_g)$label.cex <- V(graph_i_olap_g)$degree/(max(V(graph_i_olap_g)$degree)/2)+ .3
V(team_adjacency)$label = V(team_adjacency)$name
V(team_adjacency)$degree = degree(team_adjacency)
#tkplot(team_adjacency)


library(d3heatmap)
library(heatmaply)

# get percentages of whole matrix
p_mat = cbind(mat / rowSums(mat)) #fuck ups below
# p_mat = prop.table(mat)
# p_mat = mat / diag(mat)
head(p_mat, 30)

head(p_mat)
p_mat[is.na(p_mat)] = 0
p_mat[is.infinite(p_mat)] = 0

d3heatmap(p_mat, scale='none', 
          colors = "Spectral",
          height=850, width=1500,
          yaxis_font_size = 10,
          xaxis_font_size = 10)




plot(graph_i, layout=layout.fruchterman.reingold)








#pivot check
library(rpivotTable)

rpivotTable(tb,
            aggregatorName='Sum',
            vals='Revenue',
            row='Team',
            width="100%", 
            height="2500px",
            rendererName='Treemap',
            menuLimit = 20000)









































#gravyard





# 
# # TRY PRINTING AS DF
# library(DT)
# 
# x = length(the_nodes)
# DT:::DT2BSClass(c('compact', 'cell-border'))
# datatable(the_nodes, 
#           filter = 'top',
#           rownames = FALSE,
#           options = 
#             list(pageLength = x))
# 




