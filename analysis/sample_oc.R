# script that samples from a large Leiden clustering
# taking 10% from each decile after clusters below 11 nodes are removed. 
# updated to incorporate a simpler strategy to avoid the 'identical bin' problem
# that results in oversampling.

# ***
# To avoid errors run this script from the direcory where the output files are to be located.
# Making this script easier to run is being worked on.
# ***


# Revised strategy
# Sample 2 % of the population from equal to or above the 3rd quartile and
# 4 % from below the third quartile


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

# construct quantiles
q3 <- quantile(x$node_count,probs=0.75)
print(paste("Q3= ",q3))

s1 <- x[node_count >= q3][,sample(cluster_id,ceiling(1*(dim(x)[1])/100))]
s2 <- x[node_count  < q3][,sample(cluster_id,ceiling(3*(dim(x)[1])/100))]
print(length(s1))
print(length(s2))
sample <- union(s1,s2)
print(paste("Sample Size Is ", length(sample)))

print("***")
print(length(sample))
print("***")

#import original clustering
original_clustering <- fread(args[1])
# subset clustering using clusters in sample
cmready_clustering <- original_clustering[V2 %in% sample]

write.table(sample,file=paste0('dec_sample_',args[2]),sep='\t',row.names=F,col.names=F)
write.table(cmready_clustering,file=paste0('cm_ready_sample_',args[2]),sep='\t',row.names=F,col.names=F)







