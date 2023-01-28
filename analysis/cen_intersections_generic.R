# Script to measure intersections across Leiden
# clusterings of networks after CM treatment. George Chacko
# Jan 28, 2023. 

# Run as in "Rscript /data1/chackoge/repos/cm_manuscript/analysis/cen_intersections_generic.R \
# <network>_cleaned.tsv

rm(list=ls())
library(data.table)
args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "default.tsv"
}

# Import Data
# Run from directory containing files of interest

# Leiden clustering files have node_id/cluster)_id
# .tsv format without headers.

# make vector of files
file_vec <- list.files(pattern='*_after.tsv')
file_vec <- sort(file_vec, decreasing=TRUE)
print(file_vec)

# node and edge counts for parent graph
parent_graph <- fread(args[1])
nc <- length(union(parent_graph$V1,parent_graph$V2))
ec <- dim(parent_graph)[1]

file_list <- list()
# read files into list
for (i in 1:length(file_vec)){
	file_list[[i]] <- fread(file_vec[i])
}
names(file_list) <- file_vec
# Generate list of clusters of size > 10 
file_list_trimmed <- lapply(file_list,function(x) x[,.N,by='V2'][N>10])
names(file_list_trimmed) <- file_vec

lapply(file_list_trimmed,function(x) dim(x))


# Generate vectors of node_ids for each clustering that 
# are drawn from cluster of size > 10
# Elements 1,2,3,4 are post-CM clusterings
l5_nodes <- file_list[[1]][V2 %in% file_list_trimmed[[1]][,V2]][,V1]
l1_nodes <- file_list[[2]][V2 %in% file_list_trimmed[[2]][,V2]][,V1]
l01_nodes <- file_list[[3]][V2 %in% file_list_trimmed[[3]][,V2]][,V1]
l001_nodes <- file_list[[4]][V2 %in% file_list_trimmed[[4]][,V2]][,V1]

# Intersection
int <- length(Reduce(intersect, list(l5_nodes,l1_nodes,l01_nodes,l001_nodes)))
print(paste("Intersection =", int))
# Union
uni <- length(Reduce(union, list(l5_nodes,l1_nodes,l01_nodes,l001_nodes)))
print(paste("Union =", uni))

intersection_node_coverage <- round(100*(int/nc),2)
union_node_coverage <- round(100*(uni/nc),2)

# Print node coverage for intersection and union of the four clusterings
# The fraction of total nodes that is in found in clusters of size > 10
print(paste("Node_Coverage as Intersection across clusterings of nodes in clusters of size > 10 relative to the total number of nodes in the cleaned network ", intersection_node_coverage))
print(paste("Node_Coverage as Union across clusterings of nodes in clusters of size > 10 relative to the total number of\
 nodes in the cleaned network", union_node_coverage))


