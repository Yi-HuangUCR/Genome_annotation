#!/bin/bash -l
#SBATCH -p short
module load bedtools

awk -v OFS="\t" '{ if ($3 == "mRNA") print $1, $4, $5 }' ../../glauca_rnd1.all.maker.noseq.gff | \
awk -v OFS="\t" '{ if ($2 < 1000) print $1, "0", $3+1000; else print $1, $2-1000, $3+1000 }' | \
bedtools getfasta -fi ../../../manzanita.sorted.fa -bed - -fo glauca_rnd1.all.maker.transcripts1000.fasta
