#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=60
#SBATCH --mem-per-cpu=7G
#SBATCH --time 04-00:00:00
#SBATCH --mail-user=yhuan073@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --output=Predict.out
#SBATCH -p intel
set -e

ASSEM=manzanita.masked.fa
echo Running Funannotate predict on $ASSEM

module load funannotate/1.6.0
module unload CodingQuarry #unload the module or set the EVM weight to 0. it takes five-ever to complete!

#Set AUGUSTUS paths to the local copy
echo Setting AUGUSTUS path to local directories
AUGUSTUS_SCRIPTS_PATH=$(realpath ./augustus/scripts )
AUGUSTUS_BIN_PATH=$(realpath ./augustus/bin )
AUGUSTUS_CONFIG_PATH=$(realpath ./augustus/config )
echo $AUGUSTUS_SCRIPTS_PATH is the scripts path
echo $AUGUSTUS_BIN_PATH is the binaries path
echo $AUGUSTUS_CONFIG_PATH is the config path

funannotate predict \
    -i $ASSEM \
    -s "Arctostaphylos glauca" \
    -o Predicted_2 \
    --organism other\
    --min_training_models 190\
    --genemark_mode ES \
    --repeats2evm \
    --optimize_augustus \
    --augustus_species manzanita \
    --busco_seed_species tomato \
    --busco_db embryophyta_odb9 \
    --cpus $SLURM_CPUS_PER_TASK
#    --maker_gff Predicted\
#    --name HAX54_ \

