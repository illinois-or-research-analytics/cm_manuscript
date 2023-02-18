# script to remove dummy_nodes from Leiden clusterings
# George Chacko 2/18/2023

## usage Rscript remove_dummies.R  <network_edgelist.tsv>  <clustering_file.tsv>
## # output defaults to default.tsv

rm(list=ls())
library(data.table)
args = commandArgs(trailingOnly=TRUE)

if (length(args)<2) {
  stop("At least two arguments must be supplied", call.=FALSE)
}

nw <- fread(args[1])

cl <- fread(args[2])

# Construct nodelist
nl <- union(nw$V1,nw$V2)

# Filter clustering output against nodelist to remove dummies
no_dummies <- cl[V1 %in% nl]

output_file_name <- paste0('no_dummies_',args[2],'.tsv')
write.table(no_dummies, file=output_file_name, sep="\t", col.names = F, row.names = F)
