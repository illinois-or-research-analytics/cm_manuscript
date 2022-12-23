# Process cm output and refilter for trees

import belinda as bl
import polars as pl
import os

os.chdir('/data1/snap_leiden_venv/cen')
g = bl.Graph("./cen_clean.tsv")

# read in output from the first round of cm-cm_universal
r2c5 = bl.read_json(g,"cen_leiden.5_preprocessed_cm.out.tsv.after.json")
r2c1 = bl.read_json(g,"cen_leiden.1_preprocessed_cm.out.tsv.after.json")
r2c01 = bl.read_json(g,"cen_leiden.01_preprocessed_cm.out.tsv.after.json")
r2c001 = bl.read_json(g,"cen_leiden.001_preprocessed_cm.out.tsv.after.json")

# r2c1 = bl.read_membership(g,"cen_leiden.1_after.tsv",force_string_labels = True)
# c1 = bl.read_membership(g,"cen_leiden.1.tsv",force_string_labels = True)

#remove trees
r2c5_wt = r2c5.filter(pl.col('n') != pl.col('m') + 1)
r2c1_wt = r2c1.filter(pl.col('n') != pl.col('m') + 1)
r2c01_wt = r2c01.filter(pl.col('n') != pl.col('m') + 1)
r2c001_wt = r2c001.filter(pl.col('n') != pl.col('m') + 1)

bl.write_membership(g, r2c5_wt, "cen_leiden.5.r2_nontree_clusters.tsv")
bl.write_membership(g, r2c1_wt, "cen_leiden.1_r2_nontree_clusters.tsv")
bl.write_membership(g, r2c01_wt, "cen_leiden.01_r2_nontree_clusters.tsv")
bl.write_membership(g, r2c001_wt, "cen_leiden.001_r2_nontree_clusters.tsv")

# filter N > 10

r2c5_wt_n10 = r2c5_wt.filter(pl.col('n') > 10)
r2c1_wt_n10 = r2c1_wt.filter(pl.col('n') > 10)
r2c01_wt_n10 = r2c01_wt.filter(pl.col('n') > 10)
r2c001_wt_n10 = r2c001_wt.filter(pl.col('n') > 10) 

bl.write_membership(g, r2c5_wt_n10, "cen_leiden.5.r2_nontree_n10_clusters.tsv")
bl.write_membership(g, r2c1_wt_n10, "cen_leiden.1_r2nontree_n10_clusters.tsv")
bl.write_membership(g, r2c01_wt_n10, "cen_leiden.01_r2nontree_n10_clusters.tsv")
bl.write_membership(g, r2c001_wt_n10, "cen_leiden.001_r2nontree_n10_clusters.tsv")









