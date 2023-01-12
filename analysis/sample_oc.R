# script that samples from a large Leiden clustering
# taking 10% from each decile after clusters below 11 nodes are removed. 

# usage "Rscript sample_oc.R <name of input clustering file> 
# which should be in tsv without headers

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
y <- x[,.N,by='V2'][N>10]
z <- quantile(y$N,probs=seq(0,1,by=0.1))

for(i in 1:(length(unname(z))-1)) {
print(i)
temp = y[N >= z[i] & N <= z[i+1]]
sample_size <- ceiling(10*dim(temp)[1]/100)
dec_sample <- sample(temp$V2, sample_size)
write.csv(dec_sample,file=paste0('dec_sample_',i,'.csv'),row.names=FALSE)
}

file_vec <- list.files(pattern="*.csv")
file_list <- list()
for (i in 1:length(file_vec)){
file_list[[i]] <- fread(file_vec[i])
}

flatlist_df <- rbindlist(file_list)
flatlist_df <- unique(flatlist_df)

oc_sample <-x[V2 %in% flatlist_df$x]
write.table(oc_sample,file=paste0('sample_leiden_',args[1]),sep='\t',row.names=F,col.names=F)

