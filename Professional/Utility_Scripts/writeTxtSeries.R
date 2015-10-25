writeTextSeries = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("file_number_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}
