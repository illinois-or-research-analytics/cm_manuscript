setwd('~/Des	ktop/SNAP')
rm(list=ls())
library(data.table)
library(ggplot2)

# read in CEN Leiden CPM/0.01 clustering with tree annotations plus 
# filtered for N > 10
x <- fread('datalist_cen_leiden.001_10_treed.tsv')

p <- ggplot(data=x,aes(x=log10(node_count),log10(edge_count),color=type)) + 
geom_point(alpha=0.05) + theme_bw() + theme(legend.position="none")

p1 <- p + theme(text = element_text(size = 20))

pdf('cen_fig1.pdf')
print(p1)
dev.off()

system('cp cen_fig1.pdf ~/repos/cm_manuscript/latex/')