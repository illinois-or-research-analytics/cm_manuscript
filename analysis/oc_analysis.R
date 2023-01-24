rm(list=ls())
setwd('/data2/oc_sampling')
library(data.table)

# define function to process Leiden clusterings
oc_analysis <- function(label) {
	x_vec <- Sys.glob(paste0('*',label,'*'))
	x_vec <- sort(x_vec)
	print(x_vec)	

# Load Leiden output	
	x_orig <- fread(paste0('../open_citations/oc_',label,'.tsv'))
	#x_singleton <-  x_orig[,.N,by='V2'][N==1][,length(N)]
	#x_singleton_dist <- c(x_singleton,1,1,1)
	#singleton_df <- data.frame(t(x_singleton_dist))
	#colnames(singleton_df) <- c('V1','V2','V3','V4')
	x_2_10_dist <-  x_orig[,.N,by='V2'][N>1 & N <=10][,.(length(N),min(N),as.integer(round(median(N))),max(N))]
# Filter by size
	x_size_filtered <-  x_orig[,.N,by='V2'][N > 10][,length(N)]
	x_size_filtered_dist <-  x_orig[,.N,by='V2'][N > 10][,.(length(N),min(N),as.integer(round(median(N))),max(N))]
# Annotate for trees
	x_annotated <- fread(x_vec[4])
	x_annotated_dist <- x_annotated[,.(length(node_count),min(node_count),as.integer(round(median(node_count))),max(node_count)),by=type]
	x_annotated_dist <- x_annotated_dist[,.(V1, V2, V3, V4, type)]
# Sample
	x_sample <- fread(x_vec[1])
	x_sample_dist <- x_sample[,.N,by='V2'][,.(length(N),min(N),as.integer(round(median(N))),max(N))]
	# print(x_sample_dist)
# Post CM	
	x_post_cm <- fread(x_vec[7])
	x_post_cm_dist <- x_post_cm[,.N,by='V2'][N > 10][,.(length(N),min(N),as.integer(round(median(N))),max(N))]
# stack 
	stack <- rbind(x_2_10_dist,x_size_filtered_dist,x_annotated_dist,x_sample_dist,x_post_cm_dist,fill=TRUE)
	# print(stack)
	return(stack)
}

leiden_vec <- c('leiden.5', 'leiden.1', 'leiden.01', 'leiden.001', 'leiden.0001')

oc_df <- data.frame()
for (i in 1:length(leiden_vec)) {
	df <- oc_analysis(leiden_vec[i])
	df[,gp:=leiden_vec[i]]
	oc_df <- rbind(oc_df,df)
}
 oc_df[is.na(type),type:='-']
print(oc_df)
