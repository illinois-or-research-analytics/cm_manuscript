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

print("*** Begin ***")
print(args,flush=True)

input_graph=args.g
input_clustering=args.i
bound = args.b
cnames=['node_id','cluster_id']

print("Read in clustering file",flush=True)
l_df = pd.read_table(input_clustering,header=None,names=cnames)

print("Converting clustering df to dict")
l_dict = dict(l_df.groupby('cluster_id')['node_id'].apply(lambda x: x.tolist()))

print("Loading in graph used as input to clustering",flush=True)
elr = nk.graphio.EdgeListReader("\t", 0, continuous = False)
g = elr.read(input_graph)
g = nk.graphtools.toUndirected(g) # may not be necessary
print(nk.graphtools.size(g),flush=True)
print("Loaded graph of size {}".format(nk.graphtools.size(g)),flush=True)

print("Make a working dict (reduces the amount of computation)")
working_dict  = {k:v for k, v in l_dict.items() if len(v)> bound}

# convert node labels to ids
node_map = elr.getNodeMap()

print("Looping through working dict",flush=True)
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
    datalist.append(node_tuple)
    if key % 50 == 0:
        print("Completed {}".format(key),flush=True)

print("Converting datalist to df",flush=True)
# Convert to df and write to file
df2 = pd.DataFrame(datalist, columns =['cluster_id', 'node_count', 'edge_count'])
df2.to_csv("datalist_{}_{}.tsv".format(args.o,args.b), sep="\t")
print("*** All Done ***",flush=True)

    




