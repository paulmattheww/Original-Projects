# store data in format understandable for clustering, heatmaps, and matrices 
correl <- OMEGA[, c(2:3, 5:7, 13:28, 30:32, 34:39)]
correl <- correl[, c(2:6, 14:18, 20, 22:30)]
correl <- round(cor(correl, use = 'na.or.complete'), 2)



# hierarchical clustering
plot(hclust(dist(correl), "ave"))



# correlation matrix
library(corrplot)
library(RColorBrewer)
corrplot(correl, 
         method="shade",
         type="upper",
         tl.cex=0.6,
         order="hclust",
         col=brewer.pal(n=10, name="RdYlGn"),
         tl.col="black", 
         tl.srt=45,
         bg="grey",
         sig.level=0.05)
         

library(gridExtra)
chart.Correlation(correl, histogram=TRUE, pch=19)
library(corrplot)
library(RColorBrewer)
corrplot.mixed(correl, 
         tl.cex=0.4,
         order="hclust",
         col=brewer.pal(n=10, name="RdYlGn"),
         tl.col="black", 
         tl.srt=45,
         bg="grey",
         sig.level=0.05,
         insig="blank",
         upper="ellipse")


corrplot(correl, 
               addrect=2,
               method="ellipse",
               type="upper",
               tl.cex=0.6,
               order="hclust",
               col=brewer.pal(n=10, name="RdYlGn"),
               tl.col="black", 
               tl.srt=45,
               bg="grey",
               sig.level=0.05,
               insig="blank")

         
         
         
# heatmaps 
library(gplots)
col <- c(seq(-1,0, length=100),
         seq(0,0.8, length=100),
         seq(0.8,1 length=100))
my_palette <- colorRampPalette(c("red", "yellow", "green"))
heatmap.2(x=as.matrix(correl),
          margins=c(19,9),
          cellnote=correl,
          main="Correlation Matrix",
          notecol="black",
          density.info="none",
          trace="none",
          col=my_palette,
          dendrogram="row")

library(d3heatmap)
d3heatmap(correl, scale="column",
          dendrogram="none",
          color=scales::col_quantile("Greens", NULL, 5))
