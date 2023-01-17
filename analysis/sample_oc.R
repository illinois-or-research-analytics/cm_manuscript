# script that samples from a large Leiden clustering
# taking 10% from each decile after clusters below 11 nodes are removed. 

# usage "Rscript sample_oc.R <path_to_annotated_cluster_file> <path_to_original clustering> <output_identifier_string> 
# use the output of subset_graph_nonnetworkit_treestar.R
# which has the string treestarcounts.tsv suffixed in the filename
# **** Example: on odesa when run from /data2/oc_sampling
# Rscript /data1/chackoge/repos/cm_manuscript/analysis/sample_oc.R  ./oc_leiden.5_annotated_treestarcounts.tsv ../open_citations/oc_leiden.5.tsv  oc_leiden.5.
# ****
library(data.table)
rm(list=ls())


args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[3] = "default.tsv"<
}

x <- fread(args[1])
# filter out trees and stars
x <- x[type=='non_tree']

# probably unnencessary
set.seed(12345)

# construct quantiles
qvec <- quantile(x$node_count,probs=seq(0.1,1,by=0.1))

# sample
i=1
sample <- x[node_count <= qvec[i]][,sample(cluster_id,ceiling(5*length(cluster_id)/100))]
i=1
while (i <= (length(qvec)-1)) {
print(paste(i,i+1))
s <- x[node_count >= qvec[i] & node_count <= qvec[i+1]][,sample(cluster_id,ceiling(5*length(cluster_id)/100))]
sample <- union(sample,s)
i=i+1
}

#import original clustering
original_clustering <- fread('args[2]')
cmready_clustering <- original_clustering[V2 %in% sample]

write.table(sample,file=paste0('dec_sample_',args[1],i,'.tsv'),sep='\t',row.names=F,col.names=F)
write.table(sample,file=paste0('cm_ready_sample_',args[1],i,'.tsv'),sep='\t',row.names=F,col.names=F)


# subset clustering by sample

