import argparse
import json
import math
from collections import defaultdict, Counter
import matplotlib.pyplot as plt
import networkx as nx
import numpy as np
import pandas as pd
import seaborn as sns
from networkx.algorithms.community import modularity

name_map = {"cen": "Curated Exosome citation network (CEN)",
                "oc": "Open Citations network",
                "cit_hepph": "High energy physics citation network",
                "cit_patents":"US patents citation network",
                "wiki_topcats":"Wikipedia hyperlinks network",
                "wiki_talk":"Wikipedia talk (communication) network"}


'''def plot_degree_dist(df_emp, df_lfr, r, name):
    plt.cla()
    plt.grid(linestyle='--', linewidth=0.5)
    df_emp['log10(count)'] = np.log10(df_emp['count'])
    df_emp['log10(degree)'] = np.log10(df_emp['degree'])
    df_lfr['log10(count)'] = np.log10(df_lfr['count'])
    df_lfr['log10(degree)'] = np.log10(df_lfr['degree'])
    sns.scatterplot(data=df_emp, y="log10(count)", x="log10(degree)", linewidth=0, color='black', alpha=0.8, label='Empirical network')
    sns.scatterplot(data=df_lfr, y="log10(count)", x="log10(degree)", linewidth=0, color='turquoise', alpha=0.8, label='LFR network')
    plt.title(name_map[name])
    plt.xlabel('log10 (degree)')
    plt.ylabel('log10 (node count)')
    plt.savefig(name + '_degree_'+r+'.pdf')'''


def plot_degree_dist(ax, df_emp, df_lfr, r, name):
    ax.cla()
    ax.grid(linestyle='--', linewidth=0.5)
    df_emp['log10(count)'] = np.log10(df_emp['count'])
    df_emp['log10(degree)'] = np.log10(df_emp['degree'])
    df_lfr['log10(count)'] = np.log10(df_lfr['count'])
    df_lfr['log10(degree)'] = np.log10(df_lfr['degree'])
    sns.scatterplot(ax=ax, data=df_emp, y="log10(count)", x="log10(degree)", linewidth=0, color='black', alpha=0.7, label='Empirical network')
    sns.scatterplot(ax=ax, data=df_lfr, y="log10(count)", x="log10(degree)", linewidth=0, color='turquoise', alpha=0.7, label='LFR network')
    ax.set_title(name_map[name])
    ax.set_xlabel('log10 (degree)')
    ax.set_ylabel('log10 (node count)')


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Ploting degree and community size distribution.')
    #parser.add_argument('-n', metavar='net', type=str, required=True,
     #                   help='network name')
    args = parser.parse_args()

    r = '01'
    net_list = [["cen", "oc"],
                ["cit_hepph", "cit_patents"],
                ["wiki_topcats", "wiki_talk"]]
    fig, axes = plt.subplots(3, 2, figsize=(12, 15))

    for i in range(3):
        for j in range(2):
            net = net_list[i][j]
            degree_df = pd.read_csv('yasamin/' + net + '_cleaned_degrees.csv')
            degree_dfs_lfr = pd.read_csv('yasamin/' + net + '_leiden.' + r + '_lfr/' + 'network_cleaned_degrees.tsv')
            plot_degree_dist(axes[i, j], degree_df, degree_dfs_lfr, r, net)

    plt.savefig('all_degrees.pdf', bbox_inches='tight')

    '''net = nx.read_edgelist('yasamin/'+args.n+'_cleaned.tsv', nodetype=int)
    degrees = [d for _, d in net.degree()]
    degree_df = pd.Series(Counter(degrees)).sort_index().rename_axis('degree').reset_index(name='count')
    degree_df.to_csv('yasamin/'+args.n+'_cleaned_degrees.csv')'''
    #degree_df = pd.read_csv('yasamin/'+args.n+'_cleaned_degrees.csv')

    '''lfr_net = nx.read_edgelist('yasamin/' + args.n + '_leiden.' + r + '_lfr/' + 'network_cleaned.tsv', nodetype=int)
    degrees_lfr = [d for _, d in lfr_net.degree()]
    degree_dfs_lfr = pd.Series(Counter(degrees_lfr)).sort_index().rename_axis('degree').reset_index(name='count')
    degree_dfs_lfr.to_csv('yasamin/' + args.n + '_leiden.' + r + '_lfr/' + 'network_cleaned_degrees.tsv')'''
    #degree_dfs_lfr = pd.read_csv('yasamin/' + args.n + '_leiden.' + r + '_lfr/' + 'network_cleaned_degrees.tsv')

    #plot_degree_dist(degree_df, degree_dfs_lfr, r, args.n)

