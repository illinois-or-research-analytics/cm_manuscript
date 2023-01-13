DROP TABLE IF EXISTS public.oc_iid_edgelist;
CREATE TABLE oc_iid_edgelist AS
SELECT oc.citing, oc.cited, ocp1.iid AS citing_iid, ocp2.iid AS cited_iid
FROM open_citations
INNER JOIN open_citation_pubs ocp1 ON ocp1.doi=cte.citing 
INNER JOIN open_citation_pubs ocp2 ON ocp2.doi=cte.cited;

