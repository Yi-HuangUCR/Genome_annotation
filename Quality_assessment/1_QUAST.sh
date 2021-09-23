#!/bin/bash

#SBATCH --time=00-2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=64GB # Change back to 32GB for an intel run.
#SBATCH --output=QUAST.stdout
#SBATCH --mail-user=yhuan073@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="QUAST"
#SBATCH -p short

module load QUAST

python /opt/linux/centos/7.x/x86_64/pkgs/QUAST/4.6.3/quast.py -o quast_result/ arctostaphylos_sp_29Aug2019_kc8ay.fasta --gene-finding --eukaryote
