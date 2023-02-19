import leidenalg
import igraph
import argparse


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Script for running leiden.')
    parser.add_argument('-n', metavar='net', type=str, required=True,
                        help='network edge-list path')
    parser.add_argument('-r', metavar='resolution', type=float, required=True,
                        help='resolution parameter (gamma)')
    parser.add_argument('-o', metavar='output', type=str, required=True,
                        help='output membership path')
    args = parser.parse_args()

    net = igraph.Graph.Load(args.n, format='edgelist', directed=False)
    partition = leidenalg.find_partition(net, leidenalg.CPMVertexPartition, resolution_parameter=args.r)
    with open(args.o, "w") as f:
        for n, m in enumerate(partition.membership):
            f.write(f"{n}\t{m}\n")

