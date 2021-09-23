#!/bin/bash -l
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=10G
#SBATCH --time 00-02:00:00
#SBATCH --mail-user=yhuan073@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --output=summarize_annotate.out
#SBATCH -p short
set -e

module load funannotate
module unload iprscan
module load iprscan/5.39-77.0

#funannotate iprscan -i Predicted_2 -m local --iprscan_path /opt/linux/centos/7.x/x86_64/pkgs/iprscan/5.39-77.0/interproscan.sh

#funannotate remote -i Predicted_2 -m phobius -e yhuan073@ucr.edu

funannotate annotate -i Predicted_2 -s "Arctostaphylos glauca" --cpus 20 -o Second_annnotation --force

#Run antiSMASH:
#funannotate remote -i Predicted_2 -m antismash -e yhuan073@ucr.edu

#Annotate Genome:
#funannotate annotate -i Predicted_2 --cpus 60 --sbt yourSBTfile.txt

