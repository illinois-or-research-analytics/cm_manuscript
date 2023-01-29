# On odesa

table1_fun <- function(network,clustering,directory) {
setwd(directory)
library(data.table)
library(xtable)

parent <- fread(network) 
nc_denom <- length(union(parent$V1,parent$V2))
x <- fread(clustering)
x_singleton_count <- x[,.N,by='V2'][N==1][,length(N)]
x_non_singleton_count <- x[,.N,by='V2'][N>1][,length(N)]
x_11_plus <- x[,.N,by='V2'][N>10]
nc_num <- x_11_plus[,sum(N)]
x_11_plus_vec <- x_11_plus[,.(length(N),min(N),median(N),max(N),round(100*nc_num/nc_denom,2))][1]
counts <- unname(unlist(c(x_singleton_count,x_non_singleton_count,x_11_plus_vec)))
return(counts)

}

l5 <- table1_fun('cen_cleaned.tsv','cen_leiden.5.tsv','/data1/snap_leiden_venv/cen')
l1 <- table1_fun('cen_cleaned.tsv','cen_leiden.1.tsv','/data1/snap_leiden_venv/cen')
l01 <- table1_fun('cen_cleaned.tsv','cen_leiden.01.tsv','/data1/snap_leiden_venv/cen')
l001 <- table1_fun('cen_cleaned.tsv','cen_leiden.001.tsv','/data1/snap_leiden_venv/cen')

df <- rbind(l5,l1,l01,l001)
col1 <- c('leiden 0.5','leiden 0.1','leiden 0.01','leiden 0.001')
rownames(df) <- NULL
df <- data.frame(df)
df <- cbind(col1,df)
colnames(df) <- c('clustering','n=1','n>1','n>10','min','med','max','node_cov')
print(df)
fwrite(df,file='/data1/chackoge/repos/cm_manuscript/latex/table1.csv')
print(xtable(df))







