# script that samples from a large Leiden clustering
# taking 10% from each decile after clusters below 11 nodes are removed. 

# usage "Rscript sample_oc.R <name of input clustering file> 
# use the output of subset_graph_nonnetworkit_treestar.R
# which has the string treestarcounts.tsv suffixed in the filename

library(data.table)
rm(list=ls())

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "default.tsv"
}

x <- fread(args[1])
x <- x[type=='non_tree']

qvec <- quantile(x$node_count,probs=seq(0.1,1,by=0.1))

i=1
sample <- x[node_count <= qvec[i]][,sample(cluster_id,ceiling(5*length(cluster_id)/100))]
i=1
while (i <= (length(qvec)-1)) {
print(paste(i,i+1))
s <- x[node_count >= qvec[i] & node_count <= qvec[i+1]][,sample(cluster_id,ceiling(5*length(cluster_id)/100))]
sample <- union(sample,s)
i=i+1
}

write.table(sample,file=paste0('dec_sample_',args[1],i,'.csv'),sep='\t',row.names=F,col.names=F)

