# Script for testing small samples of clustering output
# for the presence of trees. 1/7/2023

import os
import networkit as nk
import pandas as pd

import argparse
parser = argparse.ArgumentParser()
parser.add_argument('-g', type=str, required=True)
parser.add_argument('-i', type=str, required=True)
parser.add_argument('-o', type=str, required=True)
parser.add_argument('-b', type=int, required=True)
args = parser.parse_args()
print(args)

input_graph=args.g
input_clustering=args.i
bound = args.b
cnames=['node_id','cluster_id']

# Read in clustering file
l_df = pd.read_table(input_graph,header=None,names=cnames)

# Convert to dictionary (takes too long and would benefit from speedup)
l_dict = dict(l_df.groupby('cluster_id')['node_id'].apply(lambda x: x.tolist()))

# load input graph to clustering
elr = nk.graphio.EdgeListReader("\t", 0, continuous = False)
g = elr.read(input_graph)
g = nk.graphtools.toUndirected(g) # may not be necessary
print(nk.graphtools.size(g))
print("Loaded graph of size {}".format(nk.graphtools.size(g)))

# make a working dict (reduces teh amount of computation
working_dict  = {k:v for k, v in l_dict.items() if len(v)> bound}

# convert node labels to ids
node_map = elr.getNodeMap()

# loop through dict
datalist = list()
for key in working_dict:
    remapped_nodes = [node_map[str(node)] for node in working_dict[key]]
    t = nk.graphtools.subgraphFromNodes(g, remapped_nodes)
    #print(t.numberOfNodes()
    #print(t.numberOfEdges())
    if t.numberOfNodes() <= bound:
        continue
    node_tuple = (key, t.numberOfNodes(), t.numberOfEdges())
    print("Completed {}".format(key))
    datalist.append(node_tuple)

# Convert to df and write to file
df2 = pd.DataFrame(datalist, columns =['cluster_id', 'node_count', 'edge_count'])
df2.to_csv("datalist_{}_{}.tsv".format(args.o,args.b), sep="\t")
print("All Done")




