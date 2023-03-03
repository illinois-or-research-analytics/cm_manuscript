# Collect extant data relative to cluster size
rm(list=ls())
## CEN Data
setwd('~/Desktop/cen_cm_quiet_pipeline/')

# read in filtered Leiden 0.5 clustering
setwd('res-0.5')
l5f <- fread('S3.2_cm_ready_cen_leiden.0.5_nontree_n10.tsv')
# read in before json file using jq to parse it first
system("jq '.label,.extant' S4.1_cen_leiden.0.5_preprocessed_cm.tsv.before.json | paste - - > l5_extant.csv")
l5ex <- fread('l5_extant.csv')
l5fc <- l5f[,.N,by='V2']
l5_box <- merge(l5fc,l5ex,by.x='V2',by.y='V1')

# read in filtered Leiden 0.1 clustering
setwd('../res-0.1')
l1f <- fread('S3.2_cm_ready_cen_leiden.0.1_nontree_n10.tsv')
# read in before json file using jq to parse it first
system("jq '.label,.extant' S4.1_cen_leiden.0.1_preprocessed_cm.tsv.before.json | paste - - > l1_extant.csv")
l1ex <- fread('l1_extant.csv')
l1fc <- l1f[,.N,by='V2']
l1_box <- merge(l1fc,l1ex,by.x='V2',by.y='V1')

# read in filtered Leiden 0.01 clustering
setwd('../res-0.01')
l01f <- fread('S3.2_cm_ready_cen_leiden.0.01_nontree_n10.tsv')
# read in before json file using jq to parse it first
system("jq '.label,.extant' S4.1_cen_leiden.0.01_preprocessed_cm.tsv.before.json | paste - - > l01_extant.csv")
l01ex <- fread('l01_extant.csv')
l01fc <- l01f[,.N,by='V2']
l01_box <- merge(l01fc,l01ex,by.x='V2',by.y='V1')

# read in filtered Leiden 0.001 clustering
setwd('../res-0.001')
l001f <- fread('S3.2_cm_ready_cen_leiden.0.001_nontree_n10.tsv')
# read in before json file using jq to parse it first
system("jq '.label,.extant' S4.1_cen_leiden.0.001_preprocessed_cm.tsv.before.json | paste - - > l001_extant.csv")
l001ex <- fread('l001_extant.csv')
l001fc <- l001f[,.N,by='V2']
l001_box <- merge(l001fc,l001ex,by.x='V2',by.y='V1')

l001_box[,tag:='leiden 0.001']
l01_box[,tag:='leiden 0.01']
l1_box[,tag:='leiden 0.1']
l5_box[,tag:='leiden 0.5']
combined_box <- rbind(l5_box,l1_box,l01_box,l001_box)
combined_box[,V2:=NULL]
combined_box[V2.y=='TRUE',log10_mincut:='no']
combined_box[V2.y=='FALSE',log10_mincut:='yes']
combined_box$log10_mincut <- factor(combined_box$log10_mincut,levels=c('yes','no'))
combined_box$tag <- factor(combined_box$tag,levels=c('leiden 0.5','leiden 0.1','leiden 0.01','leiden 0.001'))
p <- ggplot(combined_box,aes(x=tag,y=log10(N),gp=log10_mincut,color=log10_mincut)) + geom_boxplot() +ylab("log10(Cluster Size)") + theme_bw()
p1 <- p + theme(axis.text.x=element_text(angle = -80, hjust = 0),text = element_text(size = 20,family="Helvetica")) + xlab("")
pdf('~/repos/cm_manuscript/latex/figs/cen_boxplot.pdf')
print(p1)
dev.off()


