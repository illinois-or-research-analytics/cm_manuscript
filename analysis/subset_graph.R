# script that reduces the size of a large graph to allow find_trees.py to run more efficiently.

# usage "Rscript subset_graph.R -g  <name of input edgelist> -i <input clustering file> -o <output_edgelist_string> 
# which should be in tsv without headers
# Example: Rscript subset_graph.R oc_integer_el.tsv oc_leiden.5.tsv oc_l5_trimmed

library(data.table)
rm(list=ls())

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==3) {
  print("OK 3 params supplied")
}

g <- fread(args[1])
c <- fread(args[2]) 

# reduce clustering to those clusters of size 11 or greater
c_10 <- c[,.N,by='V2'][N>10]
sized_clusters <- c[V2 %in% c_10$V2]

# resize graph to only those edges where the endpoints map to the 
# clusters in sized_clusters
g1 <- g[(V1 %in% sized_clusters$V1) & (V2 %in% sized_clusters$V1)]

# add cluster infor to each node in g1
temp <- merge(g1,sized_clusters,by.x='V1',by.y='V1')
colnames(temp) <- c('V1','V2','V1_clus')

temp2 <- merge(temp,sized_clusters,by.x='V2',by.y='V1')
colnames(temp2) <- c("V2","V1","V1_clus","V2_clus")

# enforce endpoints in same cluster
trimmed_g <- temp2[V1_clus==V2_clus]
# get rid of extra columns
trimmed_g <- trimmed_g[,.(V1,V2)]
# write trimmed graph
write.table(trimmed_g,file=paste0(args[3],'_g.tsv'),sep='\t',col.names=F,row.names=F)
# write trimmed clustering
write.table(sized_clusters,file=paste0(args[3],'_clus.tsv'),sep='\t',col.names=F,row.names=F)


