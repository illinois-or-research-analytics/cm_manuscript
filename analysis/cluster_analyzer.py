import networkit as nk
import pandas as pd
import sys
import time
from multiprocessing import Pool, cpu_count
import argparse

'''This script reads a clustering file, an edgelist file, upper and lower bounds
for cluster size and outputs the qualified clusters along with their sizes and number of intra
cluster edges'''



''' Function to return number of edges present in
the subgraph constructed using nodes of node_list 
on the graph g'''
def getNoEdges(node_list, node_map, g):
    global cnt
    node_map_str = []
    cnt +=1
    if cnt%100==0:
            print(cnt,"clusters done", flush=True)
    for node in node_list:
        if str(node) not in node_map:
            raise ValueError("Edgeless node found" + str(node))
        else:
            node_map_str.append(node_map[str(node)])
    t = nk.graphtools.subgraphFromNodes(g, node_map_str)
    return t.numberOfEdges()

''' Calls the function fn, len(node_lists) times and parallelizes
these calls over no_cores of CPU'''
def applyParallel(node_lists, node_map, g, fn, no_cores):
    with Pool(no_cores) as p:
        ret_list = p.starmap(fn, [(node_list,node_map,g) for node_list in node_lists])
    return list(ret_list)

''' Returns a Data Frame with cluster_id, node_list, num_nodes'''
def getClusterInfo(clustering_fname, graph_fname, no_cores=10, lb_clustersz = 1, ub_clustersz = sys.maxsize):
    cl1 = pd.read_table(clustering_fname,names=["node_id", "cluster_id"])
    print("At stage group by", flush=True)
    st_groupby = time.time()
    cl1 = cl1.groupby('cluster_id')['node_id'].apply(list).reset_index(name="node_list")
    en_groupby = time.time()
    print("Group by stage completed it took", en_groupby - st_groupby,"seconds", flush=True)
    
    elr = nk.graphio.EdgeListReader("\t", 0, continuous = False)
    g = elr.read(graph_fname)
    node_map = elr.getNodeMap()
    
    print("At stage num_nodes", flush=True)
    st_num_nodes = time.time()
    cl1["node_cnt"] = cl1["node_list"].apply(lambda node_list:len(node_list))    
    cl1 = cl1[(cl1["node_cnt"]>=lb_clustersz) & (cl1["node_cnt"]<=ub_clustersz)]
    print("Post applying the lower and upper bounds:", len(cl1), "clusters", flush=True)
    en_num_nodes = time.time()
    print("num_nodes stage completed it took", en_num_nodes - st_num_nodes, "s", flush=True)
    print("At stage num edges", flush=True)

    st_num_edges = time.time()
    cl1["edge_cnt"] = applyParallel(cl1["node_list"].values, node_map, g, getNoEdges, no_cores)    
    en_num_edges = time.time()
    print("num_edges stage completed it took", en_num_edges - st_num_edges, "s", flush=True)
    cl1 = cl1.drop(columns=['node_list'])
    return cl1

parser = argparse.ArgumentParser()
parser.add_argument('-g', type=str, required=True, help="edge list file path")
parser.add_argument('-c', type=str, required=True, help="two column clustering file path")
parser.add_argument('-o', type=str, required=True, help="output file path(as .tsv)")
parser.add_argument('-lb', type=int, required=False, default=10, help="lower bound on cluster size(inclusive) default=10")
parser.add_argument('-ub', type=int, required=False, default=sys.maxsize, help="upper bound on cluster size(inclusive) default=infinite")
parser.add_argument('-n', type=int, required=False, default=10, help="number of CPU cores to be used default=10" )
args = parser.parse_args()

print("Args used:", flush=True)
print(args,flush=True)

cnt = 0
st = time.time()
df = getClusterInfo(args.c, args.g, args.n, args.lb, args.ub)
et=time.time()
print("Execution time:",et-st,"seconds", flush=True)
df.to_csv(args.o, sep="\t")

