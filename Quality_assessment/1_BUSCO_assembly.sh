#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=7G
#SBATCH --time=72:00:00
#SBATCH --mail-user=yhuan073@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -o busco.out
#SBATCH -p short
set -eu

#the point of this script is to assess the assembly with the BUSCO database
module unload miniconda2
module load miniconda3
module load busco/3.0.2
#module load busco/4.0.5
#We need to downgrade our blast version to make it work
module unload ncbi-blast
module load ncbi-blast/2.2.30+
ASSEM=manzanita.sorted.fa
ASSEMPATH=/bigdata/littlab/shared/Manzanita/Dovetail_final_assembly/second_delivered/MAKER/$ASSEM
BUSCOOUT=galuca_BUSCO_result

#BUSCO also needs augustus, and because of the cluster environment I have to install it separately
export PATH="/rhome/yhuan073/bigdata/software/augustus/bin:$PATH"
export PATH="/rhome/yhuan073/bigdata/software/augustus/scripts:$PATH"
export AUGUSTUS_CONFIG_PATH="/rhome/yhuan073/bigdata/software/augustus/config/"

#I really don't like this sincle core blast, but i can't get it to run correctly otherwise.
#also remove the -r flag if you're starting fresh
run_BUSCO.py \
    -m genome \
    -f \
    -c $SLURM_NTASKS \
    -i $ASSEMPATH \
    -o $BUSCOOUT \
    -l /srv/projects/db/BUSCO/v9/embryophyta_odb9/
#    -l /bigdata/littlab/shared/Manzanita/Dovetail_final_assembly/second_delivered/Quality_of_Assembly/solanaceae_odb10/
