library(data.table)
args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "default.tsv"
}

df <- fread(args[1])
q1 <- unname(summary(df$node_count)[2])
q2 <- unname(summary(df$node_count)[3])
q3 <- unname(summary(df$node_count)[5])

df[node_count < q1 ,quartile:='q1']
df[is.na(quartile) & node_count < q2, quartile:='q2']
df[is.na(quartile) & node_count < q3, quartile:='q3']
df[is.na(quartile) & node_count >= q3 ,quartile:='q4']

df[node_count!=edge_count+1,type:='non-tree']
df[node_count==edge_count+1,type:='tree']

write.table(df, file=args[2], sep="\t", row.names = F)

