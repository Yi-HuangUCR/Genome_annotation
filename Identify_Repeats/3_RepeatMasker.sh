#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=10G
#SBATCH --time=03-00:00:00     # 1 day and 15 minutes
#SBATCH --mail-user=yhuan073@ucr.edu
#SBATCH --out=Mask.out
#SBATCH --mail-type=ALL
#SBATCH --job-name="RepeatMasker"
#SBATCH -p intel # This is the default partition, you can use any of the following; intel, batch, highmem, gpu

module load RepeatModeler
module load RepeatMasker
#module load wublast
module load ncbi-blast

RepeatMasker -parallel 20 -lib FinalRepeats.fa -html -gff -dir repeat_sort manzanita.sorted.fa 

