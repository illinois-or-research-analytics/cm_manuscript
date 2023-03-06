# calculate cm-sensitivity for filtered clusters in open citations
# using jq:
# e.g., jq '[.extant]' oc_leiden.5._filtered_cm_out.tsv.before.json | grep true | wc -l
# Generate plots for OC and CEN
# George Chacko 3/2/2023

setwd('~/')
library(data.table); library(ggplot2)
x <- fread('oc_istouched.tsv')
x$clustering <- factor(x$clustering,levels=c('leiden.5','leiden.1','leiden.01','leiden.001','leiden.0001'))
# convert extant=true to has_small_cut to assist easily-confused readers

x[no_mincut=='FALSE', small_cut:='yes']
x[no_mincut=='TRUE', small_cut:='no']

x$small_cut <- factor(x$small_cut,levels=c('yes','no'))


p1 <- ggplot(x, aes(fill=small_cut, y=count, x=clustering)) + geom_bar(position="stack",stat="identity") + 
theme_bw() 
p2 <- p1+  theme(axis.text.x=element_text(angle = -80, hjust = 0),text = element_text(size = 20,family="Helvetica")) + 
ylab('cluster_count')

pdf('~/repos/cm_manuscript/latex/figs/oc_istouched.pdf')
print(p2)
dev.off()

# CEN data
yesvec <- integer()
novec <- integer()
labelvec <- c('leiden 0.5', 'leiden 0.1','leiden 0.01', 'leiden 0.001')
setwd('/Users/chackoge/Desktop/cen_cm_quiet_pipeline/res-0.5')
yesvec[1] <- system("jq '[.extant]' S4.1_cen_leiden.0.5_preprocessed_cm.tsv.before.json | grep false | wc -l",intern=TRUE)
novec[1] <- system("jq '[.extant]' S4.1_cen_leiden.0.5_preprocessed_cm.tsv.before.json | grep true | wc -l",intern=TRUE)

setwd('/Users/chackoge/Desktop/cen_cm_quiet_pipeline/res-0.1')
yesvec[2] <- system("jq '[.extant]' S4.1_cen_leiden.0.1_preprocessed_cm.tsv.before.json | grep false | wc -l",intern=TRUE)
novec[2] <- system("jq '[.extant]' S4.1_cen_leiden.0.1_preprocessed_cm.tsv.before.json | grep true | wc -l",intern=TRUE) 

setwd('/Users/chackoge/Desktop/cen_cm_quiet_pipeline/res-0.01')
yesvec[3] <- system("jq '[.extant]' S4.1_cen_leiden.0.01_preprocessed_cm.tsv.before.json | grep false | wc -l",intern=TRUE)
novec[3] <- system("jq '[.extant]' S4.1_cen_leiden.0.01_preprocessed_cm.tsv.before.json | grep true | wc -l",intern=TRUE) 

setwd('/Users/chackoge/Desktop/cen_cm_quiet_pipeline/res-0.001')
yesvec[4] <- system("jq '[.extant]' S4.1_cen_leiden.0.001_preprocessed_cm.tsv.before.json | grep false | wc -l",intern=TRUE)
novec[4] <- system("jq '[.extant]' S4.1_cen_leiden.0.001_preprocessed_cm.tsv.before.json | grep true | wc -l",intern=TRUE) 

df <- data.frame(cbind(labelvec,yesvec,novec))
colnames(df) <- c('clustering','yes','no')
setDT(df)
df$yes <- as.integer(df$yes)
df$no <- as.integer(df$no)
long_df <- melt(df,id.vars="clustering")
colnames(long_df)[2] <- 'small_cut'
long_df$clustering <- factor(long_df$clustering,levels=c('leiden 0.5','leiden 0.1','leiden 0.01','leiden 0.001'))
long_df$small_cut <- factor(long_df$small_cut, levels=c('yes','no'))
p3 <- ggplot(long_df,aes(x=clustering,fill=small_cut,y=value)) + geom_bar(position="stack",stat="identity") + 
theme_bw() 
p4 <- p3 + theme(axis.text.x=element_text(angle = -80, hjust = 0),text = element_text(size = 20,family="Helvetica")) + 
ylab('cluster_count')

pdf('~/repos/cm_manuscript/latex/figs/cen_istouched.pdf')
print(p4)
dev.off()

