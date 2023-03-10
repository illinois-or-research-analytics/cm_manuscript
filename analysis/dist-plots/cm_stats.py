import multiprocessing as mp
import subprocess
import sys
import json
import os
import pandas as pd
import networkx as nx
import numpy as np

dataset_path = './'

def membership_to_partition(membership):
    part_dict = {}
    for index, value in membership.items():
        if value in part_dict:
            part_dict[value].append(index)
        else:
            part_dict[value] = [index]
    return part_dict.values()

def clustering_statistics(name, step, r, net, membership, df):
    partition = membership_to_partition(membership)
    cluster_num = len(partition)
    #cluster_sizes = [len(c) for c in partition]
    larger_10_clusters = [len(c) for c in partition if len(c) > 10]
    non_singletons = [len(c) for c in partition if len(c) > 1]
    if len(larger_10_clusters) == 0:
        min_size, max_size, mean_size, median_size = 0, 0, 0, 0
    else:
        min_size, max_size, mean_size, median_size = int(np.min(larger_10_clusters)), int(np.max(larger_10_clusters)), \
                                                 np.mean(larger_10_clusters), np.median(larger_10_clusters)
    non_singleton_num = len(non_singletons)
    if name == 'oc':
        node_count = 75025194
    else:
        node_count = net.number_of_nodes()
    node_cov = sum(non_singletons) / node_count
    node_cov_10 = sum(larger_10_clusters) / node_count
    df = df.append({'net_name': name,
                    'step': step,
                    'r':r,
                    'clus_count': non_singleton_num,
                    'clus_count_10': len(larger_10_clusters),
                    'node_cov': node_cov,
                    'node_cov_10': node_cov_10,
                    'mean_size': mean_size,
                    'min_size': min_size,
                    'med_size': median_size,
                    'max_size': max_size},
                   ignore_index=True)
    return df


def get_membership_list_from_file(net, file_name):
    membership = dict()
    with open(file_name) as f:
        for line in f:
            i, m = line.strip().split()
            if net is None:
                membership[int(i)] = m
            elif int(i) in net.nodes:
                membership[int(i)] = m
    return membership


if __name__ == '__main__':
    nets = ["oc", "wiki_talk", "cit_hepph", "cit_patents", "wiki_topcats", "cen"]
    resolutions = ["0001", "001", "01", "1", "5"]
    df = pd.DataFrame(columns = ['net_name', 'step', 'r', 'clus_count', 'clus_count_10', 'node_cov', 'node_cov_10', 'mean_size', 'min_size', 'med_size', 'max_size'])
    for net in nets:
        if net == 'oc':
            edgelist = None
        else:
            edgelist = nx.read_edgelist(dataset_path + net + '_cleaned.tsv', nodetype=int)
        for r in resolutions:
            if r == '0001' and net != "oc":
                continue
            #with open(dataset_path + net+'_leiden.'+r+'.json') as f:
            #    stats = json.load(f)
            #df_stats = pd.json_normalize(stats)
            #df_stats.insert(loc=0, column='name', value=net+'_leiden.'+r+'.tsv')
            #df = df.append(df_stats, ignore_index=True)

            membership = get_membership_list_from_file(edgelist, dataset_path + net + '_processed_cm/' + net + '_leiden.' + r + '.tsv')
            df = clustering_statistics(net, 'leiden', '0.'+r, edgelist, membership, df)
            membership = get_membership_list_from_file(edgelist, dataset_path + net + '_processed_cm/' + net + '_leiden.' + r + '_nontree_n10_clusters.tsv')
            df = clustering_statistics(net, 'filter', '0.'+r, edgelist, membership, df)
            membership = get_membership_list_from_file(edgelist, dataset_path + net + '_processed_cm/' + net + '_leiden.' + r + '_r2nontree_n10_clusters.tsv')
            df = clustering_statistics(net, 'cm+filter', '0.'+r, edgelist, membership, df)

            if r == '5' and net == "wiki_talk":
                continue

            edgelist_lfr = nx.read_edgelist(dataset_path + net+'_leiden.'+r+'_lfr/network_cleaned.tsv', nodetype=int)
            membership = get_membership_list_from_file(edgelist_lfr, dataset_path + net+'_leiden.'+r+'_lfr/leiden.'+r+'_lfr.tsv')
            df = clustering_statistics(net+'_lfr', 'leiden', '0.'+r, edgelist_lfr, membership, df)
            membership = get_membership_list_from_file(edgelist_lfr, dataset_path + net + '_leiden.' + r + '_lfr/leiden.' + r + '_lfr_nontree_n10_clusters.tsv')
            df = clustering_statistics(net+'_lfr', 'filter', '0.'+r, edgelist_lfr, membership, df)
            #membership = get_membership_list_from_file(edgelist_lfr, dataset_path + net + '_leiden.' + r + '_lfr/cm_leiden.' + r + '_lfr_after.tsv')
            #df = clustering_statistics(net + '_leiden.' + r + '_lfr/cm_leiden.' + r + '_lfr_after.tsv', edgelist, membership, df)
            membership = get_membership_list_from_file(edgelist_lfr, dataset_path + net + '_leiden.' + r + '_lfr/cm_leiden.' + r + '_lfr_r2nontree_n10_clusters.tsv')
            df = clustering_statistics(net+'_lfr', 'cm+filter', '0.'+r, edgelist_lfr, membership, df)
            df.to_csv('cm_stats.csv')
    #df.to_csv('network_params_lfr.csv')

