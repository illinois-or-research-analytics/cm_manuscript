library(ggplot2)

p <- ggplot() + geom_function(fun = function(x) ceiling(0.01*(x-1)), linewidth=1.2,colour = "red") + 
geom_function(fun = function(x) floor(1 + log10(x)), linewidth=1.2,colour = "blue") +
theme_bw()  + xlim(0,500)  + scale_y_continuous(breaks=c(seq(0,500,by=50))) +
xlab("cluster_size") + ylab("min_valid_cut") + theme(text = element_text(size = 20))


pdf('tandys_figure_3.pdf')
print(p)
dev.off()
