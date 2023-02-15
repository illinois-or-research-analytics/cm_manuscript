# script that reduces clusterng to non-treeclusters

# ***
# To avoid errors run this script from the direcory where the output files are to be located.
# Making this script easier to run is being worked on.
# ***

# usage "Rscript sample_oc.R <original clustering> <annotated_cluster_file> 
# use the output of subset_graph_nonnetworkit_treestar.R
# which has the string "treestarcounts.tsv" suffixed in the filename

# **** Example: on odesa when run from /data2/oc_sampling
# Rscript /data1/chackoge/repos/cm_manuscript/analysis/sample_oc.R ../open_citations/oc_leiden.5.tsv  oc_leiden.5_annotated_treestarcounts.tsv 
# ****

library(data.table)
rm(list=ls())

args = commandArgs(trailingOnly=TRUE)

if (length(args)< 2) {
  stop("At least two arguments must be supplied (input file).n", call.=FALSE)
} 

print(getwd())
print(args[1])
print(args[2])

x <- fread(args[2])

# filter out trees and stars
x <- x[type=='non_tree']

# probably unnecessary
set.seed(12345)

#import original clustering
original_clustering <- fread(args[1])
# subset clustering using clusters in sample
cm_ready_clustering <- original_clustering[V2 %in% x$cluster_id]

# write.table(x,file=paste0('non_tree_clustering_',args[2]),sep='\t',row.names=F,col.names=F)
write.table(cm_ready_clustering,file=paste0('cm_ready_clustering_',args[2]),sep='\t',row.names=F,col.names=F)

