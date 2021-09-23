#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=64G
#SBATCH --time=00-02:00:00     # 1 day and 15 minutes
#SBATCH --mail-user=yhuan073@ucr.edu
#SBATCH --out=BuildDatabase.out
#SBATCH --mail-type=ALL
#SBATCH --job-name="BuildDatabase"
#SBATCH -p short # This is the default partition, you can use any of the following; intel, batch, highmem, gpu

module load RECON

module load RepeatScout

module load ncbi-blast

module load RepeatModeler/1.0.11
module load RepeatMasker/4-0-7
module load BBMap
module load ncbi-blast/2.2.30+
module load hmmer/3.1b2


BuildDatabase -name manzanita  -engine ncbi ../arctostaphylos_sp_29Aug2019_kc8ay.fasta


#module load RepeatModeler

#module load RECON

#module load RepeatScout

#module load TRF

#RepeatModeler/BuildDatabase -name manzanita  -engine ncbi ../arctostaphylos_sp_29Aug2019_kc8ay.fasta
