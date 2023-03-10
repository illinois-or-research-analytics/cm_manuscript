library(data.table)
rm(list=ls())

setwd("/data1/snap_leiden_venv/placeholder")
source <- fread('/data1/snap_leiden_venv/placeholder/placeholder_cleaned.tsv')
nc_denom <- length(union(source$V1,source$V2))

# vectors of file names- needs to be refined
leiden.5 <- Sys.glob("placeholder_leiden.5*.tsv")
leiden.1 <- Sys.glob("placeholder*leiden.1*.tsv")
leiden.01 <- Sys.glob("placeholder*leiden.01*.tsv")
leiden.001 <- Sys.glob("placeholder*leiden.001*.tsv")


# leiden 0.5
lei_list.5 <- list()
for (i in 1:length(leiden.5)) {
  lei_list.5[[i]] <- fread(leiden.5[i])
}
names(lei_list.5) <- leiden.5

# leiden 0.1
lei_list.1 <- list()
for (i in 1:length(leiden.1)) {
  lei_list.1[[i]] <- fread(leiden.1[i])
}
names(lei_list.1) <- leiden.1

# leiden 0.01
lei_list.01 <- list()
for (i in 1:length(leiden.01)) {
  lei_list.01[[i]] <- fread(leiden.01[i])
}
names(lei_list.01) <- leiden.01


# leiden 0.001
lei_list.001 <- list()
for (i in 1:length(leiden.001)) {
  lei_list.001[[i]] <- fread(leiden.001[i])
}
names(lei_list.001) <- leiden.001


t.5 <- lapply(lei_list.5, FUN = function(x) x[,.N,by='V2'][N>10,.(cc=length(N),nc=sum(N)/nc_denom,count=sum(N),min=min(N),med=median(N),max=max(N))])

t.1 <- lapply(lei_list.1, FUN = function(x) x[,.N,by='V2'][N>10,.(cc=length(N),nc=sum(N)/nc_denom,count=sum(N),min=min(N),med=median(N),max=max(N))])

t.01 <- lapply(lei_list.01, FUN = function(x) x[,.N,by='V2'][N>10,.(cc=length(N),nc=sum(N)/nc_denom,count=sum(N),min=min(N),med=median(N),max=max(N))])

t.001 <-lapply(lei_list.001, FUN = function(x) x[,.N,by='V2'][N>10,.(cc=length(N),nc=sum(N)/nc_denom,count=sum(N),min=min(N),med=median(N),max=max(N))])


t.5 <- cbind(names(t.5),rbindlist(t.5))[,.(Rx=V1,clus_ct=cc,node_cov=nc,node_count=count,min,med,max)]
t.1 <- cbind(names(t.1),rbindlist(t.1))[,.(Rx=V1,clus_ct=cc,node_cov=nc,node_count=count,min,med,max)]
t.01 <- cbind(names(t.01),rbindlist(t.01))[,.(Rx=V1,clus_ct=cc,node_cov=nc,node_count=count,min,med,max)]
t.001 <- cbind(names(t.001),rbindlist(t.001))[,.(Rx=V1,clus_ct=cc,node_cov=nc,node_count=count,min,med,max)]

placeholder_cm_df <- rbind(t.5,t.1,t.01,t.001)
# optional to remove preprocessed data (cm before cm_universal)
placeholder_cm_df <- placeholder_cm_df[grep("preprocessed", placeholder_cm_df$Rx, invert = TRUE), ]

# write to file
fwrite(placeholder_cm_df,file='placeholder_cm_df.csv')
placeholder_cm_df












