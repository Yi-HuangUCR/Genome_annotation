#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=60
#SBATCH --mem-per-cpu=4G
#SBATCH --nodes=1
#SBATCH --time=02-00:00:00
#SBATCH --mail-user=yhuan073@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --output=Funnanotate.stdout
#SBATCH -p intel
set -e

module  load funannotate/1.6.0
ASSEMPATH=/bigdata/littlab/shared/Manzanita/Dovetail_final_assembly/second_delivered
ASSEM=arctostaphylos_sp_29Aug2019_kc8ay.fasta 
BASE=manzanita

#I want to filter the size of the assmebly to help things out. BUSCO shows that stuff below 5kb isnt really contributing to the genespace anyways
# for the masurca assembly I am skipping this because it already has large contigs
if [ ! -e $BASE.l5000.fa ]; then
    echo Removing contigs less than 5kb ot speed annotation and because they do not contribute much to the gene space...
    #module load BBMap
    #reformat.sh in=$ASSEMPATH/$ASSEM out=$BASE.l5000.fa minlength=5000
else
    echo Contigs less than 5kb already removed
fi

#Clean the repetitive contigs
#skip this for masurca because it takes forever and doesnt remove much
if [ ! -e $BASE.cleaned.fa ]; then
    echo $(date): Running funannotate clean on $BASE...
    #funannotate clean \
#	-i $ASSEMPATH/$ASSEM \
#	-o $BASE.cleaned.fa \
#	--cpus $SLURM_CPUS_PER_TASK
    echo $(date): Done.
else
    echo $(date): $BASE already cleaned
fi

#Perform the sorting and renaming of contigs
if [ ! -e $BASE.sorted.fa ]; then
    echo $(date): Sorting $BASE...
    funannotate sort \
	-i $ASSEMPATH/$ASSEM \
	-o $BASE.sorted.fa
    echo $(date): Done.
else
    echo $(date): $BASE already sorted.
fi

#Repeat mask the assembly
if [ ! -e $BASE.masked.fa ]; then
    echo $(date): Masking $BASE...
    funannotate mask \
	-i $BASE.sorted.fa \
	-o $BASE.masked.fa \
	-l ../Mask_repetitive_element/FinalRepeats.fa \
	--cpus $SLURM_CPUS_PER_TASK
    echo $(date): Done.
else
    echo $(date): $BASE.fa already masked.
fi
