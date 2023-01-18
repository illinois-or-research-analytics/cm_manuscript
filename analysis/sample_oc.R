# script that samples from a large Leiden clustering
# taking 10% from each decile after clusters below 11 nodes are removed. 
# updated to incorporate a simpler strategy to avoid the 'identical bin' problem
# that results in oversampling.

# Revised strategy
# Sample 1 % of the population from above the 3rd quartile and
# 3 % from below the third quartile


# usage "Rscript sample_oc.R <path_to_original clustering> <path_to_annotated_cluster_file> 
# use the output of subset_graph_nonnetworkit_treestar.R
# which has the string treestarcounts.tsv suffixed in the filename
# **** Example: on odesa when run from /data2/oc_sampling
# Rscript /data1/chackoge/repos/cm_manuscript/analysis/sample_oc.R ../open_citations/oc_leiden.5.tsv  oc_leiden.5_annotated_treestarcounts.tsv 
# ****
library(data.table)
rm(list=ls())

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[3] = "default.tsv"
}

print(getwd())
print(args[1])
print(args[2])
print(args[3])

x <- fread(args[2])
# filter out trees and stars
x <- x[type=='non_tree']

# probably unnecessary
set.seed(12345)

# construct quantiles
q3 <- quantile(x$node_count,probs=0.75)

s1 <- x[node_count >= q3][,sample(cluster_id,ceiling(length(cluster_id)/100))]
s2 <- x[node_count < q3][,sample(cluster_id,ceiling(3*length(cluster_id)/100))]
print(length(s1))
print(length(s2))
sample <- union(s1,s2) 

#import original clustering
original_clustering <- fread(args[1])
cmready_clustering <- original_clustering[V2 %in% sample]

write.table(sample,file=paste0('dec_sample_',args[1]),sep='\t',row.names=F,col.names=F)
write.table(cmready_clustering,file=paste0('cm_ready_sample_',args[1]),sep='\t',row.names=F,col.names=F)




