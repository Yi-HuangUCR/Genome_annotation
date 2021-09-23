!/bin/bash -l
python -m jcvi.compara.catalog ortholog ag ac --cscore=.99 --no_strip_names --dbtype prot
python -m jcvi.graphics.dotplot ag.ac.anchors

