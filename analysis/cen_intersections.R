# Script to measure intersections across Leiden
# clusterings of CEN after CM treatment. George Chacko
# Jan 27, 2023. Download Leiden CEN clusterings to 
# ~/Desktop/Intersectional_Analysis

rm(list=ls())
library(data.table)

# Import Data
setwd('~/Desktop/Intersectional_Analysis')


# Leiden clustering files have node_id/cluster)_id
# .tsv format without headers.

# make vector of files
file_vec <- list.files(pattern='*.tsv')
file_vec <- sort(file_vec, decreasing=TRUE)
print(file_vec)

# node and edge counts for CEN
nc <- 13989436
ec <- 92051051


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
# Elements 2,4,6,8 are post-CM clusterings
l5_nodes <- file_list[[2]][V2 %in% file_list_trimmed[[2]][,V2]][,V1]
l1_nodes <- file_list[[4]][V2 %in% file_list_trimmed[[4]][,V2]][,V1]
l01_nodes <- file_list[[6]][V2 %in% file_list_trimmed[[6]][,V2]][,V1]
l001_nodes <- file_list[[8]][V2 %in% file_list_trimmed[[8]][,V2]][,V1]

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
print(paste("Intersection_Node_Coverage", intersection_node_coverage))
print(paste("Union_Node_Coverage", union_node_coverage))

