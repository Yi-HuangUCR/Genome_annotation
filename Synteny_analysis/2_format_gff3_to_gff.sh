#!/bin/bash -l
#SBATCH -p short
grep "scaffold_" ../Arctostaphylos_glauca.gff3 | awk '/gene/ {print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $9}' > test.gff
grep "scaffold_" ../Arctostaphylos_glauca.gff3 | awk '/CDS/ {print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $9}' > test1.gff

cat test.gff test1.gff > combined.gff

sed 's/ID=//g' combined.gff| sed 's/;.*//' > test2.gff 

awk '{print $1 "\t" $5 "\t" $3 "\t" $4}' test2.gff > test3.gff

sed -i 's/scaffold_/ag/g' test3.gff


rm combined.gff
rm test.gff
rm test1.gff
rm test2.gff
mv test3.gff ag.gff

#cat test.gff |awk'/^gene/ {print $2"\t"$0}' > test1.gff 
#grep 'gene' ../Arctostaphylos_glauca.gff3 | awk '{print $1"\t"$9"\t"$4"\t"$5}' | sed 's/ID=.*;Name=//g' > test1.gff

#sed 's/-T1//g' ag-original.blast > ag.blast
