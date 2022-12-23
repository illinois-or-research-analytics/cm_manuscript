# Process Leiden output preparatory to running CM (connectivity modifier)
# George Chacko 12/23/2022
# Needs to be modified to reduce hard coded files and paths
# For now I use sed to find and replace cen with say wtp

import belinda as bl
import polars as pl
import os

os.chdir('/data1/snap_leiden_venv/cen')
g = bl.Graph("./cen_clean.tsv")

c5 = bl.read_membership(g,"cen_leiden.5.tsv") # won't accept c.5 as name
c1 = bl.read_membership(g,"cen_leiden.1.tsv")
c01 = bl.read_membership(g,"cen_leiden.01.tsv")
c001 = bl.read_membership(g,"cen_leiden.01.tsv")

# remove trees
c5_wt = c5.filter(pl.col('n') != pl.col('m') + 1)
c1_wt = c1.filter(pl.col('n') != pl.col('m') + 1)
c01_wt = c01.filter(pl.col('n') != pl.col('m') + 1)
c001_wt = c001.filter(pl.col('n') != pl.col('m') + 1)

bl.write_membership(g, c5_wt, "cen_leiden.5_nontree_clusters.tsv")
bl.write_membership(g, c1_wt, "cen_leiden.1_nontree_clusters.tsv")
bl.write_membership(g, c01_wt, "cen_leiden.01_nontree_clusters.tsv")
bl.write_membership(g, c001_wt, "cen_leiden.001_nontree_clusters.tsv")

# filter N > 10
c5_wt_n10 = c5_wt.filter(pl.col('n') > 10) 
c1_wt_n10 = c1_wt.filter(pl.col('n') > 10) 
c01_wt_n10 = c01_wt.filter(pl.col('n') > 10) 
c001_wt_n10 = c001_wt.filter(pl.col('n') > 10)

bl.write_membership(g, c5_wt_n10, "cen_leiden.5_nontree_n10_clusters.tsv")
bl.write_membership(g, c1_wt_n10, "cen_leiden.1_nontree_n10_clusters.tsv")
bl.write_membership(g, c01_wt_n10, "cen_leiden.01_nontree_n10_clusters.tsv")
bl.write_membership(g, c001_wt_n10, "cen_leiden.001_nontree_n10_clusters.tsv")











