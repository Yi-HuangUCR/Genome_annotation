#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=10G
#SBATCH --time=00-02:00:00     # 1 day and 15 minutes
#SBATCH --output=ag_cs_MCScanX.stdout
#SBATCH --mail-user=yhuan073@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="ag_cs_MScanX"
#SBATCH -p short # This is the default partition, you can use any of the following; intel, batch, highmem, gpu

./MCScanX ./ag_cs/ag_cs 
