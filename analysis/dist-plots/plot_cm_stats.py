import multiprocessing as mp
import subprocess
import sys
import json
import os
import pandas as pd
import networkx as nx
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt


if __name__ == '__main__':
    df = pd.read_csv('cm_stats.csv')
    df['is_lfr'] = df['net_name'].str.contains('lfr')
    df['is_lfr'] = df['is_lfr'].map({True: 'LFR', False: 'Empirical'})
    df['net_name'] = df['net_name'].map(lambda x: x.rstrip('_lfr'))
    df['log10(clus_count_10)'] = np.log10(df['clus_count_10'])
    df['node_cov_10'] = 100*df['node_cov_10']
    df['net_name'] = df['net_name'].str.replace('cen', 'CEN')
    df['step'] = df['step'].str.replace('leiden', 'Leiden')
    df['step'] = df['step'].str.replace('cm+filter', 'CM+filter')
    #df['net_name'] = df['net_name'].str.replace('wiki_talk', 'Wikipedia talk')
    #df['net_name'] = df['net_name'].str.replace('wiki_topcats', 'Wikipedia hyperlinks')
    df['net_name'] = df['net_name'].str.replace('oc', 'open_citations')
    #df['net_name'] = df['net_name'].str.replace('cit_patents', 'Patents')
    #df['net_name'] = df['net_name'].str.replace('cit_hepph', 'High energy physics')
    df = df.sort_values(by=['net_name','is_lfr'], ascending=True)
    g = sns.FacetGrid(df, col="r", row="net_name", margin_titles=True, height=2.2,
                      row_order=['open_citations','CEN','cit_patents','cit_hepph','wiki_topcats','wiki_talk'],
                      col_order=[0.5, 0.1, 0.01, 0.001, 0.0001])
    g.map_dataframe(sns.pointplot, x="step", y="log10(clus_count_10)", hue='is_lfr', palette='Dark2')
    g.set_xlabels("")  # number of genes
    g.set_ylabels("")  # ("Species Tree Error (nCD)")
    g.set_titles(row_template='{row_name}',size=12)
    g.fig.subplots_adjust(top=0.8, bottom=0.16, left=0.14)
    g.fig.text(0.45, 0.1, s='CM Pipeline Stage', fontsize=14)
    #g.fig.text(0.09, 0.4, s='Node Coverage (%)', rotation=90, fontsize=14)
    g.fig.text(0.09, 0.4, s='log10 (Cluster count)', rotation=90, fontsize=14)
    g.set_xticklabels(rotation=35)
    g.add_legend(fontsize=12)
    plt.savefig('cm_clust_size.pdf', bbox_inches='tight')

