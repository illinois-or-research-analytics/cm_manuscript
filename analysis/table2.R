rm(list=ls())
library(data.table)
library(xtable)

table2_fun <- function(parent,tag,directory) {
setwd(directory)
parent_network <- fread(parent)
nc_denom <- length(union(parent_network$V1,parent_network$V2))

l <- fread(paste0('cen_',tag,'.tsv'))
l_nt_10 <- fread(paste0('cen_',tag,'_nontree_n10_clusters.tsv'))
l_nt_10_cm <- fread(paste0('cen_',tag,'_after.tsv'))
l_nt_10_cm_r2 <- fread(paste0('cen_',tag,'_r2nontree_n10_clusters.tsv'))

r1 <- l[,.N,by='V2'][N>10][,.(length(N),min(N),median(N),max(N),round(100*(sum(N)/nc_denom),2))]
r2 <- l_nt_10[,.N,by='V2'][N>10][,.(length(N),min(N),median(N),max(N),round(100*(sum(N)/nc_denom),2))]
r3 <- l_nt_10_cm[,.N,by='V2'][N>10][,.(length(N),min(N),median(N),max(N),round(100*(sum(N)/nc_denom),2))]
r4 <- l_nt_10_cm_r2[,.N,by='V2'][N>10][,.(length(N),min(N),median(N),max(N),round(100*(sum(N)/nc_denom),2))]

df <- rbind(r1,r2,r3,r4)
df <- cbind(rep(tag,4),rep('rx',4),df)
return(df)
}

l5 <- table2_fun('cen_cleaned.tsv','leiden.5','/data1/snap_leiden_venv/cen')
l1 <- table2_fun('cen_cleaned.tsv','leiden.1','/data1/snap_leiden_venv/cen')
l01 <- table2_fun('cen_cleaned.tsv','leiden.01','/data1/snap_leiden_venv/cen')
l001 <- table2_fun('cen_cleaned.tsv','leiden.001','/data1/snap_leiden_venv/cen')

df2 <-rbind(l5,l1,l01,l001)
colnames(df2) <- c('clustering','rx', 'clus_count','min','median','max','node_cov')
fwrite(df2,'/data1/chackoge/repos/cm_manuscript/analysis/table2.csv')
print(xtable(df2))



