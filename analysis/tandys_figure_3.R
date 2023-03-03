library(ggplot2)

#p <- ggplot() + geom_function(fun = function(x) ceiling(0.01*(x-1)), linewidth=1.2,colour = "red") + 
#  geom_function(fun = function(x) floor(1 + log10(x)), linewidth=1.2,colour = "blue") +
#  theme_bw()  + xlim(0,500)  + scale_y_continuous(breaks=c(seq(0,500,by=50))) +
#  xlab("cluster_size") + ylab("min_valid_cut") + theme(text = element_text(size = 20))


#pdf('tandys_figure_3.pdf')
#print(p)
#dev.off()

ggplot() + xlim(0,500) + ylim(0,5) +# scale_y_continuous(breaks=c(seq(0,500,by=50))) +
  geom_function(aes(colour = "Equation 1"), fun = function(x) ceiling(0.01*(x-1))) + 
  geom_function(aes(colour = "Equation 2"), fun = function(x) floor(1 + log10(x))) +
  theme_bw()+
  theme(legend.position = "right")+
  scale_colour_manual(values = c("blue", "red"))+
  xlab("Cluster size (n)") + ylab("Minimum valid cut size")+
  guides(colour=guide_legend(title=""))
  #annotate(geom="text",label=expression("f(x)"), x = 0.13, y = 4, parse = TRUE, color="red")

ggsave("well_connected_definition.pdf",width=4.5,height=3)