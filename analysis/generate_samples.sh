# generate samples for open_citations for a pragmatic analysis of clusters generate
# see script "sample_oc.R" for details of sampling
# George Chacko Jan 22, 2023

Rscript /data1/chackoge/repos/cm_manuscript/analysis/sample_oc.R ../open_citations/oc_leiden.5.tsv  oc_leiden.5_annotated_treestarcounts.tsv
Rscript /data1/chackoge/repos/cm_manuscript/analysis/sample_oc.R ../open_citations/oc_leiden.1.tsv  oc_leiden.01_annotated_treestarcounts.tsv
Rscript /data1/chackoge/repos/cm_manuscript/analysis/sample_oc.R ../open_citations/oc_leiden.01.tsv  oc_leiden.01_annotated_treestarcounts.tsv
Rscript /data1/chackoge/repos/cm_manuscript/analysis/sample_oc.R ../open_citations/oc_leiden.001.tsv  oc_leiden.001_annotated_treestarcounts.tsv
Rscript /data1/chackoge/repos/cm_manuscript/analysis/sample_oc.R ../open_citations/oc_leiden.0001.tsv  oc_leiden.0001_annotated_treestarcounts.tsv

